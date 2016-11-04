# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'InAppPurchase'
  app.identifier = "com.beta.facturame"
  app.seed_id = "97Y4EW5NHX"
  app.codesign_certificate  = "iPhone Developer: Xochitl Chamorro (Q2NXQ77YXU)"
  app.provisioning_profile = '/Users/xochitlperez/Library/MobileDevice/Provisioning Profiles/173b3a73-c14b-4ac3-8efe-1b5fd49e6544.mobileprovision'
  app.frameworks += ['StoreKit']

end
