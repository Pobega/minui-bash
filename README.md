# minui-bash

This repository builds a `bash` binary for the `aarch64` architecture for use in MinUI and derivatives.

## Supported Devices

At the current time we only support `tg5040` (TrimUI Brick/Smart Pro)

## Prerequisites

*   Docker
*   `make`

## Build

To build the `bash` binary, run:

```
make build
```

The resulting binary will be in the `build/` directory.

## Thanks

* [frysee](https://github.com/frysee) for [NextUI](https://github.com/LoveRetro/NextUI) and the cross-compile Docker image used to build bash
* [ben16w](https://github.com/ben16w) for [minui-portmaster](https://github.com/ben16w/minui-portmaster)
* [josegonzalez](https://github.com/josegonzalez) for your `minui-*` repositories, which this is (loosely) based on.
