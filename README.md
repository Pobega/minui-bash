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
