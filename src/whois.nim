##[
  | :Author: Thiago Navarro
  | :Email: thiago@oxyoy.com
  | **Created at:** 06/06/2021 23:24:50 Sunday
  | **Modified at:** 06/07/2021 02:34:13 PM Monday

  ----

  whois
  -----

  Whois free client
]##

from std/strutils import split, strip

import whois/core; export core

# API selection
import whois/api_doyosi


proc toDomain*(fullDomain: string): Domain {.noSideEffect.} =
  ## Convert a full domain string in a `Domain` instance
  let splitted = fullDomain.split "."
  if splitted.len != 2:
    result.error = DomainError.invalidDomain
    return
  result.name = splitted[0]
  result.tld = splitted[1]


proc update*(self: var Domain) =
  ## Updates the domain with api data
  if self.error != DomainError.none: return
  self.apiFetch()


proc whois*(domain: string): Domain {.inline.} =
  ## A alias for:
  ## .. code-block:: nim
  ##   var domain = "duckduckgo.com".toDomain
  ##   domain.update()
  result = domain.toDomain()
  result.update()


when isMainModule:
  import times

  echo now()

  var domain = "google.com".toDomain
  var a: DomainData

  echo domain

  domain.update()

  echo now()
  echo domain

  echo "update again"

  domain.update()

  echo now()
  echo domain
