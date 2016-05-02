# NumPad

[![Twitter](https://img.shields.io/badge/Twitter-@lasha_-blue.svg?style=flat)](http://twitter.com/lasha_)
[![CocoaPods](https://img.shields.io/cocoapods/p/NumPad.svg)](https://cocoapods.org/pods/NumPad)
[![CocoaPods](https://img.shields.io/cocoapods/v/NumPad.svg)](http://cocoapods.org/pods/NumPad)
[![Travis](https://img.shields.io/travis/efremidze/NumPad.svg)](https://travis-ci.org/efremidze/NumPad)

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

NumPad is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod 'NumPad'
```

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

See the `NumPadDemo` project for example usage.

## Contributions

Contributions are totally welcome.

## License

NumPad is available under the MIT license. See the LICENSE file for more info.
