platform :ios, '9.0'

def pods
  pod 'Alamofire', '~> 4.4'
  pod 'Argo'
  pod 'Curry'
end

target 'app' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pods

  target 'appAlpha' do
    inherit! :search_paths

    pods
  end

  target 'appTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'appUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end
