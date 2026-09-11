# Running Units

Esta extensión hace que algunas unidades corran a su destino en lugar de caminar. Actualmente admite soldados con maza, lanceros, honderos y esclavos.

## ¡Los soldados con maza corren!

Al activar la opción, corren hacia su destino. También puedes decidir si los creadores de IA tienen permiso para modificar este comportamiento.

### Personalidad de IA (character/AIC)

Para dar un carácter propio a tu IA, puedes hacer que utilice o no esta función. Añade lo siguiente en `character.json`:

```json
"RunningUnits_Macemen": 1
```

Con `1`, los soldados con maza corren. Con `0` o `2`, caminan como en el juego original.

## Esclavos, lanceros y honderos

Se aplica lo mismo. Sus campos AIC son `RunningUnits_Spearmen`, `RunningUnits_Slingers` y `RunningUnits_Slaves`.

UCP2-Legacy tiene otra opción que también hace correr a los lanceros y entra en conflicto. Asegúrate de desactivarla.

## Apoyo

¡Todo apoyo es bienvenido!

[![Buy Me A Coffee](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/orange_img.webp)](https://www.buymeacoffee.com/gynt)

Si tienes PayPal:

[![Ko-Fi](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/kofi_button_red.png)](https://ko-fi.com/kofigynt)
