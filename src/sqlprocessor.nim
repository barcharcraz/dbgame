import parsesql
import streams
import os
proc parse(sql: string): string =
    result = ""
    var stream = newStringStream(sql)
    var ast = parseSQL(stream, "")
    echo repr(ast)

when isMainModule:
    discard parse(paramStr(1))