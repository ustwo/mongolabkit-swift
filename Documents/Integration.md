## Integration

Platform-specific framework projects are included in the workspace.

``` swift
import MongoLabKit
```

### Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

``` bash
$ brew update
$ brew install carthage
```

To integrate MongoLabKit into your Xcode project using Carthage, specify it in your `Cartfile`:

``` ogdl
github "ustwo/mongolabkit-swift"
```

Then use platform-specific commands to create the build products that you need to add to your project:

````
carthage update --platform iOS
carthage update --platform tvOS
carthage update --platform watchOS
````

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for swift and Objective-C, which automates and simplifies the process of using 3rd-party libraries like MongoLabKit in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate MongoLabKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

target '{TARGET_NAME}' do
    pod 'MongoLabKitSwift'
end
```

Then, run the following command:

```bash
$ pod install
```

