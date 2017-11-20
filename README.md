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

### GoogleService-Info.plist
Follow the instructions [Google Sign-in](https://developers.google.com/identity/sign-in/ios/start-integrating). Note that the instructions are a bit outdated on some parts, so just get the configuration file and ad it to your project.

### Info.plistREMOVE
Just remove 'REMOVE' from the end of the file, and edit the file to add your correct ID number.

### AppDelegate.swift
Remove 'REMOVE' from AppDelegate.swiftREMOVE. You will need to activate and create the necessary keys for the Google Apis you are going to use. Google Mobile Ads have not been integrated to the app yet.

## Testing
The Google libraries have some problems that arise during testing. You will need to make some small changes if you wish to make the tests possible at all. Unit tests are still incomplete on the Google's documents on the problems are inexistent or missing completely.   
