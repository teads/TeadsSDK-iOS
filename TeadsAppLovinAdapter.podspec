Pod::Spec.new do |s|

    s.name                      = 'TeadsAppLovinAdapter'
    s.version                   = '5.1.2'
    s.summary                   = "AppLovin MAX Adapter for Teads' iOS SDK"
    s.module_name               = 'TeadsAppLovinAdapter'
    s.description               = <<-DESC
                                Use this adapter to include AppLovin as a demand source in your mediation waterfall
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-iOS'
    s.documentation_url         = "https://support.teads.tv/support/solutions/articles/36000357700-inread-applovin-mediation"
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2021' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :tag => "#{s.version}" }
    s.platform                  = 'ios'
    s.ios.deployment_target     = '10.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.source_files              = ['MediationAdapters/TeadsAppLovinAdapter/**/*{.swift}', 'MediationAdapters/Common/*{.swift}']
    s.exclude_files             = ['MediationAdapters/TeadsAppLovinAdapter/Exports.swift']
    s.dependency                'TeadsSDK', s.version.to_s
    s.dependency                'AppLovinSDK', '>= 11.5.1'

    s.pod_target_xcconfig       = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.user_target_xcconfig      = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

end
