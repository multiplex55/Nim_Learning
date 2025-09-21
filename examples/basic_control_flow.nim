## Basic control flow demonstrations with simple data types and loops.
##
## Run with `nim r examples/basic_control_flow.nim` to see each concept in action.

import std/strformat


type
  ## Person* represents a person with a name and age for branching examples.
  ##
  ## Parameters:
  ## * `name` — Display name for greeting output.
  ## * `age` — Used to demonstrate chained `if` statements.
  Person* = object
    name*: string
    age*: int


## classifyNumber* returns a textual description for `n`.
##
## The result includes information about whether the number is negative,
## zero, or positive, and whether it is even or odd. This procedure is used to
## illustrate `if`, `elif`, and `else` logic. Pass any integer to explore the
## resulting classifications.
proc classifyNumber*(n: int): string =
  var kind =
    if n < 0:
      "negative"
    elif n == 0:
      "zero"
    else:
      "positive"

  if n mod 2 == 0:
    kind.add " and even"
  else:
    kind.add " and odd"
  result = fmt"{n} is {kind}."


## greetPerson* builds a greeting tailored to a person's age bracket.
##
## Parameters:
## * `person` — The `Person` instance to greet.
##
## The procedure demonstrates chained `if` statements and string
## interpolation. It returns the message instead of printing directly so that it
## can be reused by other modules if desired.
proc greetPerson*(person: Person): string =
  if person.age < 18:
    result = fmt"Hey {person.name}, enjoy your studies!"
  elif person.age < 65:
    result = fmt"Hello {person.name}, hope work is going well."
  else:
    result = fmt"Good afternoon {person.name}, wishing you a relaxing day!"


## buildCountdown* constructs a descending list to illustrate loop control.
##
## Parameters:
## * `start` — Highest value to include.
##
## The procedure uses a `while` loop to create a countdown sequence, stopping
## at zero. It raises a `ValueError` when `start` is negative so callers learn
## how to leverage exceptions in simple scripts.
proc buildCountdown*(start: int): seq[int] =
  if start < 0:
    raise newException(ValueError, "Countdown requires a non-negative start.")
  var current = start
  while current >= 0:
    result.add current
    dec current


when isMainModule:
  echo "=== Control Flow Demonstration ==="

  let demoPerson = Person(name: "Avery", age: 27)
  echo greetPerson(demoPerson)

  echo "\n--- Number classification ---"
  for number in -2..3:
    echo classifyNumber(number)

  echo "\n--- Countdown ---"
  for value in buildCountdown(5):
    stdout.write(fmt"{value} ")
  echo "\nBlastoff!"

  echo "\n--- Error handling preview ---"
  try:
    discard buildCountdown(-1)
  except ValueError as err:
    echo "Tried to build a countdown with -1 and caught: ", err.msg
