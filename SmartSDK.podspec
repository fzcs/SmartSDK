Pod::Spec.new do |s|
  s.name             = "SmartSDK"
  s.version          = "0.0.1"
  s.summary          = "iOS SDK for Smart."
  s.description      = <<-DESC
                       iOS SDK for Smart.

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "http://www.dreamarts.com.cn"
  s.screenshots      = "http://www.dreamarts.com.cn/images/content/hi_1.png", "http://www.dreamarts.com.cn/images/content/hi_4.jpg"
  s.license          = 'MIT'
  s.author           = { "fzcs" => "fzcs@live.cn" }
  s.source           = { :git => "https://github.com/fzcs/SmartSDK.git", :tag => s.version.to_s }
  s.social_media_url = 'http://www.dreamarts.com.cn'

  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'
  #s.resources = 'Assets/*.png'

  s.ios.exclude_files = 'Classes/ios'
  s.osx.exclude_files = 'Classes/osx'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  s.dependency 'AFNetworking', '~> 2.0'
  #s.dependency 'MBProgressHUD', '~> 0.8'
end
