Pod::Spec.new do |s|
  s.name             = 'vgs_flutter'
  s.version          = '0.0.1'
  s.summary          = 'VGS plugin for Flutter'
  s.description      = <<-DESC
VGS plugin for Flutter
                       DESC
  s.homepage         = 'https://acmesoftware.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Acme Software LLC' => 'sales@acme-software.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'VGSCollectSDK', '1.9.6'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
