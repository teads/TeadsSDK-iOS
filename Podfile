project 'TeadsDemoApp.xcodeproj'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TeadsDemoApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TeadsDemoApp
  pod 'GoogleMobileAdsMediationTeads', '4.7.8'
  pod 'MoPub-Teads-Adapters', '4.7.8'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64 arm64e armv7 armv7s"
      config.build_settings["EXCLUDED_ARCHS[sdk=iphoneos*]"] = "i386 x86_64"
    end
  end
end
