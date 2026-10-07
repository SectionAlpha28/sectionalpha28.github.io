# HBS 2028 Section A website

The public website for Section A of the Harvard Business School MBA Class of 2028. It is an unofficial, student-run site and is not affiliated with or endorsed by Harvard Business School.

Built with [Jekyll](https://jekyllrb.com/) on the [Alembic](https://github.com/daviddarnes/alembic) theme by David Darnes (MIT licensed, see [LICENSE](LICENSE)).

## Editing the site

- **Site settings, navigation and links:** `_config.yml`
- **Pages:** `index.md` (home), `about.md`, `events.md`, `resources.md`, `contact.md`
- **News posts:** add a Markdown file to `_posts/` named `YYYY-MM-DD-title.md`
- **Colours and fonts:** `_sass/_settings.scss` (accent colour is crimson `#a51c30`)
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
