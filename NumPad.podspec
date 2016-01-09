Pod::Spec.new do |s|
    s.name             = "NumPad"
    s.version          = "0.1.0"
    s.summary          = ""
    s.homepage         = "https://github.com/efremidze/NumPad"
    s.license          = 'MIT'
    s.author           = { "Lasha Efremidze" => "efremidzel@hotmail.com" }
    s.social_media_url = 'http://twitter.com/lasha_'
    s.platform         = :ios, '8.0'
    s.requires_arc     = true
    s.source           = { :git => "https://github.com/efremidze/NumPad.git", :tag => s.version.to_s }
    s.source_files     = 'NumPad/*.swift'
end