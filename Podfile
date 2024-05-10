# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'NimbleSurvey' do
    # Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!

    # ignore all warnings from all pods
    inhibit_all_warnings!
    pod 'SwiftyJSON'
    pod 'RxOptional'
    pod 'SnapKit'
    pod 'SwiftyBeaver'

  # Pods for NimbleSurvey
#    post_install do |installer|
#        installer.pods_project.targets.each do |target|
#            target.build_configurations.each do |config|
#                if config.name == 'Debug'
#                    config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
#                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
#                end
#                
#                # Disable code coverage for all Pods and Pods Project
#                config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
#                
#                # Force all modules swift versions to 4.2
#                config.build_settings['SWIFT_VERSION'] = '4.2'
#
#            end
#        end
#    end
#    
#    installer.pods_project.build_configurations.each do |config|
#        config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
#    end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.0"
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
