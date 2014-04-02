#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "PopIn"
  s.version          = "0.1.0"
  s.summary          = "Objective-C control that displays a dismissible UIVIew inside of a pop up."
  s.homepage         = "https://github.com/jayceecam/PopIn"
  s.license          = 'MIT'
  s.author           = { "Joe Cerra" => "jcerra@gmail.com" }
  s.source           = { :git => "https://github.com/jayceecam/PopIn.git", :branch => "master", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jcerra'
  s.platform     = :ios, '5.0'
  s.source_files = 'Classes/*.{h,m}'
  s.requires_arc = true
end
