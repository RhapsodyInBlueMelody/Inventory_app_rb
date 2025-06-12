module.exports = {
  content: [
    "./app/views/**/*.html.erb", // All ERB files in app/views
    "./app/helpers/**/*.rb", // If you have Tailwind classes in helpers
    "./app/javascript/**/*.js", // If you had JavaScript, though you skipped it
    "./app/assets/stylesheets/**/*.css", // If you use custom CSS that Tailwind should process
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
