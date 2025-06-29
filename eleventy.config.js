export default function(eleventyConfig) {
  // Enhanced merge handling verification comment - ensuring proper data cascade and template merge operations
  eleventyConfig.addPassthroughCopy("src/assets");
  eleventyConfig.addPassthroughCopy("src/images");

  eleventyConfig.addFilter("url_encode", function (str) {
    return encodeURIComponent(str);
  });

  eleventyConfig.addShortcode("year", () => `${new Date().getFullYear()}`);
  
  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      data: "_data"
    },
    templateFormats: ["html", "md", "njk"],
    htmlTemplateEngine: "njk",
    markdownTemplateEngine: "njk"

  };
}