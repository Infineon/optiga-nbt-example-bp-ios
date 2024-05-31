# OPTIGA&trade; Authenticate NBT Host Library for Swift

This is the OPTIGA&trade; Authenticate NBT Host Library for Swift, which supports the utilization of the [OPTIGA&trade; Authenticate NBT](https://www.infineon.com/OPTIGA-Authenticate-NBT) in Swift-based applications.

## Overview

The OPTIGA&trade; Authenticate NBT Host Library for Swift offers an extensive API to interact with the OPTIGA&trade; Authenticate NBT and to utilize its full functionality. The host library is mainly intended to be used in Swift-based iOS apps interfacing to the OPTIGA&trade; Authenticate NBT via NFC.

Refer to the [OPTIGA&trade; Authenticate NBT - GitHub overview](https://github.com/Infineon/optiga-nbt) repository for an overview of the available host software for the OPTIGA&trade; Authenticate NBT.

### Features

- Sends command APDUs (C-APDU) and receives response APDUs (R-APDU) from the OPTIGA&trade; Authenticate NBT
- Configuration of OPTIGA&trade; Authenticate NBT via its configurator application
- Personalization and operational commands to support simplified interaction with the OPTIGA&trade; Authenticate NBT
- Enables the host application to build, encode, and decode NDEF records and messages with the NDEF library
- Supports building and parsing NDEF records of types "NFC Forum well known type" and "NFC Forum external type"
- Supports OPTIGA&trade; Authenticate NBT brand protection record

### User guide

This host library's [user guide](./docs/userguide.md) is available in the [`docs`](./docs) folder.

## Getting started

This section contains information on how to setup the OPTIGA&trade; Authenticate NBT Host Library for Swift and integrate it into custom Swift-based iOS/macOS applications.

### Setup and requirements

Minimum required versions:

- iOS version 15 and higher
- macOS version 11 and higher

### Project layout

```text
├── docs/            # Includes documentation sources and images
├── LICENSES/        # list of licenses used in this project
└── Sources/         # Includes dependent modules of the host library
```

### Build

The host library uses the Swift Package Manager to build.

```sh
# Build the code
swift build
```

To build the documentation use the following command

```sh
swift package generate-documentation
```

### Usage

See this host library's [user guide](./docs/userguide.md) and the included sub-libraries' `README.md` files for more information.

## Additional information

### Related resources

- [OPTIGA&trade; Authenticate NBT - product page](https://www.infineon.com/OPTIGA-Authenticate-NBT)
- [OPTIGA&trade; Authenticate NBT - GitHub overview](https://github.com/Infineon/optiga-nbt)

### License

This project is [REUSE compliant](https://reuse.software), so copyright and licensing information is stated for every file; see the [LICENSES](LICENSES) folder for details.
