Pod::Spec.new do |s|

s.name        = 'MoPub-Teads-Adapters'
s.version     = '4.0.6-beta'
s.summary     = "MoPub Adapter for Teads' iOS SDK"
s.description = <<-DESC
                Use this adapter to include MoPub as a demand source in your mediation waterfall
                DESC
s.homepage    = 'https://github.com/teads/TeadsSDK-iOS'
s.license     = { :type => 'Commercial' }
s.authors     = { 'Teads' => 'support-sdk@teads.tv'}

s.source      = { :git => 'https://github.com/teads/TeadsSDK-iOS.git', :branch => 'TeadsSDK-v4-beta'}
s.platform              = 'ios'
s.ios.deployment_target = '9.0'
s.static_framework      = true
s.requires_arc          = true
s.ios.vendored_frameworks 	= 'Adapters/MoPub-Teads-Adapters/TeadsMoPubAdapter.framework'
s.preserve_paths 		= 'Adapters/MoPub-Teads-Adapters/TeadsMoPubAdapter.framework'
s.framework 			= 'TeadsMoPubAdapter'

s.dependency 'TeadsSDK-beta', '4.0.6-beta'
s.dependency 'mopub-ios-sdk', '>= 5.0'

end