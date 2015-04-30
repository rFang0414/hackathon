require 'spear'

Spear.config({
  dev_key:   ENV['DEVELOPMENT_KEY'],
  # use_test:  !Rails.env.production?,
  use_test:  false,
  project:   'WeChat',
  use_model: true,
  save_api:  Rails.env.production? })