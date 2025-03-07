Pod::Spec.new do |spec|
spec.name         = "ConnectKit"
spec.version      = "2.1.1"
spec.summary      = "Connect your financial accounts via the Mono Connect Widget"
spec.description  = <<-DESC
The Mono Connect SDK is a quick and secure way to link bank accounts to Mono from within your iOS app. Mono Connect is a drop-in framework that handles connecting a financial institution to your app (credential validation, multi-factor authentication, error handling, etc).
DESC
spec.homepage     = "https://mono.co"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author             = { "author" => "tristan@mono.co" }
spec.documentation_url = "https://github.com/withmono/connect-ios"
spec.platforms = { :ios => "9.0" }
spec.swift_version = "5.3"
spec.source       = { :git => "https://github.com/withmono/connect-ios.git", :tag => "#{spec.version}" }
spec.source_files  = "Sources/ConnectKit/**/*.swift"
spec.xcconfig = { "SWIFT_VERSION" => "5.3" }
end
