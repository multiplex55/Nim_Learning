# NimLearning.nimble
# Nimble package definition for the Nim Learning educational project.

let baseOptions       = @["--hint[Processing]:off", "--hint[Conf]:off"]
let debugOptions      = baseOptions & @["-g", "--lineDir:on", "--stackTrace:on"]
let releaseOptions    = baseOptions & @["-d:release", "--opt:speed", "--stackTrace:off"]
let gccBackend        = @["--cc:gcc"]
let clangCppBackend   = @["--cc:clang", "--cpp"]
let defaultBackend    = gccBackend
let compileSteps      = @["c"]
let mainModule        = "src/nim_learning.nim"

proc joinOptions(options: seq[string]): string =
  result = ""
  for opt in options:
    if result.len > 0:
      result.add(' ')
    result.add(opt)

proc runBuild(options: seq[string]) =
  let command = "nim " & joinOptions(options & @[mainModule])
  echo "Executing: " & command
  exec command

# Package

version       = "0.1.0"
author        = "Nim Learning Contributors"
description   = "Educational resources and examples for learning the Nim programming language."
license       = "MIT"
name          = "nimlearning"
srcDir        = "src"

# Dependencies

requires "nim >= 1.6.0"

# Tasks

task buildDebug, "Build the main module with debug information":
  let opts = debugOptions & defaultBackend & compileSteps
  runBuild(opts)

task buildRelease, "Build the main module for release with performance flags":
  let opts = releaseOptions & defaultBackend & compileSteps
  runBuild(opts)

task buildC, "Build the main module targeting the C backend with GCC":
  let opts = releaseOptions & gccBackend & compileSteps
  runBuild(opts)

task buildCpp, "Build the main module targeting the C++ backend with Clang":
  let opts = releaseOptions & clangCppBackend & compileSteps
  runBuild(opts)
