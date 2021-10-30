#
# Be sure to run `pod lib lint DI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DI'
  s.version          = '1.0.0'
  s.summary          = 'DI'
  s.description      = 'Simple DI container implementation - not thread safe!'

  s.homepage         = 'https://github.com/rock88'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrey Konoplyankin' => 'rock88a@gmail.com' }
  s.source           = { :git => 'https://github.com/rock88', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '11.0'
  s.swift_version = '5.5'
  s.source_files = 'Sources/**/*.{swift,m,h}'
end
