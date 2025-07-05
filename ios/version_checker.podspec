Pod::Spec.new do |s|
  s.name             = 'version_checker'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for checking app version updates.'
  s.description      = <<-DESC
A Flutter plugin for checking app version updates with customizable dialogs and API integration.
                       DESC
  s.homepage         = 'https://github.com/aymanalareqi/version_checker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ayman Alareqi' => 'ayman@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
