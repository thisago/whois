#[
  Created at: 06/06/2021 23:24:50 Sunday
  Modified at: 09/17/2021 12:42:37 AM Friday

        Copyright (C) 2021 Thiago Navarro
  See file "license" for details about copyright
]#


from std/strutils import split, strip

import whois/core; export core

# API selection
from whois/api_doyosi import nil


proc toDomain*(fullDomain: string): Domain {.noSideEffect.} =
  ## Convert a full domain string in a `Domain` instance
  let splitted = fullDomain.split "."
  if splitted.len != 2:
    result.error = DomainError.invalidDomain
    return
  result.name = splitted[0]
  result.tld = splitted[1]


proc update*(self: var Domain, noCache = false) =
  ## Updates the domain with api data
  if self.error != DomainError.none: return

  if api_doyosi.apiFetch(self, noCache): return # If any error, try next API


proc whois*(domain: string, noCache = false): Domain {.inline.} =
  ## A alias for:
  ## .. code-block:: nim
  ##   var domain = "duckduckgo.com".toDomain
  ##   domain.update()
  result = domain.toDomain()
  result.update(noCache)


when isMainModule:
  import times

  echo cputime()

  var domain = "google.co".toDomain
  var a: DomainData

  echo domain

  domain.update()

  echo cputime()
  echo domain

  echo "update again"

  domain.update()

  echo cputime()
  echo domain

  echo "update again"

  domain.update()

  echo cputime()
  echo domain

  echo "update again"

  domain.update(noCache = true)

  echo cputime()
  echo domain
