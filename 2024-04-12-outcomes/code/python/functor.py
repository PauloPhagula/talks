from __future__ import annotations
from typing import Any, Callable

# Should be generic
class Functor:
  def __init__(self, value: Any) -> None:
    self.value = value

  def map(self, func: Callable[[Any], Any]) -> Functor:
    return Functor(func(self.value))

def add_one(x: int) -> int:
  return x + 1

def multiply_by_two(x: int) -> int:
  return x * 2

def main() -> None:
  f = Functor(5)

  # Mapping withing the same category (Functor -> Functor)
  g = f.map(add_one) # g is also a functor instance

  # Preserving structure
  assert isinstance(g, Functor)

  # Preserving composition
  assert(
    f.map(add_one).map(multiply_by_two).value
    == f.map(lambda x: multiply_by_two(add_one(x))).value
  )

if __name__ == "__main__":
  main()
