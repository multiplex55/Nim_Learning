## Examples that combine procedures, generics, iterators, templates, and macros.
##
## Run with `nim r examples/abstractions_and_metaprogramming.nim` to follow each
## demonstration in the console.

import std/[macros, strformat, strutils]


type
  ## Box* wraps a value of any type so generic procedures can transform it.
  ##
  ## Parameters:
  ## * `T` — Compile-time type parameter representing the stored value.
  ##
  ## The type exports the `value` field to make pattern matching and
  ## destructuring easy in downstream modules.
  Box*[T] = object
    value*: T


## initBox* constructs a `Box` for convenient generic experimentation.
##
## Parameters:
## * `value` — The payload to store inside the box.
##
## Use this helper to avoid explicit type annotations when creating boxes. The
## compiler infers `T` automatically based on the provided argument.
proc initBox*[T](value: T): Box[T] =
  Box[T](value: value)


## mapBox* applies `transform` to the inner value and returns a new `Box`.
##
## Parameters:
## * `box` — Source container to transform.
## * `transform` — Callback receiving the boxed value and returning a new type.
##
## The procedure demonstrates higher-order functions combined with generics.
## It is intentionally simple yet expressive enough to showcase type inference.
proc mapBox*[T, U](box: Box[T], transform: proc (value: T): U): Box[U] =
  Box[U](value: transform(box.value))


## everyOther* yields every second element from `items`.
##
## Parameters:
## * `items` — Any sequence-like container that supports indexing.
##
## The iterator demonstrates stateful iteration with captured variables. Use it
## to observe how Nim lazily produces values without allocating intermediate
## sequences.
iterator everyOther*[T](items: openArray[T]): T =
  var index = 0
  for item in items:
    if (index mod 2) == 0:
      yield item
    inc index


## withSeparator* prints a visual separator before and after executing `body`.
##
## Parameters:
## * `label` — Short description inserted into the separator line.
## * `body` — Code block executed between the separator lines.
##
## Templates run at compile time and perform lightweight code generation. This
## one keeps output formatting tidy while allowing call sites to stay compact.
template withSeparator*(label: string, body: untyped): untyped =
  block:
    let width = if label.len < 4: 4 else: label.len
    let border = repeat('-', width + 6)
    echo border, " ", label
    body
    echo border, " end"


## debugExpression* evaluates `expr`, prints its AST representation, and returns
## the computed value.
##
## Parameters:
## * `expr` — Any expression to evaluate and debug.
##
## The macro showcases compile-time metaprogramming. It generates a let-binding
## with a unique symbol, echoes the expression, and yields the result so callers
## can continue chaining computations.
macro debugExpression*(expr: typed): untyped =
  let tmp = genSym(nskLet, "tmp")
  let exprStr = newLit(expr.repr)
  result = quote do:
    let `tmp` = `expr`
    echo "[debug] ", `exprStr`, " = ", `tmp`
    `tmp`


when isMainModule:
  withSeparator "Generic boxes":
    let baseBox = initBox(21)
    let doubledBox = mapBox(baseBox, proc (value: int): int = value * 2)
    echo fmt"Base value: {baseBox.value}"
    echo fmt"Doubled value: {doubledBox.value}"

  withSeparator "Custom iterator":
    let words = @["Nim", "makes", "metaprogramming", "approachable"]
    echo "Taking every other word:" 
    for word in everyOther(words):
      stdout.write(word & " ")
    echo "\n"

  withSeparator "Macro debugging":
    let computed = debugExpression((3 + 4) * 2)
    echo fmt"Result still available as a value: {computed}"
