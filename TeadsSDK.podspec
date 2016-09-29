Pod::Spec.new do |s|

s.name         = "TeadsSDK"
s.version      = "2.4.3"
s.summary      = "Teads' iOS SDK"

s.description  = <<-DESC
                 Teads allows you to integrate a single SDK into your app, and serve premium branded ads from Teads' SSP.
                 DESC

s.ios.deployment_target     = "7.0"

s.homepage     = "https://github.com/teads/TeadsSDK-iOS"
s.license      = "Apache 2.0"
s.author       = { "Teads" => "support-sdk@teads.tv" }
s.source       = { :git => "https://github.com/teads/TeadsSDK-iOS.git", :branch => "master", :tag => "v#{s.version}" }

s.requires_arc = true
s.preserve_paths = 'TeadsSDKDemo/TeadsSDK.framework'
s.vendored_frameworks = 'TeadsSDKDemo/TeadsSDK.framework'
s.resources = 'TeadsSDKDemo/Resources/*'
s.ios.frameworks = 'AdSupport', 'AVFoundation', 'CoreLocation', 'CoreMedia', 'CoreTelephony', 'MediaPlayer', 'SystemConfiguration'
s.library = 'xml2'
s.framework = 'TeadsSDK'

end
