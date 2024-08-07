Pod::Spec.new do |s|
  s.name           = "Adtrace-sdk"
  s.version        = "2.3.0"
  s.summary        = "This is the iOS SDK of adtrace. You can read more about it at https://adtrace.io."
  s.homepage       = "https://github.com/adtrace/adtrace_sdk_iOS"
  s.license        = { :type => 'MIT', :file => 'MIT-LICENSE' }
  s.author         = { "Nasser Amini" => "namini40@gmail.com" }
  s.source         = { :git => "https://github.com/adtrace/adtrace_sdk_iOS.git", :tag => "v2.3.0" }
  s.ios.deployment_target = '9.0'
  s.framework      = 'SystemConfiguration'
  s.ios.weak_framework = 'AdSupport'
  s.requires_arc   = true
  s.default_subspec = 'Core'
  s.pod_target_xcconfig = { 'BITCODE_GENERATION_MODE' => 'bitcode' }

  s.subspec 'Core' do |co|
    co.source_files   = 'Adtrace/*.{h,m}', 'Adtrace/ADTAdditions/*.{h,m}'
  end
end
