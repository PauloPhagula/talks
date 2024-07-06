# Example account sign up
# Steps:
# * Validate email
# * Check unicity
# * Validate password requirements (length, numbers, character, the blood of a virgin)
# * Generate confirmation token
# * Store everything in db
# * Enqueue sign up confirmation mail
# Any of these steps can fail, the email address might not be valid, not because the UI skipped validating but because someone is using the API directly; The password might not be good enough; someone might have signed up already; something goes wrong when inserting the data; Redis is offline and so Sidekiq won’t take our job

def signup(email, password)
  token = generate_confirmation_token
  User.create(
    email: email,
    password: password,
    confirmation_token: token
  )
  enqueue_confirmation_mail(email, token)
end


def signup(email, password)
  unless valid_email?(email)
    raise 'Invalid email'
  end

  unless uniq_email?(email)
    raise 'Already signed up'
  end

  unless valid_password?(password)
    raise 'Password lacks dragon blood'
  end

  token = generate_confirmation_token

  user = User.create(
    email: email,
    password: password,
    confirmation_token: token
  )

  unless user
    raise 'Something went wrong'
  end

  begin
    enqueue_confirmation_mail(email, confirmation_token)
  rescue
    raise 'Sidekiq down. Could not enqueue confirmation email'
  end
end
