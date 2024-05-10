# WeatherForecast


<p align="center">
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a> 
<a href="https://developer.apple.com/swift"><img alt="Swift 5" src="https://img.shields.io/badge/language-Swift5-orange.svg"/></a>
</p>


## Getting Started

1. Install Xcode.
1. Install CocoaPod.
1. Clone this repository.
1. Open the `WeatherForecast.xcworkspace`.

## Project structure
###### Architecture: MVVM
###### Network layer: Moya
###### Reactive framework: RxSwift
###### Project structure


##### 1) View Controllers folder
To store all ViewControllers
##### 2) View Models folder
To store all ViewModels
##### 3) View folder
To store all custom Views such as UITableViewCell, etc.
##### 4) Service folder
To store all services (e.g: Network service)
##### 5) Helpers folder
To store all helpers and extensions




## Testing
#### Framework used:
1. Cuckoo (Mocking framework)
2. Nimble (express the expectation framework)

#### Install
1. Modified the generate.sh script to instruct the Cuckoo run
1. Add relative path of the swift file for mocking
1. Execute `./generate` to overwrite the `GeneratedMock.swift`


## Checklist
1. Programming language: Swift is required, Objective-C is optional.
2. Design app's architecture (recommend VIPER or MVP, MVVM but not mandatory)
3. UI should be looks like in attachment.4. WriteUnitTests
5. Exceptionhandling
6. Scaling Text: Display size and font size: To change the size of items on your screen,
adjust the display size or font size.
7. The application is able to proceed searching with a condition of the search term length
must be from 3 characters or above.
8. The application supports caching mechanism so as to prevent the app from
generating a bunch of API requests


## Copyright

### © 2020 Vanalite. All Rights Reserved.

