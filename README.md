# AlamofireNetworkLogger

Simple request / response logger for Alamofire 5.

```
⬆️ POST 'https://ackee.cz/examples'
Headers: [
    Accept-Encoding : gzip;q=1.0, compress;q=0.5
    Accept-Language : en-US;q=1.0
    Content-Type : application/json
    User-Agent : Reqres_Example/org.cocoapods.demo.Reqres-Example (1; OS Version 9.3 (Build 13E230))
    Content-Length : 13
]
Body: {
    "foo" : "bar"
}

...

⬇️ POST https://ackee.cz/examples (✅ 201 Created) [0.54741 s]
Headers: [
    Vary : Authorization,Accept-Encoding
    Content-Encoding : gzip
    Content-Length : 13
    Server : Apache
    Content-Type : application/json
    Date : Mon, 05 Sep 2016 07:33:51 GMT
    Cache-Control : no-cache
]
Body: {
    "foo" : "bar"
}
```

## Installation

### Carthage

```
github LukasHromadnik/AlamofireNetworkLogger
```

## Usage

AlamofireNetworkLogger is a direct implementation of Alamofire's `EventMonitor`. To integrate it you need to pass it to `Session`

```swift
let logger = AlamofireNetworkLogger(logLevel: .verbose)
let session = Session(eventMonitors: [logger])
```

and then make the request using the `session` property

```swift
session.request(...)
```

## Configuration

Right now the only possible configuration is `logLevel` and it's passed to AlamofireNetworkLogger during initialization.

| Value | Description |
| ---   | ---         |
| `.none` | Nothing will be printed to the console |
| `.light` | Only the URL, status code and duration time will be printed |
| `.verbose` | Everything will appear in the console |
