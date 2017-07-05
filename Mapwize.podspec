#
#  Be sure to run `pod spec lint Mapwize.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Mapwize"
  s.version      = "2.3.2"
  s.summary      = "Mapwize: The Indoor Mapping Platform"

  s.description  = <<-DESC
       Mapwize: The Indoor Mapping Platform.
       This SDK allows you to display and interact with venue maps.
                   DESC

  s.homepage     = "https://www.mapwize.io"
  s.license      = "MIT"
  s.author       = { "Mapwize" => "contact@mapwize.io" }
  s.source       = { :git => "https://github.com/Mapwize/mapwize-ios-sdk.git", :tag => s.version.to_s }

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source_files  = "Mapwize", "Mapwize/Mapwize/Classes/**/*.{h,m}"
  s.public_header_files = "Mapwize/Mapwize/Classes/**/*.h"
  s.resource_bundles = {
    'Mapwize' => ['Mapwize/Mapwize/Resources/**/*']
  }

  s.frameworks = 'UIKit', 'WebKit', 'CoreLocation'
  s.dependency "AFNetworking"

end
