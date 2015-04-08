# config/initializers/workless.rb

Delayed::Backend::ActiveRecord::Job.class_eval do
  after_destroy "self.class.scaler.down"
  after_create "self.class.scaler.up"
  after_update "self.class.scaler.down"
end
