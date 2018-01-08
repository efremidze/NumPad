# NumPad

[![Language](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](https://swift.org)
[![Version](https://img.shields.io/cocoapods/v/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)
[![CI Status](http://img.shields.io/travis/efremidze/NumPad.svg?style=flat)](https://travis-ci.org/efremidze/NumPad)
[![codebeat badge](https://codebeat.co/badges/c41fb90e-aa9f-4a40-85b4-9df9011e7931)](https://codebeat.co/projects/github-com-efremidze-numpad)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Number Pad inspired by [Square](https://square.com). This module is based on [LEAmountInputView](https://github.com/efremidze/LEAmountInputView).

![Demo](demo.gif)

```
$ pod try NumPad
```

## Requirements

- iOS 9.0+
- Xcode 9.0+
- Swift 4 (NumPad 3.x), Swift 3 (NumPad 2.x), Swift 2.3 (NumPad 1.x)

## Installation

### CocoaPods
To install with [CocoaPods](http://cocoapods.org/), simply add this in your `Podfile`:
```ruby
use_frameworks!
pod "NumPad"
```

### Carthage
To install with [Carthage](https://github.com/Carthage/Carthage), simply add this in your `Cartfile`:
```ruby
github "efremidze/NumPad"
```

### Manually
1. Download and drop ```NumPad.swift``` in your project.  
2. Congratulations!

## Usage

At first, import NumPad library:

```swift
import NumPad
```

Set the data source and delegate:

```swift
let numPad = NumPad()
numPad.dataSource = self
numPad.delegate = self
addSubview(numPad)
```

Or use the `DefaultNumPad` for a preconfigured NumPad:

```swift
let numPad = DefaultNumPad()
addSubview(numPad)
```

### Data Source
```swift
// number of rows
func numberOfRowsInNumPad(numPad: NumPad) -> Int

// number of columns for row
func numPad(numPad: NumPad, numberOfColumnsInRow row: Row) -> Int

// item for position
func numPad(numPad: NumPad, itemAtPosition position: Position) -> Item
```

### Delegate
```swift
// handle item tap
func numPad(numPad: NumPad, itemTapped item: Item, atPosition position: Position)

// item size for position
func numPad(numPad: NumPad, sizeForItemAtPosition position: Position) -> CGSize
```

## Contributions

Contributions are totally welcome.

## License

NumPad is available under the MIT license. See the LICENSE file for more info.
