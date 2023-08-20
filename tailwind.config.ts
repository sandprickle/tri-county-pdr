module.exports = {
  variants: [],
  theme: {
    container: {
      center: true,
      padding: '1rem',
    },
    extend: {
      colors: {
        brand: {
          normal: '#2e3092',
          dark: '#1e1f5e',
          lightest: '#8a8bde',
          light: '#474ADE',
        },
        trans: 'rgba(255,255,255,0.8)',
      },
      fontSize: {
        '2xs': '.6rem',
        '3xs': '.4rem',
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
}
