# Running Units

Ez a bővítmény egyes egységeket gyaloglás helyett futásra késztet az úti céljuk felé. Jelenleg a buzogányosok, lándzsások, parittyások és rabszolgák támogatottak.

## A buzogányosok futnak!

Bekapcsolás után a buzogányosok futnak a céljukhoz. Azt is megadhatod, hogy az MI-k készítői módosíthatják-e ezt a viselkedést.

### MI-személyiség (character/AIC)

Az MI egyedi jellegéhez választhatsz, használja-e ezt a funkciót. A `character.json` fájlba írd be:

```json
"RunningUnits_Macemen": 1
```

Az `1` értékkel a buzogányosok futnak. `0` vagy `2` esetén az alapjátékhoz hasonlóan gyalogolnak.

## Rabszolgák, lándzsások és parittyások

Ugyanez érvényes rájuk. AIC-mezőik: `RunningUnits_Spearmen`, `RunningUnits_Slingers` és `RunningUnits_Slaves`.

A lándzsásokhoz az UCP2-Legacy is tartalmaz futást engedélyező, ütköző beállítást. Ezt kapcsold ki.

## Támogatás

Minden támogatást köszönök!

[![Buy Me A Coffee](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/orange_img.webp)](https://www.buymeacoffee.com/gynt)

Ha van PayPal-fiókod:

[![Ko-Fi](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/kofi_button_red.png)](https://ko-fi.com/kofigynt)
