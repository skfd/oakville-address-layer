# Oakville Addresses Layer

Turns the Town of Oakville municipal **Address Points** dataset into map-tile
layers (interactive vector + labelled raster) that OpenStreetMap mappers can add
to the **iD** and **JOSM** editors as a reference overlay.

This is a thin repo: the whole pipeline is the
[`address-layerist`](../address-layerist) engine. All that lives here is
[`layer.toml`](layer.toml) (the data source + field map + site settings) and a
`run.py` shim.

## Setup

```
pip install -e ../address-layerist      # the engine + its deps
```

The vector-tile step needs WSL2 + tippecanoe once -- see
[../address-layerist/wsl-setup.md](../address-layerist/wsl-setup.md).

## Usage

```
python run.py fetch      # paginated pull from the Oakville ArcGIS layer
python run.py slim       # stream it into a slim GeoJSONL + meta
python run.py vector     # vector (MVT) tiles via WSL tippecanoe
python run.py raster     # labelled raster (PNG) tiles
python run.py site       # render the landing page

python run.py build      # all of the above
python run.py update     # build + publish (the daily entry point)
```

Build output lands in `build/site/`; that directory is what gets published.

## Scheduling (Windows)

Run as Administrator:

```powershell
.\schedule-add.ps1       # registers a daily task "OakvilleAddressLayer"
.\schedule-remove.ps1    # unregisters it
```

## Licence / attribution

Address data (c) Town of Oakville, published under the Open Government Licence.
Tiles and the landing page carry that attribution.
