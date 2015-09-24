Pod::Spec.new do |s|
  s.name         = "MXStrongObject"
  s.version      = "1.0.0"
  s.summary      = "strong the object easily"
  s.description  = "strong the object easily while using block"
  s.homepage     = "https://github.com/longminxiang/MXStrongObject"
  s.license      = "MIT"
  s.author       = { "Eric Lung" => "longminxiang@gmail.com" }
  s.source       = { :git => "https://github.com/longminxiang/MXStrongObject.git", :tag => "v" + s.version.to_s }
  s.requires_arc = true
  s.platform     = :ios, '6.0'
  s.source_files = "MXStrongObject/*.{h,m}"
end
