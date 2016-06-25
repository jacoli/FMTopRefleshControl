Pod::Spec.new do |s|
  s.name         = "FMTopRefleshControl"
  s.version      = "0.0.1"
  s.summary      = "A simple top reflesh control for scrollview/tableview."
  s.homepage     = "https://github.com/jacoli/FMTopRefleshControl"
  s.license      = "MIT"
  s.authors      = { "jacoli" => "luckylcg@163.com" }
  s.source       = { :git => "https://github.com/jacoli/FMTopRefleshControl.git", :tag => "0.0.1" }
  s.frameworks   = 'Foundation', 'UIKit'
  s.platform     = :ios, '7.0'
  s.source_files = 'FMTopReflesh/FMTopRefleshControl/*.{h,m}'
  s.requires_arc = true
end
