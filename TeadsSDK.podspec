Pod::Spec.new do |s|

    s.name                  = "TeadsSDK"
    s.version               = "4.8.7"
    s.summary               = "Teads' iOS SDK"
    s.module_name           = s.name
    s.description           = <<-DESC
                            Teads allows you to integrate a single SDK into your app, and serve premium branded ads from Teads' SSP.
                            DESC
    s.documentation_url     = "https://support.teads.tv/support/solutions/articles/36000165909"
    s.ios.deployment_target = "9.0"

    s.homepage              = "https://github.com/teads/TeadsSDK-iOS"
    s.license               = { :type => 'Copyright', :text => 'Copyright Teads 2021' }
    s.author                = { "Teads" => "support-sdk@teads.tv" }
    s.source                = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :branch => 'master', :tag => "v#{s.version}"}
    
    s.requires_arc          = true
    
    s.frameworks            = 'AdSupport', 'AVFoundation', 'CoreMedia', 'CoreTelephony', 'MediaPlayer', 'SystemConfiguration'

    s.default_subspec     = 'Core'

    s.subspec 'Core' do |core|
      core.preserve_paths        = "#{s.name}.framework", "OMSDK_Teadstv.xcframework"
      core.vendored_frameworks   = "#{s.name}.xcframework", "OMSDK_Teadstv.xcframework"
    end
end
