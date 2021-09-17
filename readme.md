<!--
  Created at: 06/09/2021 12:05:16 Wednesday
  Modified at: 09/17/2021 12:46:24 AM Friday

        Copyright (C) 2021 Thiago Navarro
  See file "license" for details about copyright
-->

<!-- Hello! Thanks for interest in my lib! :) -->

# Whois.nim

The Whois.nim is a simple whois client.
**With cache (kashae)!**

---

## Requirements

- The Nim ([Official website](https://nim-lang.org/)) programming language (Min version 1.4.0)
- Nimble ([Github](https://github.com/nim-lang/nimble)), the Nim's package manager

Hint: Install Nim with Choosenim ([Github](https://github.com/dom96/choosenim))

## Installation

Directly with Nimble

```bash
# Install directly with Nimble
nimble install whois
```

or

Directly with Nimble (with url)

```bash
# Install directly with Nimble (with url)
nimble install https://github.com/thisago/whois.nim
```

or

Manually with Nimble

```bash
# Clone repo
git clone https://github.com/thisago/whois.nim

# go to folder
cd whois

# Install (with Nimble)
nimble install -y
```

## Docs

You can find the [docs in Github pages](https://thisago.github.io/whois/whois.html)

## Usage

example/example.nim
```nim
import whois

echo whois("duckduckgo.com")

# or

var domain = "metager.org".toDomain # convert to a `Domain` instance
domain.update() # Get data from API

echo domain
```

Run:
```bash
nim c -r -d:ssl -d:release example/example.nim
```

NOTE: Compile with `-d:ssl`

## TODO

- [ ] Change the nimble package url from gitea to github


## Contributing

Its easy to create a parser for another API!

Just see `src/whois/api_doyosi.nim` to understand how simple is it.

All definitions is in `src/whois/core.nim`.

- Create a new file in `src/whois/` called `api_APINAME.nim`
- Import module `src/whois/core.nim`
- Export a function named `apiFetch`
- In `src/whois.nim`
  - Import the new api parser using:
    ```nim
    from whois/api_APINAME.nim import nil
    ```
  - Call the `apiFetch` function in `update` in end like:
    ```nim
    if api_APINAME.apiFetch(self, noCache): return # If any error, try next API
    ```

## NOTICE

The implemented API service has no relation with this lib.
