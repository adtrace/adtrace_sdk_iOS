Pod::Spec.new do |s|
  s.name           = "Adtrace-sdk"
  s.version        = "3.0.0"
  s.summary        = "This is the iOS SDK of adtrace. You can read more about it at https://adtrace.io."
  s.homepage       = "https://github.com/adtrace/adtrace_sdk_iOS"
  s.license        = { :type => 'MIT', :file => 'MIT-LICENSE' }
  s.author         = { "Nasser Amini" => "namini40@gmail.com" }
  s.source         = { :git => "https://github.com/adtrace/adtrace_sdk_iOS.git", :tag => "v#{s.version}" }
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'
  s.framework      = 'SystemConfiguration'
  s.ios.weak_framework = 'AdSupport'
  s.tvos.weak_framework = 'AdSupport'
  s.requires_arc   = true
  s.default_subspec = 'Core'

  # Core SDK without the SDK Signature library (signature remains optional via reflection if ADTSigner is present).
  # WebBridge is unchanged and not part of this podspec (same as before).
  s.subspec 'Core' do |co|
    co.source_files   = 'Adtrace/*.{h,m}', 'Adtrace/ADTAdditions/*.{h,m}'
    co.exclude_files  = 'Adtrace/include/**/*.h'
    co.resource_bundle = { 'Adtrace' => ['Adtrace/PrivacyInfo.xcprivacy'] }
  end
end
