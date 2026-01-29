Pod::Spec.new do |s|

    s.name                      = 'TeadsAppLovinAdapter'
    s.version                   = '6.0.6'
    s.summary                   = "AppLovin MAX Adapter for Teads' iOS SDK"
    s.module_name               = 'TeadsAppLovinAdapter'
    s.description               = <<-DESC
                                Use this adapter to include AppLovin as a demand source in your mediation waterfall
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-iOS'
    s.documentation_url         = "https://support.teads.tv/support/solutions/articles/36000314771-smart-adserver-mediation-inread"
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2023' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :tag => "#{s.version}" }
    s.platform                  = 'ios'
    s.ios.deployment_target     = '12.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.source_files              = ['MediationAdapters/TeadsAppLovinAdapter/**/*{.swift}', 'MediationAdapters/Common/*{.swift}']
    s.exclude_files             = ['MediationAdapters/TeadsAppLovinAdapter/Exports.swift']
    s.dependency                'TeadsSDK', s.version.to_s
    s.dependency                'AppLovinSDK', '>= 12.3.1'

    s.pod_target_xcconfig       = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.user_target_xcconfig      = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

end
