#
# Be sure to run `pod lib lint Mapwize.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Mapwize"
  s.version          = "1.7.1"
  s.summary          = "Mapwize: The Indoor Mapping Platform"

  s.description      = <<-DESC
        Mapwize: The Indoor Mapping Platform.
        This SDK allows you to display and interact with venue maps.
                       DESC

  s.homepage         = "https://www.mapwize.io"
  s.license          = 'MIT'
  s.author           = { "Mapwize" => "contact@mapwize.io" }
  s.source           = { :git => "https://github.com/Mapwize/mapwize-ios-sdk.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Mapwize' => ['Pod/Assets/**/*']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'WebKit', 'CoreLocation'
end
