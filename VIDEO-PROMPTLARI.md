# Higgsfield prompt'ları — Duştaş

5 video: **3 hero + 2 scroll**. Üretilen dosyayı aşağıdaki **kaydet adı** ile
`_raw/` klasörüne at; `README.md`'deki ffmpeg komutları o adları bekliyor.

## Ayarlar (her video için aynı)

16:9 · 8 saniye · ses kapalı · motion strength **düşük** · en yüksek çözünürlük ·
kamera preset varsa **"Dolly / Pan — slow"**

## Negatif prompt (hepsine yapıştır)

```
text, letters, captions, subtitles, watermark, logo, signage, brand names, UI,
people, human, hands, face, cut, jump cut, scene change, camera shake, handheld,
zoom, fast motion, speed ramp, stutter, distortion, morphing, vertical video,
dirty, mold, cluttered, dark, moody
```

## Dosya eşleşmesi

| Prompt | `_raw/` kaydet adı | Sitede |
|---|---|---|
| HERO 1 | `hero_raw_alt1.mp4` | `media/hero1.mp4/.webm` · `?h=1` |
| HERO 2 | `hero_raw_alt2.mp4` | `media/hero2.mp4/.webm` · `?h=2` |
| HERO 3 | `hero_raw_alt3.mp4` | `media/hero3.mp4/.webm` · `?h=3` |
| SCROLL A | `scroll_raw_alt1.mp4` | `frames/a/0001–0120.jpg` · `?s=a` |
| SCROLL B | `scroll_raw_alt2.mp4` | `frames/b/0001–0120.jpg` · `?s=b` |

> Önizleme klipleri `media/preview/h1..h3.mp4` ve `sa.mp4` / `sb.mp4` olacak —
> `s1`/`s2` değil. Kare klasörleri `a`/`b` olduğu için adlandırma buna uymak zorunda.

---

## HERO 1 — "Aydınlık banyo" (varsayılan)

```
Slow cinematic lateral drift through a bright, airy modern bathroom in daylight.
The camera glides smoothly to the right at a constant slow speed, revealing a
frameless glass walk-in shower enclosure with slim chrome profiles, large-format
light stone tiles, a floating vanity, and soft daylight from a frosted window.
Bright, clean, high-key lighting, white and pale grey palette with chrome accents,
water droplets glistening on the glass. Interior photography aesthetic, photorealistic,
soft shadows, subtle reflections.
The left third of the frame stays plain and uncluttered — a smooth out-of-focus
light wall with no detail.
No people, no text, no logos, no brand names, no watermark.
One single continuous take: no cuts, no camera shake, no zoom, no speed changes.
16:9 widescreen, 10 seconds.
```

## HERO 2 — "Su" (bu sektör için en güçlüsü)

```
Slow motion close-up of clean water falling from a large square chrome rain shower
head against a bright, softly out-of-focus white bathroom background. The camera
drifts slowly and continuously to the right at a constant speed. Individual droplets
catch the daylight, water sheets down a pane of clear glass on the right side of the
frame. High-key bright lighting, white and pale aqua tones, crisp and clean, spa-like.
Photorealistic, macro detail on the droplets, gentle depth of field.
The left third of the frame stays plain and bright with no detail.
No people, no text, no logos, no brand names, no watermark.
One continuous take, no cuts, no shake, no zoom. 16:9 widescreen, 10 seconds.
```

## HERO 3 — "Showroom"

```
Slow cinematic drift through a bright modern bathroom showroom. The camera glides
smoothly to the right at a constant slow speed past a row of glass shower enclosures
and staged bathroom vignettes, each lit evenly by soft ceiling light, polished floor
reflecting the displays. Clean retail interior photography, high-key bright lighting,
white walls, chrome and clear glass, pale aqua accents.
The left third of the frame stays plain and uncluttered.
No people, no text, no logos, no brand names, no price tags, no watermark.
One continuous take, no cuts, no shake, no zoom. 16:9 widescreen, 10 seconds.
```

---

## SCROLL A — "Duşakabine giriş" (varsayılan)

Kurallar **pazarlık edilemez**: tek kesintisiz çekim, sabit yavaş hız, ivmelenme yok,
yazı yok. Cut varsa scroll'da zıplar, ivmelenme varsa takılır.

```
Slow cinematic dolly-in, one single unbroken take. The camera glides smoothly and
continuously forward at a constant slow speed through a bright modern bathroom:
starting at the doorway, moving across light stone tiles toward a frameless glass
walk-in shower enclosure, passing through its open glass door, and ending facing the
chrome rain shower head and the tiled niche wall. The camera maintains exactly the
same slow forward speed for the entire shot, like a smooth gimbal walkthrough on rails.
Bright high-key daylight, white and pale grey palette, chrome fixtures, clean glass
with a few water droplets. Photorealistic interior photography, soft shadows.
No people, no text, no logos, no brand names, no watermark.
Absolutely no cuts, no camera shake, no acceleration, no pauses, no zoom, no orbiting.
16:9 widescreen, 8 seconds.
```

## SCROLL B — "Detaydan banyoya"

```
Slow cinematic pull-back, one single unbroken take. The camera starts extremely close
on a polished chrome shower hinge and the edge of a clear glass panel with a single
water droplet, then glides continuously backward at a constant slow speed, gradually
revealing the full glass shower enclosure and then the entire bright modern bathroom
around it. Macro-to-wide reveal in one uninterrupted motion.
Bright high-key lighting, white and pale aqua tones, photorealistic, shallow depth of
field opening into deep focus, crisp reflections on chrome.
The backward speed never changes for the entire shot.
No people, no hands, no text, no logos, no brand names, no watermark.
No cuts, no shake, no acceleration, no zoom. 16:9 widescreen, 8 seconds.
```

---

## Video geldiğinde ilk iş

```bash
ffprobe -v error -select_streams v:0 -count_frames \
  -show_entries stream=nb_read_frames,r_frame_rate,width,height,duration \
  -of default=nw=1 _raw/scroll_raw_alt1.mp4
```

- Kare sayısı 193 değilse `README.md`'deki boomerang komutundaki `191` değerini düzelt
  (kural: `toplam_kare - 2`).
- Scroll videosu 8 sn değilse `fps` değerini `120 / süre` olacak şekilde ayarla
  (5 sn → `fps=24`). `FRAME_COUNT` her hâlükârda 120 kalır.
