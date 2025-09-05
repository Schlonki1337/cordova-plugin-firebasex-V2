# ios-build-extras.rb
# This script runs before the Xcode build
# It patches CordovaLib and all Pods deployment targets

require 'xcodeproj'

# Patch deployment target for CordovaLib
cordova_lib_path = File.join(Dir.pwd, 'platforms', 'ios', 'CordovaLib', 'CordovaLib.xcodeproj')
if File.exist?(cordova_lib_path)
  project = Xcodeproj::Project.open(cordova_lib_path)
  project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
  project.save
end

# Patch Pods deployment targets
podfile_path = File.join(Dir.pwd, 'platforms', 'ios', 'Podfile')
if File.exist?(podfile_path)
  # This ensures that after 'pod install', the Pods have the correct deployment target
  post_install_script = <<~RUBY
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        end
      end
    end
  RUBY

  File.open(podfile_path, 'a') { |f| f.puts post_install_script }
end
