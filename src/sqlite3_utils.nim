import db_sqlite
import sqlite3

when defined(windows):
  when defined(nimOldDlls):
    const Lib = "sqlite3.dll"
  elif defined(cpu64):
    const Lib = "sqlite3_64.dll"
  else:
    const Lib = "sqlite3_32.dll"
elif defined(macosx):
  const
    Lib = "libsqlite3(|.0).dylib"
else:
  const
    Lib = "libsqlite3.so(|.0)"

template check*(db: DBconn, code: expr) =
  {.line.}:
    var res = code
    if res != SQLITE_OK and res != SQLITE_ROW and res != SQLITE_DONE: dbError(db)
    
type Backup = object
type PBackup = ptr Backup


proc sqlite3_backup_init*(dest: PSqlite3, destName: cstring, src: PSqlite3, srcName: cstring): PBackup 
  {.importc, dynlib: Lib.}
proc sqlite3_backup_step*(p: PBackup, npage: cint): cint {.importc, dynlib: Lib}
proc sqlite3_backup_finish*(p: PBackup): cint {.importc, dynlib: Lib.}

proc backup_init*(dest: PSqlite3, destName: cstring, src: PSqlite3, srcName: cstring): PBackup =
  result = sqlite3_backup_init(dest, destName, src, srcName)
  if result == nil: dbError(dest)

proc step*(p: PBackup, npage: cint): cint = sqlite3_backup_step(p, npage)
proc finish*(p: PBackup): cint = sqlite3_backup_finish(p)

proc load_db*(filename: string): PSqlite3 =
  var db: PSqlite3
  check(result): open(":memory:", result)
  check(db): open(filename, db)
  var backup = backup_init(result, "main", db, "main")
  check(result): backup.step(-1)
  check(result): backup.finish()
  discard sqlite3.close(db)

proc save_db*(db: PSqlite3, filename: string) =
  var dst: PSqlite3
  discard open(filename, dst)
  var backup = backup_init(dst, "main", db, "main")
  check(dst): backup.step(-1)
  check(dst): backup.finish()
  discard sqlite3.close(dst)