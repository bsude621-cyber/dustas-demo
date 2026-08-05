# Duştaş Demo Sitesi (Kütahya) — 6 Senaryo

> **Bu site Duştaş için hazırlanmış bağımsız bir tasarım önerisidir, firmanın resmî
> sitesi değildir.** Arama motorlarına kapalıdır (`noindex, nofollow` — hem meta
> etiketi hem de `vercel.json` içinde `X-Robots-Tag`).

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
  hero1..3.mp4/.webm   16 sn dikişsiz boomerang loop, 1600x900, sessiz
  preview/h1..3.mp4    galeri önizlemeleri (560px, ~130-220 KB)
  preview/sa,sb.mp4    galeri önizlemeleri
frames/a/0001..0120.jpg  scroll-scrub kareleri (1440px)
frames/b/0001..0120.jpg
_raw/               ham Higgsfield çıktıları — DAĞITILMAZ (.gitignore + .vercelignore)
_tools/             npm ffmpeg/ffprobe — DAĞITILMAZ
```

Dağıtılan toplam **21.7 MB** (ölçüldü). Ziyaretçi başına indirilen: 1 hero
(0.9–1.5 MB webm) + 120 kare (~6 MB; mobilde `STEP=2` ile ~3 MB).

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
Hero videoları zaten high-key/aydınlık olduğu için gerçek değerler bunların üstünde
çıkacak — tablo alt sınırı gösteriyor.

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

## Uydurma bilgi politikası

Bu site gerçek bir firma için hazırlandığından **doğrulanamayan hiçbir bilgi
yazılmadı.** Sitede müşteri yorumu, puan, ödül, sertifika, bayilik veya marka
ortaklığı iddiası **yok**.

**Doğrulanmış** (bağımsız işletme rehberleriyle teyitli):

- Meydan Mah. Mithat Paşa Cad. No:55 · 0507 537 36 43
- Adnan Menderes Bulvarı No:22 · 0534 743 73 23
- Ürün grupları: duşakabin, duş teknesi, küvet & jakuzi, banyo dolabı, vitrifiye,
  banyo dekorasyon, ayna & aksesuar

**Doğrulanamadı** — sayfada `[DOĞRULA]` / `[YIL]` etiketiyle görünür bırakıldı:

| Yer tutucu | Nerede |
|---|---|
| `[DOĞRULA]` çalışma saatleri | iki showroom kartında |
| `[DOĞRULA]` "kendi montaj ekibimiz" | Neden Biz kartı |
| `[E-POSTA]` | İletişim kutusu |
| `[YIL]` `[PROJE]` `[SÜRE]` `[GARANTİ]` | istatistik şeridi (dördü de boş) |

`dustas.com.tr` bu makineden açılmadı (DNS timeout), bilgiler bağımsız
rehberlerden doğrulandı. Sitenin kendi metinlerini görebilirsen `[DOĞRULA]`
etiketlerini oradan doldur.

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
| Dağıtılan boyut | **21.7 MB** (hero 11 MB + kareler 12 MB) |
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
| Mobil kare seyreltme | JS `STEP = isMobile ? 2 : 1` |
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
3. **Demo anahtarını sil:** `<div class="demo-bar">` bloğu, `.demo-bar` CSS'i ve
   `demoBar()` JS fonksiyonu. Nav ve footer'daki `.nav-demo` "Senaryolar"
   sekmelerini de kaldır.
4. **`senaryolar.html`'i sil** ve kullanılmayan hero/frames setlerini temizle.
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
8. **WhatsApp numarasını doğrula:** tüm `wa.me/905075373643` bağlantıları
   işletmenin WhatsApp hattına gitmeli; ikinci şube için `905347437323`.
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
