// Scroll kareleri: hızı sabitle.
//
// Sorun: Higgsfield klibi sabit hızda değil — bazı yerlerde kamera hızlanıyor.
// Zamanı eşit bölersen (fps=15) scroll'da o noktada sıçrama hissi olur.
// Çözüm: zamanı değil HAREKETİ eşit böl. Kaynağın her karesi arası hareket
// ölçülür, kümülatif eğri çıkarılır, 120 kare bu eğri üzerinde eşit aralıklarla
// seçilir. Böylece her scroll pikseli aynı miktarda görüntü hareketine denk gelir.
const fs = require('fs');
const path = require('path');

const W = 160, H = 90, SZ = W * H;
const [,, grayDosya, srcDizin, hedefDizin] = process.argv;

const buf = fs.readFileSync(grayDosya);
const n = buf.length / SZ;
const src = fs.readdirSync(srcDizin).filter(f => f.endsWith('.jpg')).sort();
if (src.length !== n) {
  console.error(`UYUŞMAZLIK: ${n} gri kare, ${src.length} jpg — çıkılıyor`);
  process.exit(1);
}

// kare-arası hareket
const d = [];
for (let i = 0; i < n - 1; i++) {
  const a = i * SZ, b = (i + 1) * SZ;
  let s = 0;
  for (let k = 0; k < SZ; k++) s += Math.abs(buf[a + k] - buf[b + k]);
  d.push(s / SZ);
}
// kümülatif hareket eğrisi
const cum = [0];
for (let i = 0; i < d.length; i++) cum.push(cum[i] + d[i]);
const toplam = cum[cum.length - 1];

// eşit hareket aralıklarında 120 kare seç
const N = 120, secim = [];
for (let j = 0; j < N; j++) {
  const hedef = (toplam * j) / (N - 1);
  let lo = 0, hi = cum.length - 1;
  while (lo < hi) { const m = (lo + hi) >> 1; if (cum[m] < hedef) lo = m + 1; else hi = m; }
  secim.push(lo);
}
// aynı kareyi iki kez seçme (donuk bölümde olabilir) — ileri kaydır
for (let j = 1; j < N; j++) if (secim[j] <= secim[j - 1]) secim[j] = Math.min(n - 1, secim[j - 1] + 1);

fs.rmSync(hedefDizin, { recursive: true, force: true });
fs.mkdirSync(hedefDizin, { recursive: true });
secim.forEach((idx, j) => {
  fs.copyFileSync(path.join(srcDizin, src[idx]),
                  path.join(hedefDizin, String(j + 1).padStart(4, '0') + '.jpg'));
});

const tekrar = new Set(secim).size;
console.log(`${path.basename(hedefDizin)}: ${n} kaynak kare → 120 seçildi (${tekrar} benzersiz), ` +
            `kare başına hareket ${(toplam / (N - 1)).toFixed(2)}`);
