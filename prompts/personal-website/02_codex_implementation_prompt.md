# Codex Implementation & Refinement Prompt

> 用途：当视觉方向已经确定后，交给 Codex 执行。  
> 重点负责：**读取现有项目、保护已经成功的区域、接入真实资源、字体加载、头像、响应式、动效、可访问性与验证**。

## Final Codex Implementation Prompt

You are performing a focused implementation and refinement pass on an existing personal website.

Do NOT redesign the entire website from scratch.

The visual direction has already been established.

Your job is to:

1. inspect the current project
2. preserve successful sections
3. implement the intended typography correctly
4. load the real portrait and local assets
5. refine spacing and responsiveness
6. verify the result technically

Do not make speculative visual changes unless necessary.

# 1. Inspect before editing

Before changing code:
- inspect the project structure
- read the current `index.html`
- inspect the `assets/` directory
- identify the real portrait filename
- identify all real font files
- identify existing CSS architecture
- identify all current animation rules
- identify media queries
- identify all `font-family` and `font:` shorthand declarations

Do not guess filenames.

Do not invent paths.

Do not download new assets unless explicitly requested.

# 2. Keep the architecture lightweight

This is a small static personal website intended for GitHub Pages.

Do NOT introduce:
- React
- Vue
- Next.js
- Tailwind
- a build system
- large animation libraries

unless the existing project already uses them.

Prefer:
- semantic HTML
- CSS
- small amounts of vanilla JavaScript

Keep the page fast and portable.

# 3. Preserve the successful structure

Do not redesign successful sections without a concrete reason.

The intended page rhythm is:

1. calm one-screen Hero / personal information
2. About
3. humorous records
4. Projects
5. Contact

Projects and Contact should be treated as stable.

Refine them only for:
- typography
- spacing
- responsiveness
- small interaction improvements

Do not radically change their composition.

# 4. Hero implementation

The first viewport should occupy approximately `100svh`.

It should contain only:
- navigation
- name
- short introduction
- portrait
- one restrained geometric accent
- optional tiny metadata

Do not add:
- awards
- mathematical diagrams
- equations
- multiple competing shapes
- decorative clutter

The hero is a cover page.

Suggested desktop structure:

LEFT:
- name
- short introduction

RIGHT:
- portrait
- one red geometric plane

On mobile, recompose intentionally.

Do not simply hide the portrait.

# 5. Use the real portrait

Inspect `./assets/` and locate the actual portrait image.

Use the exact filename.

Prefer an actual image element:

```html
<figure class="portrait">
  <img src="./assets/REAL_FILENAME" alt="祁清玄">
</figure>
```

Do not use a placeholder.

Do not invent `avatar.jpg`.

Do not rely on a file outside the project directory.

Use project-relative paths suitable for GitHub Pages.

The portrait should:
- remain recognizable
- use `object-fit: cover`
- have responsive sizing
- avoid circular cropping
- avoid extreme filters
- avoid heavy posterization
- avoid rounded-card UI

Check z-index carefully so the portrait is never hidden behind the red plane.

# 6. Load local fonts correctly

Do not merely write font names into a fallback stack.

Actually load local fonts using `@font-face`.

Inspect `./assets/` first.

Determine whether each font is:
- `.woff2`
- `.woff`
- `.ttf`
- `.otf`
- variable font
- static weight

Use the exact path and correct format.

Example only:

```css
@font-face {
  font-family: "QXChinese";
  src: url("./assets/REAL_CHINESE_FONT.woff2") format("woff2");
  font-style: normal;
  font-weight: 100 900;
  font-display: swap;
}
```

Use unique internal names such as:
- `QXChinese`
- `QXLatin`

This avoids accidentally resolving to an installed system font.

# 7. Typography mapping

Create explicit font variables:

```css
:root {
  --font-cn: "QXChinese", sans-serif;
  --font-latin: "QXLatin", "QXChinese", sans-serif;
}
```

Apply Chinese typography explicitly to:
- `body`
- hero name
- About title
- Contact title
- Chinese project title
- intro copy
- About body copy

Apply the Latin / display font explicitly to:
- project numbers
- project type labels
- English project names
- years
- navigation metadata
- GitHub / Bilibili labels
- small English annotations

Do not rely only on inheritance.

Check every `font:` shorthand rule because it can silently override `font-family`.

# 8. Font hierarchy

Avoid maximum weight everywhere.

Recommended:
- body: 400–500
- intro: 400–500
- nav: 500–600
- metadata: 600–700
- Chinese section headings: 700–800
- project titles: 700–800
- large numbers: 800–900

