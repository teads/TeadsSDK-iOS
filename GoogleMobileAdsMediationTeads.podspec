Pod::Spec.new do |s|

s.name        = 'GoogleMobileAdsMediationTeads'
s.version     = '4.0.6-beta'
s.summary     = "AdMob Adapter for Teads' iOS SDK"
s.description = <<-DESC
                Use this adapter to include AdMob as a demand source in your mediation waterfall
                DESC
s.homepage    = 'https://github.com/teads/TeadsSDK-iOS'
s.license     = { :type => 'Commercial' }
s.authors     = { 'Teads' => 'support-sdk@teads.tv'}

s.source      = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :branch => 'TeadsSDK-v4-beta'}
s.platform              = 'ios'
s.ios.deployment_target = '9.0'
s.static_framework      = true
s.requires_arc          = true
s.ios.vendored_frameworks 	= 'Adapters/GoogleMobileAdsMediationTeads/TeadsAdMobAdapter.framework'
s.preserve_paths 		= 'Adapters/GoogleMobileAdsMediationTeads/TeadsAdMobAdapter.framework'
s.framework 			= 'TeadsAdMobAdapter'

s.dependency 'TeadsSDK-beta', '4.0.6-beta'
s.dependency 'Google-Mobile-Ads-SDK', '>= 7.31'

end