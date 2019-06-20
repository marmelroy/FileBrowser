#
# Be sure to run `pod lib lint FileBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftFileBrowser"
  s.version          = "1.0.1"
  s.summary          = "Powerful iOS file browser in Swift."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                      A Swift file browser for iOS. Supports QuickLook, search and 3D touch.
                     DESC

  s.homepage         = "https://github.com/algonrey/FileBrowser"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Roy Marmelstein" => "marmelroy@gmail.com" }
  s.source           = { :git => "https://github.com/algonrey/FileBrowser.git", :tag => s.version.to_s, :submodules => true}
  s.social_media_url   = "http://twitter.com/marmelroy"

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = "FileBrowser"
  s.resources = "FileBrowser/Resources/*.*"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'QuickLook', 'WebKit'
  # s.dependency 'AFNetworking', '~> 2.3'

end
