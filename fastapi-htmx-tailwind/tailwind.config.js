/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./templates/**/*.{html,jinja}"],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/container-queries'),
  ],
}

