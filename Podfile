platform :ios, '10.0'
use_frameworks!

def helper_pods
  pod 'SwiftLint', '0.30.1'
  pod 'SwiftFormat/CLI', '0.38.0'
end

target 'Mimic' do
  helper_pods
end

target 'MimicTests' do
  helper_pods
end

target 'MimicExample' do
  pod 'Mimic', :path => './'
end
