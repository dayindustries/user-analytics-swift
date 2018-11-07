# User Analytics (Swift)

## Installation

Given a `Package.swift` like:

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "foo",
    products: [
        .executable(name: "Foo", targets: ["Foo"]),
    ],
    dependencies: [
        // TODO: Add dependencies here...
    ],
    targets: [
        .target(
            name: "Foo",
            dependencies: [
                // TODO: Add library names here...
            ]),
    ]
)
```

Replace `// TODO: Add dependencies here...` with:

```swift
.package(url: "https://github.com/dayindustries/user-analytics-swift.git"),
```

And replace `// TODO: Add library names here...` with:

```swift
"UserAnalytics"
```

## Usage

```swift
import UserAnalytics

let userAnalytics = UserAnalytics(token: token, endpoint: endpoint)
let data: Dictionary<String, Any> = [
    "distinct_id": "1",
    "time": UserAnalytics.toAthenaTimestamp(Date()),
    "ip": "71.198.38.200",
    "env": "prod",
    "event": "Signed Up",
    "subcategory": "",
    "event_id": "",
    "source": "someservice",
    "client": "ios",
    "os_version": "",
    "app_version": ""
]

userAnalytics.post(streamName: "UserAnalytics", data: data) { data, error in
    if error != nil || data == nil {
        // TODO: Handle something going wrong...
    }

    let dictionary = try JSONSerialization.jsonObject(with: data!, options: [])
    if dictionary == nil {
        // TODO: Couldn't parse the dictionary...
    }

    // Do something with the string body...
    print(dictionary)
}
```
