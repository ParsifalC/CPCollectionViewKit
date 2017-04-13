# CollectionViewWheelLayoutSwift

<p align="center">
	   <img style=" float:left; display:inline" src="https://github.com/ParsifalC/CollectionViewWheelLayoutSwift/blob/master/ScreenShot.png?raw=true" width="160" height="275" align="center">
	   <img style=" float:left; display:inline" src="http://ojg3xdx9d.bkt.clouddn.com//CPCollectionViewLayout-BottomCenter.gif" width="160" height="275" align="center">
      <img style=" float:left; display:inline" src="http://ojg3xdx9d.bkt.clouddn.com//CPCollectionViewLayout-LeftBottom.gif" width="160" height="275" align="center">
      <img style=" float:left; display:inline" src="http://ojg3xdx9d.bkt.clouddn.com//CPCollectionViewLayout-LeftCenter.gif" width="160" height="275" align="center">
      <img style=" float:left; display:inline" src="http://ojg3xdx9d.bkt.clouddn.com//CPCollectionViewLayout-TopCenter.gif" width="160" height="275" align="center">
 </p>

[![CI Status](http://img.shields.io/travis/ParsifalC/CollectionViewWheelLayoutSwift.svg?style=flat)](https://travis-ci.org/Parsifal/CollectionViewWheelLayoutSwift)
[![Version](https://img.shields.io/cocoapods/v/CollectionViewWheelLayoutSwift.svg?style=flat)](http://cocoapods.org/pods/CollectionViewWheelLayoutSwift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/CollectionViewWheelLayoutSwift.svg?style=flat)]
(http://cocoapods.org/pods/CollectionViewWheelLayoutSwift)
[![Platform](https://img.shields.io/cocoapods/p/CollectionViewWheelLayoutSwift.svg?style=flat)](http://cocoapods.org/pods/CollectionViewWheelLayoutSwift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.[You can view it from Appetize](https://appetize.io/app/k20jdwcyuh8cmjjwyqyq8fen8g?device=iphone6s&scale=75&orientation=portrait&osVersion=9.3)

## Requirements
- **Swift3**
- **Xcode 8.1+**
- **iOS 8.0+**    

## Installation    
CollectionViewWheelLayoutSwift supports multiple methods for installing the library in a project.    
### Installation with CocoaPods    
CollectionViewWheelLayoutSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CollectionViewWheelLayoutSwift"
```
### Installation with Carthage
[Carthage](https://github.com/Carthage/Carthage) is supported as well.To install
it, add the following line to your Cartfile, then Drag the Framework to your Project:

```ruby
github "ParsifalC/CollectionViewWheelLayoutSwift"
```
### Install manually
1. Clone OR Download this repo.    
2. Drag **"CollectionViewWheelLayoutSwift.swift"** to your project.    

## USAGE    

Just config your CollectionView with this layout:
```Swift
let configuration = WheelLayoutConfiguration.init(withCellSize: CGSize.init(width: 100, height: 100), radius: 200, angular: 20, wheelType:wheelType)
let wheelLayout = CollectionViewWheelLayout.init(withConfiguration: configuration)
let colletionView = UICollectionView.init(frame: view.frame, collectionViewLayout:wheelLayout)
```

Support 8 types layout:    

```Swift
public enum WheelLayoutType:Int {
    case leftBottom = 0
    case rightBottom
    case leftTop
    case rightTop
    case leftCenter
    case rightCenter
    case topCenter
    case bottomCenter
}
```

Customize your layout:    

```Swift
public struct WheelLayoutConfiguration {
    public var cellSize:CGSize
    public var radius:Double
    public var angular:Double   
    public var fadeAway:Bool
    public var zoomInOut:Bool
    public var maxContentHeight:Double
    public var contentHeigthPadding:Double
}
```

See more in Example project.   

## Author

Parsifal, zmw@izmw.me

## License

CollectionViewWheelLayoutSwift is available under the MIT license. See the LICENSE file for more info.
