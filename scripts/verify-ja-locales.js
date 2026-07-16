#!/usr/bin/env node
/**
 * verify-ja-locales.js — checks client/src/i18n/locales/ja/*.json against the
 * en/ originals: same files present, same key set (recursively), same
 * {{placeholder}} tokens per key. Run after merging upstream changes — new
 * upstream keys show up here as "missing" until translated.
 *
 * Exit code 0 = all ja files match en key-for-key. Exit code 1 = gaps found
 * (printed to stderr, one line per file).
 */
const fs = require("fs");
const path = require("path");

const BASE = path.join(__dirname, "..", "client", "src", "i18n", "locales");

function flatten(obj, prefix = "") {
  const out = {};
  for (const [k, v] of Object.entries(obj)) {
    const key = prefix ? `${prefix}.${k}` : k;
    if (v && typeof v === "object" && !Array.isArray(v)) {
      Object.assign(out, flatten(v, key));
    } else {
      out[key] = v;
    }
  }
  return out;
}

function placeholders(s) {
  if (typeof s !== "string") return [];
  return (s.match(/\{\{[^}]+\}\}/g) || []).sort();
}

function main() {
  const files = fs.readdirSync(path.join(BASE, "en")).filter((f) => f.endsWith(".json"));
  let ok = true;
  let totalKeys = 0;

  for (const name of files) {
    const enPath = path.join(BASE, "en", name);
    const jaPath = path.join(BASE, "ja", name);
    if (!fs.existsSync(jaPath)) {
      console.error(`${name}: MISSING ja file entirely`);
      ok = false;
      continue;
    }
    const en = flatten(JSON.parse(fs.readFileSync(enPath, "utf8")));
    const ja = flatten(JSON.parse(fs.readFileSync(jaPath, "utf8")));
    const enKeys = Object.keys(en).sort();
    const jaKeys = Object.keys(ja).sort();
    const missing = enKeys.filter((k) => !jaKeys.includes(k));
    const extra = jaKeys.filter((k) => !enKeys.includes(k));
    if (missing.length || extra.length) {
      if (missing.length)
        console.error(`${name}: MISSING keys (untranslated): ${missing.join(", ")}`);
      if (extra.length)
        console.error(`${name}: EXTRA keys (stale, en no longer has these): ${extra.join(", ")}`);
      ok = false;
      continue;
    }
    let phOk = true;
    for (const k of enKeys) {
      const ep = placeholders(en[k]).join(",");
      const jp = placeholders(ja[k]).join(",");
      if (ep !== jp) {
        console.error(`${name}: PLACEHOLDER MISMATCH at "${k}": en=[${ep}] ja=[${jp}]`);
        ok = false;
        phOk = false;
      }
    }
    totalKeys += enKeys.length;
    if (phOk) console.log(`${name}: OK (${enKeys.length} keys)`);
  }

  console.log(`\nTOTAL: ${files.length} files, ${totalKeys} keys, ${ok ? "all OK" : "GAPS FOUND"}`);
  process.exitCode = ok ? 0 : 1;
}

main();
