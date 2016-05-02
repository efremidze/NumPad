# NumPad

![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)
[![License](https://img.shields.io/cocoapods/l/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)
[![Platform](https://img.shields.io/cocoapods/p/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/efremidze/NumPad.svg)](https://travis-ci.org/efremidze/NumPad)
[![Twitter](https://img.shields.io/badge/Twitter-@lasha_-blue.svg?style=flat)](http://twitter.com/lasha_)

## Overview

`NumPad` is a number pad inspired by Square's design.

![NumPad Screenshot](Screenshots/example.gif)

```
$ pod try NumPad
```

## Requirements
* iOS 7.0+
* Swift 2.2
* Xcode 7

## Installation
* **CocoaPods**
  ```ruby
  use_frameworks!
  pod "NumPad"
  ```

* **Carthage**
  ```ruby
  github "efremidze/NumPad"
  ```

* **Swift Package Manager**
  ```swift
  import PackageDescription

  let package = Package(
    name: "NumPad",
    dependencies: [
      .Package(url: "https://github.com/efremidze/NumPad.git", majorVersion: 1)
    ]
  )
  ```

* **Manually**
  * To install manually the NumPad in an app, just drag the `NumPad/NumPad.swift` file into your project.

## Usage

```swift
let numPad = NumPad()
numPad.dataSource = self
numPad.delegate = self
addSubview(numPad)

// NumPadDataSource
func numberOfRowsInNumberPad(numPad: NumPad) -> Int {
    return 4
}

func numPad(numPad: NumPad, numberOfColumnsInRow row: Int) -> Int {
    return 3
}

// NumPadDelegate
func numPad(numPad: NumPad, willDisplayButton button: UIButton, forPosition position: Position) {
    let index = numPad.indexForPosition(position)
    button.setTitle("\(index + 1)", forState: .Normal)
}

func numPad(numPad: NumPad, buttonTappedAtPosition position: Position) {
    // handle tap
}

```

## Contributions

Contributions are totally welcome.

## License

NumPad is available under the MIT license. See the LICENSE file for more info.
