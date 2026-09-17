# ŞİRKETİM — Duşakabin & Banyo Örnek Sitesi (KARNER) — 6 Senaryo

> **Bu site gerçek bir firmaya ait değildir.** Duşakabin & banyo dekorasyon
> sektörü için KARNER tarafından hazırlanmış bir vitrin demosudur. Marka adı,
> telefon, adres ve e-posta alanlarının tamamı yer tutucudur.
> Arama motorlarına kapalıdır (`noindex, nofollow` — hem meta etiketi hem de
> `vercel.json` içinde `X-Robots-Tag`).

Tek dosyalık statik demo. Build yok, bağımlılık yok.

**Hepsini bir arada görmek için:** [`senaryolar.html`](senaryolar.html)

---

## Senaryolar

3 hero videosu × 2 scroll videosu = 6 kombinasyon. `index.html` URL parametresiyle seçilir:

| | Hero (`?h=`) | Scroll (`?s=`) |
|---|---|---|
| **1 / a** | Aydınlık modern banyo, yandan kayış | Kapıdan duşakabinin içine yürüyüş |
| **2 / b** | Yağmurlama başlığı, ağır çekim su | Menteşe detayından tüm banyoya |
| **3** | Duşakabin showroom'u | — |

```
index.html?h=1&s=a   ← varsayılan
index.html?h=2&s=a   ← bu sektör için önerilen (su + ürüne giriş)
```

Scroll videosuna göre sahne metinleri de değişir (`COPY` sabiti, `index.html` içinde):
`s=a` → ÖLÇÜ / ÜRETİM / MONTAJ · `s=b` → DETAY / CAM & PROFİL / BANYONUZ

Sitenin sağ altındaki **senaryo anahtarı** ile videolar arasında geçiş yapabilirsin;
scroll konumunu koruduğu için aynı noktada A/B karşılaştırması yapılabilir.

---

## Çalıştırma

`file://` ile açma — `frames/` fetch'i CORS'a takılır. Local server şart:

```bash
python -m http.server 8031
```

`http://localhost:8031/senaryolar.html`

Videolar henüz yokken de site **çalışır durumdadır**: hero CSS fallback'e düşer,
scroll-scrub prosedürel aydınlık placeholder çizer, galeri önizlemeleri
"videosu bekleniyor" yer tutucusu gösterir.

> ### ⚠ Port 8021'i kullanma
> `mimar-demo` de 8021'de çalışıyordu ve **dosya yolları birebir aynı**
> (`frames/a/0001.jpg`, `media/hero1.webm`). Tarayıcı bunları aynı origin'de
> disk cache'inde tuttuğu için, bu demoyu 8021'de açtığında sunucu 404 dönse bile
> **mimarlık demosunun kareleri çizilir.** Bu proje bilerek **8031**'e alındı.
> Yine de 8021'de test edersen `Ctrl+Shift+R` ile sert yenile, yoksa yanlış
> videoyu doğrulamış olursun.

---

## Klasör yapısı

```
index.html          demo site (senaryo parametreli)
senaryolar.html     6 senaryo karşılaştırma galerisi
media/
  hero1..3.mp4/.webm     16 sn dikişsiz boomerang loop, 1600x900, sessiz
  hero1..3-m.mp4/.webm   aynı loop, 900px — MOBİL (0.30–0.50 MB)
  preview/h1..3.mp4      galeri önizlemeleri (560px, ~130-220 KB)
  preview/sa,sb.mp4      galeri önizlemeleri
frames/a/0001..0120.jpg    scroll-scrub kareleri (1440px) — masaüstü
frames/a/m/0001..0120.jpg  aynı kareler 1000px — MOBİL
frames/b/…                 aynısı
_raw/               ham Higgsfield çıktıları — DAĞITILMAZ (.gitignore + .vercelignore)
_tools/             npm ffmpeg/ffprobe — DAĞITILMAZ
```

Dağıtılan toplam **32 MB** (mobil setle birlikte; öncesi 21.7 MB).
Ziyaretçi başına indirilen (ölçüldü, önbellek kapalı):

| | masaüstü | mobil (<860px) |
|---|---|---|
| hero | 0.9–1.5 MB | **0.30–0.50 MB** (`-m` kopya) |
| kareler | 120 × 1440px ≈ 6 MB | **60 × 1000px ≈ 1.5 MB** (`/m/` + `STEP=2`) |
| toplam | ~6.9 MB | **1.93 MB** (en ağır senaryo `?h=3&s=b`: **2.17 MB**) |

