# MapPlaces
MapPlaces is an app add and share your personal locations on Google Maps, with easy management and sharing using Google Sheets. It is written in Swift 4.

## Integrate with Google
You will need to do fix a few steps before you can get the app running.

* Install Pods
* GoogleService-Info.plistREMOVE
* Info.plistREMOVE
* AppDelegate.swiftREMOVE

### Install Frameworks
Just run 'pod install' in the same folder as Podfile exists. For more information [CocoaPods Guide](https://guides.cocoapods.org/using/the-podfile.html)

More information on [Google Sheets](https://developers.google.com/sheets/api/quickstart/ios). Beware the docs are inadequate to say the least and some outdated completely. Easiest way to find out how commands work is to read the source code directly from the framework and use the XCode autocomplete to find out various functions.

 For [Google Maps](https://developers.google.com/maps/documentation/ios-sdk/). The docs are pretty good, and you should have no problems with Google Maps.

### GoogleService-Info.plist
Follow the instructions [Google Sign-in](https://developers.google.com/identity/sign-in/ios/start-integrating). Note that the instructions are a bit outdated on some parts, so just get the configuration file and add it to your project.

### Info.plistREMOVE
Just remove 'REMOVE' from the end of the file, and edit the file to add your correct ID number.

### AppDelegate.swift
Remove 'REMOVE' from AppDelegate.swiftREMOVE. You will need to activate and create the necessary keys for the Google Apis you are going to use. Google Mobile Ads have not been integrated to the app yet.

### MapPlaces.xcodeproj/project.pbxproj
Remember to check your own project settings.

## Testing
The Google libraries have some problems that arise during testing. You will need to make some small changes if you wish to make the tests possible at all. Unit tests are still incomplete on the Google's documents on the problems are inexistent or missing completely.

## Future
Ideally the unit and UI-tests should be comprehensive, but there are real issues here with the Google Pods. One could consider moving to use Firebase, but there are is no documentation available on how to integrate it with Google Sheets API.

Important improvements for the future:
* Improve UX, listing various locations is confusing
* Automate fetching the lists
* Improve Google Maps experience in terms of navigating between various points

Less important:
* Ad a function that verifies a person has visited a place, this would add value to the app as a navigating tool for e.g. orienteering, pub crawls, music events.
* GoogleMobileAds would be beneficial to help keep the project alive
