Pod::Spec.new do |s|
  s.name             = "HaidoraNetwork"
  s.version          = "0.1.0"
  s.summary          = "A Simple Wrapper of AFNetworking."
  s.description      = <<-DESC
                    A Simple Wrapper of AFNetworking.(fork from YTKNetwork,RTNetworking.)
                       DESC

  s.homepage         = "https://github.com/Haidora/HaidoraNetwork"
  s.license          = 'MIT'
  s.author           = { "mrdaios" => "mrdaios@gmail.com" }
  s.source           = { :git => "https://github.com/Haidora/HaidoraNetwork.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'HaidoraNetwork' => ['Pod/Assets/*.png']
  }
  s.dependency 'AFNetworking','~> 2.6.1'
end
