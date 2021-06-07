##[
  | :Author: Thiago Navarro
  | :Email: thiago@oxyoy.com
  | **Created at:** 06/06/2021 23:24:50 Sunday
  | **Modified at:** 06/07/2021 12:14:49 AM Monday

  ----

  whois
  ----

  Whois free client
]##

# from strutils import split, `%`, toLowerAscii
import strutils
from httpclient import newHttpHeaders, newHttpClient, post, code, Http200, `==`, body
from uri import encodeUrl
from json import parseJson, `{}`, getStr

# from times import Date
import times

const whoisApi = (
  url: "https://whois.doyosi.com/whois",
  referrer: "https://whois.doyosi.com/",
  bodyTemplate: "domain=$1",
  contentType: "application/x-www-form-urlencoded; charset=UTF-8",
  takenMessage: "Registry Expiry Date: ",
)

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
    whoisDBLastUpdate: DateTime         ## Last update of WHOIS database
    whoisServer*: string                ## Registrar WHOIS Server

  Domain* = object
    ## The domain object
    name*, tld*: string
    avaliable*: bool
    error*: DomainError
    data*: DomainData

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
  var
    headers = newHttpHeaders({
      "Content-Type": whoisApi.contentType,
      "referrer": whoisApi.referrer,
      "x-requested-with": "XMLHttpRequest",
      "accept-language": "en-US,en;q=0.9",
      "accept": "application/json, text/javascript, */*; q=0.01",
    })
    client = newHttpClient(headers = headers)

  let
    domain = self.full
    body = whoisApi.bodyTemplate % domain.encodeUrl()
    response = client.post(whoisApi.url, body)

  if response.code != Http200:
    self.error = DomainError.apiError

  let
    takenMessage = (whoisApi.takenMessage % domain).toLowerAscii()
    json = response.body.parseJson
    responseBody = json{"data"}.getStr.toLowerAscii()

  if json{"status"}.getStr != "success":
    self.error = DomainError.unknownAvaliability

  self.avaliable = responseBody.find(takenMessage) == -1

when isMainModule:
  var domain = "dasdaiuhshsdai.com".toDomain
  var a: DomainData

  echo domain

  domain.update()

  echo domain

#[
const whoisApi = (
  url: "https://whois.doyosi.com/whois",
  referrer: "https://whois.doyosi.com/",
  bodyTemplate: "domain=$1",
  contentType: "application/x-www-form-urlencoded; charset=UTF-8",
  takenMessage: "Registry Expiry Date: ",
)

proc isAvaliable(domain: string): DomainStatus =
  var
    headers = newHttpHeaders({
      "Content-Type": whoisApi.contentType,
      "referrer": whoisApi.referrer,
      "x-requested-with": "XMLHttpRequest",
      "accept-language": "en-US,en;q=0.9",
      "accept": "application/json, text/javascript, */*; q=0.01",
    })
    client = newHttpClient(headers = headers)

  let
    body = whoisApi.bodyTemplate % domain.encodeUrl()
    response = client.post(whoisApi.url, body)

  if response.code != Http200:
    echo "API Error: " & response.body
    quit(1)

  let
    takenMessage = (whoisApi.takenMessage % domain).toLowerAscii()
    json = response.body.parseJson
    responseBody = json{"data"}.getStr.toLowerAscii()

  if json{"status"}.getStr != "success": return DomainUnknown

  return if responseBody.find(takenMessage) == -1: DomainAvaliable
                                             else: DomainTaken


 ]#
