# SwiftMongoLabKit by ustwo
---

### Welcome to SwiftMongoLabKit 
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/ustwo/swift-mongolab-kit/blob/master/LICENSE) 
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/badge/Pods-compatible-4BC51D.svg?style=flat)](https://cocoapods.org)
[![Platforms iOS | watchOS | tvOS](https://img.shields.io/badge/Platforms-iOS%20%7C%20watchOS%20%7C%20tvOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)

SwiftMongoLabKit is a REST client API for iOS, tvOS and watchOS written to make REST calls to a MongoLab database.

---

## Requirements 

- iOS 9.0+ / Mac OS X 10.9+
- Xcode 7.3 / Swift 2.2

## Platform Support

- iOS
- tvOS
- watchOS

## Integration

Platform-specific framework projects are included in the workspace.

``` swift 
import SwiftMongoLabKit
```

### Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

``` bash
$ brew update
$ brew install carthage
```

To integrate SwiftMongoLabKit into your Xcode project using Carthage, specify it in your `Cartfile`:

``` ogdl
github "ustwo/swift-mongolab-kit"
```

Then use platform-specific commands to create the build products that you need to add to your project:

````
carthage update --platform iOS
carthage update --platform tvOS
carthage update --platform watchOS
````

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for swift and Objective-C, which automates and simplifies the process of using 3rd-party libraries like SwiftMongoLabKit in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate SwiftMongoLabKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/ustwo/swift-mongolab-kit.git'

pod 'SwiftMongoLabKit', '~>0.1'
```

Then, run the following command:

```bash
$ pod install
```

---

## Usage

### Creating a configuration map

A configuration map must be created to define the mongoLab database baseURL and apiKey

``` swift 
let configuration = MongoLabConfiguration(baseURL: "{BASE_URL}", apiKey: "{API_KEY}")
```

### Creating a GET request with query string parameters

``` Swift
let parameter1 = MongoLabURLRequest.RequestParameter(parameter: "{PARAMETER_NAME}", value: "{PARAMETER_VALUE}")
let parameter2 = MongoLabURLRequest.RequestParameter(parameter: "{PARAMETER_NAME}", value: "{PARAMETER_VALUE}")

let request = MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/[COLLECTION_NAME]", method: .GET, parameters: [parameter1, parameter2], bodyData: nil)
```

### Creating a POST request with body data

``` Swift
let body: [String: AnyObject] = [{PARAMETER_KEY}: [{PARAMETER_KEY}: {PARAMETER_VALUE}]]

let request = MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/[COLLECTION_NAME]", method: .POST, parameters: [], bodyData: body)
```

### Making REST call

``` Swift
let client = MongoLabClient()

client.performRequest(request) {
result in

switch result {
case let .Success(response):
print("Success \(response)")

case let .Failure(error):
print("Error \(error)")

}
}
```

---

## Roadmap

* Create services and parsers for creating, modifying and deleting collections
* Create services and parsers for creating, modifying and deleting documents

---

## Contributing

Do you love the app and want to get involved? Or maybe you've found a bug or 
have a new feature suggestion? Thanks! There are plenty of ways you can help.

Please see the [Contributing to SwiftMongoLabKit guide](https://github.com/ustwo/swift-mongolab-kit/blob/develop/CONTRIBUTING.md).

---

## Team

* Developer iOS: [Luca Strazzullo](mailto:luca@ustwo.com)
