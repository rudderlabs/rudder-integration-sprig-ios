require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

rudder_sdk_version = '~> 1.29'
deployment_target = '13.0'

sprig_sdk_name = 'UserLeapKit'
sprig_sdk_version = '~> 4.22.3'

Pod::Spec.new do |s|
  s.name             = 'Rudder-Sprig'
  s.version          = package['version']
  s.summary          = 'Privacy and Security focused Segment-alternative. Sprig Native SDK integration support.'

  s.description      = <<-DESC
  Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
                       DESC
  s.homepage         = 'https://github.com/rudderlabs/rudder-integration-sprig-ios'
  s.license          = { :type => "Apache", :file => "LICENSE.md" }
  s.author           = { 'RudderStack' => 'sdk-accounts@rudderstack.com' }
  s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-sprig-ios.git' , :tag => "v#{s.version}" }
  
  s.requires_arc = true
  s.source_files = 'Rudder-Sprig/Classes/**/*'
  s.static_framework = true
  s.ios.deployment_target = deployment_target
  
  if defined?($SprigSDKVersion)
    Pod::UI.puts "#{s.name}: Using user specified Sprig SDK version '#{$SprigSDKVersion}'"
    sprig_sdk_version = $SprigSDKVersion
  else
    Pod::UI.puts "#{s.name}: Using default Sprig SDK version '#{sprig_sdk_version}'"
  end
  
  if defined?($RudderSDKVersion)
    Pod::UI.puts "#{s.name}: Using user specified Rudder SDK version '#{$RudderSDKVersion}'"
    rudder_sdk_version = $RudderSDKVersion
  else
    Pod::UI.puts "#{s.name}: Using default Rudder SDK version '#{rudder_sdk_version}'"
  end
  
  s.dependency 'Rudder', rudder_sdk_version
  s.dependency sprig_sdk_name, sprig_sdk_version
  
end
