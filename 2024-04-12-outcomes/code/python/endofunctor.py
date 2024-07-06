from typing import Any, Callable

class StringFunctor:
  def __init__(self, value: str):
    self.value = value

  def map(self, func):
    return ListFunctor([func(self.value)])

class ListFunctor:
  def __init__(self, values: list[Any]):
    self.values = values

  def map(self, func: Callable[[Any], Any]):
    return ListFunctor([func(value)] for value in self.values)

def main() -> None:
  sf = StringFunctor("Hello")
  lf = sf.map(len) # Now it's a ListFunctor, not a String Functor

  # Further mapping will use ListFunctor's map method
  lf2 = lf.map(lambda x: x * 2)
