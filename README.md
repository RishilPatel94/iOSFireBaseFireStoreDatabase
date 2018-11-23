
## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects. See the ["Getting Started" guide for more information](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking). You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build AFNetworking 3.0.0+.

#### Podfile

To integrate AFNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RishilFBDB' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  #use_frameworks!
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  # Pods for RishilFBDB

end
```

Then, run the following command:

```bash
$ pod install
```

