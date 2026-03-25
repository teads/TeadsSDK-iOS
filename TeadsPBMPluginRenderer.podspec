Pod::Spec.new do |s|

    s.name                      = 'TeadsPBMPluginRenderer'
    s.version                   = '6.0.11'
    s.summary                   = "PrebidMobile Plugin renderer for Teads' iOS SDK"
    s.module_name               = 'TeadsPBMPluginRenderer'
    s.description               = <<-DESC
                                Use this plugin to request and render Teads demand source in your PrebidMobile integration
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-iOS'
    s.documentation_url         = 'https://developers.teads.com/docs/iOS-SDK/Prebid/custom_plugin'
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2026' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :tag => "#{s.version}" }
    s.platform                  = 'ios'
    s.ios.deployment_target     = '14.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.source_files              = ['MediationAdapters/TeadsPBMPluginRenderer/**/*{.swift}']
    s.dependency                'TeadsSDK', s.version.to_s
    s.dependency                'PrebidMobile', '>= 3.0.2'

end
