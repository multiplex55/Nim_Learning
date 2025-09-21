## Demonstrates Nim's exception system and the `Option[T]` type for recoverable
## flows.
##
## Run with `nim r examples/error_handling_and_options.nim` to watch several
## strategies for dealing with failures.

import std/[options, strformat, strutils]


type
  ## CalculationError* surfaces invalid numeric operations such as division by
  ## zero.
  ##
  ## Raising this custom exception makes it easy for callers to catch only the
  ## errors they expect while letting unrelated issues bubble up. Deriving from
  ## `CatchableError` allows the exception to be trapped in user code.
  CalculationError* = object of CatchableError


## safeDivide* divides two floating-point numbers while guarding against
## division-by-zero scenarios.
##
## Parameters:
## * `numerator` — Value on the top of the fraction.
## * `denominator` — Value on the bottom of the fraction.
##
## The procedure raises `CalculationError` whenever the denominator is too close
## to zero, using a configurable epsilon to avoid floating-point surprises.
proc safeDivide*(numerator, denominator: float): float =
  const epsilon = 1e-9
  if abs(denominator) < epsilon:
    raise newException(CalculationError, "Cannot divide by zero or near-zero.")
  numerator / denominator


## parsePositiveInt* converts `text` to a strictly positive integer wrapped in an
## option.
##
## Parameters:
## * `text` — String containing the digits to parse.
##
## On successful parsing of a value greater than zero the procedure returns
## `some(value)`. Invalid input or non-positive numbers yield `none(int)`,
## allowing callers to pattern match on the result instead of raising errors.
proc parsePositiveInt*(text: string): Option[int] =
  try:
    let parsed = parseInt(text)
    if parsed > 0:
      result = some(parsed)
    else:
      result = none(int)
  except ValueError:
    result = none(int)


## attemptDivision* returns an optional quotient using `safeDivide` for the heavy
## lifting.
##
## Parameters:
## * `numerator` — Dividend.
## * `denominator` — Divisor.
##
## A `CalculationError` from `safeDivide` is transformed into `none(float)`,
## allowing callers to handle the absence of a result without a `try` block.
proc attemptDivision*(numerator, denominator: float): Option[float] =
  try:
    some(safeDivide(numerator, denominator))
  except CalculationError:
    none(float)


when isMainModule:
  echo "=== Option type parsing ==="
  for sample in @["42", "-10", "abc"]:
    let parsed = parsePositiveInt(sample)
    if parsed.isSome:
      echo fmt"Successfully parsed {sample} as {parsed.get}."
    else:
      echo fmt"Input {sample} is not a positive integer."

  echo "\n=== Exception handling ==="
  for pair in @[ (numerator: 10.0, denominator: 2.0), (numerator: 5.0, denominator: 0.0) ]:
    try:
      let quotient = safeDivide(pair.numerator, pair.denominator)
      echo fmt"{pair.numerator} / {pair.denominator} = {quotient}"
    except CalculationError as err:
      echo fmt"Could not divide {pair.numerator} by {pair.denominator}: {err.msg}"

  echo "\n=== Options from divisions ==="
  for pair in @[ (numerator: 9.0, denominator: 3.0), (numerator: 1.0, denominator: 0.0) ]:
    let maybeQuotient = attemptDivision(pair.numerator, pair.denominator)
    if maybeQuotient.isSome:
      echo fmt"Quotient is {maybeQuotient.get}."
    else:
      echo fmt"Division failed for {pair.numerator} / {pair.denominator}."
