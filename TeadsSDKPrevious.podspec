Pod::Spec.new do |s|

s.name         = "TeadsSDKPrevious"
s.version      = "4.2.5"
s.summary      = "Teads' iOS SDK"

s.description  = <<-DESC
                 Teads allows you to integrate a single SDK into your app, and serve premium branded ads from Teads' SSP.
                 DESC

s.ios.deployment_target     = "9.0"

s.homepage     = "https://github.com/teads/TeadsSDK-iOS"
s.license      = "Apache 2.0"
s.author       = { "Teads" => "support-sdk@teads.tv" }
s.source       = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :branch => 'master', :tag => "v#{s.version}Previous"}

s.requires_arc = true
s.preserve_paths = 'TeadsSDKPrevious/TeadsSDK.framework'
s.ios.frameworks = 'AdSupport', 'AVFoundation', 'CoreMedia', 'CoreTelephony', 'MediaPlayer', 'SystemConfiguration'
s.vendored_frameworks = 'TeadsSDKPrevious/TeadsSDK.framework'

s.framework 			= 'TeadsSDK'
end
