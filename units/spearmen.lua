-- 17 bytes for storing which aic wants running spearmen, 0 is the human
-- for others, this is the logic: array[aiType] == 1 means run
-- array[aiType] == 2 means walk
-- array[aiType] == 0 means vanilla (aka don't set)
local aicRunningSpearmen = core.allocate(17 * 1, true) -- 17 bytes

local SPEARMEN_AIC_KEY = "RunningUnits_Spearmen"
local SPEARMEN_AIC_VALUES = {
    [0] = "vanilla",
    [1] = "run",
    [2] = "walk",
}
local spearmenMode = core.allocate(1, true)

-- The spearmen running decision: the detour replays its first instruction (cmp word [esi+field],di),
-- which reads the same field as the cmp at +15, and jumps to the run state at +60. UCP2-Legacy removes
-- the je at +58 and Rebalancer changes the jle at +23.
local DECISION = "66 39 BE ? ? ? ? 74 21 89 86 ? ? ? ? 66 83 BE ? ? ? ? 46 7E 3C 66 C7 86 ? ? ? ? FF FF "
    .. "89 BE ? ? ? ? EB 32 66 39 BE ? ? ? ? 75 1C 66 39 BE ? ? ? ? 74 13 C7 86 ? ? ? ? 81 00 00 00 "
    .. "66 89 86 ? ? ? ? EB 0D 89 86 ? ? ? ? 66 89 BE"

local PLAYER_ID = "0F ? ? ? ? ? ? 8B EF 69 ED F4 39 00 00 BA 01 00 00 00 01 ? ? ? ? ? 01 ? ? ? ? ? 51 B9 ? ? ? ? 66 ? ? ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ?"
local CURRENT_AI = "8D ? ? ? ? ? ? 6A 04 51 B9 ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ? 6A 00 6A 00"

return function(config)
    local beforeCmpLocation, reason = core.AOBScanUnique(DECISION)
    if beforeCmpLocation == nil then
        log(ERROR, "Running spearmen is off: run decision " .. reason .. ".")
        return
    end
    if core.readInteger(beforeCmpLocation + 3) ~= core.readInteger(beforeCmpLocation + 18) then
        log(ERROR, "Running spearmen is off: run decision compares different unit fields.")
        return
    end
    local playerID, playerIDReason = core.AOBScanUnique(PLAYER_ID)
    if playerID == nil then
        log(ERROR, "Running spearmen is off: unit player field " .. playerIDReason .. ".")
        return
    end
    local currentAI, currentAIReason = core.AOBScanUnique(CURRENT_AI)
    if currentAI == nil then
        log(ERROR, "Running spearmen is off: current AI array " .. currentAIReason .. ".")
        return
    end
    local ptrUnitsArray_PlayerID = core.readInteger(playerID + 3)
    local ptrCurrentAIArray = core.readInteger(currentAI + 3)

    log(VERBOSE, "enable spearmen running")

    -- Location for the detour
    -- ESI contains units offset for current unit ID
    -- EDI contained player ID, but has been cleared
    -- EBX contains current unit ID
    -- ECX should be restored
    -- EAX should be restored
    -- EDI should be restored
    local detourSize = 7
    local setRunning = beforeCmpLocation + 60

    if config.spearmen.running.ai == "aic_ignore_run" then
        -- Set to always run without caring about AIC
        core.writeBytes(aicRunningSpearmen, {
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1,
        })
    elseif config.spearmen.running.ai == "aic_ignore_walk" then
        -- Do nothing?, this is the vanilla situation
        core.writeBytes(aicRunningSpearmen, {
            2, 2, 2, 2, 2,
            2, 2, 2, 2, 2,
            2, 2, 2, 2, 2,
            2, 2,
        })
    elseif config.spearmen.running.ai == "aic_run_if_not_defined" then
        -- If AIC didn't define, assume run
        core.writeBytes(aicRunningSpearmen, {
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1,
            1, 1,
        })
    elseif config.spearmen.running.ai == "aic_walk_if_not_defined" then
        -- If AIC didn't define, assume walk
        core.writeBytes(aicRunningSpearmen, {
            2, 2, 2, 2, 2,
            2, 2, 2, 2, 2,
            2, 2, 2, 2, 2,
            2, 2,
        })
    else
        error(string.format("Invalid option: %s", config.spearmen.running.ai))
    end

    local asm = [[
		push ECX
		push EAX
    push EDI

		cmp EBX, 0
		; unitID is invalid
		jle original
		; playerID is 0
    movsx EDI, WORD [ESI + ptrUnitsArray_PlayerID]
		cmp EDI, 0
		jle original

	  isAI:
		; CurrentAIArray, gets aiType, or 0 if human
		mov EAX, DWORD [EDI*4 + ptrCurrentAIArray]

		; get configured action for aiType
		xor ECX, ECX
		mov CL, BYTE [EAX*1 + aicRunningSpearmen]
		cmp ECX, 0
		je original
		cmp ECX, 2
		je original
		cmp ECX, 1
		jne original

		; if action is 1
	  running:
    pop EDI
		pop EAX
		pop ECX
		; jumps away; original code isn't run
		jmp near setRunning

	  original:
    pop EDI
		pop EAX
		pop ECX
		; resume original code
	]]

    -- Detour at the location, place original code at the end of the custom assembly
    core.insertCode(beforeCmpLocation, detourSize, {
        core.AssemblyLambda(asm, {
            ptrCurrentAIArray = ptrCurrentAIArray,
            aicRunningSpearmen = aicRunningSpearmen,
            setRunning = setRunning,
            ptrUnitsArray_PlayerID = ptrUnitsArray_PlayerID,
        }),
    }, nil, 'after')

    -- Register in the aicloader that we provide an extra value, once the detour is in place
    modules.aicloader:setAdditionalAICValue(
        SPEARMEN_AIC_KEY,
        -- set
        function(aiType, aicValue)
            if type(aicValue) ~= "number" then
                log(WARNING,
                    string.format("Cannot set AIC '%s', invalid value: %s", SPEARMEN_AIC_KEY, tostring(aicValue)))
            else
                if config.spearmen.running.ai ~= "aic_ignore_run" and config.spearmen.running.ai ~= "aic_ignore_walk" then
                    log(VERBOSE,
                        string.format("Setting %s for ai #%s to value '%s'", SPEARMEN_AIC_KEY, aiType,
                            tostring(SPEARMEN_AIC_VALUES[aicValue])))
                    core.writeByte(aicRunningSpearmen + aiType, aicValue)
                else
                    log(WARNING,
                        string.format("Did not set AIC '%s', aic value is ignored", SPEARMEN_AIC_KEY))
                end
            end
        end,
        -- reset
        function(aiType)
            core.writeByte(aicRunningSpearmen + aiType, 0)
        end
    )
end
