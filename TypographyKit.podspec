#
# Be sure to run `pod lib lint TypographyKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TypographyKit'
  s.version          = '0.4.0'
  s.summary          = 'Visually consistent, accessible type for your iOS application.'
  s.swift_version    = '4.1'
  s.description      = <<-DESC
TypographyKit makes it easy to define typography styles in your iOS app helping you achieve visual consistency in your design as well as supporting Dynamic Type even where using custom fonts.
                       DESC

  s.homepage         = 'https://github.com/rwbutler/TypographyKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rwbutler' => 'github@rwbutler.com' }
  s.source           = { :git => 'https://github.com/rwbutler/TypographyKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TypographyKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TypographyKit' => ['TypographyKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
