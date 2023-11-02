from math import factorial

def permutations(elements):
  if not elements:
    raise Exception()
  if len(elements) == 1:
    return [elements]
  generated = []
  for index, start in enumerate(elements):
    ends = permutations(elements[:index] + elements[index + 1:])
    for end in ends:
      generated.append([start] + end)
  return generated

arg = [1, 2, 3, 4, 5]
result = permutations(arg)
print(result)
assert len(result) == factorial(len(arg)), "length should be factorial"
print()
