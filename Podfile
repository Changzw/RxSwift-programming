# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

#install! 'cocoapods',
#:generate_multiple_pod_projects => true,
#:incremental_installation => true
#
#plugin 'cocoapods-static-swift-framework'
#plugin 'cocoapods-binary'

target 'RxSwift-programming' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RxSwift-programming
  pod 'RxSwift', '~> 5.0' #, :binary=>true
  pod 'RxCocoa', '~> 5.0' #, :binary=>true
  pod 'Action', '4.0'     #, :binary=>true
  pod 'SnapKit'
#  pod 'RxTexture'         #, :binary=>true

  target 'RxSwift-programmingTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end

  target 'RxSwift-programmingUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
