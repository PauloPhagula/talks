# typed: strict
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
      .when_ok do ->(result) { puts result } end
      .when_error do ->(error) { puts 'Oh no!' } end
  end
end

risky_operation(5)
      .when_ok do ->(result) { puts result } end
      .when_error do ->(error) { puts 'Oh no!' } end

def signup(email, password)

  sign_up = SignUp(email, password)

  valid_email?(sign_up)
    .bind do |sign_up|
      uniq_email?(sign_up)
    end
    .bind do |sign_up|
      valid_password?(sign_up)
    end
    .bind do |sign_up|
      token = generate_confirmation_token
    end
    .bind do |sign_up|
      user = User.create(
        email: email,
        password: password,
        confirmation_token: token
      )
    end
    .bind do |user|
      enqueue_confirmation_mail(email, confirmation_token)
    end
