Pod::Spec.new do |s|
  s.name             = 'AFCurvedArrowView'
  s.version          = '1.0.1'
  s.summary          = 'A view to show a configurable arrow wherever you need'
  s.description      = <<-DESC
A view to show a configurable arrow wherever you need. (Mostly useful for user guides) With its' help you don’t need to have different images for arrows for different screen sizes anymore.
                       DESC

  s.homepage         = 'https://github.com/anton-filimonov/AFCurvedArrowView'
  s.screenshots      = 'https://github.com/anton-filimonov/AFCurvedArrowView/blob/master/sample.gif?raw=true'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Filimonov' => 'anton.s.filimonov@gmail.com' }
  s.source           = { :git => 'https://github.com/anton-filimonov/AFCurvedArrowView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AntonFilimon'
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.source_files = 'AFCurvedArrowView/Classes/**/*'
  s.public_header_files = 'AFCurvedArrowView/Classes/**/*.h'
end
