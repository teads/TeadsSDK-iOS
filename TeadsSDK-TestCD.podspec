Pod::Spec.new do |s|

s.name         = "TeadsSDK-TestCD"
s.version      = "4.1.0"
s.summary      = "Teads' iOS SDK"

s.description  = <<-DESC
                 Teads allows you to integrate a single SDK into your app, and serve premium branded ads from Teads' SSP.
                 DESC

s.ios.deployment_target     = "9.0"

s.homepage     = "https://github.com/teads/TeadsSDK-iOS"
s.license      = "Apache 2.0"
s.author       = { "Teads" => "support-sdk@teads.tv" }
s.source       = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :branch => 'test_CD', :tag => "v#{s.version}"}

s.requires_arc = true
s.preserve_paths = 'TeadsSDK-Xcode9.4/TeadsSDK-Xcode9.4.framework'
s.vendored_frameworks = 'TeadsSDK-Xcode9.4/TeadsSDK-Xcode9.4.framework'
s.ios.frameworks = 'AdSupport', 'AVFoundation', 'CoreLocation', 'CoreMedia', 'CoreTelephony', 'MediaPlayer', 'SystemConfiguration'
s.framework = 'TeadsSDK'

end