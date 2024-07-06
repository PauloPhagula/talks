func foo() (int, error) {
  if failed {
    return 0, errors.New("Bad things happened")
  }
  return 42, nil
}

if value, err := foo(); err != nil {
  // Error!  Deal with it.
} else {
 // Use value ...
}
