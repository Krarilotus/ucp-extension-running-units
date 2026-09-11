# Running Units

Cette extension fait courir certaines unités vers leur destination au lieu de les faire marcher. Les massiers, lanciers, frondeurs et esclaves sont actuellement pris en charge.

## Les massiers courent !

Une fois l’option activée, les massiers courent vers leur destination. Vous pouvez aussi choisir si les créateurs d’IA sont autorisés à modifier ce comportement.

### Personnalité de l’IA (character/AIC)

Pour personnaliser votre IA, vous pouvez lui faire utiliser ou non cette fonction. Ajoutez ceci dans `character.json` :

```json
"RunningUnits_Macemen": 1
```

Avec `1`, les massiers courent. Avec `0` ou `2`, ils marchent comme dans le jeu d’origine.

## Esclaves, lanciers et frondeurs

Le même principe s’applique. Leurs champs AIC sont `RunningUnits_Spearmen`, `RunningUnits_Slingers` et `RunningUnits_Slaves`.

Pour les lanciers, une option d’UCP2-Legacy les fait également courir et entre en conflit. Veillez à la désactiver.

## Soutien

Tout soutien est le bienvenu !

[![Buy Me A Coffee](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/orange_img.webp)](https://www.buymeacoffee.com/gynt)

Si vous utilisez PayPal :

[![Ko-Fi](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/kofi_button_red.png)](https://ko-fi.com/kofigynt)
