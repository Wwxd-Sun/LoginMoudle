#
# Be sure to run `pod lib lint LoginMoudle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LoginMoudle'
  s.version          = '0.0.2'
  s.summary          = '登陆模块'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Wwxd-Sun/LoginMoudle'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wwxd-Sun' => 'sun19881202@163.com' }
  s.source           = { :git => 'https://github.com/Wwxd-Sun/LoginMoudle.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = "5.0"
  s.source_files = 'LoginMoudle/Classes/**/*.{swift}'
  s.dependency 'UserMoudle', '~> 0.0.1'
  s.dependency 'NetworkMoudle', '~> 0.0.9'
  s.resource_bundles = {
     'LoginMoudle' => ['LoginMoudle/Assets/*{.storyboard,.xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
