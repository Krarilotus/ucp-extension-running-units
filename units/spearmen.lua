local SPEARMEN_AIC_KEY = "RunningUnits_Spearmen"
local SPEARMEN_AIC_VALUES = {
    [0] = "vanilla",
    [1] = "run",
    [2] = "walk",
}
local DEFAULT_ACTIONS = {
    aic_ignore_run = 1,
    aic_ignore_walk = 0,
    aic_run_if_not_defined = 1,
    aic_walk_if_not_defined = 0,
}

-- The detour replays the first comparison for the game's own decision.
-- The run and walk branches at +60 and +79 both set the movement state and destination field.
local DECISION = "66 39 BE ? ? ? ? 74 21 89 86 ? ? ? ? 66 83 BE ? ? ? ? 46 7E 3C 66 C7 86 ? ? ? ? FF FF "
    .. "89 BE ? ? ? ? EB 32 66 39 BE ? ? ? ? 75 1C 66 39 BE ? ? ? ? 74 13 C7 86 ? ? ? ? 81 00 00 00 "
    .. "66 89 86 ? ? ? ? EB 0D 89 86 ? ? ? ? 66 89 BE ? ? ? ?"

local PLAYER_ID = "0F ? ? ? ? ? ? 8B EF 69 ED F4 39 00 00 BA 01 00 00 00 01 ? ? ? ? ? 01 ? ? ? ? ? 51 B9 ? ? ? ? 66 ? ? ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ?"
local CURRENT_AI = "8D ? ? ? ? ? ? 6A 04 51 B9 ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ? 6A 00 6A 00"

return function(config)
    local rule = config.spearmen.running.ai
    if type(rule) ~= "string" then
        log(ERROR, "Running spearmen is off: the AI running rule must be a string.")
        return
    end
    local defaultAction = DEFAULT_ACTIONS[rule]
    if defaultAction == nil then
        log(WARNING, "Running spearmen is off: unknown AI running rule " .. rule .. ".")
        return
    end
    local allowAIC = rule ~= "aic_ignore_run" and rule ~= "aic_ignore_walk"

    local beforeCmpLocation, reason = core.AOBScanUnique(DECISION)
    if beforeCmpLocation == nil then
        log(ERROR, "Running spearmen is off: run decision " .. reason .. ".")
        return
    end
    if core.readInteger(beforeCmpLocation + 3) ~= core.readInteger(beforeCmpLocation + 18) then
        log(ERROR, "Running spearmen is off: run decision compares different unit fields.")
        return
    end
    if core.readInteger(beforeCmpLocation + 62) ~= core.readInteger(beforeCmpLocation + 81)
        or core.readInteger(beforeCmpLocation + 73) ~= core.readInteger(beforeCmpLocation + 88) then
        log(ERROR, "Running spearmen is off: run and walk branches write different unit fields.")
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

    local setWalking = beforeCmpLocation + 79

    -- One byte per AI type, including index 0 for the human player.
    local aicRunningSpearmen = core.allocate(17, true)
    local actions = {}
    for index = 1, 17 do
        actions[index] = defaultAction
    end
    core.writeBytes(aicRunningSpearmen, actions)

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
		cmp ECX, 2
		je walking
		cmp ECX, 1
		jne original

		; if action is 1
	  running:
    pop EDI
		pop EAX
		pop ECX
		; jumps away; original code isn't run
		jmp near setRunning

	  walking:
		pop EDI
		pop EAX
		pop ECX
		jmp near setWalking

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
            setWalking = setWalking,
            ptrUnitsArray_PlayerID = ptrUnitsArray_PlayerID,
        }),
    }, nil, 'after')

    -- Register in the aicloader that we provide an extra value, once the detour is in place
    modules.aicloader:setAdditionalAICValue(
        SPEARMEN_AIC_KEY,
        -- set
        function(aiType, aicValue)
            if type(aicValue) ~= "number" then
                log(ERROR, "AIC '" .. SPEARMEN_AIC_KEY .. "' must be a number.")
            elseif SPEARMEN_AIC_VALUES[aicValue] == nil then
                log(WARNING, "Invalid AIC '" .. SPEARMEN_AIC_KEY .. "': " .. tostring(aicValue))
            elseif not allowAIC then
                log(WARNING, "Did not set AIC '" .. SPEARMEN_AIC_KEY .. "': the launcher rule takes precedence.")
            else
                log(VERBOSE, string.format("Setting %s for ai #%s to '%s'", SPEARMEN_AIC_KEY, aiType,
                    SPEARMEN_AIC_VALUES[aicValue]))
                core.writeByte(aicRunningSpearmen + aiType, aicValue)
            end
        end,
        -- reset
        function(aiType)
            core.writeByte(aicRunningSpearmen + aiType, defaultAction)
        end
    )
end
