#
# Be sure to run `pod lib lint Communication.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Communication'
  s.version          = '0.1.0'
  s.summary          = 'Chat message module.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'Try to crate the library.'
                       DESC

  s.homepage         = 'https://github.com/JigarBilGit/Message'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JigarPatel1991' => 'jigar.patel@billiyo.com' }
  s.source           = { :git => 'https://github.com/JigarBilGit/Message.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'Source/**/*.swift'
  s.swift_version = '5.0'
  s.platforms = {
        "ios": "13.0"
  }
  
  # s.resource_bundles = {
  #   'Communication' => ['Communication/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'Alamofire'
  s.dependency 'SDWebImage'
#  s.dependency 'AKImageCropperView'
  s.dependency 'SwiftSignalRClient'
  s.dependency 'SVProgressHUD'
  s.dependency 'ReachabilitySwift'
  s.dependency 'Zip', '~> 2.1'
  s.dependency 'CropViewController'
  s.dependency 'BSImagePicker', '~> 3.1'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'Connectivity', '~> 3.0'
  s.dependency 'AZSClient'
  
end
