Pod::Spec.new do |spec|
    spec.name = 'SwiftMongoLabKit'
    spec.version = '0.2'
    spec.summary = 'SwiftMongoLabKit is a REST client API for iOS, tvOS and watchOS written to make REST calls to a MongoLab database.'
    spec.homepage = 'https://github.com/ustwo/swift-mongolab-kit'
    spec.license = { type: 'MIT', file: 'LICENSE' }
    spec.authors = { 'Luca Strazzullo' => 'luca@ustwo.com' }
    spec.social_media_url = 'http://twitter.com/ustwo'
    spec.ios.deployment_target = '9.0'
    spec.watchos.deployment_target = '2.0'
    spec.tvos.deployment_target = '9.0'
    spec.requires_arc = true
    spec.source = { :git => 'https://github.com/ustwo/swift-mongolab-kit.git', :tag => spec.version }
    spec.source_files = 'SwiftMongoLabKit/Sources/**/*'
end