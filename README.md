# NumPad [![CI Status](http://img.shields.io/travis/efremidze/NumPad.svg?style=flat)](https://travis-ci.org/efremidze/NumPad) ![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg) [![Version](https://img.shields.io/cocoapods/v/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![License](https://img.shields.io/cocoapods/l/NumPad.svg?style=flat)](http://cocoapods.org/pods/NumPad)

Number Pad inspired by [Square](https://square.com). This module is based on [LEAmountInputView](https://github.com/efremidze/LEAmountInputView).

![Demo](demo.gif)

```
$ pod try NumPad
```

## Installation
###CocoaPods
To install with [CocoaPods](http://cocoapods.org/), simply add this in your `Podfile`:
```ruby
use_frameworks!
pod "NumPad"
```

###Carthage
To install with [Carthage](https://github.com/Carthage/Carthage), simply add this in your `Cartfile`:
```ruby
github "efremidze/NumPad"
```

## Usage
NumPad simply works!
```swift
import NumPad

let numPad = NumPad()
addSubview(numPad)
```

### Customization
```swift
var rows: Int // number of rows
var columns: (Int -> Int) // number of columns for row
var item: (Position -> Item)? // item for position
var itemSize: (Position -> CGSize)? // item size for position
var itemTapped: ((Item, Position) -> Void)? // handle item tap
```

## Contributions

Contributions are totally welcome.

## License

NumPad is available under the MIT license. See the LICENSE file for more info.
