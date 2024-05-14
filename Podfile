# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'NimbleSurvey' do
    # Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!

    # ignore all warnings from all pods
    inhibit_all_warnings!
    pod 'RealmSwift'
    pod 'Moya/RxSwift'
    pod 'SwiftyJSON'
    pod 'RxRealm'
    pod 'RxOptional'
    pod 'SnapKit'
    pod 'SwiftyBeaver'
    pod 'Kingfisher'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.0"
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        # Disable code coverage for all Pods and Pods Project
        config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        config.build_settings['ENABLE_BITCODE'] = 'NO'

        config.build_settings['SUPPORTED_PLATFORMS'] = 'iphoneos iphonesimulator'
        config.build_settings['SUPPORTS_MACCATALYST'] = 'NO'
        config.build_settings['SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD'] = 'NO'

      end
    end
  end

  target 'NimbleSurveyTests' do
      inherit! :search_paths
      # Pods for testing
      use_frameworks!
      inhibit_all_warnings!
      pod 'Nimble'
      pod 'Cuckoo'
      pod 'RxTest'
      pod 'RxBlocking'
  end

end
