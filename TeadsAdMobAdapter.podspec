Pod::Spec.new do |s|

    s.name                      = 'TeadsAdMobAdapter'
    s.version                   = '5.0.1'
    s.summary                   = "AdMob Adapter for Teads' iOS SDK"
    s.module_name               = 'TeadsAdMobAdapter'
    s.description               = <<-DESC
                                Use this adapter to include AdMob as a demand source in your mediation waterfall
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-adapter-admob-ios'
    s.documentation_url         = "https://support.teads.tv/support/solutions/articles/36000166678-google-ad-manager-and-admob-mediation-ios"
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2021' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-adapter-admob-ios.git', :tag => "v5.0.0"}
    s.platform                  = 'ios'
    s.ios.deployment_target     = '10.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.source_files              = ['MediationAdapters/TeadsAdMobAdapter/**/*{.swift}', 'MediationAdapters/Common/*{.swift}']
    s.dependency                'TeadsSDK', s.version.to_s
    s.dependency                'Google-Mobile-Ads-SDK', '>= 8.0'

    s.pod_target_xcconfig       = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.user_target_xcconfig      = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
