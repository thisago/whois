##[
  | :Author: Thiago Navarro
  | :Email: thiago@oxyoy.com
  | **Created at:** 06/06/2021 23:24:50 Sunday
  | **Modified at:** 06/06/2021 11:43:48 PM Sunday

  ----

  whois
  ----

  Whois free client
]##

from strutils import split

type
  DomainError* {.pure.} = enum
    ## The possible errors that can have
    none, invalidDomain, unknownAvaliability

  Domain* = object
    ## The domain object
    name*, tld*: string
    avaliable*: bool
    error*: DomainError

proc full*(self: Domain): string {.noSideEffect.} =
  ## Join the name with tld to get the full domain name
  self.name & "." & self.tld

proc `==`*(a, b: Domain): bool {.noSideEffect.} =
  ## Checks if the full domain name is same
  a.full == b.full

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
  echo "update"

when isMainModule:
  var domain = "oxyoy.com".toDomain

  echo domain

  domain.update()

  echo domain