Mobilde kareler **sahne yaklaşana kadar hiç inmez** (IntersectionObserver);
hero'da durup geri çıkan ziyaretçi sadece HTML + hero videosunu indirir (~0.4 MB).

> **Dosya adlandırma tutarlılığı:** kare klasörleri `a`/`b` olduğu için önizleme
> klipleri de `sa.mp4` / `sb.mp4` olmalı — `s1`/`s2` değil.

---

## Aydınlık palet ve kontrast

Mimarlık demosu koyu lacivert + bakırdı; bu site aydınlık. Aydınlık zeminde iki
renk **metin olarak kullanılamaz** — ölçüldü, aşağıda:

| Kullanım | Ölçülen | Durum |
|---|---|---|
| `--ink #16202b` / `--paper #f7f9fb` | **15.60:1** | AA ✓ |
| `--ink` / `--surface #ffffff` | **16.46:1** | AA ✓ |
| `--ink-dim #5a6874` / `--paper` | **5.43:1** | AA ✓ |
| `--aqua-deep #1c6d8c` / `--paper` (kicker, vurgu) | **5.50:1** | AA ✓ |
| `--aqua-deep` / `--aqua-soft #e3f1f6` | **5.03:1** | AA ✓ |
| beyaz / `--aqua-deep` (birincil buton) | **5.81:1** | AA ✓ |
| beyaz / `--aqua-dark #175f79` (buton hover) | **7.12:1** | AA ✓ |
| beyaz / `--wa #0f7a6d` (WhatsApp butonu) | **5.22:1** | AA ✓ |
| ~~`--aqua #2e93b8` / `--paper`~~ | 3.33:1 | **METİNDE KULLANMA** — sadece çizgi/ikon/gradyan |
| ~~`--chrome #9aa7b1` / `--paper`~~ | 2.33:1 | **METİNDE KULLANMA** — sadece dekor |

Yani: brief'teki palet aynen korundu, sadece **metin rolü `--aqua`'dan
`--aqua-deep`'e taşındı** ve iki yardımcı ton eklendi (`--aqua-dark` hover,
`--wa` WhatsApp yeşili — ham `#25d366` beyaz metinle 1.98:1 olduğu için
kullanılamazdı).

### Hero — açık scrim + koyu metin

Brief'teki **önerilen** yöntem uygulandı: videonun üstüne beyaz scrim, metin koyu.
Üç katman var (yatay + alttan dikey + üstten nav koruması). Aşağıdaki sayılar
**en kötü hal** — yani video karesi saf siyahken:

| Metnin bulunduğu yer | Etkin scrim | `--ink` kontrastı |
|---|---|---|
| Sol alt (h1 başlangıcı) | .884 | **12.59:1** |
| h1'in sağ ucu (~%62 en) | .727 | **8.39:1** |
| CTA düğmeleri hizası | .776 | **9.64:1** |
| Yalnızca yatay scrim, metin bandındaki en zayıf nokta | .560 | **5.09:1** |

Metnin ulaşmadığı sağ uçta scrim .28'e düşer (video orada net görünür).

**Videolar geldikten sonra gerçek ölçüm** — üç hero'nun 24'er karesi örneklendi,
metin bölgesindeki (`x %3–62`, `y %45–90`) **her piksel** scrim'le kompozitlenip
`--ink` kontrastı hesaplandı:

| | Ortalama | En kötü tek piksel |
|---|---|---|
| hero1 — aydınlık banyo | 12.65:1 | **7.67:1** |
| hero2 — su | 15.15:1 | **7.26:1** |
| hero3 — showroom | 13.86:1 | **6.37:1** |

Yani metin bandındaki en karanlık piksel bile AA eşiğinin (4.5:1) belirgin üstünde.
Videoların sol üçte biri gerçekten sade geldiği için scrim'i daha da açmaya gerek yok;
tersine, istersen sağ tarafta videoyu biraz daha ortaya çıkarmak için `.28`'i
düşürebilirsin — metin oraya ulaşmıyor.

### Scroll-scrub sahnesi

`.grade` soldan sağa beyaz scrim: `.86 → .60 (%42) → .18 (%72) → .06`.
Metin bloğu en fazla %42'ye kadar uzanıyor; orada saf siyah video üzerinde
`--ink` kontrastı **5.78:1**. Kapanış kartı (`rgba(255,255,255,.93)`) **14.06:1**.

