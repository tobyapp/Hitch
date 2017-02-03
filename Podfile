platform :ios, '9.0'
use_frameworks!

target "hitch" do
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit' 

pod 'Whisper'

pod 'SwiftyJSON'

pod 'SWRevealViewController'

pod 'Material' 

pod 'Parse'
pod 'ParseUI'
pod 'ParseFacebookUtilsV4'

pod 'GoogleMaps'

pod 'Alamofire'

pod 'Cosmos'

pod 'JVFloatLabeledTextField'

pod 'ASValueTrackingSlider'

pod 'SMSegmentView'

pod 'APParallaxHeader'



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

end
