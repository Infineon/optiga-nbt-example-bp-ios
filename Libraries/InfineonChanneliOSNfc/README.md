<!--
SPDX-FileCopyrightText: 2024 Infineon Technologies AG
SPDX-License-Identifier: MIT
-->

# Infineon NFC Channel for iOS Swift Library

This library implements the IChannel protocol establishing the NFC synchronous communication channel for iPhones using Core NFC framework provided by iOS SDK. Using a Infineon NFC Channel for iOS we can use Infineon`s library developed for NFC devices.

## Usage

1. Include headers

```swift
import InfineonChanneliOSNfc
```

2. Create a NFC Channel

```swift
 let session: NFCTagReaderSession =  ... // Get the instance from NFCTagReaderSessionDelegate
 let session: NFCTagReaderSession =  ... // Get the instance from NFCTagReaderSessionDelegate
 
 let nfcChannel = NfcChannel(tag: tag, readerSession: session)
``` 
  
2. Open a NFC Channel

```swift
 try nfcChannel.open(exclusive: true)
```
3. Connect a NFC Channel

```swift
  try await channel.connect(request: nil)
```

3. transmit a APDU data

```swift
 let caseCommand = Data([0x00, 0xA4, 0x04, 0x00, 0x00])
 let response = try await nfcChannel.transmit(stream: caseCommand)
     
```    
     
     
4. Use NFC Channel in ApduChannel
```swift
// Instantiates the ``APDUChannel`` with console logger.
let logger = ConsoleLogger.getConsoleLogger()

apduChannel = ApduChannel(
    channel: NfcChannel(tag: tag, readerSession: session),
    logger: logger
)

 ```
 
## Dependencies
* **hsw-channel-swift**

    The Channel library provides IChannel protocol for establishing the generic synchronous communication channel.
    
* **hsw-utils-swift**

    The utilities library provides the utility methods such as byte conversions, string conversions and bit operations. 


