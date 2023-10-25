RSpec::Matchers.define :be_considered_valid do
  match do |result|
    @errors = result.errors.to_h
    @errors.empty?
  end

  failure_message do |_contract|
    "expected contract to be valid, but got errors: #{@errors.inspect}"
  end
end


RSpec::Matchers.define :be_considered_invalid do |expected_error_keys = []|
  match do |result|
    @errors = result.errors.to_h
    @missing_keys = expected_error_keys - @errors.keys
    @unexpected_keys = @errors.keys - expected_error_keys
    @missing_keys.empty? && @unexpected_keys.empty?
  end

  failure_message do |_contract|
    messages = []
    messages << "expected contract to have errors on keys: #{@missing_keys.inspect}" unless @missing_keys.empty?
    messages << "did not expect contract to have errors on keys: #{@unexpected_keys.inspect}" unless @unexpected_keys.empty?
    messages.join(', ')
  end
end
