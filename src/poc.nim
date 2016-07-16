import db_sqlite
import sqlite3
import assimp
proc sqlite3_enable_load_extension(db: PSqlite3, onoff: cint): cint {.importc, dynlib:"libsqlite3-0.dll".}
proc sqlite3_load_extension(db: PSqlite3, file: cstring, entry: cstring, err: ptr cstring): int {.importc, dynlib:"libsqlite3-0.dll".}
proc spatialite_alloc_connection(): pointer {.importc, dynlib:"libspatialite-4.dll".}
proc spatialite_init_ex(handle: PSqlite3, mem: pointer, verbose: int) {.importc, dynlib:"libspatialite-4.dll".}
let db = open(":memory:", "", "", "")
echo sqlite3_enable_load_extension(db, 1)
var mem = spatialite_alloc_connection()
spatialite_init_ex(db, mem, 1)
#db.exec(sql"SELECT load_extension('libspatialite-4.dll')")
echo "Spatialite Version: ", db.getValue(sql"SELECT geos_version()")
