# NumPad

[![Version](https://img.shields.io/cocoapods/v/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)
[![License](https://img.shields.io/cocoapods/l/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)
![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/efremidze/NumPad.svg)](https://travis-ci.org/efremidze/NumPad)

## Overview

Number Pad inspired by Square's design.

![Demo](demo.gif)

```
$ pod try NumPad
```

## Requirements
* iOS 7.0+
* Swift 2.2
* Xcode 7

## Installation
###CocoaPods
  ```ruby
  use_frameworks!
  pod "NumPad"
  ```

###Carthage
  ```ruby
  github "efremidze/NumPad"
  ```

###Swift Package Manager
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

```swift
let numPad = NumPad()
numPad.dataSource = self
numPad.delegate = self
addSubview(numPad)
```

DataSource Functions 
```swift
func numberOfRowsInNumberPad(numPad: NumPad) -> Int {
    // numbers of rows
}

func numPad(numPad: NumPad, numberOfColumnsInRow row: Int) -> Int {
    // numbers of columns
}

func numPad(numPad: NumPad, buttonForPosition position: Position) -> UIButton {
    // configure button
}
```

Delegate Functions 
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
