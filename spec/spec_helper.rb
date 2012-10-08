require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :fakeweb
  config.default_cassette_options = { :record => :new_episodes }
  config.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.extend VCR::RSpec::Macros
end
