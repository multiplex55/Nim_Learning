## Nim Learning main module
## This file provides a simple entry point so that build tasks have
## something meaningful to compile while the curriculum is developed.

import std/strformat

const welcomeMessage = "Welcome to Nim Learning!"

proc formatGreeting(name = "Learner"): string =
  ## Returns a friendly greeting used by the starter application.
  fmt"{welcomeMessage} Let's explore Nim together, {name}."

when isMainModule:
  echo formatGreeting()
