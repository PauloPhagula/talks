# typed: strict
module Payroll
  module Dtos
    class SignUp < T::Struct
      const :email, String
      const :password, String
      const :token, T.nilable(String)
    end
  end
end
