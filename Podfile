
project 'TeadsSampleApp.xcodeproj'
# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'TeadsSampleApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Use local TeadsSDK from Frameworks directory
  pod 'TeadsSDK', :path => '.'

  # Use remote adapters
  pod 'TeadsSASAdapter', :path => '.'
  pod 'TeadsAdMobAdapter', :path => '.'
  pod 'TeadsAppLovinAdapter', :path => '.'

  pod 'SwiftFormat/CLI'
end
