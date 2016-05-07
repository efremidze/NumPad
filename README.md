# NumPad ![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg) [![Version](https://img.shields.io/cocoapods/v/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![License](https://img.shields.io/cocoapods/l/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)

## Overview

Number Pad inspired by [Square](https://square.com). This module is based on [LEAmountInputView](https://github.com/efremidze/LEAmountInputView).

![Demo](demo.gif)

```
$ pod try NumPad
```

## Installation
###CocoaPods
To install with [CocoaPods](http://cocoapods.org/), simply add this in your *Podfile* file:
  ```ruby
  use_frameworks!
  pod "NumPad"
  ```

###Carthage
To install with [Carthage](https://github.com/Carthage/Carthage), simply add this in your `Cartfile`:
  ```ruby
  github "efremidze/NumPad"
  ```

###Swift Package Manager
To install with [Swift Package Manager](https://github.com/apple/swift-package-manager), simply add this in your `Package.Swift`:
  ```swift
  import PackageDescription

  let package = Package(
    name: "NumPad",
    dependencies: [
      .Package(url: "https://github.com/efremidze/NumPad.git", majorVersion: 1)
    ]
  )
  ```

## Usage
NumPad makes it easy to create a number pad.
```swift
let numPad = NumPad()
numPad.dataSource = self
numPad.delegate = self
addSubview(numPad)
```

### DataSource
```swift
func numberOfRowsInNumPad(numPad: NumPad) -> Int {
    // numbers of rows
}

func numPad(numPad: NumPad, numberOfColumnsInRow row: Int) -> Int {
    // numbers of columns
}

func numPad(numPad: NumPad, buttonForPosition position: Position) -> UIButton {
    // configured button
}
```

### Delegate
```swift
func numPad(numPad: NumPad, buttonTappedAtPosition position: Position) {
    // handle button tap
}

func numPad(numPad: NumPad.NumPad, sizeForButtonAtPosition position: NumPad.Position, defaultSize size: CGSize) -> CGSize {
    // custom button sizing
}
```

## Contributions

Contributions are totally welcome.

## License

NumPad is available under the MIT license. See the LICENSE file for more info.
