
Pod::Spec.new do |s|

  s.name         				= "TableViewKit"
  s.version      				= "0.3.0"
  s.summary      				= "TableView Kit Layer"
  s.description  				= "TableView Kit Layer"
  s.homepage     				= "http://www.edreamsodigeo.com/"
  s.license      				= "Copyright (c) 2014 eDreams ODIGEO. All rights reserved"
  s.author       				= { "iOS Mobile Team" => "ios-dev@odigeo.com" }
  s.ios.deployment_target 		= "8.0"
  s.source 						= { :path => '.' }
  s.source_files  				= "Core/**/*.swift"
  s.resource_bundles	 		= { "TableViewKit" => "Core/Resources/*.*" }
  s.framework  					= "UIKit", "Foundation"
  s.requires_arc 				= true
end
