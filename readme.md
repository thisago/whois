<!--
  :Author: Thiago Navarro
  :Email: thiago@oxyoy.com

  **Created at:** 06/09/2021 12:05:16 Wednesday
  **Modified at:** 06/09/2021 01:05:30 PM Wednesday

  ------------------------------------------------------------------------------

  readme
  ------------------------------------------------------------------------------
-->

# Whois.nim

The Whois.nim is a simple whois client. **With cache!**

---

## Requirements

- The Nim ([Official website](https://nim-lang.org/)) programming language
- Nimble ([Github](https://github.com/nim-lang/nimble)), the Nim`s package manager

Hint: Install Nim with Choosenim ([Github](https://github.com/dom96/choosenim))

## Installation

```bash
# Clone repo
git clone https://gitea.com/Thisago/whois.nim

# go to folder
cd whois

# Install (with Nimble)
nimble install -y
```

---

## Usage

```nim
import whois

echo whois("duckduckgo.com")

# or

var domain = "metager.org".toDomain # convert to a `Domain` instance
domain.update() # Get data from API

echo domain
```

---

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

<!-- - Import it and call in `src/whois.nim` like was made to `src/whois/api_doyosi.nim`. -->

## NOTICE

The implemented API service has no relation with this lib.