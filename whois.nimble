# Package

version       = "0.1.0"
author        = "Thiago Navarro"
description   = "A simple and free whois client"
license       = "MIT"
srcDir        = "src"

binDir = "build"

bin = @["whois"]

# Dependencies

requires "nim >= 1.4.6"
requires "kashae" # REVIEW

task buildRelease, "builds the release version":
  exec "nimble -d:release build"
