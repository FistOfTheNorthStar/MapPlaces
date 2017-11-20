# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

def all_pods
  #pod 'IGListKit', '~> 3.0'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Alamofire', '~> 4.5'
  pod 'SnapKit', '~> 4.0.0'
  pod 'Google-Mobile-Ads-SDK'
  pod 'GoogleSignIn'
  pod 'SwiftyJSON'
  pod 'PopupDialog', '~> 0.6'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'GoogleAPIClientForREST/Sheets', '~> 1.2.1'
  pod 'FontAwesome.swift', :git => 'https://github.com/thii/FontAwesome.swift.git', :branch => 'swift-4.0'
  pod 'Firebase'
  pod 'FirebaseAuth'
end

target 'MapPlaces' do
  all_pods
end

target 'MapPlacesTests' do
  inherit! :search_paths
  # Pods for testing
  all_pods
end

target 'MapPlacesUITests' do
  inherit! :search_paths
  # Pods for testing
  all_pods
end
