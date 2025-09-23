# Nim feature notes

This guide connects each learning module to the Nim language constructs it demonstrates. Use it alongside the inline comments in the source tree for a deeper understanding of how the examples are structured.

## Entry point (`src/nim_learning.nim`)

- `formatGreeting` shows how default parameters and string interpolation via `fmt"..."` make it straightforward to build friendly command-line output while keeping the main module tiny for rapid compilation cycles.【F:src/nim_learning.nim†L6-L14】

## Basic control flow (`examples/basic_control_flow.nim`)

- The `Person` object type wraps named fields and is exported (`*`) so other modules can reuse it when experimenting with branching logic.【F:examples/basic_control_flow.nim†L9-L16】
- `classifyNumber` demonstrates nested `if`/`elif`/`else` expressions that return values, including string concatenation that depends on runtime parity checks.【F:examples/basic_control_flow.nim†L21-L36】
- `greetPerson` illustrates how returning strings instead of printing directly makes procedures easier to compose in larger applications.【F:examples/basic_control_flow.nim†L39-L48】
- `buildCountdown` combines guard clauses with a `while` loop and raises a `ValueError` to emphasise how Nim handles exceptional flows.【F:examples/basic_control_flow.nim†L51-L66】

## Abstractions and metaprogramming (`examples/abstractions_and_metaprogramming.nim`)

- `Box[T]` plus `initBox` and `mapBox` highlight Nim's generic type parameters and type inference when transforming stored values with higher-order procedures.【F:examples/abstractions_and_metaprogramming.nim†L11-L38】
- The `everyOther` iterator keeps internal state between `yield` calls, showcasing how Nim lazily traverses collections without allocating temporary sequences.【F:examples/abstractions_and_metaprogramming.nim†L41-L55】
- `withSeparator` is a template that generates reusable logging scaffolding at compile time, reinforcing how templates reduce boilerplate while keeping call sites tidy.【F:examples/abstractions_and_metaprogramming.nim†L58-L70】
- `debugExpression` is a macro that prints the abstract syntax tree (AST) representation of an expression before returning the evaluated result, illustrating Nim's metaprogramming capabilities.【F:examples/abstractions_and_metaprogramming.nim†L73-L88】

## Error handling and options (`examples/error_handling_and_options.nim`)

- `CalculationError` derives from `CatchableError` to define a custom exception hierarchy suitable for end-user scripts.【F:examples/error_handling_and_options.nim†L11-L18】
- `safeDivide` shows defensive programming with floating-point comparisons and exception raising when invariants are violated.【F:examples/error_handling_and_options.nim†L21-L34】
- `parsePositiveInt` returns `Option[int]`, emphasising recoverable flows that avoid exceptions when parsing user input fails.【F:examples/error_handling_and_options.nim†L37-L49】
- `attemptDivision` converts thrown errors into `Option[float]` values to keep the call site free from `try`/`except` blocks while still acknowledging potential failure.【F:examples/error_handling_and_options.nim†L52-L61】

## C and C++ interop (`examples/interop_c_and_cpp.nim`)

- `cStringLength` and `cPrintLine` use the `{.importc.}` pragma to bind directly to C standard-library functions for measuring string length and printing lines, respectively.【F:examples/interop_c_and_cpp.nim†L8-L25】
- When compiled with the C++ backend, `cppAddOne` activates via `{.importcpp.}` to call an inline helper defined in `examples/cpp_helpers.hpp`, demonstrating conditional compilation with the `when defined(cpp)` guard.【F:examples/interop_c_and_cpp.nim†L27-L41】

## GUI demo (`src/gui/nimx_demo.nim`)

- `launchDemo` wraps `runApplication` to construct a cross-platform window with a nimx declarative layout that instantiates labels, buttons, text fields, checkboxes, pop-up menus, and a table-backed activity log.【F:src/gui/nimx_demo.nim†L17-L143】
- Each widget wires into closures that mutate shared state, refresh status labels, and append to the log so interactions immediately update the interface.【F:src/gui/nimx_demo.nim†L149-L220】

Refer back to the example modules after reading each section and tinker with the code to reinforce the concepts.
