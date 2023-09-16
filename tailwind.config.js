// See the Tailwind default theme values here:
// https://github.com/tailwindcss/tailwindcss/blob/master/stubs/defaultConfig.stub.js
const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')

/** @type {import('tailwindcss').Config */
module.exports = {
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],

  content: [
    './app/components/**/*.rb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.erb',
    './app/views/**/*.haml',
    './app/views/**/*.slim',
    './lib/jumpstart/app/views/**/*.erb',
    './lib/jumpstart/app/helpers/**/*.rb',
  ],

  // All the default values will be compiled unless they are overridden below
  theme: {
    // Extend (add to) the default theme in the `extend` key
    extend: {
      // Create your own at: https://javisperez.github.io/tailwindcolorshades
      colors: {
        primary: colors.blue,
        secondary: colors.emerald,
        tertiary: colors.gray,
        danger: colors.red,
        "code-400": "#fefcf9",
        "code-600": "#3c455b",
        'haiti': {
          '50': '#f0ebf5',
          '100': '#e2d8eb',
          '200': '#b6a3cc',
          '300': '#8a74ab',
          '400': '#41306e',
          '500': '#0e092d',
          '600': '#0c0729',
          '700': '#080521',
          '800': '#06031c',
          '900': '#040214',
          '950': '#02010d'
        },
        "black-violet": "#0E092D",
        "marketing-gradient-start": "#faf6fd",
        "marketing-gradient-end": "#f9e9e0",

      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', ...defaultTheme.fontFamily.sans],
      },
      screens: {
        'xxs': '320px', // max-width
        'xs': '460px', // min-width
      },  
    },
  },

  // Opt-in to TailwindCSS future changes
  future: {
  },
}
