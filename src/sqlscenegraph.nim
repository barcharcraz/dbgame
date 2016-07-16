import sqlite3
import sqlite3ext
import vecmath
import sqlite3_utils
sqlite_extension_init1()
proc print_mat4f(db: Pcontext, nArgs: int32, args: PValueArg) {.cdecl.} =
    var a = cast[ptr Mat4f](value_blob(args[0]))
    echo vecmath.`$`(a[])
proc mult_mat4f(db: Pcontext, nArgs: int32, args: PValueArg) {.cdecl, exportc, dynlib.} = 
    assert nArgs == 2
    var a: ptr Mat4f = cast[ptr Mat4f](value_blob(args[0]))
    var b: ptr Mat4f = cast[ptr Mat4f](value_blob(args[1]))
    var res = mul(a[], b[])
    result_blob(db, addr res.data[0], sizeof(res).int32, cast[Result_func](SQLITE_TRANSIENT))


proc sqlite3_sqlscenegraph_init*(db: Psqlite3, 
                                errMsg: cstringarray, 
                                papi: ptr sqlite3_api_routines): int {.exportc, dynlib, cdecl.} = 
  sqlite_extension_init2(papi)
  var rc = SQLITE_OK
  rc = sqlite3_api.create_function(db, "mult_mat4f".cstring, -1.int32, SQLITE_UTF8.int32, nil, 
        mult_mat4f, 
        cast[Create_function_step_func](nil), 
        cast[Create_function_final_func](nil))
  rc = sqlite3_api.create_function(db, "print_mat4f".cstring, 1.int32, SQLITE_UTF8.int32, nil, print_mat4f,
        cast[Create_function_step_func](nil),
        cast[Create_function_final_func](nil))
  return rc
  