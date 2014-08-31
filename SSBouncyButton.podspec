Pod::Spec.new do |s|
  s.name         = "SSBouncyButton"
  s.version      = "1.0.0"
  s.summary      = "iOS7-style bouncy button."
  s.homepage     = "http://github.com/StyleShare/SSBouncyButton"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "devxoul" => "devxoul@gmail.com" }
  s.source       = { :git => "https://github.com/StyleShare/SSBouncyButton.git",
                     :tag => "#{s.version}" }
  s.platform     = :ios, '7.0'
  s.frameworks   = 'UIKit', 'Foundation', 'QuartzCore'
  s.source_files = 'SSBouncyButton/*.{h,m}'
  s.requires_arc = true

  s.dependency 'BRYSerialAnimationQueue', '~> 1.0'
  s.dependency 'UIColor-Hex'
  s.dependency 'UIImage+BetterAdditions', '~> 2.0'
end
