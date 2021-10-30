source 'https://cdn.cocoapods.org/'

ios_deployment_target = '13.0'
osx_deployment_target = '11.0'

use_modular_headers!

def shared_pod
  pod 'DI', :path => 'DI'
  pod 'Lists', :path => 'Lists'
  
  pod 'SwiftFormat/CLI'
  pod 'SwiftLint'
end

target 'TinyTasks' do
  platform :ios, ios_deployment_target
  shared_pod
end

target 'TinyTasksMultiplatform (iOS)' do
  platform :ios, ios_deployment_target
  shared_pod
end

target 'TinyTasksMultiplatform (macOS)' do
  platform :osx, osx_deployment_target
  shared_pod
end

post_install do |installer|
  puts "Update minimum deployment target..."
  
  ios_version = Gem::Version.new(ios_deployment_target)
  installer.generated_projects.map { |project| project.targets } .flatten.each do |target|
    (target.build_configurations + target.project.build_configurations).each { |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
        if (Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']) <=> ios_version) < 0
          current = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = ios_deployment_target
          
          puts "  change iOS #{current} to #{ios_deployment_target} for #{target.name} (#{config})"
        end
      end
    }
  end
end
