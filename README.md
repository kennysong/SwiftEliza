# SwiftEliza

SwiftEliza is a Swift + iOS implementation of Weizenbaum's [ELIZA chatbot](https://en.wikipedia.org/wiki/ELIZA), which is a simulation of a Rogerian psychotherapist. 

Based on my [Go implementation](https://github.com/kennysong/goeliza) and QuestionBot from Apple's [App Development with Swift](https://itunes.apple.com/book/app-development-with-swift/id1118575552) book.

![SwiftEliza screenshot](/SwiftEliza/screenshot.png)

## Notes

To run, just open the `SwiftEliza.xcodeproj` in XCode. 

The functionality of ELIZA is contained in the `Eliza.swift` file, and the rest are boilerplate for the iOS app.

Written in Swift 3 for iOS 10 and above. 

## Swift Package Manager

### Import Package

You can import Eliza as a regular Swift Package Manager package. To do so,
use a `Package.swift` like this:

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "MyEliza",
    dependencies: [
        .package(url: "https://github.com/kennysong/SwiftEliza.git",
                 from: "1.0.0")
    ],
    targets: [
        .target(name: "MyEliza", dependencies: [ "Eliza" ])
    ]
)
```

### API

The API consists of just three functions:

- `elizaHi() -> String`
- `elizaBye() -> String`
- `replyTo(_: String) -> String`

Example:

```swift
let eliza = Eliza()
print(eliza.elizaHi())
print(eliza.replyTo("Hi Eliza, I'm feeling super-bad today!"))
print(eliza.elizaBuy())
```

It is recommended that you add proper delays when responding to interactive
questions. See the iOS app or the [therapist](Sources/therapist) tool for an example.
