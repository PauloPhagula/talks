begin
 #... process, may raise an exception
rescue =>
 #... error handler
else
 #... executes when no error
ensure
 #... always executed
end

# typed: true

# A function that claims to raise an exception, but it's not enforced by Ruby
# and Sorbet doesn't check for it.
# @raise [RuntimeError] This exception is not enforced by Ruby or Sorbet.
def risky_operation(x)
  if x == 0
    raise "Operation failed"
  else
    10 / x
  end
end

# Calling the function
puts risky_operation(5)  # This will not raise any exception
puts risky_operation(0)  # This will raise an exception, but it's not checked


Outcome.ok(1-1).bind do |result|
#    result == 0 ? Outcome.malformed_request('Cannot divide by 0') : Outcome.ok(10 / result)
# end

def risky_operation(x)
  if x == 0
    Outcome.malformed_request('Cannot divide by 0')
  else
    Outcome.ok(10 / x)
  end
end

risky_operation(5)
  .when_ok do ->(result) { puts result }
  .when_error do ->(error) { puts 'Oh no!' }


add1 = ->(a) {a + 1}
multiply2 = ->(a) {a * 2}

add1_multiply2 = add1 >> multiply2
add1_multiply2.call(1) # => 4

multiply2_add1 = add1 << multiply2
add1_multiply2.call(1) # => 3
