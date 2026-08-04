/**
 * @file themePrefs.ts
 * @description localStorage-backed light/dark theme preference. Applies
 * `data-theme` on `<html>` as a side effect on import (before React mounts,
 * to avoid a flash of the wrong theme) and on every {@link themePrefs.set}
 * call. Mirrors the tabbyPrefs pattern (components/Tabby/prefs.ts).
 */

export type ThemeMode = "dark" | "light";

const STORAGE_KEY = "agent-dashboard-theme";
const EVENT = "theme:prefs";

function readTheme(): ThemeMode {
  try {
    return localStorage.getItem(STORAGE_KEY) === "light" ? "light" : "dark";
  } catch {
    return "dark";
  }
}

function applyTheme(mode: ThemeMode): void {
  document.documentElement.dataset.theme = mode;
}

function writeTheme(mode: ThemeMode): void {
  try {
    localStorage.setItem(STORAGE_KEY, mode);
  } catch {
    // Ignore storage failures (private mode, quota) - theme is best-effort.
  }
  applyTheme(mode);
  try {
    window.dispatchEvent(new CustomEvent(EVENT));
  } catch {
    // SSR / non-DOM contexts: nothing to notify.
  }
}

applyTheme(readTheme());

export const themePrefs = {
  get: readTheme,
  set: writeTheme,
  /** Subscribe to theme changes (including from other tabs). Returns an unsubscribe fn. */
  subscribe(handler: () => void): () => void {
    const listener = () => handler();
    window.addEventListener(EVENT, listener);
    window.addEventListener("storage", listener);
    return () => {
      window.removeEventListener(EVENT, listener);
      window.removeEventListener("storage", listener);
    };
  },
};
