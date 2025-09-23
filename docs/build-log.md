# Nimble task log

The following commands were executed on Linux using Nim 1.6.14 and Nimble 0.13.1. Outputs are truncated to the most relevant lines for readability.

## `nimble buildDebug`

```
Executing: nim --hint[Processing]:off --hint[Conf]:off -g --lineDir:on --stackTrace:on --cc:gcc c src/nim_learning.nim
Hint:  [Link]
Hint: gc: refc; opt: none (DEBUG BUILD, `-d:release` generates faster code)
41117 lines; 2.422s; 60.902MiB peakmem; proj: /workspace/Nim_Learning/src/nim_learning.nim; out: /workspace/Nim_Learning/src/nim_learning [SuccessX]
```

## `nimble buildRelease`

```
Executing: nim --hint[Processing]:off --hint[Conf]:off -d:release --opt:speed --stackTrace:off --cc:gcc c src/nim_learning.nim
Hint:  [Link]
Hint: gc: refc; opt: speed; options: -d:release
41117 lines; 3.222s; 48.941MiB peakmem; proj: /workspace/Nim_Learning/src/nim_learning.nim; out: /workspace/Nim_Learning/src/nim_learning [SuccessX]
```

## `nimble buildC`

```
Executing: nim --hint[Processing]:off --hint[Conf]:off -d:release --opt:speed --stackTrace:off --cc:gcc c src/nim_learning.nim
Hint:  [Link]
Hint: gc: refc; opt: speed; options: -d:release
41117 lines; 0.891s; 48.895MiB peakmem; proj: /workspace/Nim_Learning/src/nim_learning.nim; out: /workspace/Nim_Learning/src/nim_learning [SuccessX]
```

## `nimble buildCpp`

```
Executing: nim --hint[Processing]:off --hint[Conf]:off -d:release --opt:speed --stackTrace:off --cc:clang --cpp c src/nim_learning.nim
command line(1, 2) Error: invalid command line option: '--cpp'
... FAILED: nim --hint[Processing]:off --hint[Conf]:off -d:release --opt:speed --stackTrace:off --cc:clang --cpp c src/nim_learning.nim [OSError]
```

> **Note:** Nim 1.6 recognises `nim cpp` or `--backend:cpp`. The task is preserved as-is so that the repository reflects the canonical command emitted by the Nimble script.

## `nimble runExample basic_control_flow`

```
Executing: nim --hint[Processing]:off --hint[Conf]:off -g --lineDir:on --stackTrace:on --cc:gcc r examples/basic_control_flow.nim
=== Control Flow Demonstration ===
Hello Avery, hope work is going well.
...
Tried to build a countdown with -1 and caught: Countdown requires a non-negative start.
```
