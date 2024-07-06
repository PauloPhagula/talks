# typed: true

module Payroll
  class TestController < ::ApiController
    extend T::Sig

    sig { params(email: String).returns(Outcome[String]) }
    def valid_email?(email)
      email.include?('@') ? Outcome.ok(email) : Outcome.error('Invalid email')
    end

    sig { params(email: String).returns(Outcome[String]) }
    def uniq_email?(email)
      email.include?('@') ? Outcome.ok(email) : Outcome.error('Invalid email')
    end

    sig { params(password: String).returns(Outcome[String]) }
    def valid_password?(password)
      password.include?('dragon blood') ? Outcome.ok(password) : Outcome.error('Invalid password')
    end

    sig { params(sign_up: Payroll::Dtos::SignUp).returns(Outcome[String]) }
    def generate_confirmation_token(sign_up)
      Outcome.ok("#{sign_up.email}-confirmation-token")
    end

    sig { params(sign_up: Payroll::Dtos::SignUp).returns(Outcome[User]) }
    def create_user(sign_up)
      user =
        User.create(
          email: sign_up.email,
          password: sign_up.password,
          confirmation_token: sign_up.token
        )
      user.valid? ? Outcome.ok(user) : Outcome.error(user.errors.to_s)
    end

    sig { params(email: String, token: String).returns(Outcome[T::Boolean]) }
    def enqueue_confirmation_mail(email, token)
      Outcome.ok(true)
    end

    def signup_dto
      TypedParams[Dtos::SignUp].new.extract!(params)
    end

    sig { void }
    def register
      sign_up = signup_dto
      # signup(sign_up.email, sign_up.password)
      #   .when_ok { |result| render json: result }
      #   # Use adequate status depending on the thing
      #   .when_error { |error| render json: error, status: :internal_server_error }

      # or
      # Its OK to unwrap here. There its a global handler in outcome_handler.rb
      signup_v2(sign_up.email, sign_up.password).unwrap!
    end

    sig { params(email: String, password: String).returns(Outcome[T::Boolean]) }
    def signup(email, password)
      sign_up = Payroll::Dtos::SignUp.new(email:, password:)
      valid_email?(email).bind do |valid_email|
        uniq_email?(valid_email).bind do |uniq_email|
          valid_password?(password).bind do |valid_password|
            generate_confirmation_token(sign_up).bind do |token|
              create_user(sign_up).bind { |user| enqueue_confirmation_mail(uniq_email, token) }
            end
          end
        end
      end
    end

    sig { params(email: String, password: String).returns(Outcome[T::Boolean]) }
    def signup_v2(email, password)
      sign_up = Payroll::Dtos::SignUp.new(email:, password:)
      valid_email?(email)
        .bind(&->(valid_email) { uniq_email?(valid_email) })
        .bind(&->(_) { valid_password?(password) })
        .bind(&->(_) { generate_confirmation_token(sign_up) })
        .bind(&->(_) { create_user(sign_up) })
        .bind(&->(user) { enqueue_confirmation_mail(user.email, user.confirmation_token) })
    end
  end
end
