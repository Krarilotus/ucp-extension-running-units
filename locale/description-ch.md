# Running Units

此扩展让部分单位跑向目的地，而不是步行。目前支持链锤兵、长矛兵、投石兵和奴隶。

## 链锤兵奔跑

启用后，链锤兵会跑向目的地。您还可以决定是否允许 AI 作者更改这一行为。

### AI 个性（character/AIC）

为增添个性，可以让自己的 AI 使用或不使用该功能。在 `character.json` 中加入：

```json
"RunningUnits_Macemen": 1
```

设为 `1` 时，链锤兵会奔跑；设为 `0` 或 `2` 时，会像原版一样步行。

## 奴隶、长矛兵和投石兵

同样的规则也适用于这些单位。对应 AIC 字段为 `RunningUnits_Spearmen`、`RunningUnits_Slingers` 和 `RunningUnits_Slaves`。

UCP2-Legacy 也有让长矛兵奔跑的选项，会与此冲突，请确保关闭它。

## 支持

欢迎各种支持！

[![Buy Me A Coffee](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/orange_img.webp)](https://www.buymeacoffee.com/gynt)

如果您使用 PayPal：

[![Ko-Fi](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/kofi_button_red.png)](https://ko-fi.com/kofigynt)
