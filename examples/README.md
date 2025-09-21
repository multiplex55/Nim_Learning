# Example Programs

These standalone examples illustrate core Nim language features. Run each file
with `nim r examples/<name>.nim` unless noted otherwise.

You can also run any example through the Nimble task `nimble runExample`. Pass the module name as an argument or set the `EXAMPLE` environment variable, e.g. `nimble runExample basic_control_flow` or `EXAMPLE=error_handling_and_options nimble runExample`.

## `basic_control_flow.nim`
- **Command:** `nim r examples/basic_control_flow.nim`
- **Highlights:** Immutable and mutable variables, branching with `if`/`elif`/`else`,
  loops, exception handling basics.
- **Expected output:**

```
=== Control Flow Demonstration ===
Hello Avery, hope work is going well.

--- Number classification ---
-2 is negative and even.
-1 is negative and odd.
0 is zero and even.
1 is positive and odd.
2 is positive and even.
3 is positive and odd.

--- Countdown ---
5 4 3 2 1 0
Blastoff!

--- Error handling preview ---
Tried to build a countdown with -1 and caught: Countdown requires a non-negative start.
```

## `abstractions_and_metaprogramming.nim`
- **Command:** `nim r examples/abstractions_and_metaprogramming.nim`
- **Highlights:** Generic procedures, custom iterators, templates for code reuse,
  and macros for compile-time debugging.
- **Expected output:**

```
------------------- Generic boxes
Base value: 21
Doubled value: 42
------------------- end
--------------------- Custom iterator
Taking every other word:
Nim metaprogramming

--------------------- end
--------------------- Macro debugging
[debug] 14 = 14
Result still available as a value: 14
--------------------- end
```

## `error_handling_and_options.nim`
- **Command:** `nim r examples/error_handling_and_options.nim`
- **Highlights:** Defining custom exceptions, working with `Option[T]`, and using
  `try`/`except` blocks to recover from failures.
- **Expected output:**

```
=== Option type parsing ===
Successfully parsed 42 as 42.
Input -10 is not a positive integer.
Input abc is not a positive integer.

=== Exception handling ===
10.0 / 2.0 = 5.0
Could not divide 5.0 by 0.0: Cannot divide by zero or near-zero.

=== Options from divisions ===
Quotient is 3.0.
Division failed for 1.0 / 0.0.
```

## `interop_c_and_cpp.nim`
- **Command:** `nim r examples/interop_c_and_cpp.nim`
- **Highlights:** Calling C standard library functions using `importc`.
- **Expected output:**

```
Byte length reported by strlen: 21
Printed by the C standard library.
```

To demonstrate the optional C++ integration, compile and run with the C++
backend instead:

```
nim cpp --run examples/interop_c_and_cpp.nim
```

Expected additional output in that mode:

```
C++ helper reports 7 + 1 = 8
```
