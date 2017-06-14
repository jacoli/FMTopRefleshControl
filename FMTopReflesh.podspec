Pod::Spec.new do |s|
  s.name         = "FMTopReflesh"
  s.version      = "1.0.0"
  s.summary      = "A simple top reflesh control for scrollview/tableview."
  s.homepage     = "https://github.com/jacoli/FMTopRefleshControl"
  s.license      = "MIT"
  s.authors      = { "jacoli" => "jaco.lcg@gmail.com" }
  s.source       = { :git => "https://github.com/jacoli/FMTopRefleshControl.git", :tag => "#{s.version}" }
  s.frameworks   = 'Foundation', 'UIKit'
  s.platform     = :ios, '7.0'
  s.source_files = 'FMTopReflesh/FMTopRefleshControl/*.{h,m}'
  s.requires_arc = true
end
