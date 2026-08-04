/**
 * @file tailwind.config.js
 * @description Tailwind CSS configuration — content globs and the dashboard's dark-theme design tokens.
 * @author Son Nguyen <hoangson091104@gmail.com>
 */

/**
 * Reads a color from a CSS custom property (`--color-<name>`) so the same
 * Tailwind class (e.g. `bg-surface-3`, `text-gray-400`) resolves to different
 * RGB values depending on the `data-theme` attribute on `<html>` — see the
 * `:root` / `:root[data-theme="light"]` blocks in `src/index.css`. Tailwind's
 * opacity modifiers (`/50` etc.) keep working because the variable stores a
 * bare "R G B" triplet, not a full `rgb()` string.
 */
function withOpacity(variableName) {
  return ({ opacityValue }) =>
    opacityValue === undefined
      ? `rgb(var(${variableName}))`
      : `rgb(var(${variableName}) / ${opacityValue})`;
}

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        surface: {
          0: withOpacity("--color-surface-0"),
          1: withOpacity("--color-surface-1"),
          2: withOpacity("--color-surface-2"),
          3: withOpacity("--color-surface-3"),
          4: withOpacity("--color-surface-4"),
          5: withOpacity("--color-surface-5"),
        },
        border: {
          DEFAULT: withOpacity("--color-border"),
          light: withOpacity("--color-border-light"),
        },
        accent: {
          DEFAULT: withOpacity("--color-accent"),
          hover: withOpacity("--color-accent-hover"),
          muted: "var(--color-accent-muted)",
        },
        amber: {
          100: withOpacity("--color-amber-100"),
          200: withOpacity("--color-amber-200"),
          300: withOpacity("--color-amber-300"),
          400: withOpacity("--color-amber-400"),
          500: withOpacity("--color-amber-500"),
        },
        blue: {
          200: withOpacity("--color-blue-200"),
          300: withOpacity("--color-blue-300"),
          400: withOpacity("--color-blue-400"),
          500: withOpacity("--color-blue-500"),
        },
        cyan: {
          200: withOpacity("--color-cyan-200"),
          300: withOpacity("--color-cyan-300"),
          400: withOpacity("--color-cyan-400"),
          500: withOpacity("--color-cyan-500"),
        },
        emerald: {
          100: withOpacity("--color-emerald-100"),
          200: withOpacity("--color-emerald-200"),
          300: withOpacity("--color-emerald-300"),
          400: withOpacity("--color-emerald-400"),
          500: withOpacity("--color-emerald-500"),
        },
        fuchsia: {
          300: withOpacity("--color-fuchsia-300"),
          500: withOpacity("--color-fuchsia-500"),
        },
        gray: {
          50: withOpacity("--color-gray-50"),
          100: withOpacity("--color-gray-100"),
          200: withOpacity("--color-gray-200"),
          300: withOpacity("--color-gray-300"),
          400: withOpacity("--color-gray-400"),
          500: withOpacity("--color-gray-500"),
          600: withOpacity("--color-gray-600"),
          700: withOpacity("--color-gray-700"),
          800: withOpacity("--color-gray-800"),
          900: withOpacity("--color-gray-900"),
        },
        green: {
          200: withOpacity("--color-green-200"),
          400: withOpacity("--color-green-400"),
          500: withOpacity("--color-green-500"),
        },
        indigo: {
          200: withOpacity("--color-indigo-200"),
          300: withOpacity("--color-indigo-300"),
          400: withOpacity("--color-indigo-400"),
          500: withOpacity("--color-indigo-500"),
        },
        orange: {
          300: withOpacity("--color-orange-300"),
          400: withOpacity("--color-orange-400"),
          500: withOpacity("--color-orange-500"),
        },
        pink: {
          300: withOpacity("--color-pink-300"),
          400: withOpacity("--color-pink-400"),
          500: withOpacity("--color-pink-500"),
        },
        red: {
          100: withOpacity("--color-red-100"),
          200: withOpacity("--color-red-200"),
          300: withOpacity("--color-red-300"),
          400: withOpacity("--color-red-400"),
          500: withOpacity("--color-red-500"),
          600: withOpacity("--color-red-600"),
          950: withOpacity("--color-red-950"),
        },
        rose: {
          200: withOpacity("--color-rose-200"),
          300: withOpacity("--color-rose-300"),
          400: withOpacity("--color-rose-400"),
          500: withOpacity("--color-rose-500"),
        },
        sky: {
          300: withOpacity("--color-sky-300"),
          400: withOpacity("--color-sky-400"),
          500: withOpacity("--color-sky-500"),
        },
        slate: {
          300: withOpacity("--color-slate-300"),
          400: withOpacity("--color-slate-400"),
          500: withOpacity("--color-slate-500"),
        },
        teal: {
          200: withOpacity("--color-teal-200"),
          300: withOpacity("--color-teal-300"),
          400: withOpacity("--color-teal-400"),
          500: withOpacity("--color-teal-500"),
        },
        violet: {
          200: withOpacity("--color-violet-200"),
          300: withOpacity("--color-violet-300"),
          400: withOpacity("--color-violet-400"),
          500: withOpacity("--color-violet-500"),
          600: withOpacity("--color-violet-600"),
        },
        yellow: {
          200: withOpacity("--color-yellow-200"),
          300: withOpacity("--color-yellow-300"),
          400: withOpacity("--color-yellow-400"),
          500: withOpacity("--color-yellow-500"),
        },
      },
      fontFamily: {
        sans: ["Inter", "-apple-system", "BlinkMacSystemFont", "Segoe UI", "sans-serif"],
        mono: ["JetBrains Mono", "Fira Code", "Consolas", "monospace"],
      },
      animation: {
        "pulse-slow": "pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite",
        "fade-in": "fadeIn 0.3s ease-out",
        "slide-up": "slideUp 0.3s ease-out",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        slideUp: {
          "0%": { opacity: "0", transform: "translateY(8px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
      },
    },
  },
  plugins: [],
};