Kontrastı yeniden ölçmek istersen: `--paper`, `--ink` gibi değerleri değiştirdikten
sonra WCAG 2.1 formülüyle (`(L1+0.05)/(L2+0.05)`) yeniden hesapla; eşik normal
metinde 4.5, 24px+ / 19px+bold metinde 3.0.

### Tipografi

Harici font yüklenmiyor. Başlıklar `system-ui` **800** ağırlıkta.
Büyük başlıklarda harf aralığı `-.02em` (ağır kesim büyük puntoda sıkışık daha iyi
duruyor); geniş aralık `.18–.30em` küçük etiketlerde — kicker, buton, nav, `.k` başlıkları.

---

## Mobil uyum

Site Ağustos 2026'da masaüstü için kurulmuştu; Eylül 2026'da telefonda da
masaüstü kadar iyi çalışsın diye elden geçirildi. **Masaüstü görünümü
değişmedi** — neredeyse tüm değişiklikler `@media(max-width:860px)` ve
`@media(max-height:560px) and (orientation:landscape)` bloklarının içinde.
İçerik, metinler, bölüm sırası ve `[KÖŞELİ PARANTEZ]` yer tutucuları aynı kaldı.

### Ne değişti

| | Öncesi | Sonrası |
|---|---|---|
| 44 px altı dokunma hedefi (375 px) | **32** | **0** |
| 13 px altı yazı (375 px) | **94** | **0** |
| Ziyaretçi başına inen veri (375 px) | 3.93 MB | **1.93 MB** |
| Yatay taşma | yoktu | yok |

1. **Dokunma hedefleri.** Nav markası ve hamburger (44×44), tüm `.btn`'ler (50 px),
   "Fiyat sor" bağlantıları, showroom/iletişim telefon bağlantıları, footer
   bağlantıları ve senaryo anahtarının bütün düğmeleri (48 px) mobilde en az
   44 px. Görsel boyut korundu, alan `min-height` + `align-items:center` ile büyüdü.
2. **Yazı boyutları.** Gövde metinleri 16 px (ürün açıklaması, süreç, neden-biz,
   showroom satırları, sahne metinleri, demo notu), ikincil/etiket metinleri
   13 px (kicker, `.prod-meta`, `.shop-tag`, `.tile-lbl`, `.k`, `.l`, `.lbl`,
   `.n`, footer). En küçük değer 8 px'ti (`.brand-sub`) → 13 px.
   Bu metinlerde satır yüksekliği ≥1.5.
3. **Mobil menü** zaten vardı; erişilebilirlik tamamlandı: `aria-expanded` +
   değişen `aria-label`, **Esc** ile kapanma ve odağın hamburgere dönmesi, açılışta
   ilk bağlantıya odak, Tab'ın menü içinde dönmesi, açıkken `body` kaydırma kilidi.
   Menü yüksekliği artık JS ile ölçülen `--nav-h`'ye dayanıyor (dar ekranda
   marka satırı sarabiliyor, sabit 62/77 px varsayımı kayıyordu).
   Menü zemini **tam opak** yapıldı — yarı saydam + `backdrop-filter`, altındaki
   oynayan hero videosunun ayrı compositing katmanı yüzünden menüyü kırpıyordu.
   Menü açıkken hero videosu duraklatılıyor.
4. **Mobil sabit alt bar** zaten vardı; `Ara` + `WhatsApp` düğmeleri 50 px'e
   çıktı, yazı 13 px oldu, sol/sağ/alt `env(safe-area-inset-*)` eklendi.
   Yüksekliği `--mbar-h: 68px` değişkeninde; `body` alt dolgusu ve senaryo
   anahtarının konumu bu değişkenden hesaplanıyor.
5. **iOS video kuralı.** `<source>` listesi kaldırıldı. Format `canPlayType` ile
   seçiliyor (Safari/iOS → daima mp4), videoya **tek `src`** veriliyor, `error`
   olayında diğer formata geçiliyor, ikisi de açılmazsa element kaldırılıp
   `.hero-fallback` görünüyor. Otomatik oynatma engellenirse (iOS Düşük Güç Modu)
   ilk dokunuş/tıklama/tuşta başlatılıyor. `navigator.connection.saveData` açıksa
   video hiç indirilmiyor.
