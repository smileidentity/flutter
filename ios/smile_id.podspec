# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint smileid.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'smile_id'
  # NB! Keep this version in sync with the Native iOS SDK version
  s.version = '10.2.2'
  s.summary          = 'Official Smile ID SDK for Flutter'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://usesmileid.com'
  s.author           = { 'Smile ID' => 'support@usesmileid.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  # NB! Update the s.version above when changing this version
  s.dependency 'SmileID', '10.2.2'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
