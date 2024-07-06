# typed: true
require 'rails_helper'

def risky_operation(x)
  if x == 0
    Outcome.malformed_request('Cannot divide by 0')
  else
    Outcome.ok(10 / x)
  end
end

RSpec.describe Payroll::FieldMatcher do
  it 'works' do
    risky_operation(5)
      .when_ok { ->(result) { puts result } }
      .when_error { ->(error) { puts 'Oh no!' } }
  end
end

risky_operation(5).when_ok { ->(result) { puts result } }.when_error { ->(error) { puts 'Oh no!' } }
