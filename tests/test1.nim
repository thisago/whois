#[
  Created at: 06/06/2021 23:22:26 Sunday
  Modified at: 09/17/2021 12:41:44 AM Friday

        Copyright (C) 2021 Thiago Navarro
  See file "license" for details about copyright
]#

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
