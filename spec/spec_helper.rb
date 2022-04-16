# frozen_string_literal: true

RSpec.configure do |config|
  config.filter_run_when_matching :focus

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random
end
