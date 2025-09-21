# NimLearning.nimble
# Nimble package definition for the Nim Learning educational project.
import std/[os, strutils]

proc findWnimMacrosPath(): string =
  ## Locate the installed wNim wMacros module.
  const relativePath = joinPath("wNim", "private", "wMacros.nim")

  proc addCandidate(result: var seq[string], dirPath: string) =
    if dirPath.len > 0 and dirExists(dirPath):
      result.add(dirPath)

  var searchRoots: seq[string] = @[]
  let nimbleDir = getEnv("NIMBLE_DIR")
  if nimbleDir.len > 0:
    addCandidate(searchRoots, nimbleDir / "pkgs2")
    addCandidate(searchRoots, nimbleDir / "pkgs")
  let homeNimble = getHomeDir() / ".nimble"
  addCandidate(searchRoots, homeNimble / "pkgs2")
  addCandidate(searchRoots, homeNimble / "pkgs")

  for root in searchRoots:
    for kind, path in walkDir(root):
      if kind == pcDir:
        let folder = extractFilename(path).toLowerAscii
        if folder.startsWith("wnim"):
          let candidate = path / relativePath
          if fileExists(candidate):
            return candidate

proc ensureWnimRootRefCompatibility() =
  ## Patch wNim to define RootRef on Nim 2.x installations where it was removed.
  let macrosPath = findWnimMacrosPath()
  if macrosPath.len == 0:
    echo "Warning: Unable to locate wNim's wMacros.nim for compatibility patch."
    return

  var content = readFile(macrosPath)
  if content.contains("RootRef* = RootObj") or content.contains("RootRef = RootObj"):
    return

  let marker = "import macros, strutils, strformat, tables, sets, hashes, winimx"
  let insertPos = content.find(marker)
  if insertPos < 0:
    echo "Warning: Unexpected wMacros.nim layout. Skipping RootRef compatibility patch."
    return

  let insertion = "\n\nwhen not declared(RootRef):\n  type RootRef* = RootObj\n"
  if content.find(insertion.strip) >= 0:
    return

  content.insert(insertion, insertPos + marker.len)
  writeFile(macrosPath, content)
  echo "Applied wNim RootRef compatibility patch at " & macrosPath

let baseOptions       = @["--hint[Processing]:off", "--hint[Conf]:off"]
let debugOptions      = baseOptions & @["-g", "--lineDir:on", "--stackTrace:on"]
let releaseOptions    = baseOptions & @["-d:release", "--opt:speed", "--stackTrace:off"]
let gccBackend        = @["--cc:gcc"]
let clangCppBackend   = @["--cc:clang", "--cpp"]
let defaultBackend    = gccBackend
let compileSteps      = @["c"]
let runStep          = @["r"]
let mainModule        = "src/nim_learning.nim"

let exampleModules   = @[
  "examples/basic_control_flow.nim",
  "examples/abstractions_and_metaprogramming.nim",
  "examples/error_handling_and_options.nim",
  "examples/interop_c_and_cpp.nim"
]

proc joinOptions(options: seq[string]): string =
  result = ""
  for opt in options:
    if result.len > 0:
      result.add(' ')
    result.add(opt)

proc runNimCommand(options: seq[string], module: string) =
  let command = "nim " & joinOptions(options & @[module])
  echo "Executing: " & command
  exec command

proc runBuild(options: seq[string]) =
  runNimCommand(options, mainModule)

proc addNimExtension(fileName: string): string =
  if fileName.endsWith(".nim"):
    fileName
  else:
    fileName & ".nim"

proc locateExample(target: string): string =
  if target.len == 0:
    return ""
  let normalized = addNimExtension(target)
  for module in exampleModules:
    if module == normalized or module.endsWith(normalized):
      return module
  let direct = normalized
  let nested = joinPath("examples", normalized)
  if fileExists(direct):
    return direct
  if fileExists(nested):
    return nested
  ""

proc compileExamples(options: seq[string]) =
  for module in exampleModules:
    runNimCommand(options, module)

# Package

version       = "0.1.0"
author        = "Nim Learning Contributors"
description   = "Educational resources and examples for learning the Nim programming language."
license       = "MIT"
when compiles(name = "nimlearning"):
  name          = "nimlearning"
srcDir        = "src"

# Dependencies

requires "nim >= 1.6.0"
requires "wNim >= 1.0.0"

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

task examplesDebug, "Compile all example modules with debug options":
  let opts = debugOptions & defaultBackend & compileSteps
  compileExamples(opts)

task examplesRelease, "Compile all example modules with release options":
  let opts = releaseOptions & defaultBackend & compileSteps
  compileExamples(opts)

task runExample, "Run a single example module. Provide the name (with or without .nim) as an argument or set EXAMPLE.":
  var target = getEnv("EXAMPLE")
  let params = commandLineParams()
  for i in 0 ..< params.len - 1:
    if params[i] == "runExample":
      target = params[i + 1]
      break
  if target.len == 0 and params.len > 0:
    let candidate = params[params.len - 1]
    if candidate.len > 0 and candidate[0] != '-' and candidate != "runExample" and not candidate.endsWith(".nim") and not candidate.endsWith(".nims"):
      target = candidate
  if target.len == 0:
    quit "Specify an example to run. Available modules: " & exampleModules.join(", ")
  let module = locateExample(target)
  if module.len == 0:
    quit "Could not find example '" & target & "'. Available modules: " & exampleModules.join(", ")
  let opts = debugOptions & defaultBackend & runStep
  runNimCommand(opts, module)

task runGui, "Compile and launch the Windows-only wNim GUI demo":
  when defined(windows):
    ensureWnimRootRefCompatibility()
    let module = "src/gui/wnim_demo.nim"
    let opts = debugOptions & defaultBackend & runStep & @["--app:gui"]
    runNimCommand(opts, module)
  else:
    quit "The wNim GUI demo can only be built on Windows where wNim is supported."

