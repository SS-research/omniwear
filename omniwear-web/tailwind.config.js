/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./node_modules/primereact/**/*.{js,ts,jsx,tsx}", "./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      backgroundColor: {
        'primary': "#006E7B",
        'secondary': '#FFA500',
      },
      borderColor: {
        'primary-lighter': "#4CA1A9",
      },
    },
  },
  plugins: [],
};
