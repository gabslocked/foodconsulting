import type { Config } from "tailwindcss";

export default {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        // Food Consulting Brand Colors (from Flutter app)
        primary: {
          DEFAULT: '#003E71', // Indigo Dye - Primary brand color
          light: '#1A5490',
          dark: '#002A4F',
        },
        secondary: {
          DEFAULT: '#8F0E34', // Claret - Secondary brand color
          light: '#A8234A',
          dark: '#6B0A28',
        },
        accent: {
          DEFAULT: '#E9B93A', // Saffron - Accent/highlight color
          light: '#EDC555',
          dark: '#D4A429',
        },
        background: '#FFFFFF',
        surface: {
          DEFAULT: '#FFFFFF',
          variant: '#F9FAFB',
        },
        text: {
          primary: '#003E71',
          secondary: '#6B7280',
          'on-primary': '#FFFFFF',
          'on-accent': '#003E71',
        },
        status: {
          success: '#10B981',
          warning: '#E9B93A',
          error: '#8F0E34',
          info: '#003E71',
        },
        gray: {
          50: '#F9FAFB',
          100: '#F3F4F6',
          200: '#E5E7EB',
          300: '#D1D5DB',
          400: '#9CA3AF',
          500: '#6B7280',
          600: '#4B5563',
          700: '#374151',
          800: '#1F2937',
          900: '#111827',
        },
      },
    },
  },
  plugins: [],
} satisfies Config;