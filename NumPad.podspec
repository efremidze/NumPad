Pod::Spec.new do |s|
    s.name             = "NumPad"
    s.version          = "0.1.2"
    s.summary          = "Number Pad"
    s.homepage         = "https://github.com/efremidze/NumPad"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { "Lasha Efremidze" => "efremidzel@hotmail.com" }
    s.platform         = :ios, "8.0"
    s.source           = { :git => "https://github.com/efremidze/NumPad.git", :tag => s.version.to_s }
    s.source_files     = "Sources/*.swift"
    s.requires_arc     = true
end
