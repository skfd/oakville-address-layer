"""Thin entry point: the pipeline lives in the address-layer engine.

    python run.py build     # fetch + slim + vector + raster + site
    python run.py update    # build + publish
See `python run.py --help` or `addresslayer onboard` for more.
"""

from addresslayer.cli import main

if __name__ == "__main__":
    main()
