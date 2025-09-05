post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Force iOS 12.0 as minimum for every pod
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'

      # Optional: if you run into simulator arm64 issues
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
