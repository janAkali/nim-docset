from os import getTempDir, `/`, ExeExt, getCurrentCompilerExe, parentDir, commandLineParams
import strutils

var
  path = getCurrentCompilerExe().parentDir().parentDir()
  version = ""
  hash = ""
  vflag = false

for i in 3 .. paramCount():
  let
    param = paramStr(i)
  if existsDir(param):
    path = param
  elif param == "--version":
    vflag = true

let
  nim = path / "bin" / "nim" & ExeExt
  upload = path / "web" / "upload"

if not existsFile(nim):
  echo "Needs to be a Nim root directory with bin/nim[.exe]"
  quit()

let
  (output, ret) = gorgeEx(nim & " -v")
if ret != 0:
  echo "Nim doesn't run"
  echo output
  quit()

if "Nim Compiler Version" notin output:
  echo "Bad nim -v output"
  echo output
  quit()

version = output.split()[3]
hash = output.split()[18]
echo "Running for " & version & " at " & path
if hash.len < 16:
  # No hash in nim -v output
  hash = "v" & version
echo  "  commit " & hash

if not existsDir(upload/version):
  rmDir(upload)
  withDir path:
    exec "./koch docs --git.commit=" & hash

if not existsDir(upload/version):
  echo "No html directory generated"
  quit()

for file in @["dashing.json", "icon.png", "icon@2x.png"]:
  cpFile(file, upload/version/file)

# Cleanup
withDir(upload/version):
  exec "rm -rf Nim.tgz"
  exec "rm -rf nim*.docset*"

if not vflag:
  # Unversioned for Kapeli
  withDir(upload/version):
    exec "~/go/bin/dashing build nim"
    exec "tar cvzf Nim.tgz nim.docset"

  mvFile(upload/version/"Nim.tgz", "Nim.tgz")
else:
  # Versioned for upload
  var
    djson = upload/version/"dashing.json"
    json = djson.readFile()

  json = json.multiReplace([
    ("\"nim\"", "\"nim-$1\"" % version),
    ("\"Nim\"", "\"Nim $1\"" % version)
  ])

  djson.writeFile(json)

  withDir(upload/version):
    exec "rm -rf Nim.tgz"
    exec "rm -rf nim*.docset*"
    exec "~/go/bin/dashing build nim"
    exec "zip -r nim-$1.docset.zip nim-$1.docset" % version

  mvFile(upload/version/"nim-$1.docset.zip" % version, "nim-$1.docset.zip" % version)
