##[
  | :Author: Thiago Navarro
  | :Email: thiago@oxyoy.com
  | **Created at:** 06/06/2021 23:22:26 Sunday
  | **Modified at:** 06/09/2021 12:25:15 PM Wednesday

  ----

  test1
  ----

  Whois lib test
]##

import unittest

import whois

echo "[NOTICE] The tests will make some requests to API. Depending of your " &
     "internet speed, may take some time"

test "Unavaliable":
  check whois("google.com").avaliable == false
  check whois("bing.com").avaliable == false
  check whois("facebook.com").avaliable == false

test "Avaliable":
  check whois("uknmaiNadd.org").avaliable == true
  check whois("uknmaiNddasde.net").avaliable == true
  check whois("uknaadasdgv.org").avaliable == true

test "Unknown":
  check whois("google.fgff").error == DomainError.unknownAvaliability
  check whois("bing.daf").error == DomainError.unknownAvaliability
  check whois("facebook").error == DomainError.invalidDomain
