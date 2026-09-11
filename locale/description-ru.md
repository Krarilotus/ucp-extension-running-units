# Running Units

Расширение заставляет некоторые войска бежать к цели вместо ходьбы. Сейчас поддерживаются булавоносцы, копейщики, пращники и рабы.

## Булавоносцы бегут!

При включении настройки булавоносцы бегут к месту назначения. Также можно разрешить или запретить авторам ИИ менять это поведение.

### Личность ИИ (character/AIC)

Для индивидуальных особенностей ИИ может использовать эту возможность или отказаться от неё. Добавьте в `character.json`:

```json
"RunningUnits_Macemen": 1
```

При `1` булавоносцы бегают. При `0` или `2` они ходят как в исходной игре.

## Рабы, копейщики и пращники

Принцип тот же. Их поля AIC: `RunningUnits_Spearmen`, `RunningUnits_Slingers` и `RunningUnits_Slaves`.

Для копейщиков есть конфликтующая настройка UCP2-Legacy, также включающая бег. Обязательно отключите её.

## Поддержка

Любая поддержка приветствуется!

[![Buy Me A Coffee](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/orange_img.webp)](https://www.buymeacoffee.com/gynt)

Если у вас есть PayPal:

[![Ko-Fi](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/kofi_button_red.png)](https://ko-fi.com/kofigynt)
