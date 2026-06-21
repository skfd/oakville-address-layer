# CLAUDE.md (project)

Thin consumer of the **address-layer** engine (`../address-layer`). This repo is
config, not code.

- Build pipeline + all logic: `../address-layer/addresslayer/`. Don't add
  pipeline code here; fix or extend the engine instead.
- Data source / field map / site settings: [`layer.toml`](layer.toml).
- Onboarding a different city is a skill: `../address-layer/skills/onboard-city/`.

Common commands (run from this repo root):

```
pip install -e ../address-layer
python run.py build      # fetch + slim + vector + raster + site
python run.py update     # build + publish
```

`publish` force-pushes `build/site/` to an orphan `gh-pages` branch and needs a
git repo with an `origin` remote (do it only when asked).
