Pod::Spec.new do |spec|
    spec.name = 'MongoLabKit'
    spec.version = '0.1'
    spec.summary = 'MongoLabKit is a REST client API for iOS, tvOS and watchOS written to make REST calls to a MongoLab database.'
    spec.homepage = 'https://github.com/ustwo/mongolabkit-swift'
    spec.license = { type: 'MIT', file: 'LICENSE' }
    spec.authors = { 'Luca Strazzullo' => 'luca@ustwo.com' }
    spec.social_media_url = 'http://twitter.com/ustwo'
    spec.ios.deployment_target = '9.0'
    spec.watchos.deployment_target = '2.0'
    spec.tvos.deployment_target = '9.0'
    spec.requires_arc = true
    spec.source = { :git => 'https://github.com/ustwo/mongolabkit-swift.git', :tag => spec.version }
    spec.source_files = 'MongoLabKit/Sources/**/*'
end