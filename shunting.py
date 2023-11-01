print()

def shunt(expr):
  tokens = expr.split()
  output = []
  operators = []

  for token in tokens:
    if token == "+":
      operators.append(token)
    else:
      output.append(token)

  while(operators):
    output.append(operators.pop())

  return " ".join(output)

def eval(rpn):
  tokens = rpn.split()

  stack = []
  
  for token in tokens:
    if token == "+":
      stack.append(stack.pop() + stack.pop())
    else:
      stack.append(int(token))

  return stack.pop()

inf_expr = "1 + 1 + 1 + 1"
rpn_expr = shunt(inf_expr)

print(inf_expr)
print(rpn_expr)
print(eval(rpn_expr))
