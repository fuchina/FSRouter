Pod::Spec.new do |s|
  s.name             = 'FSRouter'
  s.version          = '0.1'
  s.summary          = 'FSRouter is a tool'
  s.description      = <<-DESC
		This is a very small software library, offering a few methods to help with programming.
    DESC

  s.homepage         = 'https://github.com/fuchina/FSRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fudon' => '1245102331@qq.com' }
  s.source           = { :git => 'https://github.com/fuchina/FSRouter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'FSRouter/*'
  s.dependency   'FSKit'

end
