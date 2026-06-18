
workspace 'TeadsSampleApp.xcworkspace'
# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

# Shared Teads pods reused by both the UIKit and SwiftUI sample apps.
def teads_sample_pods
  # Use local TeadsSDK from Frameworks directory
  pod 'TeadsSDK', :path => '.'

  # Use remote adapters
  pod 'TeadsSASAdapter', :path => '.'
  pod 'TeadsAdMobAdapter', :path => '.'
  pod 'TeadsAppLovinAdapter', :path => '.'
end

target 'TeadsSampleApp' do
  project 'TeadsSampleApp.xcodeproj'
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  teads_sample_pods

  pod 'SwiftFormat/CLI'
end

target 'TeadsSwiftUISampleApp' do
  project 'TeadsSwiftUISampleApp.xcodeproj'
  use_frameworks!

  teads_sample_pods
end
