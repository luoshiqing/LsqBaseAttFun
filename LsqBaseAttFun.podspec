
Pod::Spec.new do |spec|

  spec.name         = "LsqBaseAttFun"

  spec.version      = "1.0.0"

  spec.summary      = "基础延展和方法"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "罗石清" => "644402920@qq.com" }

  spec.platform     = :ios, "9.0"

  spec.homepage     = "https://github.com/luoshiqing/LsqBaseAttFun"
  
  spec.source       = { :git => "https://github.com/luoshiqing/LsqBaseAttFun.git", :tag => "#{spec.version}" }

  spec.requires_arc = true
 
  spec.swift_versions = "5.0"

  spec.source_files  = "LsqBaseAttFun/**/*.{swift}"

end
