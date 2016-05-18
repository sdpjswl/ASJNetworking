Pod::Spec.new do |s|
  s.name         = 'ASJNetworking'
  s.version      = '0.2'
  s.platform	   = :ios, '7.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/sudeepjaiswal/ASJNetworking'
  s.authors      = { 'Sudeep Jaiswal' => 'sudeepjaiswal87@gmail.com' }
  s.summary      = 'Basic networking using NSURLSession and no external dependencies'
  s.source       = { :git => 'https://github.com/sudeepjaiswal/ASJNetworking.git', :tag => '0.2' }
  s.source_files = 'ASJNetworking/*.{h,m}'
  s.requires_arc = true
end