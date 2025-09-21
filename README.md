# Nim Learning

Nim Learning is an educational sandbox for exploring the Nim programming language.
The project will grow into a curated collection of lessons, executable examples,
reference notes, and exercises that help developers practice core Nim concepts.

## Project Layout

```
Nim_Learning/
├── docs/        # Guides, tutorials, and reference material
├── examples/    # Small runnable snippets that complement the lessons
├── src/         # Library and application source code (main module lives here)
├── tests/       # Future automated checks for the curriculum
├── NimLearning.nimble  # Nimble package definition and build tasks
└── README.md    # Project overview and contributor onboarding
```

## Build Tasks

All builds are driven through the custom Nimble tasks defined in
`NimLearning.nimble`. The tasks reuse shared option lists so you can tweak
compiler behavior in a single place.

| Task | Command | Purpose |
| --- | --- | --- |
| Debug build | `nimble buildDebug` | Compiles `src/nim_learning.nim` with debug symbols and safety checks enabled. |
| Release build | `nimble buildRelease` | Produces an optimized build using the default C backend. |
| C backend | `nimble buildC` | Builds with the Nim C backend via GCC using the release optimization set. |
| C++ backend | `nimble buildCpp` | Builds with the Nim C++ backend via Clang while reusing the release optimization set. |

> **Note:** If `nimble` is not available in your environment, you can execute the
> same commands by running `nim` with the options printed at the start of each task.

## Configuration Variables

At the top of `NimLearning.nimble` you will find reusable sequences that
encapsulate compiler flags and backend selections:

- `baseOptions` – shared across every task to silence noisy hints.
- `debugOptions` / `releaseOptions` – extend the base options with debugging or
  performance-oriented flags.
- `gccBackend` / `clangCppBackend` – switch the compiler backend between GCC and
  Clang (`--cpp`).
- `compileSteps` and `mainModule` – describe what should be built, letting tasks
  reference the same entry point.

Update these sequences to experiment with different CPUs (`--cpu:arm64`),
operating systems (`--os:linux`), or additional flags without touching the task
implementations.

## Next Steps

- Flesh out the `docs/` and `examples/` directories with instructional content.
- Add tests under `tests/` to validate code samples and exercises.
- Expand `src/` with reusable utilities that support the lessons.
