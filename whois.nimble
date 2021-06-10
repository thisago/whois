# Package

version       = "0.1.0"
author        = "Thiago Navarro"
description   = "A simple and free whois client"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.4.1"
requires "kashae"

task buildRelease, "builds the release version":
  exec "nimble -d:release build"
