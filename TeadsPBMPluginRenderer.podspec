Pod::Spec.new do |s|

    s.name                      = 'TeadsPrebidPlugin'
    s.version                   = '5.3.0'
    s.summary                   = "PrebidMobile Plugin renderer for Teads' iOS SDK"
    s.module_name               = 'TeadsPrebidPlugin'
    s.description               = <<-DESC
                                Use this plugin to request and render Teads demand source in your PrebidMobile integration
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-iOS'
    s.documentation_url         = "https://support.teads.tv/support/solutions/articles/36000459748"
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2021' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :tag => "#{s.version}" }
    s.platform                  = 'ios'
    s.ios.deployment_target     = '12.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.source_files              = ['MediationAdapters/TeadsPluginRenderer/**/*{.swift}', 'MediationAdapters/Common/*{.swift}']
    s.exclude_files             = []
    s.dependency                'TeadsSDK', s.version.to_s
    s.dependency                'PrebidMobile', '>= 3.0.2'

    s.pod_target_xcconfig       = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.user_target_xcconfig      = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
