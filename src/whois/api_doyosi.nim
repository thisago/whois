#[
  Created at: 06/07/2021 10:36:49 Monday
  Modified at: 09/17/2021 12:42:19 AM Friday

        Copyright (C) 2021 Thiago Navarro
  See file "license" for details about copyright
]#

##[
  Doyosi free API implementation

  API source code: https://github.com/Karyazilim/DoyosiWhois
]##

{.experimental: "codeReordering".}

from std/httpcore import Http200, `$`
from std/httpclient import newHttpHeaders, newHttpClient, post, code, `==`, body
from std/uri import encodeUrl
from std/json import parseJson, `{}`, getStr
from std/strutils import `%`, toLowerAscii, strip

import std/with
from std/sugar import collect

import kashae

import ./core


const apiConfigs = (
  url: "https://whois.doyosi.com/whois",
  referrer: "https://whois.doyosi.com/",

  # url: "http://127.0.0.1/u3/apache/DoyosiWhois/",
  # referrer: "http://127.0.0.1/u3/apache/DoyosiWhois/",

  bodyTemplate: "domain=$1",
  contentType: "application/x-www-form-urlencoded; charset=UTF-8",
  takenMessage: "Registry Expiry Date: ",
  messageNewline: "<br />\r\n"
)


proc apiFetch*(self: var Domain, noCache = false): bool =
  ## This function fetch the data of domain and returns a `ApiResponse` instance
  ## Returns true on request success
  result = true
  var response = apiRequest(self.full, noCache)
  if response.code != Http200:
    self.error = DomainError.apiError
    return false
  let json = response.body.parseJson

  if json{"status"}.getStr != "success":
    self.error = DomainError.unknownAvaliability
    return false
  self.parse json{"data"}.getStr


proc apiRequest(domain: string): ApiResponse {.cacheOpt: {clearParam}.} =
  var
    headers = newHttpHeaders({
      "content-type": apiConfigs.contentType,
      "referrer": apiConfigs.referrer,
      "x-requested-with": "XMLHttpRequest",
      "accept-language": "en-US,en;q=0.9",
      "accept": "application/json, text/javascript, */*; q=0.01",
    })
    client = newHttpClient(headers = headers)
  let
    body = apiConfigs.bodyTemplate % domain.encodeUrl()
    response = client.post(apiConfigs.url, body)

  result.body = response.body
  result.code = response.code



proc parse(self: var Domain, data: string) =
  ## Parse the API response and saves in the `Domain` instance
  let domain = self.full

  self.avaliable = data.toLowerAscii().find(
    (apiConfigs.takenMessage % domain).toLowerAscii()
  ) == -1

  if self.avaliable: return

  with self.data:
    creationDate = data.get("Creation Date: ").toDate
    expireDate = data.get("Registry Expiry Date: ").toDate
    id = data.get("Registry Domain ID: ")
    registrantCountry = data.get("Registry Domain ID: ")
    registrantOrganization = data.get("Registrant Organization: ")
    registrantState = data.get("Registrant State/Province: ")
    registrar = data.get("Registrar: ")
    registrarAbuseContactEmail = data.get("Registrar Abuse Contact Email: ")
    registrarAbuseContactPhone = data.get("Registrar Abuse Contact Phone: ")
    registrarIanaId = data.get("Registrar IANA ID: ")
    updatedDate = data.get("Updated Date: ").toDate
    whoisDBLastUpdate = data.get("Last update of whois database: ").toDate
    whoisServer = data.get("Registrar WHOIS Server: ")

  self.data.nameServers = @[]

  block:
    const toFind = "Name Server: " # The value name to get
    var
      mdata = data # A mutable copy of data
      index = mdata.find toFind
    while index > -1: # While finding the value
      mdata = mdata.substr(index + toFind.len).strip # delete everything from
                                                      # begin of match and save
                                                      # on itself
      index = mdata.find toFind # update the index

      self.data.nameServers.add mdata.substr( # Delete all from newline
        0, mdata.find(apiConfigs.messageNewline) - 1)


proc get(data, val: string): string =
  ## Gets the data from response
  let index = data.find val
  if index == -1: return

  let croppedStart = data.substr(index + val.len).strip
  result = croppedStart.substr(
    0, croppedStart.find(apiConfigs.messageNewline) - 1)

proc find(s, sub: string): int =
  strutils.find(s.toLowerAscii(), sub.toLowerAscii())
