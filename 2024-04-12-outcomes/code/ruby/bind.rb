sig do
  abstract
    .type_parameters(:U)
    .params(_block: T.proc.params(arg_0: Elem).returns(Outcome[T.type_parameter(:U)]))
    .returns(Outcome[T.type_parameter(:U)])
end
def bind(&_block)
end
