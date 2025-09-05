post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Existing fixes
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'

      # Disable Swift optimization to avoid errors
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'

      # Optional: Only for BoringSSL-GRPC
      if target.name == 'BoringSSL-GRPC'
        config.build_settings['CLANG_CXX_LANGUAGE_STANDARD'] = 'c++17'
        config.build_settings['CLANG_CXX_LIBRARY'] = 'libc++'
      end
    end
  end
end
