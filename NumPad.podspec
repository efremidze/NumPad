#
# Be sure to run `pod lib lint NumPad.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "NumPad"
    s.version          = "1.0.7"
    s.summary          = "Number Pad"
    s.homepage         = "https://github.com/efremidze/NumPad"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { "Lasha Efremidze" => "efremidzel@hotmail.com" }
    s.platform         = :ios, "8.0"
    s.source           = { :git => "https://github.com/efremidze/NumPad.git", :tag => s.version.to_s }
    s.source_files     = "Sources/*.swift"
end
