# Running Units

Bu uzantı bazı birliklerin hedeflerine yürümek yerine koşmasını sağlar. Şu anda gürzlü askerler, mızrakçılar, sapancılar ve köleler desteklenir.

## Gürzlü askerler koşuyor!

Etkinleştirildiğinde gürzlü askerler hedeflerine koşar. Yapay zekâ yapımcılarının bu davranışı değiştirmesine izin verip vermeyeceğinizi de seçebilirsiniz.

### Yapay zekâ kişiliği (character/AIC)

Yapay zekânıza özellik katmak için bu işlevi kullanıp kullanmayacağını belirleyebilirsiniz. `character.json` dosyasına şunu ekleyin:

```json
"RunningUnits_Macemen": 1
```

`1` değerinde gürzlü askerler koşar. `0` veya `2` ise özgün oyundaki gibi yürürler.

## Köleler, mızrakçılar ve sapancılar

Aynı kural geçerlidir. AIC alanları `RunningUnits_Spearmen`, `RunningUnits_Slingers` ve `RunningUnits_Slaves` adını taşır.

UCP2-Legacy’de mızrakçıları koşturan ve bununla çakışan başka bir seçenek vardır. Onu kapattığınızdan emin olun.

## Destek

Her türlü destek memnuniyetle karşılanır!

[![Buy Me A Coffee](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/orange_img.webp)](https://www.buymeacoffee.com/gynt)

PayPal kullanıyorsanız:

[![Ko-Fi](https://raw.githubusercontent.com/gynt/ucp-extension-running-units/main/locale/kofi_button_red.png)](https://ko-fi.com/kofigynt)
