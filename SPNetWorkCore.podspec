#
# Be sure to run `pod lib lint SPNetWorkCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SPNetWorkCore'
  s.version          = '0.0.1'
  s.summary          = 'RxSwift封装的网络请求.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: RxSwift封装了网络请求  包含网络请求，数据解析
                       DESC

  s.homepage         = 'https://github.com/songspecs/SPNetWorkCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'songpu_work@163.com' => 'songpu_work@163.com' }
  s.source           = { :git => 'https://github.com/songspecs/SPNetWorkCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SPNetWorkCore/Classes/**/*'
  
  s.swift_version = "4.2"

  s.dependency 'SPModelProtocol', '~> 0.0.1'
  # https://github.com/TyroneSong/SPSpecs/tree/master/SPModelProtocol/0.0.1

  s.dependency 'Alamofire', '~> 5.0.0-beta.5'
  s.dependency 'RxSwift', '~> 4.5.0'
  s.dependency 'RxCocoa', '~> 4.5.0'
  s.dependency 'Result', '~> 4.1.0'
  # s.resource_bundles = {
  #   'SPNetWorkCore' => ['SPNetWorkCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
