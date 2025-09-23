# Nim Learning

Nim Learning is an educational sandbox for exploring the Nim programming language. The repository collects runnable examples, notes, and tooling that reinforce core language concepts through hands-on experimentation.

## Project Overview

- **Guided source code** – Start from the minimal entry point in [`src/nim_learning.nim`](src/nim_learning.nim) and branch into progressively richer examples under [`examples/`](examples). Each snippet highlights a different language feature while remaining small enough to understand in one sitting.
- **Curated build tasks** – Custom Nimble tasks wrap commonly used compiler configurations so you can focus on learning rather than memorising flag combinations.
- **Cross-language experiments** – Selected modules demonstrate how Nim interfaces with C and C++, as well as how its metaprogramming facilities reduce boilerplate.

For a deeper explanation of the showcased concepts and direct references to the relevant procedures, see the [Nim feature notes](docs/nim-feature-notes.md).

## Repository Layout

```
Nim_Learning/
├── docs/        # Guides, logs, and background material
├── examples/    # Small runnable snippets that complement the lessons
├── src/         # Library and application source code (main module lives here)
├── tests/       # Future automated checks for the curriculum
├── NimLearning.nimble  # Nimble package definition and build tasks
└── README.md    # Project overview and contributor onboarding
```

## Requirements

- Nim 1.6 or newer with `nimble` available on your `PATH`.
- A C toolchain (GCC or Clang) for compiling native binaries.

## Building and Running

Nimble drives every build from [`NimLearning.nimble`](NimLearning.nimble). The custom tasks reuse shared flag lists so that compiler behaviour can be tweaked in one location.

| Task | Command | What it does |
| --- | --- | --- |
| Debug build | `nimble buildDebug` | Builds `src/nim_learning.nim` with debug symbols and extra runtime checks. |
| Release build | `nimble buildRelease` | Produces an optimised build targeting the default C backend. |
| C backend | `nimble buildC` | Rebuilds the main module with the GCC-backed C toolchain. |
| C++ backend | `nimble buildCpp` | Switches to the Clang-based C++ backend to mirror `nim cpp`. |
| Example runner | `nimble runExample <module>` | Compiles and executes one of the examples listed below. |

> **Tip:** each task prints the exact `nim` command before compiling. Copy the output to experiment with additional flags such as `--cpu:arm64` or `--threads:on`.

A recent execution log for the build tasks is available in [`docs/build-log.md`](docs/build-log.md).

## Example Showcase

Use `nimble runExample <name>` (or `nim r examples/<name>.nim`) to explore the following topics:

| Module | Highlights |
| --- | --- |
| [`basic_control_flow.nim`](examples/basic_control_flow.nim) | Branching logic, string interpolation, and loop control with error handling for invalid input. |
| [`abstractions_and_metaprogramming.nim`](examples/abstractions_and_metaprogramming.nim) | Generics, iterators, templates, and macros that generate helpful debug output. |
| [`error_handling_and_options.nim`](examples/error_handling_and_options.nim) | Custom exceptions combined with `Option[T]` workflows for recoverable operations. |
| [`interop_c_and_cpp.nim`](examples/interop_c_and_cpp.nim) | Calling C standard-library functions and optionally invoking inline C++ helpers. |

Each module is documented inline and is cross-referenced in the [feature notes](docs/nim-feature-notes.md) with explanations about why the showcased patterns are useful.

## Additional Notes

- Configuration variables such as `baseOptions`, `releaseOptions`, and the backend selectors live near the top of [`NimLearning.nimble`](NimLearning.nimble). Adjust them to experiment with different targets without rewriting each task.
- Suggested improvements and broader lesson outlines are tracked in [`docs/nim-feature-notes.md`](docs/nim-feature-notes.md); the document also links back to the relevant procedures so you can see how theory maps to code.

Happy hacking!
