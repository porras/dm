require 'YAML'
require 'twitter'
require 'csv'

config = YAML.load_file("#{ENV.fetch('HOME')}/.trc")
profile = config.fetch('configuration').fetch('default_profile')
config = config.fetch('profiles')
profile.each do |s|
  config = config.fetch(s)
end

client = Twitter::REST::Client.new do |c|
  c.consumer_key        = config.fetch('consumer_key')
  c.consumer_secret     = config.fetch('consumer_secret')
  c.access_token        = config.fetch('token')
  c.access_token_secret = config.fetch('secret')
end

CSV($stdout) do |csv|
  csv << ['Sender', 'Text']
  client.direct_messages(count: 2, full_text: true).each do |m|
    csv << [m.sender.screen_name, m.full_text]
  end
end
