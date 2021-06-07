##[
  | :Author: Thiago Navarro
  | :Email: thiago@oxyoy.com
  | **Created at:** 06/07/2021 10:38:20 Monday
  | **Modified at:** 06/07/2021 02:38:00 PM Monday

  ----

  core
  ----

  Whois Core
]##

from std/times import DateTime, utc, parse
from httpcore import HttpCode
from strutils import find, AllChars, Letters, Digits, delete, strip

type
  DomainError* {.pure.} = enum
    ## The possible errors that can have
    none, invalidDomain, unknownAvaliability, apiError

  DomainData* = object
    ## All data provided by API
    id*: string                         ## Registry Domain ID
    creationDate*: DateTime             ## Creation Date
    expireDate*: DateTime               ## Registry Expiry Date
    nameServers*: seq[string]           ## Name Server(s)
    registrantCountry*: string          ## Registrant Country
    registrantOrganization*: string     ## Registrant Organization
    registrantState*: string            ## Registrant State/Province
    registrar*: string                  ## Registrar
    registrarAbuseContactEmail*: string ## Registrar Abuse Contact Email
    registrarAbuseContactPhone*: string ## Registrar Abuse Contact Phone
    registrarIanaId*: string            ## Registrar IANA ID
    updatedDate*: DateTime              ## Updated Date
    whoisDBLastUpdate*: DateTime        ## Last update of WHOIS database
    whoisServer*: string                ## Registrar WHOIS Server

  Domain* = object
    ## The domain object
    name*, tld*: string
    avaliable*: bool
    error*: DomainError
    data*: DomainData

# Api types
type
  ApiResponse* = object
    ## The response got by API
    code*: HttpCode ## The `Response` http code
    body*: string   ## The `Response` body

proc full*(self: Domain): string {.noSideEffect.} =
  ## Join the name with tld to get the full domain name
  self.name & "." & self.tld

proc `==`*(a, b: Domain): bool {.noSideEffect.} =
  ## Checks if the full domain name is same
  a.full == b.full

const invalidDateChars = AllChars - Digits - {'T', 'Z', ':', '-'}

proc toDate*(s: string): DateTime =
  let endIndex = s.find invalidDateChars
  var cleaned = s.strip
  if endIndex > -1: cleaned = cleaned.substr(0, endIndex - 1).strip

  if cleaned.len == 0: return

  return parse(cleaned, "yyyy-MM-dd'T'HH:mm:sszzz", utc())
