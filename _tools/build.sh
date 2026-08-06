#!/usr/bin/env bash
# Banyo/duşakabin demo — ham Higgsfield çıktılarını siteye hazırlar.
# Kaynak: 1920x1080, 24 fps, 8.0417 sn, 193 kare (ffprobe ile doğrulandı)
set -e
cd "$(dirname "$0")/.."
FF="_tools/node_modules/@ffmpeg-installer/win32-x64/ffmpeg.exe"
mkdir -p _tools/tmp media/preview frames/a frames/b

# ---------- HERO ×3 → dikişsiz boomerang loop ----------
# Ters klipten ilk ve son kare atılır (n=0 ve n=192) → 191 kare.
# 193 + 191 = 384 kare = tam 16.000 sn @24fps
for N in 1 2 3; do
  echo ">>> hero$N: ileri"
  "$FF" -y -v error -i "_raw/hero_raw_alt$N.mp4" -an -vf "scale=1600:-2" \
    -c:v libx264 -crf 20 -preset veryfast -pix_fmt yuv420p "_tools/tmp/f$N.mp4"

  echo ">>> hero$N: geri (n=1..191)"
  "$FF" -y -v error -i "_tools/tmp/f$N.mp4" -an \
    -vf "reverse,select='between(n\,1\,191)',setpts=N/FRAME_RATE/TB" \
    -c:v libx264 -crf 20 -preset veryfast -pix_fmt yuv420p "_tools/tmp/r$N.mp4"

  printf "file 'f%s.mp4'\nfile 'r%s.mp4'\n" "$N" "$N" > "_tools/tmp/list$N.txt"

  echo ">>> hero$N: birleştir → mp4"
  "$FF" -y -v error -f concat -safe 0 -i "_tools/tmp/list$N.txt" -an \
    -c:v libx264 -crf 25 -preset slow -pix_fmt yuv420p -movflags +faststart \
    "media/hero$N.mp4"

  echo ">>> hero$N: webm"
  "$FF" -y -v error -i "media/hero$N.mp4" -an -c:v libvpx-vp9 -crf 36 -b:v 0 \
    -row-mt 1 -deadline good -cpu-used 3 "media/hero$N.webm"
done

# ---------- SCROLL ×2 → 120 kare ----------
# 8 sn × 15 fps = 120 kare → JS'teki FRAME_COUNT = 120 ile birebir.
# -frames:v 120 şart: yoksa 121. kare üretilir ve eşleşme kayar.
for PAIR in "1 a" "2 b"; do
  set -- $PAIR; N=$1; L=$2
  echo ">>> scroll $L: 120 kare"
  rm -f frames/$L/*.jpg
  "$FF" -y -v error -i "_raw/scroll_raw_alt$N.mp4" -vf "fps=15,scale=1440:-2" \
    -q:v 4 -frames:v 120 "frames/$L/%04d.jpg"
done

# ---------- GALERİ ÖNİZLEMELERİ ----------
# Ad tutarlılığı: kare klasörleri a/b olduğu için klipler de sa/sb (s1/s2 DEĞİL)
for N in 1 2 3; do
  echo ">>> preview h$N"
  "$FF" -y -v error -i "media/hero$N.mp4" -an -vf "scale=560:-2" \
    -c:v libx264 -crf 31 -preset slow -pix_fmt yuv420p -movflags +faststart \
    "media/preview/h$N.mp4"
done
for PAIR in "1 a" "2 b"; do
  set -- $PAIR; N=$1; L=$2
  echo ">>> preview s$L"
  "$FF" -y -v error -i "_raw/scroll_raw_alt$N.mp4" -an -vf "scale=560:-2" \
    -c:v libx264 -crf 31 -preset slow -pix_fmt yuv420p -movflags +faststart \
    "media/preview/s$L.mp4"
done

echo ">>> BİTTİ"
