##[
  | :Author: Thiago Navarro
  | :Email: thiago@oxyoy.com
  | **Created at:** 06/06/2021 23:22:26 Sunday
  | **Modified at:** 06/06/2021 11:24:15 PM Sunday

  ----

  test1
  ----

  Whois lib test
]##

import unittest

import whois

test "Unavaliable":
  check whois("google.com").avaliable == false
  check whois("bing.com").avaliable == false
  check whois("facebook.com").avaliable == false

# test "Avaliable":
#   check whois("uknmaiNadd.org").avaliable == true
#   check whois("uknmaiNddasde.org").avaliable == true
#   check whois("uknaadasdgv.org").avaliable == true

# test "Unknown":
#   check whois("google.fgff").error == true
#   check whois("bing.daf").error == true
#   check whois("facebook").error == true