6. **Scroll-scrub mobil set.** `frames/<a|b>/m/` (1000 px, ~25 KB/kare) + `STEP=2`
   → 60 kare ≈ 1.5 MB (masaüstünde 120 × 1440 px ≈ 6 MB). Kareler
   `IntersectionObserver` ile **sahne ekranın %40'ı kadar yaklaşınca** inmeye
   başlıyor; preload başlamadan `requestAnimationFrame` döngüsü de dönmüyor.
7. **Küçük ekran yerleşimi.** Izgaralar tek sütun (ürünler, neden-biz, süreç,
   showroom, iletişim; istatistik şeridi bilerek 2 sütun kaldı — kısa etiketler).
   Yapışkan başlık mobilde 65 px (1160 px altındaki eski hali 77 px), kaydırınca 60 px —
   44 px'lik marka dokunma hedefi + 2×10 px dolgu bunun tabanı.
   **≤360 px'te navdaki marka alt satırı (`Kütahya · Duşakabin & Banyo`) gizlendi**:
   13 px'te iki satıra sarıp başlığı 75 px'e çıkarıyordu. Aynı bilgi hemen
   altındaki hero kicker'ında ve footer'da duruyor, içerik kaybı yok.
   375 px'te kicker + başlık + alt metin + iki CTA ilk ekranda
   (CTA 534–644 px, alt bar 743 px'te başlıyor).
8. **Senaryo anahtarı** mobilde **katlanır**: kapalıyken tek bir 48 px'lik
   "Senaryo" hapı, açılınca yukarı doğru panel. Alt barla çakışmıyor
   (hap alt kenarı 738 px, alt bar 743 px'te başlıyor), Esc ve dışına dokunmayla
   kapanıyor, menü açıkken gizleniyor. Soluklaşma mobilde `.36` yerine `.8` —
   `.36` metni 2.24:1'e, `.55` 3.81:1'e düşürüyordu; `.8` ile **8.71:1** (AA ✓).
9. **Güvenli alan.** `viewport-fit=cover` + nav, hero, bölümler, footer, sahne
   metni, kapanış kartı, alt bar ve senaryo anahtarında `env(safe-area-inset-*)`.
10. **Yatay mod** (`max-height:560px`): hero `min-height` kalkıyor, içerik navın
    altından başlıyor, başlık 24–30 px'e iniyor → 812×375'te başlık, alt metin ve
    CTA'lar ilk ekranda (CTA 238–288 px, alt bar 306 px'te).

`senaryolar.html` de aynı kurallara göre düzeltildi (9 küçük hedef + 80 küçük
yazı → 0).

### Ölçümler (headless Chrome, `frames`/`media` önbelleği kapalı)

Her genişlikte sayfanın tamamı kaydırıldı, sonra ölçüldü:

| Genişlik | Yatay taşma | <44 px hedef | <13 px yazı | Konsol |
|---|---|---|---|---|
| 320×812 | yok | 0 | 0 | temiz |
| 360×812 | yok | 0 | 0 | temiz |
| 375×812 | yok | 0 | 0 | temiz |
| 390×812 | yok | 0 | 0 | temiz |
| 414×812 | yok | 0 | 0 | temiz |
| 812×375 (yatay) | yok | 0 | 0 | temiz |
| 375×812 menü açık | yok | 0 | 0 | temiz |
| 375×812 senaryo paneli açık | yok | 0 | 0 | temiz |
| 768×1024 | yok | 0 | 0 | temiz |
| 1440×900 (masaüstü) | yok | değişmedi | değişmedi | temiz |

Elle test edilenler (375×812 ve 812×375, ölçülerek): mobil menü aç/kapa · Esc ile
kapanma ve odak dönüşü · `body` kaydırma kilidi · alt bardaki `tel:`/`wa.me`
bağlantıları · senaryo anahtarı aç/kapa ve senaryo değiştirme (scroll konumu
korunuyor: `?h=1&s=b`, `scrollY` geri geliyor) · hero videosu (`hero1-m.webm`,
900×506, `readyState 4`, oynuyor, tek `src`, 0 `<source>`) · scroll-scrub
(`frames/a/m/0001.jpg` … 60 kare, kapanış kartı 425–715 px, alt barı örtmüyor) ·
`prefers-reduced-motion` (video hiç istenmiyor, reveal'lar görünür, scrub çalışıyor).

### Kalan bilinen sorunlar

- **Masaüstü** tarafı bilerek elden geçirilmedi: 1440 px'te 35 adet 44 px altı
  hedef ve 101 adet 13 px altı yazı var (orijinal tasarımın kendisi). Fare ile
  kullanıldığı için mobil eşikleri uygulanmadı.
- Masaüstünde senaryo anahtarı soluklaşınca (`.demo-bar.dim`, opacity `.36`)
  metin kontrastı **2.24:1**. Demo-only bir kontrol ve teslimde siliniyor;
  mobilde `.8`'e çekilerek düzeltildi.
- Yatay modda (812×375) `.hero-facts` şeridi sabit alt barın arkasında kalıyor;
  kicker + başlık + alt metin + CTA'lar ilk ekranda. 375 px yükseklikte beşini
  birden sığdırmak mümkün değil.
- `.stats` şeridi mobilde 2 sütun (tek sütun değil) — dört kısa etiket için
  bilerek böyle bırakıldı.
- Mobil kareler 1000 px; DPR 2 telefonda tuval 1443 CSS px genişliğinde çiziyor,
  yani kare ~1.4× büyütülüyor. Beyaz scrim ve hızlı scrub yüzünden fark
  edilmiyor, ama 2.5 MB bütçesi büyütülürse `_tools/build.sh` içindeki
  `scale=1000` değeri artırılabilir.

---

## Uydurma bilgi politikası

Sitede müşteri yorumu, puan, ödül, sertifika, bayilik veya marka ortaklığı
iddiası **yok**. Sayı gerektiren her alan bilerek boş bırakıldı — gerçek bir
firmaya uyarlanırken doldurulur.

**Yer tutucular** — hepsi sahte, hiçbiri gerçek bir işletmeye ait değil:

| Yer tutucu | Nerede |
|---|---|
| `ŞİRKETİM` marka adı + `Ş` monogram | nav, footer, "Neden ŞİRKETİM", `<title>` |
| `0500 000 00 00` / `0500 000 00 01` | telefon, `tel:`, `wa.me` bağlantıları |
| `Örnek Mah. Örnek Cad. No:00` | iki showroom kartı + İletişim kutusu |
| `[DOĞRULA]` çalışma saatleri | iki showroom kartında |
| `[DOĞRULA]` "kendi montaj ekibimiz" | Neden Biz kartı |
| `[E-POSTA]` | İletişim kutusu |
| `[YIL]` `[PROJE]` `[SÜRE]` `[GARANTİ]` | istatistik şeridi (dördü de boş) |

Ürün grupları (duşakabin, duş teknesi, küvet & jakuzi, banyo dolabı, vitrifiye,
banyo dekorasyon, ayna & aksesuar) sektörün standart ürün ağacıdır; belirli bir
firmadan alınmamıştır.

---

## Doğrulanan şeyler (videolar gelmeden)

Ölçülerek kontrol edildi, tahminle geçilmedi:

| Kontrol | Sonuç |
|---|---|
| Yatay taşma — 375, 414, 680, 768, 900, 1000, 1080, 1160, 1161, 1200, 1280, 1440, 1920 px | **0 px**, taşan eleman yok |
| Sıfır boyutlu görünür eleman | yok; canvas her genişlikte dolu (360→1905 px) |
| Nav taşması | tam menü **1074 px** istiyor, hamburger 1160 px'te devreye giriyor → 86 px pay. 1400 px üstünde 1210 px istiyor, orada da sığıyor |
| Hamburger geçişi | 1160 px hamburger / 1161 px tam menü — tam eşikte |
| Placeholder gerçekten çiziyor mu | evet; ortalama parlaklık **222/255** (aydınlık), scroll'la kareler arası **%20–47** piksel değişiyor |
| Placeholder metin bölgesi (sol %42) | parlaklık **226/255** → koyu metin rahat okunuyor |
| `band`/`bell` zamanlaması | st1→st2→st3→kart kesintisiz; 4 sahnenin hepsinin 0.35'in altında kaldığı ölü nokta yok |
| Kare yolu ↔ ffmpeg | `FRAME_COUNT = 120`, `padStart(4,'0')` ↔ `%04d` — uyumlu |
| 6 senaryo bağlantısı | `senaryolar.html` altı kartın altısında da doğru `?h=&s=` üretiyor |
| **Hero boomerang dikişi** | üç hero da **384 kare / tam 16.000 sn**; dönüş noktasında ve döngü kapanışında birebir tekrar eden kare **yok** (döngü baştan sona kare kare tarandı) |
| **Scroll hız profili** | duraklama yok, cut yok, tekrar eden kare yok; scroll b'de hız 5.49 / 5.52 / 5.51 |
| **Medya bütünlüğü** | 254 dosyanın 254'ü sunucudan **200** dönüyor; 6 senaryonun altısı da tam |
| **Watermark** | beş ham klipte de yok — `delogo` gerekmedi |
| Dağıtılan boyut | **32 MB** (hero 11 MB + mobil hero 2 MB + kareler 12 MB + mobil kareler 7 MB) |
| `noindex` | index.html + senaryolar.html meta, ayrıca `vercel.json` `X-Robots-Tag` |
| Kontrast | yukarıdaki tablo — tüm metin/zemin çiftleri AA (≥4.5:1) |

Görsel kontrol yapılmadı — tarayıcı paneli gizliyken `document.hidden = true` olur,
`requestAnimationFrame` ateşlenmez ve canvas 0×0 doğar; scroll-scrub'ı ekran
görüntüsüyle doğrulamak mümkün değil. Yukarıdaki placeholder ölçümleri bu yüzden
sayfadaki gerçek `drawPlaceholder` kaynağı izole bir canvas'ta çalıştırılarak alındı.

---

## Videolar nasıl işlenecek

ffmpeg sistemde yok, npm ile kurulur:

```bash
mkdir _tools && cd _tools && npm init -y
npm i @ffmpeg-installer/ffmpeg @ffprobe-installer/ffprobe
node -e "console.log(require('@ffmpeg-installer/ffmpeg').path)"
```

Ham çıktıları `_raw/` altına koy (gitignore'lu). Aşağıdaki komutlar şu adları bekliyor:

| Higgsfield çıktısı | `_raw/` kaydet adı | Sitede |
|---|---|---|
| HERO 1 — aydınlık banyo | `hero_raw_alt1.mp4` | `media/hero1.mp4/.webm` · `?h=1` |
| HERO 2 — su | `hero_raw_alt2.mp4` | `media/hero2.mp4/.webm` · `?h=2` |
| HERO 3 — showroom | `hero_raw_alt3.mp4` | `media/hero3.mp4/.webm` · `?h=3` |
| SCROLL A — duşakabine giriş | `scroll_raw_alt1.mp4` | `frames/a/0001–0120.jpg` · `?s=a` |
| SCROLL B — detaydan banyoya | `scroll_raw_alt2.mp4` | `frames/b/0001–0120.jpg` · `?s=b` |

Önce `ffprobe` ile kare sayısını doğrula — aşağıdaki `191` değeri 193 kareye göredir,
farklıysa düzelt (kural: `toplam_kare - 2`). Scroll videosu 8 sn değilse `fps` değerini
`120 / süre` olacak şekilde ayarla (5 sn → `fps=24`); `FRAME_COUNT` her hâlükârda 120 kalır.

```bash
ffprobe -v error -select_streams v:0 -count_frames \
  -show_entries stream=nb_read_frames,r_frame_rate,width,height,duration \
  -of default=nw=1 _raw/scroll_raw_alt1.mp4
```

### Hero → dikişsiz loop (boomerang)

Basit `concat` yaparsan dönüş noktasında kare tekrar eder ve 1 karelik takılma olur.
Ters klipten ilk ve son kare atılmalı:

```bash
# 1) ileri
ffmpeg -y -i _raw/hero_raw_alt1.mp4 -an -vf "scale=1600:-2" \
  -c:v libx264 -crf 20 -preset veryfast -pix_fmt yuv420p _tools/tmp/f1.mp4
# 2) geri (n=0 ve n=192 atılır → 191 kare)
ffmpeg -y -i _tools/tmp/f1.mp4 -an \
  -vf "reverse,select='between(n\,1\,191)',setpts=N/FRAME_RATE/TB" \
  -c:v libx264 -crf 20 -preset veryfast -pix_fmt yuv420p _tools/tmp/r1.mp4
# 3) birleştir  (list1.txt: file 'f1.mp4' / file 'r1.mp4')
ffmpeg -y -f concat -safe 0 -i _tools/tmp/list1.txt -an \
  -c:v libx264 -crf 25 -preset slow -pix_fmt yuv420p -movflags +faststart media/hero1.mp4
# 4) webm
ffmpeg -y -i media/hero1.mp4 -an -c:v libvpx-vp9 -crf 36 -b:v 0 -row-mt 1 \
  -deadline good -cpu-used 3 media/hero1.webm
```

Sonuç: 384 kare = tam 16.000 sn, 1600×900. Aynısını `hero2` ve `hero3` için tekrarla.

### Scroll → 120 kare

Basit hâli:

```bash
ffmpeg -y -i _raw/scroll_raw_alt1.mp4 -vf "fps=15,scale=1440:-2" -q:v 4 \
  -frames:v 120 "frames/a/%04d.jpg"
```

8 sn × 15 fps = 120 kare → JS'teki `FRAME_COUNT = 120` ile birebir.
`-frames:v 120` şart, yoksa 121. kare üretilip eşleşme kayar.
Sıfır-pad 4 hane (`%04d` ↔ `padStart(4,'0')`).
Video 5 sn geldiyse `fps=24` kullan (5×24=120), `FRAME_COUNT` değişmez.

#### …ama bu projede yetmedi: hız düzleştirme

Ölçünce iki klipte de sabit hız yoktu (`_tools/linearize.js` bunun için yazıldı):

| | Sorun | Yapılan |
|---|---|---|
| **scroll a** | son ~0.4 sn'de kamera duruyor, 118→119 birebir tekrar eden kare | kuyruk atıldı (`-t 7.60`) |
| **scroll b** | ilk ~0.8 sn makro kadraj sabit; 30→33 arasında hız ortalamanın **3 katına** çıkıyor | baş atıldı (`-ss 0.72 -t 7.32`) + hareket eşitlendi |

Zamanı eşit bölmek (`fps=15`) yanlış sonuç veriyordu: kamera hızlandığında scroll
sıçrıyor, yavaşladığında takılıyor. Bunun yerine **zaman değil hareket eşit bölündü** —
kaynağın her karesi arası hareket ölçülüp kümülatif eğri çıkarıldı, 120 kare bu eğri
üzerinde eşit aralıklarla seçildi. Böylece her scroll pikseli aynı miktarda görüntü
hareketine denk geliyor.

```bash
bash _tools/build.sh          # hero ×3 + scroll ×2 + önizleme ×5, baştan sona
```

Sonuç (kare-arası hareketin baş / orta / son ortalaması):

| | Önce | Sonra |
|---|---|---|
| scroll a | 7.91 / 6.65 / **3.72** · 5 kare duraklama | 7.56 / 7.02 / 6.46 · duraklama yok |
| scroll b | **1.41** / 7.04 / 4.08 · 2 sıçrama (3×) | **5.49 / 5.52 / 5.51** · sıçrama yok |

İkisinde de 120 karenin 120'si benzersiz, birebir tekrar eden kare yok.

Watermark çıkarsa CSS ile kapatma, kaynakta sil:
`-vf "delogo=x=1715:y=875:w=175:h=165,fps=15,scale=1440:-2"`

### Galeri önizlemeleri

```bash
ffmpeg -y -i media/hero1.mp4 -an -vf "scale=560:-2" -c:v libx264 -crf 31 \
  -preset slow -pix_fmt yuv420p -movflags +faststart media/preview/h1.mp4
ffmpeg -y -i _raw/scroll_raw_alt1.mp4 -an -vf "scale=560:-2" -c:v libx264 -crf 31 \
  -preset slow -pix_fmt yuv420p -movflags +faststart media/preview/sa.mp4
```

---

## Ayar noktaları

| Ne | Nerede |
|---|---|
| Scroll hızı / uzunluğu | `.scene { height:520vh }` (mobil `400vh`) — büyük = yavaş scrub |
| Kare sayısı | JS `FRAME_COUNT` (ffmpeg fps ile senkron olmalı) |
| Metin sahne zamanları | `band()`/`bell()`: `0.14–0.26`, `0.30–0.56`, `0.58–0.78`, kart `0.80–0.92` |
| Sahne metinleri | JS `COPY` sabiti (scroll videosuna göre iki set) |
| Mobil kare seyreltme | JS `STEP = isMobile ? 2 : 1` (`isMobile = innerWidth < 860`) |
| Mobil kare klasörü | JS `FRAME_DIR` → `frames/<a\|b>/m/` · çözünürlük `_tools/build.sh` `scale=1000` |
| Mobil hero kopyası | JS `small = innerWidth < 860 ? '-m' : ''` · `build.sh` `scale=900`, `crf 30/40` |
| Kare preload eşiği | scrub IO `rootMargin:'0px 0px -40% 0px'` (büyütürsen daha erken iner) |
| Mobil alt bar yüksekliği | `:root --mbar-h` (`body` dolgusu + senaryo anahtarı buradan hesaplanır) |
| Yapışkan başlık yüksekliği | JS `setNavH()` → `--nav-h` (mobil menünün üst kenarı) |
| Mobil eşik | `@media(max-width:860px)` — alt bar, 44 px hedefler, 13/16 px yazı |
| DPR tavanı | `resize()` içindeki `Math.min(devicePixelRatio, 2)` |
| Hero scrim yoğunluğu | `.hero-scrim` — değiştirirsen kontrastı yeniden ölç |
| Scroll scrim yoğunluğu | `.grade` — aynısı |
| Palet | `:root` → `--paper --ink --aqua-deep --wa` |
| Hamburger eşiği | `@media(max-width:1160px)` — tam nav ~1120px istiyor |

---

## Müşteriye teslim ederken

1. **Senaryoyu sabitle:** `HERO` / `SCRL` sabitlerini seçtiğin değere sabitle,
   URL parametresi okumasını kaldır.
2. **Demo notunu sil:** `<section class="demo-note">` bloğu, `.demo-note` CSS'i ve
   `.foot-copy` içindeki "Bağımsız tasarım önerisi" satırı.
3. **Demo anahtarını sil:** `<div class="demo-bar">` bloğu (içindeki
   `.demo-toggle` düğmesi ve `.demo-panel` dahil), `.demo-bar` / `.demo-toggle` /
   `.demo-panel` / `.demo-seg` / `.demo-all` CSS'i — mobil blokta da bir bölüm var —
   ve `demoBar()` JS fonksiyonu. Nav ve footer'daki `.nav-demo` "Senaryolar"
   sekmelerini de kaldır. `@media(max-width:860px)` içindeki
   `.nav.open ~ .demo-bar{display:none}` satırı da gider.
4. **`senaryolar.html`'i sil** ve kullanılmayan hero/frames setlerini temizle —
   seçilen senaryo dışındakilerin hem masaüstü hem `-m` / `/m/` mobil kopyaları.
5. **`noindex`'i kaldır:** `<meta name="robots">` etiketi (iki dosyada) ve
   `vercel.json` içindeki `X-Robots-Tag` başlığı. Gerçek siteye dönüşene kadar
   **kaldırma.**
6. **Yer tutucuları doldur:** `[DOĞRULA]`, `[E-POSTA]`, `[YIL]`, `[PROJE]`,
   `[SÜRE]`, `[GARANTİ]`. İstatistiklerde `<span class="num ph">[YIL]</span>`
   yerine `<span class="num" data-count="18" data-suffix="+">0</span>` yazarsan
   sayaç animasyonu kendiliğinden çalışır; `.stats-note` satırını da sil.
7. **Ürün fotoğrafları:** `<div class="prod-art">…</div>` yerine
   `<img class="prod-art" src="urunler/1.jpg" alt="…">` — ölçüler aynı kalır,
   SVG teknik çizimler silinir.
8. **Marka adı ve numaralar:** `ŞİRKETİM` → firma adı, `Ş` monogramı → baş harf,
   tüm `wa.me/905000000000` bağlantıları işletmenin WhatsApp hattına gitmeli
   (ikinci şube: `905000000001`), `Örnek Mah. …` → gerçek adres ve
   "Yol Tarifi Al" butonlarına `maps/dir/?api=1&destination=…` linki.
9. `[E-POSTA]` gelmezse İletişim kutusunu üçten ikiye düşür (grid otomatik uyar).

> **WhatsApp'tan HTML dosyası göndermek işe yaramaz** — `index.html` tek başına
> videoları içermez. Her zaman canlı link gönder.

---

## Deploy

Vercel'e bağla; ayar gerekmez. `vercel.json` hazır:
`cleanUrls`, `frames/` ve `media/` için 1 yıllık immutable cache, tüm yollarda
`X-Robots-Tag: noindex, nofollow`.

`.vercelignore` `_raw/`, `_tools/`, `node_modules/` ve `README.md`'yi hariç tutar.

---

*Mekanik kaynağı: `mimar-demo` (aydınlık palete uyarlandı) ·
`emlak-video-hero/NASIL-YAPILDI.md` (scroll-scrub reçetesi).*
