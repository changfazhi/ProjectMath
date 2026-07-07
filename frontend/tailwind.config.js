/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'Consolas', 'monospace'],
      },
      keyframes: {
        'fade-in': {
          from: { opacity: '0', transform: 'translateY(4px)' },
          to: { opacity: '1', transform: 'translateY(0)' },
        },
        // Correct-answer tick: spring in with overshoot
        'tick-pop': {
          '0%': { transform: 'scale(0.3)', opacity: '0' },
          '60%': { transform: 'scale(1.1)', opacity: '1' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
        // Green ring expanding + dissolving around the tick
        'ring-burst': {
          '0%': { transform: 'scale(0.5)', opacity: '0.6' },
          '100%': { transform: 'scale(1.8)', opacity: '0' },
        },
        // Whole celebration: hold, then fade with upward drift
        'celebrate-out': {
          '0%, 70%': { opacity: '1', transform: 'translateY(0)' },
          '100%': { opacity: '0', transform: 'translateY(-12px)' },
        },
        // Streak pill first appearance
        'slide-in-right': {
          from: { opacity: '0', transform: 'translateX(12px)' },
          to: { opacity: '1', transform: 'translateX(0)' },
        },
        // Pill bounce on each increment
        'pill-bounce': {
          '0%': { transform: 'scale(1)' },
          '35%': { transform: 'scale(1.12)' },
          '70%': { transform: 'scale(0.97)' },
          '100%': { transform: 'scale(1)' },
        },
        // Streak number scale-pop
        'num-pop': {
          '0%': { transform: 'scale(1.6)' },
          '100%': { transform: 'scale(1)' },
        },
        // Flame wiggle on increment
        'flame-wiggle': {
          '0%, 100%': { transform: 'rotate(0deg) scale(1)' },
          '25%': { transform: 'rotate(-12deg) scale(1.15)' },
          '55%': { transform: 'rotate(10deg) scale(1.1)' },
          '80%': { transform: 'rotate(-4deg) scale(1)' },
        },
        // StreakNotification card entrance
        'scale-in': {
          from: { opacity: '0', transform: 'scale(0.85)' },
          to: { opacity: '1', transform: 'scale(1)' },
        },
        // StreakNotification gently pulsing flame
        'flame-pulse': {
          '0%, 100%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(1.12)' },
        },
      },
      animation: {
        'fade-in': 'fade-in 0.3s ease-out both',
        'tick-pop': 'tick-pop 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both',
        'ring-burst': 'ring-burst 0.6s ease-out both',
        'celebrate-out': 'celebrate-out 1.2s ease-in both',
        'slide-in-right': 'slide-in-right 0.35s ease-out both',
        'pill-bounce': 'pill-bounce 0.45s ease-out',
        'num-pop': 'num-pop 0.35s cubic-bezier(0.34, 1.56, 0.64, 1) both',
        'flame-wiggle': 'flame-wiggle 0.6s ease-in-out',
        'scale-in': 'scale-in 0.25s cubic-bezier(0.34, 1.56, 0.64, 1) both',
        'flame-pulse': 'flame-pulse 1.6s ease-in-out infinite',
      },
    },
  },
  plugins: [],
}
