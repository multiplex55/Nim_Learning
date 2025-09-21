## Demonstrates calling C and C++ routines directly from Nim code.
##
## Run with `nim r examples/interop_c_and_cpp.nim` to observe the C interop
## output. For the optional C++ portion, run `nim cpp --run examples/interop_c_and_cpp.nim`.

import std/strformat


## cStringLength* exposes the C `strlen` function for measuring UTF-8 byte length.
##
## Parameters:
## * `text` — Null-terminated string to measure. Use Nim's `.cstring` converter.
##
## Returns the number of bytes before the terminator, mirroring the C standard
## library behavior.
proc cStringLength*(text: cstring): csize_t {.importc: "strlen", header: "<string.h>".}


## cPrintLine* wraps the C `puts` function to print a line using the C standard
## library.
##
## Parameters:
## * `text` — Null-terminated string. Nim automatically appends a newline.
##
## The function returns the status code from `puts`. Discard the result if you do
## not need to inspect it.
proc cPrintLine*(text: cstring): cint {.importc: "puts", header: "<stdio.h>".}


when defined(cpp):
  ## cppAddOne* calls a helper C++ inline function defined in `cpp_helpers.hpp`.
  ##
  ## Parameters:
  ## * `value` — Integer forwarded to the C++ helper.
  ##
  ## The example showcases `importcpp` with a Nim call that expands to a C++
  ## function invocation. Compile with the C++ backend (`nim cpp`) for this code
  ## path to activate.
  proc cppAddOne*(value: cint): cint {.importcpp: "addOne(@)", header: "\"cpp_helpers.hpp\"".}


when isMainModule:
  let greeting = "Hello from Nim via C!"
  echo fmt"Byte length reported by strlen: {cStringLength(greeting.cstring)}"
  discard cPrintLine("Printed by the C standard library.".cstring)

  when defined(cpp):
    echo fmt"C++ helper reports 7 + 1 = {cppAddOne(7)}"
