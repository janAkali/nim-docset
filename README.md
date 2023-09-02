## Docsets for Nim in Dash, Zeal or Velocity

### Install in reader

To install latest version into your docset reader, use [this](https://zealusercontributions.now.sh/api/docsets/Nim) feed URL.

### Download and extract

To install a versioned release that allows multiple versions to coexist, download from the Github [releases](releases) page and extract to the docset directory configured in the reader.

### Generating docs

#### Prerequisites

- Ensure a working GCC, Nim, Go and NodeJS installations
- make sure koch tool is in the nim directory and has the 'execute' permission
  - (nim installed with choosenim might require `sudo chmod +x ~/.choosenim/toolchains/<nim-version>/koch`)
- Install dashing package `go install github.com/technosophos/dashing`
- Clone this repo

#### Non-versioned docset

To create a docset ready to upload to [Kapeli](https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets/Nim):
```
nim e docset.nims
```
This will create `Nim.tgz` in the current directory.

#### Versioned docset

To create a versioned docset found in the releases page:
```
nim e docset.nims --version
```
This will create `nim-x.y.z.docset.zip` in the current directory.

#### Target compiler

By default, docs will be generated for the Nim compiler that ran the script. If you need to point to another location, specify `/path/to/nim/root` as a parameter.

### Credits

Thanks to the work from [niv](https://github.com/niv/nim-docset), [wicast](https://github.com/wicast/nim-docset) and [genotrance](https://github.com/genotrance/nim-docset).
