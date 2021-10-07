Pod::Spec.new do |s|

    s.name                      = 'TeadsMoPubAdapter'
    s.version                   = '5.0.4'
    s.summary                   = "MoPub Adapter for Teads' iOS SDK"
    s.module_name               = 'TeadsMoPubAdapter'
    s.description               = <<-DESC
                                Use this adapter to include MoPub as a demand source in your mediation waterfall
                                DESC
    s.homepage                  = 'https://github.com/teads/TeadsSDK-adapter-mopub-ios'
    s.documentation_url         = "https://support.teads.tv/support/solutions/articles/36000166728-twitter-mopub-mediation-ios"
    s.license                   = { :type => 'Copyright', :text => 'Copyright Teads 2021' }
    s.authors                   = { 'Teads' => 'support-sdk@teads.tv'}

    s.source                    = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :tag => "v#{s.version}" }
    s.platform                  = 'ios'
    s.ios.deployment_target     = '10.0'
    s.static_framework          = true
    s.requires_arc              = true
    s.source_files              = ['MediationAdapters/TeadsMoPubAdapter/**/*{.swift}', 'MediationAdapters/Common/*{.swift}']
    s.dependency                'TeadsSDK', s.version.to_s
    s.dependency                'mopub-ios-sdk', '>= 5.13'
    s.frameworks                =  'StoreKit'
    

end
