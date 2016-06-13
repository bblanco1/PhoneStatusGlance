# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Phone Status Glance' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Phone Stats
  pod 'ReachabilitySwift', :git => 'https://github.com/ashleymills/Reachability.swift'
  pod "RFAboutView", '1.0.4'

  target 'Phone Status GlanceTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Phone Status Glance WatchKit App' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Phone Stats WatchKit App

end

target 'Phone Status Glance WatchKit Extension' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Phone Stats WatchKit Extension

end

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Phone Status Glance/Pods-Phone Status Glance-acknowledgements.plist', 'Phone Stats/Acknowledgements.plist', :remove_destination => true)
end