Do not use `850` or `900` for almost every element.

The typography should feel sharp but refined.

# 9. Debug fonts instead of assuming

If the font still appears unchanged:

1. confirm the real font file path
2. check network / console errors
3. check for:
   - 404
   - failed font decoding
   - OTS parsing errors
   - incorrect format declaration
4. inspect computed styles
5. inspect Rendered Fonts in browser DevTools
6. check whether a later CSS rule overrides the font
7. check whether a `font:` shorthand resets the family

For verification, temporarily apply:

```css
font-family: "QXChinese", sans-serif !important;
```

to the hero name.

Confirm the real custom font renders.

Then remove `!important` if no longer needed.

Do not claim the font is fixed unless the browser is actually rendering it.

# 10. Projects

Preserve the existing graphic direction.

Keep:
- black background
- oxide red accent
- oversized project numbers
- horizontal structure
- hover red field
- sharp link treatment

Project titles should be large enough to read immediately.

Recommended desktop scale:

```css
font-size: clamp(2rem, 3.6vw, 3.6rem);
```

Recommended mobile direction:

```css
font-size: clamp(1.8rem, 9vw, 2.8rem);
```

Adjust based on the actual font metrics.

Do not let project numbers overpower the project name.

Descriptions should remain concise.

# 11. About and records

About is where the graphic language begins to expand after the calm hero.

Use:
- one dominant red field
- clean body copy
- strong but readable heading

Keep the humorous records deadpan.

Do not rewrite their jokes.

Do not convert them into equal cards.

Keep hierarchy among the record entries.

# 12. Contact

Preserve the current Contact direction.

Only refine:
- font consistency
- spacing
- mobile layout
- hover behavior if needed

Do not add generic CTA copy.

# 13. Motion

Keep motion short and decisive.

Hero:
- one geometric motion
- one text reveal
- one portrait reveal

Later sections may use:
- mask reveals
- cut-ins
- line motion
- quick black/red inversion
- directional slide

Avoid fade-up everywhere.

Respect:

```css
@media (prefers-reduced-motion: reduce)
```

The page must remain fully understandable with animations disabled.

# 14. Responsive design

Do not simply shrink desktop composition.

At tablet/mobile widths:
- recompose hero
- retain portrait
- retain name and intro
- preserve breathing room
- reduce decorative intensity
- keep project titles prominent
- avoid clipped faces
- avoid horizontal overflow

Test at least:
- large desktop
- laptop
- ~850px
- ~580px
- ~390px

# 15. Accessibility

Preserve or add:
- semantic headings
- useful `alt` text
- keyboard focus states
- meaningful nav labels
- sufficient contrast
- `prefers-reduced-motion`
- external link `rel="noopener noreferrer"`

Do not sacrifice accessibility for poster aesthetics.

# 16. GitHub Pages compatibility

All resources must work when deployed from the repository.

Prefer:

```text
./assets/...
```

for project-local resources.

Do not reference:
- local absolute Windows paths
- files outside the repository
- temporary filesystem paths

Verify filenames and case sensitivity.

Remember that GitHub Pages runs on a case-sensitive environment.

# 17. Anti-regression rule

This is a refinement pass, not another design exploration.

Do not:
- bring back the crowded poster hero
- add mathematical diagrams to the cover
- move awards back into the first viewport
- shrink project titles
- replace successful Project / Contact layouts
- add random decorations because they match the aesthetic
- rewrite concise human copy into marketing language

If a change is not required to solve a concrete problem, leave the successful design alone.

# 18. Final verification

Before finishing, verify:

## Assets
- real portrait filename found
- real font filenames found
- all paths resolve
- no missing files

## Fonts
- `@font-face` declarations resolve
- browser actually uses the custom fonts
- no unwanted fallback
- Chinese and Latin mappings work

## Hero
- portrait visible
- face recognizable
- hero remains calm
- no clutter
- one-screen composition works

## Projects
- titles are prominent
- hover still works
- black/red composition preserved

## Responsive
- no horizontal overflow
- portrait remains visible on mobile
- typography does not break layouts

## Accessibility
- focus states work
- reduced motion works
- images have alt text

# 19. Final report

After implementation, report only:

1. portrait file used
2. font files used
3. Chinese font mapping
4. Latin / number font mapping
5. any path or font-loading problem discovered
6. any CSS override discovered
7. whether desktop and mobile were verified

Do not stop at recommendations.

Actually modify and verify the code.
