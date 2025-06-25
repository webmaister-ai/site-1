# CLAUDE.md

This file provides guidance to Claude Code when working with this website.

## Code Generation Guidelines

### Core Principles
- **Keep it simple**: Use straightforward HTML, CSS, and minimal JavaScript
- **Content first**: Focus on clear, accessible content over complex features
- **Performance matters**: Optimize images, minimize CSS/JS, use semantic HTML
- **Mobile responsive**: Always consider mobile-first design

### Code Style
- Follow standard HTML5 semantic structure
- Use Tailwind utility classes, avoid custom CSS unless necessary
- Keep JavaScript minimal and progressive enhancement focused
- Prefer Eleventy's built-in features over custom plugins

## Technology Stack

### Required Versions
- **Eleventy**: `@11ty/eleventy@^3.1.1` (latest v3.x)
- **Tailwind CSS**: `tailwindcss@^4.1.0` (latest v4.x with CSS-first approach)
- **Node.js**: v20.x LTS or higher

### Key Differences in These Versions
- **Tailwind v4**: Uses CSS-first configuration, not JavaScript config files
- **Eleventy v3**: ESM by default, updated template syntax, improved performance
- Both tools have breaking changes from previous major versions

## Project Structure

### Expected Layout
```
/
├── package.json
├── eleventy.config.js (ESM format)
├── tailwind.config.css (NOT .js file)
├── src/
│   ├── _includes/
│   ├── _data/
│   ├── assets/
│   └── ... content ...
└── _site/ (build output)
```

### Configuration Files

**Eleventy Config (eleventy.config.js):**
```javascript
export default function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("src/assets");
  eleventyConfig.addPassthroughCopy("src/images");
  
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
```

**Tailwind Config (tailwind.config.css):**
```css
@import "tailwindcss";

/* Custom imports here */

@theme {
  /* Custom design tokens here */
}
```

## Development Commands

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

```

### Package.json Scripts
```json
{
  "scripts": {
    "dev": "npm run css:watch & eleventy --serve --watch",
    "build": "npm run css:build && eleventy",
    "preview": "eleventy --serve",
    "css:build": "tailwindcss -i tailwind.config.css -o _site/css/style.css",
    "css:watch": "tailwindcss -i tailwind.config.css -o _site/css/style.css --watch"
  },
}
```

## Content Guidelines

## Content Management

### Business Information Workflow
1. **Source of truth**: All business information is maintained in `site-information.md`
2. **Auto-generation**: When updating content, generate `src/_data/business.json` from the markdown file
3. **Template usage**: Use `{{ business.name }}`, `{{ business.phone }}` etc. in templates

### Content Update Process
When business information changes:
1. Human updates `site-information.md` 
2. Claude Code reads the markdown and generates/updates `src/_data/business.json`
3. Eleventy templates automatically use the updated data

### Data Generation Rules
- Parse `site-information.md` and extract structured data
- Convert to JSON format compatible with Eleventy templates
- Maintain consistent property names (camelCase for template usage)
- Handle nested data (hours, location, menu items) appropriately

### File Organization
- Pages go in `src/` root and subsections under their own directory
- Layouts in `src/_includes/`
- Data files in `src/_data/`
- Static assets in `src/assets/`

## File Management Rules

### Restricted Directories
**NEVER access, read, or modify files in these directories:**
- `prompts/` - Historical data only, completely off-limits
- `.git/` - Version control data
- `node_modules/` - Package dependencies

### Important: Prompts Directory
- The `prompts/` folder exists for human record-keeping only
- Claude Code should never read from or reference this directory
- All necessary context will be provided explicitly in each request
- Do not scan or explore the prompts directory for any reason


### Common Patterns
- Use `.md` for content-heavy pages
- Use `.njk` for template-heavy pages
- Keep frontmatter simple and consistent
- Use Eleventy's data cascade effectively

## Styling Approach

### Tailwind v4 Guidelines
- Use utility classes directly in templates
- Define custom properties in `tailwind.config.css` using `@theme`
- Avoid creating custom CSS files unless absolutely necessary
- Use Tailwind's semantic color names

### Responsive Design
- Mobile-first approach with `sm:`, `md:`, `lg:` prefixes
- Test on multiple screen sizes
- Ensure touch targets are at least 44px

## Common Tasks

### Adding New Pages
1. Create file in `src/` or appropriate directory
2. Add frontmatter with title, layout, etc.
3. Use consistent navigation structure
4. Test responsive design

### Updating Styles
1. Use existing Tailwind utilities first
2. If custom styles needed, add to `tailwind.config.css`
3. Avoid inline styles or separate CSS files
4. Maintain design consistency

### Working with Data
1. Use `src/_data/` for site-wide data
2. JSON files become global data
3. Use data in templates with Eleventy's syntax
4. Keep data structure simple and flat when possible

## Before Making Changes

## Post-Change Actions

### After Making Changes
Always trigger a build to verify changes work correctly:
```bash
npm run build
```

### Quick Checklist
1. Is the development server running? (`npm run dev`)
2. Are you editing files in `src/` not `_site/`?
3. Do changes work on mobile?
4. Is the code simple and maintainable?

### Testing Changes
- Check browser console for errors
- Test responsive breakpoints
- Verify all links work
- Ensure content is accessible