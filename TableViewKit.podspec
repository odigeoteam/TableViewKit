Pod::Spec.new do |s|
  s.name                    = "TableViewKit"
  s.version                 = "1.2.0"
  s.summary                 = "Empowering UITableView with painless multi-type cell support and built-in automatic state transition animations"
  s.homepage                = "http://github.com/odigeoteam/TableViewKit/"
  s.license                 = "MIT"
  s.author                  = "TableViewKit Contributors"
  s.ios.deployment_target   = "8.0"
  s.source                  = { :git => 'https://github.com/odigeoteam/TableViewKit.git', :tag => "v#{s.version}" }
  s.source_files  			= "TableViewKit/**/*.swift"
  s.framework  				= "UIKit", "Foundation"
  s.requires_arc 			= true
  s.swift_version = '4.2'
end
