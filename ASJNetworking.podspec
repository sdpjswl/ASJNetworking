Pod::Spec.new do |s|
  s.name          = 'ASJNetworking'
  s.version       = '1.0'
  s.platform      = :ios, '7.0'
  s.license       = { :type => 'MIT' }
  s.homepage      = 'https://github.com/sudeepjaiswal/ASJNetworking'
  s.authors       = { 'Sudeep Jaiswal' => 'sudeepjaiswal87@gmail.com' }
  s.summary       = 'Basic networking using NSURLSession and no external dependencies'
  s.source        = { :git => 'https://github.com/sudeepjaiswal/ASJNetworking.git', :tag => s.version }
  s.source_files  = 'ASJNetworking/*.{h,m}'
  s.requires_arc  = true
end