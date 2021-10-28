source 'https://cdn.cocoapods.org/'

deployment_target = '13.0'
platform :ios, deployment_target

use_modular_headers!

target 'TinyTasks' do
  pod 'SwiftFormat/CLI'
  pod 'SwiftLint'
end

post_install do |installer|
  puts "Update minimum deployment target...".green
  
  installer.generated_projects.map { |project| project.targets } .flatten.each do |target|
    (target.build_configurations + target.project.build_configurations).each { |config|
      if (Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']) <=> Gem::Version.new(deployment_target)) < 0
        current = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        
        puts "  change iOS #{current} to #{deployment_target} for #{target.name} (#{config})".blue
      end
    }
  end
end
