# HBS 2028 Section A website

The public website for Section A of the Harvard Business School MBA Class of 2028. It is an unofficial, student-run site and is not affiliated with or endorsed by Harvard Business School.

Built with [Jekyll](https://jekyllrb.com/) on the [Alembic](https://github.com/daviddarnes/alembic) theme by David Darnes (MIT licensed, see [LICENSE](LICENSE)).

## Editing the site

- **Site settings, navigation and links:** `_config.yml`
- **Pages:** `index.md` (home), `about.md` (The Section), `members.md`, `events.md`, `contact.md`
- **Member profiles:** one file per person in `_members/`. Copy `member-template.md` to `_members/first-last.md` and fill it in; each profile gets its own page at `/members/first-last/` and a card on the Members page. Add a square photo to `assets/members/`, or leave `photo` empty to show gold initials. Delete the `classmate-0X.md` placeholders as real profiles arrive
- **Stories:** add a Markdown file to `_posts/` named `YYYY-MM-DD-title.md`
- **Colours and fonts:** `_sass/_settings.scss` sets the black, gold (`#c9a54c`) and platinum (`#e5e4e2`) palette and the type; `_sass/_luxe.scss` holds the minimalist styling
- **Styrene typeface:** Styrene is a licensed font from Commercial Type, so the site uses the free look-alike Space Grotesk until you add it. With a web licence, put `StyreneA-Regular.woff2`, `StyreneA-Medium.woff2`, `StyreneB-Regular.woff2` and `StyreneB-Bold.woff2` in `assets/fonts/` and set `styrene_fonts: true` in `_config.yml`. Visitors who have Styrene installed already see it
- **Logo and icons:** `assets/logos/`

Pages contain _placeholder_ text in italics. Replace it with real content, and only publish classmates' names, photos or contact details with their consent, since the site is public.

## Publishing on GitHub Pages

1. In the repository, go to **Settings → Pages** and set **Source** to **GitHub Actions**.
2. Push to `main`. The workflow in `.github/workflows/pages.yml` builds and deploys the site.

## Running locally

```sh
bundle install
bundle exec jekyll serve
```

Then open http://localhost:4000.
