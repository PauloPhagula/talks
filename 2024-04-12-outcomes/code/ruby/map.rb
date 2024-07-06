sig do
  abstract
    .type_parameters(:U)
    .params(_block: T.proc.params(arg_0: Elem).returns(T.type_parameter(:U)))
    .returns(Outcome[T.type_parameter(:U)])
end
def map(&_block)
end
