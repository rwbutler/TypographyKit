Pod::Spec.new do |s|
  s.name             = 'TypographyKit'
  s.version          = '0.4.3'
  s.summary          = 'Visually consistent, accessible type for your iOS application.'
  s.swift_version    = '4.1'
  s.description      = <<-DESC
TypographyKit makes it easy to define typography styles in your iOS app helping you achieve visual consistency in your design as well as supporting Dynamic Type even where using custom fonts.
                       DESC
  s.homepage         = 'https://github.com/rwbutler/TypographyKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rwbutler' => 'github@rwbutler.com' }
  s.source           = { :git => 'https://github.com/rwbutler/TypographyKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'TypographyKit/Classes/**/*'
end
