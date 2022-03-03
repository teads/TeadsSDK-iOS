Pod::Spec.new do |s|

    s.name                      = 'TeadsMoPubAdapter'
    s.version                   = '5.0.11'
    s.summary                   = "MoPub Adapter for Teads' iOS SDK"
    s.module_name               = 'TeadsMoPubAdapter'
    s.description               = <<-DESC
                                Use this adapter to include MoPub as a demand source in your mediation waterfall
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-iOS'
    s.documentation_url         = "https://support.teads.tv/support/solutions/articles/36000314769-inread-twitter-mopub-mediation"
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2021' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :tag => "#{s.version}" }
    s.platform                  = 'ios'
    s.ios.deployment_target     = '10.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.source_files              = ['MediationAdapters/TeadsMoPubAdapter/**/*{.swift}', 'MediationAdapters/Common/*{.swift}']
    s.dependency                'TeadsSDK', s.version.to_s
    s.dependency                'mopub-ios-sdk', '>= 5.13'
    s.frameworks                =  'StoreKit'
    

end
