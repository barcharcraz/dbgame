import ospaths
switch("define", "nimOldDlls")
switch("nimcache", "build/nimcache")
switch("out", "build/")
task dataimport, "builds the dataimport tools":
    switch("out", "build/dataimport.exe")
    setCommand "c", "src/dataimport.nim"

task sqlprocessor, "builds the sql processor":
    switch("out", "build/sqlprocessor.exe")
    setCommand "c", "src/sqlprocessor.nim"