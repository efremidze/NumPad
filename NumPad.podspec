#
# Be sure to run `pod lib lint NumPad.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "NumPad"
    s.version          = "1.0.8"
    s.summary          = "Number Pad"
    s.homepage         = "https://github.com/efremidze/NumPad"
    s.license          = 'MIT'
    s.author           = { "Lasha Efremidze" => "efremidzel@hotmail.com" }
    s.ios.deployment_target = '8.0'
    s.source           = { :git => 'https://github.com/efremidze/NumPad.git', :tag => s.version }
    s.source_files     = "Sources/*.swift"
    s.requires_arc     = true
end
