fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios bump_patch
```
fastlane ios bump_patch
```
Increment patch version number
### ios bump_major
```
fastlane ios bump_major
```
Increment major version number
### ios bump_minor
```
fastlane ios bump_minor
```
Increment minor version number
### ios test
```
fastlane ios test
```
Runs all the tests
### ios betafast
```
fastlane ios betafast
```
Submit a new Beta Build without Screenshots
### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight

This will also make sure the profile is up to date
### ios deploy
```
fastlane ios deploy
```
Deploy a new version to the App Store

----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools).
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).