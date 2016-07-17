## #
## #* 2006 June 7
## #*
## #* The author disclaims copyright to this source code.  In place of
## #* a legal notice, here is a blessing:
## #*
## #*    May you do good and not evil.
## #*    May you find forgiveness for yourself and forgive others.
## #*    May you share freely, never taking more than you give.
## #*
## #************************************************************************
## #* This header file defines the SQLite interface for use by
## #* shared libraries that want to be imported as extensions into
## #* an SQLite instance.  Shared libraries that intend to be loaded
## #* as extensions by SQLite should #include this file instead of 
## #* sqlite3.h.
## #

import
  sqlite3

export sqlite3.Pvalue, sqlite3.SQLITE_UTF8, sqlite3.SQLITE_OK, sqlite3.PSqlite3
## #
## #* The following structure holds pointers to all of the SQLite API
## #* routines.
## #*
## #* WARNING:  In order to maintain backwards compatibility, add new
## #* interfaces to the end of this structure only.  If you insert new
## #* interfaces in the middle of this structure, then older different
## #* versions of SQLite will not be able to load each other's shared
## #* libraries!
## #
type Backup = object
type PBackup = ptr Backup
type Vfs = object
type PVfs = ptr Vfs
type Module {.pure, final.} = object
type PModule* = ptr Module
type Mutex {.pure, final.} = object
type PMutex* = ptr Mutex
type sqlite_int64 = int64
type sqlite3_int64 = int64
type sqlite_uint64 = uint64
type sqlite3_blob = pointer
type sqlite3_uint64 = uint64
type
  sqlite3_api_routines* = object
    aggregate_context*: proc (a2: PContext; nBytes: cint): pointer {.cdecl.}
    aggregate_count*: proc (a2: PContext): cint {.cdecl.}
    bind_blob*: proc (a2: Pstmt; a3: cint; a4: pointer; n: cint;
                    a6: proc (a2: pointer) {.cdecl.}): cint {.cdecl.}
    bind_double*: proc (a2: Pstmt; a3: cint; a4: cdouble): cint {.cdecl.}
    bind_int*: proc (a2: Pstmt; a3: cint; a4: cint): cint {.cdecl.}
    bind_int64*: proc (a2: Pstmt; a3: cint; a4: sqlite_int64): cint {.cdecl.}
    bind_null*: proc (a2: Pstmt; a3: cint): cint {.cdecl.}
    bind_parameter_count*: proc (a2: Pstmt): cint {.cdecl.}
    bind_parameter_index*: proc (a2: Pstmt; zName: cstring): cint {.cdecl.}
    bind_parameter_name*: proc (a2: Pstmt; a3: cint): cstring {.cdecl.}
    bind_text*: proc (a2: Pstmt; a3: cint; a4: cstring; n: cint;
                    a6: proc (a2: pointer) {.cdecl.}): cint {.cdecl.}
    bind_text16*: proc (a2: Pstmt; a3: cint; a4: pointer; a5: cint;
                      a6: proc (a2: pointer) {.cdecl.}): cint {.cdecl.}
    bind_value*: proc (a2: Pstmt; a3: cint; a4: PValue): cint {.cdecl.}
    busy_handler*: proc (a2: PSqlite3;
                       a3: proc (a2: pointer; a3: cint): cint {.cdecl.}; a4: pointer): cint {.
        cdecl.}
    busy_timeout*: proc (a2: PSqlite3; ms: cint): cint {.cdecl.}
    changes*: proc (a2: PSqlite3): cint {.cdecl.}
    close*: proc (a2: PSqlite3): cint {.cdecl.}
    collation_needed*: proc (a2: PSqlite3; a3: pointer; a4: proc (a2: pointer;
        a3: PSqlite3; eTextRep: cint; a5: cstring) {.cdecl.}): cint {.cdecl.}
    collation_needed16*: proc (a2: PSqlite3; a3: pointer; a4: proc (a2: pointer;
        a3: PSqlite3; eTextRep: cint; a5: pointer) {.cdecl.}): cint {.cdecl.}
    column_blob*: proc (a2: Pstmt; iCol: cint): pointer {.cdecl.}
    column_bytes*: proc (a2: Pstmt; iCol: cint): cint {.cdecl.}
    column_bytes16*: proc (a2: Pstmt; iCol: cint): cint {.cdecl.}
    column_count*: proc (pStmt: Pstmt): cint {.cdecl.}
    column_database_name*: proc (a2: Pstmt; a3: cint): cstring {.cdecl.}
    column_database_name16*: proc (a2: Pstmt; a3: cint): pointer {.cdecl.}
    column_decltype*: proc (a2: Pstmt; i: cint): cstring {.cdecl.}
    column_decltype16*: proc (a2: Pstmt; a3: cint): pointer {.cdecl.}
    column_double*: proc (a2: Pstmt; iCol: cint): cdouble {.cdecl.}
    column_int*: proc (a2: Pstmt; iCol: cint): cint {.cdecl.}
    column_int64*: proc (a2: Pstmt; iCol: cint): sqlite_int64 {.cdecl.}
    column_name*: proc (a2: Pstmt; a3: cint): cstring {.cdecl.}
    column_name16*: proc (a2: Pstmt; a3: cint): pointer {.cdecl.}
    column_origin_name*: proc (a2: Pstmt; a3: cint): cstring {.cdecl.}
    column_origin_name16*: proc (a2: Pstmt; a3: cint): pointer {.cdecl.}
    column_table_name*: proc (a2: Pstmt; a3: cint): cstring {.cdecl.}
    column_table_name16*: proc (a2: Pstmt; a3: cint): pointer {.cdecl.}
    column_text*: proc (a2: Pstmt; iCol: cint): ptr cuchar {.cdecl.}
    column_text16*: proc (a2: Pstmt; iCol: cint): pointer {.cdecl.}
    column_type*: proc (a2: Pstmt; iCol: cint): cint {.cdecl.}
    column_value*: proc (a2: Pstmt; iCol: cint): PValue {.cdecl.}
    commit_hook*: proc (a2: PSqlite3; a3: proc (a2: pointer): cint {.cdecl.};
                      a4: pointer): pointer {.cdecl.}
    complete*: proc (sql: cstring): cint {.cdecl.}
    complete16*: proc (sql: pointer): cint {.cdecl.}
    create_collation*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: pointer; a6: proc (
        a2: pointer; a3: cint; a4: pointer; a5: cint; a6: pointer): cint {.cdecl.}): cint {.
        cdecl.}
    create_collation16*: proc (a2: PSqlite3; a3: pointer; a4: cint; a5: pointer; a6: proc (
        a2: pointer; a3: cint; a4: pointer; a5: cint; a6: pointer): cint {.cdecl.}): cint {.
        cdecl.}
    create_function*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: cint; a6: pointer;
        xFunc: Create_function_func_func;
        xStep: Create_function_step_func;
                          xFinal: Create_function_final_func): cint {.
        cdecl.}
    create_function16*: proc (a2: PSqlite3; a3: pointer; a4: cint; a5: cint;
                            a6: pointer; xFunc: proc (a2: PContext;
        a3: cint; a4: ptr PValue) {.cdecl.}; xStep: proc (
        a2: PContext; a3: cint; a4: ptr PValue) {.cdecl.};
                            xFinal: proc (a2: PContext) {.cdecl.}): cint {.
        cdecl.}
    create_module*: proc (a2: PSqlite3; a3: cstring; a4: PModule;
                        a5: pointer): cint {.cdecl.}
    data_count*: proc (pStmt: Pstmt): cint {.cdecl.}
    db_handle*: proc (a2: Pstmt): PSqlite3 {.cdecl.}
    declare_vtab*: proc (a2: PSqlite3; a3: cstring): cint {.cdecl.}
    enable_shared_cache*: proc (a2: cint): cint {.cdecl.}
    errcode*: proc (db: PSqlite3): cint {.cdecl.}
    errmsg*: proc (a2: PSqlite3): cstring {.cdecl.}
    errmsg16*: proc (a2: PSqlite3): pointer {.cdecl.}
    exec*: proc (a2: PSqlite3; a3: cstring; a4: Callback; a5: pointer;
               a6: cstringArray): cint {.cdecl.}
    expired*: proc (a2: Pstmt): cint {.cdecl.}
    finalize*: proc (pStmt: Pstmt): cint {.cdecl.}
    free*: proc (a2: pointer) {.cdecl.}
    free_table*: proc (result: cstringArray) {.cdecl.}
    get_autocommit*: proc (a2: PSqlite3): cint {.cdecl.}
    get_auxdata*: proc (a2: PContext; a3: cint): pointer {.cdecl.}
    get_table*: proc (a2: PSqlite3; a3: cstring; a4: ptr cstringArray; a5: ptr cint;
                    a6: ptr cint; a7: cstringArray): cint {.cdecl.}
    global_recover*: proc (): cint {.cdecl.}
    interruptx*: proc (a2: PSqlite3) {.cdecl.}
    last_insert_rowid*: proc (a2: PSqlite3): sqlite_int64 {.cdecl.}
    libversion*: proc (): cstring {.cdecl.}
    libversion_number*: proc (): cint {.cdecl.}
    malloc*: proc (a2: cint): pointer {.cdecl.}
    mprintf*: proc (a2: cstring): cstring {.cdecl, varargs.}
    open*: proc (a2: cstring; a3: ptr PSqlite3): cint {.cdecl.}
    open16*: proc (a2: pointer; a3: ptr PSqlite3): cint {.cdecl.}
    prepare*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: ptr Pstmt;
                  a6: cstringArray): cint {.cdecl.}
    prepare16*: proc (a2: PSqlite3; a3: pointer; a4: cint; a5: ptr Pstmt;
                    a6: ptr pointer): cint {.cdecl.}
    profile*: proc (a2: PSqlite3; a3: proc (a2: pointer; a3: cstring; a4: sqlite_uint64) {.
        cdecl.}; a4: pointer): pointer {.cdecl.}
    progress_handler*: proc (a2: PSqlite3; a3: cint;
                           a4: proc (a2: pointer): cint {.cdecl.}; a5: pointer) {.cdecl.}
    realloc*: proc (a2: pointer; a3: cint): pointer {.cdecl.}
    reset*: proc (pStmt: Pstmt): cint {.cdecl.}
    result_blob*: proc (a2: PContext; a3: pointer; a4: cint;
                      a5: proc (a2: pointer) {.cdecl.}) {.cdecl.}
    result_double*: proc (a2: PContext; a3: cdouble) {.cdecl.}
    result_error*: proc (a2: PContext; a3: cstring; a4: cint) {.cdecl.}
    result_error16*: proc (a2: PContext; a3: pointer; a4: cint) {.cdecl.}
    result_int*: proc (a2: PContext; a3: cint) {.cdecl.}
    result_int64*: proc (a2: PContext; a3: sqlite_int64) {.cdecl.}
    result_null*: proc (a2: PContext) {.cdecl.}
    result_text*: proc (a2: PContext; a3: cstring; a4: cint;
                      a5: proc (a2: pointer) {.cdecl.}) {.cdecl.}
    result_text16*: proc (a2: PContext; a3: pointer; a4: cint;
                        a5: proc (a2: pointer) {.cdecl.}) {.cdecl.}
    result_text16be*: proc (a2: PContext; a3: pointer; a4: cint;
                          a5: proc (a2: pointer) {.cdecl.}) {.cdecl.}
    result_text16le*: proc (a2: PContext; a3: pointer; a4: cint;
                          a5: proc (a2: pointer) {.cdecl.}) {.cdecl.}
    result_value*: proc (a2: PContext; a3: PValue) {.cdecl.}
    rollback_hook*: proc (a2: PSqlite3; a3: proc (a2: pointer) {.cdecl.}; a4: pointer): pointer {.
        cdecl.}
    set_authorizer*: proc (a2: PSqlite3; a3: proc (a2: pointer; a3: cint; a4: cstring;
        a5: cstring; a6: cstring; a7: cstring): cint {.cdecl.}; a4: pointer): cint {.cdecl.}
    set_auxdata*: proc (a2: PContext; a3: cint; a4: pointer;
                      a5: proc (a2: pointer) {.cdecl.}) {.cdecl.}
    snprintf*: proc (a2: cint; a3: cstring; a4: cstring): cstring {.cdecl, varargs.}
    step*: proc (a2: Pstmt): cint {.cdecl.}
    table_column_metadata*: proc (a2: PSqlite3; a3: cstring; a4: cstring; a5: cstring;
                                a6: cstringArray; a7: cstringArray; a8: ptr cint;
                                a9: ptr cint; a10: ptr cint): cint {.cdecl.}
    thread_cleanup*: proc () {.cdecl.}
    total_changes*: proc (a2: PSqlite3): cint {.cdecl.}
    trace*: proc (a2: PSqlite3; xTrace: proc (a2: pointer; a3: cstring) {.cdecl.};
                a4: pointer): pointer {.cdecl.}
    transfer_bindings*: proc (a2: Pstmt; a3: Pstmt): cint {.cdecl.}
    update_hook*: proc (a2: PSqlite3; a3: proc (a2: pointer; a3: cint; a4: cstring;
        a5: cstring; a6: sqlite_int64) {.cdecl.}; a4: pointer): pointer {.cdecl.}
    user_data*: proc (a2: PContext): pointer {.cdecl.}
    value_blob*: proc (a2: PValue): pointer {.cdecl.}
    value_bytes*: proc (a2: PValue): cint {.cdecl.}
    value_bytes16*: proc (a2: PValue): cint {.cdecl.}
    value_double*: proc (a2: PValue): cdouble {.cdecl.}
    value_int*: proc (a2: PValue): cint {.cdecl.}
    value_int64*: proc (a2: PValue): sqlite_int64 {.cdecl.}
    value_numeric_type*: proc (a2: PValue): cint {.cdecl.}
    value_text*: proc (a2: PValue): ptr cuchar {.cdecl.}
    value_text16*: proc (a2: PValue): pointer {.cdecl.}
    value_text16be*: proc (a2: PValue): pointer {.cdecl.}
    value_text16le*: proc (a2: PValue): pointer {.cdecl.}
    value_type*: proc (a2: PValue): cint {.cdecl.}
    vmprintf*: proc (a2: cstring): cstring {.cdecl, varargs.} ## # Added ??? 
    overload_function*: proc (a2: PSqlite3; zFuncName: cstring; nArg: cint): cint {.
        cdecl.}               ## # Added by 3.3.13 
    prepare_v2*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: ptr Pstmt;
                     a6: cstringArray): cint {.cdecl.}
    prepare16_v2*: proc (a2: PSqlite3; a3: pointer; a4: cint;
                       a5: ptr Pstmt; a6: ptr pointer): cint {.cdecl.}
    clear_bindings*: proc (a2: Pstmt): cint {.cdecl.} ## # Added by 3.4.1 
    create_module_v2*: proc (a2: PSqlite3; a3: cstring; a4: PModule;
                           a5: pointer; xDestroy: proc (a2: pointer) {.cdecl.}): cint {.
        cdecl.}               ## # Added by 3.5.0 
    bind_zeroblob*: proc (a2: Pstmt; a3: cint; a4: cint): cint {.cdecl.}
    blob_bytes*: proc (a2: pointer): cint {.cdecl.}
    blob_close*: proc (a2: pointer): cint {.cdecl.}
    blob_open*: proc (a2: PSqlite3; a3: cstring; a4: cstring; a5: cstring;
                    a6: sqlite3_int64; a7: cint; a8: ptr pointer): cint {.cdecl.}
    blob_read*: proc (a2: pointer; a3: pointer; a4: cint; a5: cint): cint {.cdecl.}
    blob_write*: proc (a2: pointer; a3: pointer; a4: cint; a5: cint): cint {.cdecl.}
    create_collation_v2*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: pointer; a6: proc (
        a2: pointer; a3: cint; a4: pointer; a5: cint; a6: pointer): cint {.cdecl.};
                              a7: proc (a2: pointer) {.cdecl.}): cint {.cdecl.}
    file_control*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: pointer): cint {.cdecl.}
    memory_highwater*: proc (a2: cint): sqlite3_int64 {.cdecl.}
    memory_used*: proc (): sqlite3_int64 {.cdecl.}
    mutex_alloc*: proc (a2: cint): PMutex {.cdecl.}
    mutex_enter*: proc (a2: PMutex) {.cdecl.}
    mutex_free*: proc (a2: PMutex) {.cdecl.}
    mutex_leave*: proc (a2: PMutex) {.cdecl.}
    mutex_try*: proc (a2: PMutex): cint {.cdecl.}
    open_v2*: proc (a2: cstring; a3: ptr PSqlite3; a4: cint; a5: cstring): cint {.cdecl.}
    release_memory*: proc (a2: cint): cint {.cdecl.}
    result_error_nomem*: proc (a2: PContext) {.cdecl.}
    result_error_toobig*: proc (a2: PContext) {.cdecl.}
    sleep*: proc (a2: cint): cint {.cdecl.}
    soft_heap_limit*: proc (a2: cint) {.cdecl.}
    vfs_find*: proc (a2: cstring): PVfs {.cdecl.}
    vfs_register*: proc (a2: PVfs; a3: cint): cint {.cdecl.}
    vfs_unregister*: proc (a2: PVfs): cint {.cdecl.}
    xthreadsafe*: proc (): cint {.cdecl.}
    result_zeroblob*: proc (a2: PContext; a3: cint) {.cdecl.}
    result_error_code*: proc (a2: PContext; a3: cint) {.cdecl.}
    test_control*: proc (a2: cint): cint {.cdecl, varargs.}
    randomness*: proc (a2: cint; a3: pointer) {.cdecl.}
    context_db_handle*: proc (a2: PContext): PSqlite3 {.cdecl.}
    extended_result_codes*: proc (a2: PSqlite3; a3: cint): cint {.cdecl.}
    limit*: proc (a2: PSqlite3; a3: cint; a4: cint): cint {.cdecl.}
    next_stmt*: proc (a2: PSqlite3; a3: Pstmt): Pstmt {.cdecl.}
    sql*: proc (a2: Pstmt): cstring {.cdecl.}
    status*: proc (a2: cint; a3: ptr cint; a4: ptr cint; a5: cint): cint {.cdecl.}
    backup_finish*: proc (a2: PBackup): cint {.cdecl.}
    backup_init*: proc (a2: PSqlite3; a3: cstring; a4: PSqlite3; a5: cstring): PBackup {.
        cdecl.}
    backup_pagecount*: proc (a2: PBackup): cint {.cdecl.}
    backup_remaining*: proc (a2: PBackup): cint {.cdecl.}
    backup_step*: proc (a2: PBackup; a3: cint): cint {.cdecl.}
    compileoption_get*: proc (a2: cint): cstring {.cdecl.}
    compileoption_used*: proc (a2: cstring): cint {.cdecl.}
    create_function_v2*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: cint;
                             a6: pointer; xFunc: proc (a2: PContext;
        a3: cint; a4: ptr PValue) {.cdecl.}; xStep: proc (
        a2: PContext; a3: cint; a4: ptr PValue) {.cdecl.};
                             xFinal: proc (a2: PContext) {.cdecl.};
                             xDestroy: proc (a2: pointer) {.cdecl.}): cint {.cdecl.}
    db_config*: proc (a2: PSqlite3; a3: cint): cint {.cdecl, varargs.}
    db_mutex*: proc (a2: PSqlite3): PMutex {.cdecl.}
    db_status*: proc (a2: PSqlite3; a3: cint; a4: ptr cint; a5: ptr cint; a6: cint): cint {.
        cdecl.}
    extended_errcode*: proc (a2: PSqlite3): cint {.cdecl.}
    log*: proc (a2: cint; a3: cstring) {.cdecl, varargs.}
    soft_heap_limit64*: proc (a2: sqlite3_int64): sqlite3_int64 {.cdecl.}
    sourceid*: proc (): cstring {.cdecl.}
    stmt_status*: proc (a2: Pstmt; a3: cint; a4: cint): cint {.cdecl.}
    strnicmp*: proc (a2: cstring; a3: cstring; a4: cint): cint {.cdecl.}
    unlock_notify*: proc (a2: PSqlite3;
                        a3: proc (a2: ptr pointer; a3: cint) {.cdecl.}; a4: pointer): cint {.
        cdecl.}
    wal_autocheckpoint*: proc (a2: PSqlite3; a3: cint): cint {.cdecl.}
    wal_checkpoint*: proc (a2: PSqlite3; a3: cstring): cint {.cdecl.}
    wal_hook*: proc (a2: PSqlite3; a3: proc (a2: pointer; a3: PSqlite3; a4: cstring;
        a5: cint): cint {.cdecl.}; a4: pointer): pointer {.cdecl.}
    blob_reopen*: proc (a2: pointer; a3: sqlite3_int64): cint {.cdecl.}
    vtab_config*: proc (a2: PSqlite3; op: cint): cint {.cdecl, varargs.}
    vtab_on_conflict*: proc (a2: PSqlite3): cint {.cdecl.} ## # Version 3.7.16 and later 
    close_v2*: proc (a2: PSqlite3): cint {.cdecl.}
    db_filename*: proc (a2: PSqlite3; a3: cstring): cstring {.cdecl.}
    db_readonly*: proc (a2: PSqlite3; a3: cstring): cint {.cdecl.}
    db_release_memory*: proc (a2: PSqlite3): cint {.cdecl.}
    errstr*: proc (a2: cint): cstring {.cdecl.}
    stmt_busy*: proc (a2: Pstmt): cint {.cdecl.}
    stmt_readonly*: proc (a2: Pstmt): cint {.cdecl.}
    stricmp*: proc (a2: cstring; a3: cstring): cint {.cdecl.}
    uri_boolean*: proc (a2: cstring; a3: cstring; a4: cint): cint {.cdecl.}
    uri_int64*: proc (a2: cstring; a3: cstring; a4: sqlite3_int64): sqlite3_int64 {.cdecl.}
    uri_parameter*: proc (a2: cstring; a3: cstring): cstring {.cdecl.}
    vsnprintf*: proc (a2: cint; a3: cstring; a4: cstring): cstring {.cdecl, varargs.}
    wal_checkpoint_v2*: proc (a2: PSqlite3; a3: cstring; a4: cint; a5: ptr cint;
                            a6: ptr cint): cint {.cdecl.} ## # Version 3.8.7 and later 
    auto_extension*: proc (a2: proc () {.cdecl.}): cint {.cdecl.}
    bind_blob64*: proc (a2: Pstmt; a3: cint; a4: pointer; a5: sqlite3_uint64;
                      a6: proc (a2: pointer) {.cdecl.}): cint {.cdecl.}
    bind_text64*: proc (a2: Pstmt; a3: cint; a4: cstring; a5: sqlite3_uint64;
                      a6: proc (a2: pointer) {.cdecl.}; a7: cuchar): cint {.cdecl.}
    cancel_auto_extension*: proc (a2: proc () {.cdecl.}): cint {.cdecl.}
    load_extension*: proc (a2: PSqlite3; a3: cstring; a4: cstring; a5: cstringArray): cint {.
        cdecl.}
    malloc64*: proc (a2: sqlite3_uint64): pointer {.cdecl.}
    msize*: proc (a2: pointer): sqlite3_uint64 {.cdecl.}
    realloc64*: proc (a2: pointer; a3: sqlite3_uint64): pointer {.cdecl.}
    reset_auto_extension*: proc () {.cdecl.}
    result_blob64*: proc (a2: PContext; a3: pointer; a4: sqlite3_uint64;
                        a5: proc (a2: pointer) {.cdecl.}) {.cdecl.}
    result_text64*: proc (a2: PContext; a3: cstring; a4: sqlite3_uint64;
                        a5: proc (a2: pointer) {.cdecl.}; a6: cuchar) {.cdecl.}
    strglob*: proc (a2: cstring; a3: cstring): cint {.cdecl.} ## # Version 3.8.11 and later 
    value_dup*: proc (a2: PValue): PValue {.cdecl.}
    value_free*: proc (a2: PValue) {.cdecl.}
    result_zeroblob64*: proc (a2: PContext; a3: sqlite3_uint64): cint {.cdecl.}
    bind_zeroblob64*: proc (a2: Pstmt; a3: cint; a4: sqlite3_uint64): cint {.
        cdecl.}               ## # Version 3.9.0 and later 
    value_subtype*: proc (a2: PValue): cuint {.cdecl.}
    result_subtype*: proc (a2: PContext; a3: cuint) {.cdecl.} ## # Version 3.10.0 and later 
    status64*: proc (a2: cint; a3: ptr int64; a4: ptr int64; a5: cint): cint {.
        cdecl.}
    strlike*: proc (a2: cstring; a3: cstring; a4: cuint): cint {.cdecl.}
    db_cacheflush*: proc (a2: PSqlite3): cint {.cdecl.} ## # Version 3.12.0 and later 
    system_errno*: proc (a2: PSqlite3): cint {.cdecl.}


## #
## #* The following macros redefine the API routines so that they are
## #* redirected through the global sqlite3_api structure.
## #*
## #* This header file is also used by the loadext.c source file
## #* (part of the main SQLite library - not an extension) so that
## #* it can get access to the sqlite3_api_routines structure
## #* definition.  But the main library does not want to redefine
## #* the API.  So the redefinition macros are only valid if the
## #* SQLITE_CORE macros is undefined.
## #

when not defined(SQLITE_CORE) and not defined(SQLITE_OMIT_LOAD_EXTENSION):    
    template aggregate_context_tmpl*{aggregate_context(x)}(x: varargs[untyped]): untyped = sqlite3_api.aggregate_context(x)
    when not defined(SQLITE_OMIT_DEPRECATED):
    
      template aggregate_count_tmpl*{aggregate_count(x)}(x: varargs[untyped]): untyped = sqlite3_api.aggregate_count(x)
  
    template bind_blob_tmpl*{bind_blob(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_blob(x)
    template bind_double_tmpl*{bind_double(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_double(x)
    template bind_int_tmpl*{bind_int(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_int(x)
    template bind_int64_tmpl*{bind_int64(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_int64(x)
    template bind_null_tmpl*{bind_null(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_null(x)
    template bind_parameter_count_tmpl*{bind_parameter_count(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_parameter_count(x)
    template bind_parameter_index_tmpl*{bind_parameter_index(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_parameter_index(x)
    template bind_parameter_name_tmpl*{bind_parameter_name(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_parameter_name(x)
    template bind_text_tmpl*{bind_text(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_text(x)
    template bind_text16_tmpl*{bind_text16(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_text16(x)
    template bind_value_tmpl*{bind_value(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_value(x)
    template busy_handler_tmpl*{busy_handler(x)}(x: varargs[untyped]): untyped = sqlite3_api.busy_handler(x)
    template busy_timeout_tmpl*{busy_timeout(x)}(x: varargs[untyped]): untyped = sqlite3_api.busy_timeout(x)
    template changes_tmpl*{changes(x)}(x: varargs[untyped]): untyped = sqlite3_api.changes(x)
    template close_tmpl*{close(x)}(x: varargs[untyped]): untyped = sqlite3_api.close(x)
    template collation_needed_tmpl*{collation_needed(x)}(x: varargs[untyped]): untyped = sqlite3_api.collation_needed(x)
    template collation_needed16_tmpl*{collation_needed16(x)}(x: varargs[untyped]): untyped = sqlite3_api.collation_needed16(x)
    template column_blob_tmpl*{column_blob(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_blob(x)
    template column_bytes_tmpl*{column_bytes(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_bytes(x)
    template column_bytes16_tmpl*{column_bytes16(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_bytes16(x)
    template column_count_tmpl*{column_count(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_count(x)
    template column_database_name_tmpl*{column_database_name(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_database_name(x)
    template column_database_name16_tmpl*{column_database_name16(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_database_name16(x)
    template column_decltype_tmpl*{column_decltype(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_decltype(x)
    template column_decltype16_tmpl*{column_decltype16(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_decltype16(x)
    template column_double_tmpl*{column_double(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_double(x)
    template column_int_tmpl*{column_int(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_int(x)
    template column_int64_tmpl*{column_int64(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_int64(x)
    template column_name_tmpl*{column_name(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_name(x)
    template column_name16_tmpl*{column_name16(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_name16(x)
    template column_origin_name_tmpl*{column_origin_name(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_origin_name(x)
    template column_origin_name16_tmpl*{column_origin_name16(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_origin_name16(x)
    template column_table_name_tmpl*{column_table_name(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_table_name(x)
    template column_table_name16_tmpl*{column_table_name16(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_table_name16(x)
    template column_text_tmpl*{column_text(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_text(x)
    template column_text16_tmpl*{column_text16(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_text16(x)
    template column_type_tmpl*{column_type(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_type(x)
    template column_value_tmpl*{column_value(x)}(x: varargs[untyped]): untyped = sqlite3_api.column_value(x)
    template commit_hook_tmpl*{commit_hook(x)}(x: varargs[untyped]): untyped = sqlite3_api.commit_hook(x)
    template compe_tmpl*{compe(x)}(x: varargs[untyped]): untyped = sqlite3_api.compe(x)
    template compe16_tmpl*{compe16(x)}(x: varargs[untyped]): untyped = sqlite3_api.compe16(x)
    template create_collation_tmpl*{create_collation(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_collation(x)
    template create_collation16_tmpl*{create_collation16(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_collation16(x)
    template create_function_tmpl*{create_function(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_function(x)
    template create_function16_tmpl*{create_function16(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_function16(x)
    template create_module_tmpl*{create_module(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_module(x)
    template create_module_v2_tmpl*{create_module_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_module_v2(x)
    template data_count_tmpl*{data_count(x)}(x: varargs[untyped]): untyped = sqlite3_api.data_count(x)
    template db_handle_tmpl*{db_handle(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_handle(x)
    template declare_vtab_tmpl*{declare_vtab(x)}(x: varargs[untyped]): untyped = sqlite3_api.declare_vtab(x)
    template enable_shared_cache_tmpl*{enable_shared_cache(x)}(x: varargs[untyped]): untyped = sqlite3_api.enable_shared_cache(x)
    template errcode_tmpl*{errcode(x)}(x: varargs[untyped]): untyped = sqlite3_api.errcode(x)
    template errmsg_tmpl*{errmsg(x)}(x: varargs[untyped]): untyped = sqlite3_api.errmsg(x)
    template errmsg16_tmpl*{errmsg16(x)}(x: varargs[untyped]): untyped = sqlite3_api.errmsg16(x)
    template exec_tmpl*{exec(x)}(x: varargs[untyped]): untyped = sqlite3_api.exec(x)
    when not defined(SQLITE_OMIT_DEPRECATED):
    
      template expired_tmpl*{expired(x)}(x: varargs[untyped]): untyped = sqlite3_api.expired(x)
  
    template finalize_tmpl*{finalize(x)}(x: varargs[untyped]): untyped = sqlite3_api.finalize(x)
    template free_tmpl*{free(x)}(x: varargs[untyped]): untyped = sqlite3_api.free(x)
    template free_table_tmpl*{free_table(x)}(x: varargs[untyped]): untyped = sqlite3_api.free_table(x)
    template get_autocommit_tmpl*{get_autocommit(x)}(x: varargs[untyped]): untyped = sqlite3_api.get_autocommit(x)
    template get_auxdata_tmpl*{get_auxdata(x)}(x: varargs[untyped]): untyped = sqlite3_api.get_auxdata(x)
    template get_table_tmpl*{get_table(x)}(x: varargs[untyped]): untyped = sqlite3_api.get_table(x)
    when not defined(SQLITE_OMIT_DEPRECATED):
    
      template global_recover_tmpl*{global_recover(x)}(x: varargs[untyped]): untyped = sqlite3_api.global_recover(x)
  
    template interrupt_tmpl*{interrupt(x)}(x: varargs[untyped]): untyped = sqlite3_api.interrupt(x)
    template last_insert_rowid_tmpl*{last_insert_rowid(x)}(x: varargs[untyped]): untyped = sqlite3_api.last_insert_rowid(x)
    template libversion_tmpl*{libversion(x)}(x: varargs[untyped]): untyped = sqlite3_api.libversion(x)
    template libversion_number_tmpl*{libversion_number(x)}(x: varargs[untyped]): untyped = sqlite3_api.libversion_number(x)
    template malloc_tmpl*{malloc(x)}(x: varargs[untyped]): untyped = sqlite3_api.malloc(x)
    template mprintf_tmpl*{mprintf(x)}(x: varargs[untyped]): untyped = sqlite3_api.mprintf(x)
    template open_tmpl*{open(x)}(x: varargs[untyped]): untyped = sqlite3_api.open(x)
    template open16_tmpl*{open16(x)}(x: varargs[untyped]): untyped = sqlite3_api.open16(x)
    template prepare_tmpl*{prepare(x)}(x: varargs[untyped]): untyped = sqlite3_api.prepare(x)
    template prepare16_tmpl*{prepare16(x)}(x: varargs[untyped]): untyped = sqlite3_api.prepare16(x)
    template prepare_v2_tmpl*{prepare_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.prepare_v2(x)
    template prepare16_v2_tmpl*{prepare16_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.prepare16_v2(x)
    template profile_tmpl*{profile(x)}(x: varargs[untyped]): untyped = sqlite3_api.profile(x)
    template progress_handler_tmpl*{progress_handler(x)}(x: varargs[untyped]): untyped = sqlite3_api.progress_handler(x)
    template realloc_tmpl*{realloc(x)}(x: varargs[untyped]): untyped = sqlite3_api.realloc(x)
    template reset_tmpl*{reset(x)}(x: varargs[untyped]): untyped = sqlite3_api.reset(x)
    template result_blob_tmpl*{result_blob(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_blob(x)
    template result_double_tmpl*{result_double(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_double(x)
    template result_error_tmpl*{result_error(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_error(x)
    template result_error16_tmpl*{result_error16(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_error16(x)
    template result_int_tmpl*{result_int(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_int(x)
    template result_int64_tmpl*{result_int64(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_int64(x)
    template result_null_tmpl*{result_null(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_null(x)
    template result_text_tmpl*{result_text(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_text(x)
    template result_text16_tmpl*{result_text16(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_text16(x)
    template result_text16be_tmpl*{result_text16be(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_text16be(x)
    template result_text16le_tmpl*{result_text16le(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_text16le(x)
    template result_value_tmpl*{result_value(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_value(x)
    template rollback_hook_tmpl*{rollback_hook(x)}(x: varargs[untyped]): untyped = sqlite3_api.rollback_hook(x)
    template set_authorizer_tmpl*{set_authorizer(x)}(x: varargs[untyped]): untyped = sqlite3_api.set_authorizer(x)
    template set_auxdata_tmpl*{set_auxdata(x)}(x: varargs[untyped]): untyped = sqlite3_api.set_auxdata(x)
    template snprintf_tmpl*{snprintf(x)}(x: varargs[untyped]): untyped = sqlite3_api.snprintf(x)
    template step_tmpl*{step(x)}(x: varargs[untyped]): untyped = sqlite3_api.step(x)
    template table_column_metadata_tmpl*{table_column_metadata(x)}(x: varargs[untyped]): untyped = sqlite3_api.table_column_metadata(x)
    template thread_cleanup_tmpl*{thread_cleanup(x)}(x: varargs[untyped]): untyped = sqlite3_api.thread_cleanup(x)
    template total_changes_tmpl*{total_changes(x)}(x: varargs[untyped]): untyped = sqlite3_api.total_changes(x)
    template trace_tmpl*{trace(x)}(x: varargs[untyped]): untyped = sqlite3_api.trace(x)
    when not defined(SQLITE_OMIT_DEPRECATED):
      
      template transfer_bindings_tmpl*{transfer_bindings(x)}(x: varargs[untyped]): untyped = sqlite3_api.transfer_bindings(x)
    
    template update_hook_tmpl*{update_hook(x)}(x: varargs[untyped]): untyped = sqlite3_api.update_hook(x)
    template user_data_tmpl*{user_data(x)}(x: varargs[untyped]): untyped = sqlite3_api.user_data(x)
    template value_blob_tmpl*{value_blob(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_blob(x)
    template value_bytes_tmpl*{value_bytes(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_bytes(x)
    template value_bytes16_tmpl*{value_bytes16(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_bytes16(x)
    template value_double_tmpl*{value_double(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_double(x)
    template value_int_tmpl*{value_int(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_int(x)
    template value_int64_tmpl*{value_int64(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_int64(x)
    template value_numeric_type_tmpl*{value_numeric_type(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_numeric_type(x)
    template value_text_tmpl*{value_text(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_text(x)
    template value_text16_tmpl*{value_text16(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_text16(x)
    template value_text16be_tmpl*{value_text16be(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_text16be(x)
    template value_text16le_tmpl*{value_text16le(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_text16le(x)
    template value_type_tmpl*{value_type(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_type(x)
    template vmprintf_tmpl*{vmprintf(x)}(x: varargs[untyped]): untyped = sqlite3_api.vmprintf(x)
    template vsnprintf_tmpl*{vsnprintf(x)}(x: varargs[untyped]): untyped = sqlite3_api.vsnprintf(x)
    template overload_function_tmpl*{overload_function(x)}(x: varargs[untyped]): untyped = sqlite3_api.overload_function(x)
    template prepare_v2_tmpl*{prepare_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.prepare_v2(x)
    template prepare16_v2_tmpl*{prepare16_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.prepare16_v2(x)
    template clear_bindings_tmpl*{clear_bindings(x)}(x: varargs[untyped]): untyped = sqlite3_api.clear_bindings(x)
    template bind_zeroblob_tmpl*{bind_zeroblob(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_zeroblob(x)
    template blob_bytes_tmpl*{blob_bytes(x)}(x: varargs[untyped]): untyped = sqlite3_api.blob_bytes(x)
    template blob_close_tmpl*{blob_close(x)}(x: varargs[untyped]): untyped = sqlite3_api.blob_close(x)
    template blob_open_tmpl*{blob_open(x)}(x: varargs[untyped]): untyped = sqlite3_api.blob_open(x)
    template blob_read_tmpl*{blob_read(x)}(x: varargs[untyped]): untyped = sqlite3_api.blob_read(x)
    template blob_write_tmpl*{blob_write(x)}(x: varargs[untyped]): untyped = sqlite3_api.blob_write(x)
    template create_collation_v2_tmpl*{create_collation_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_collation_v2(x)
    template file_control_tmpl*{file_control(x)}(x: varargs[untyped]): untyped = sqlite3_api.file_control(x)
    template memory_highwater_tmpl*{memory_highwater(x)}(x: varargs[untyped]): untyped = sqlite3_api.memory_highwater(x)
    template memory_used_tmpl*{memory_used(x)}(x: varargs[untyped]): untyped = sqlite3_api.memory_used(x)
    template mutex_alloc_tmpl*{mutex_alloc(x)}(x: varargs[untyped]): untyped = sqlite3_api.mutex_alloc(x)
    template mutex_enter_tmpl*{mutex_enter(x)}(x: varargs[untyped]): untyped = sqlite3_api.mutex_enter(x)
    template mutex_free_tmpl*{mutex_free(x)}(x: varargs[untyped]): untyped = sqlite3_api.mutex_free(x)
    template mutex_leave_tmpl*{mutex_leave(x)}(x: varargs[untyped]): untyped = sqlite3_api.mutex_leave(x)
    template mutex_try_tmpl*{mutex_try(x)}(x: varargs[untyped]): untyped = sqlite3_api.mutex_try(x)
    template open_v2_tmpl*{open_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.open_v2(x)
    template release_memory_tmpl*{release_memory(x)}(x: varargs[untyped]): untyped = sqlite3_api.release_memory(x)
    template result_error_nomem_tmpl*{result_error_nomem(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_error_nomem(x)
    template result_error_toobig_tmpl*{result_error_toobig(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_error_toobig(x)
    template sleep_tmpl*{sleep(x)}(x: varargs[untyped]): untyped = sqlite3_api.sleep(x)
    template soft_heap_limit_tmpl*{soft_heap_limit(x)}(x: varargs[untyped]): untyped = sqlite3_api.soft_heap_limit(x)
    template vfs_find_tmpl*{vfs_find(x)}(x: varargs[untyped]): untyped = sqlite3_api.vfs_find(x)
    template vfs_register_tmpl*{vfs_register(x)}(x: varargs[untyped]): untyped = sqlite3_api.vfs_register(x)
    template vfs_unregister_tmpl*{vfs_unregister(x)}(x: varargs[untyped]): untyped = sqlite3_api.vfs_unregister(x)
    template threadsafe_tmpl*{threadsafe(x)}(x: varargs[untyped]): untyped = sqlite3_api.threadsafe(x)
    template result_zeroblob_tmpl*{result_zeroblob(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_zeroblob(x)
    template result_error_code_tmpl*{result_error_code(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_error_code(x)
    template test_control_tmpl*{test_control(x)}(x: varargs[untyped]): untyped = sqlite3_api.test_control(x)
    template randomness_tmpl*{randomness(x)}(x: varargs[untyped]): untyped = sqlite3_api.randomness(x)
    template context_db_handle_tmpl*{context_db_handle(x)}(x: varargs[untyped]): untyped = sqlite3_api.context_db_handle(x)
    template extended_result_codes_tmpl*{extended_result_codes(x)}(x: varargs[untyped]): untyped = sqlite3_api.extended_result_codes(x)
    template limit_tmpl*{limit(x)}(x: varargs[untyped]): untyped = sqlite3_api.limit(x)
    template next_stmt_tmpl*{next_stmt(x)}(x: varargs[untyped]): untyped = sqlite3_api.next_stmt(x)
    template sql_tmpl*{sql(x)}(x: varargs[untyped]): untyped = sqlite3_api.sql(x)
    template status_tmpl*{status(x)}(x: varargs[untyped]): untyped = sqlite3_api.status(x)
    template backup_finish_tmpl*{backup_finish(x)}(x: varargs[untyped]): untyped = sqlite3_api.backup_finish(x)
    template backup_init_tmpl*{backup_init(x)}(x: varargs[untyped]): untyped = sqlite3_api.backup_init(x)
    template backup_pagecount_tmpl*{backup_pagecount(x)}(x: varargs[untyped]): untyped = sqlite3_api.backup_pagecount(x)
    template backup_remaining_tmpl*{backup_remaining(x)}(x: varargs[untyped]): untyped = sqlite3_api.backup_remaining(x)
    template backup_step_tmpl*{backup_step(x)}(x: varargs[untyped]): untyped = sqlite3_api.backup_step(x)
    template compileoption_get_tmpl*{compileoption_get(x)}(x: varargs[untyped]): untyped = sqlite3_api.compileoption_get(x)
    template compileoption_used_tmpl*{compileoption_used(x)}(x: varargs[untyped]): untyped = sqlite3_api.compileoption_used(x)
    template create_function_v2_tmpl*{create_function_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.create_function_v2(x)
    template db_config_tmpl*{db_config(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_config(x)
    template db_mutex_tmpl*{db_mutex(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_mutex(x)
    template db_status_tmpl*{db_status(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_status(x)
    template extended_errcode_tmpl*{extended_errcode(x)}(x: varargs[untyped]): untyped = sqlite3_api.extended_errcode(x)
    template log_tmpl*{log(x)}(x: varargs[untyped]): untyped = sqlite3_api.log(x)
    template soft_heap_limit64_tmpl*{soft_heap_limit64(x)}(x: varargs[untyped]): untyped = sqlite3_api.soft_heap_limit64(x)
    template sourceid_tmpl*{sourceid(x)}(x: varargs[untyped]): untyped = sqlite3_api.sourceid(x)
    template stmt_status_tmpl*{stmt_status(x)}(x: varargs[untyped]): untyped = sqlite3_api.stmt_status(x)
    template strnicmp_tmpl*{strnicmp(x)}(x: varargs[untyped]): untyped = sqlite3_api.strnicmp(x)
    template unlock_notify_tmpl*{unlock_notify(x)}(x: varargs[untyped]): untyped = sqlite3_api.unlock_notify(x)
    template wal_autocheckpoint_tmpl*{wal_autocheckpoint(x)}(x: varargs[untyped]): untyped = sqlite3_api.wal_autocheckpoint(x)
    template wal_checkpoint_tmpl*{wal_checkpoint(x)}(x: varargs[untyped]): untyped = sqlite3_api.wal_checkpoint(x)
    template wal_hook_tmpl*{wal_hook(x)}(x: varargs[untyped]): untyped = sqlite3_api.wal_hook(x)
    template blob_reopen_tmpl*{blob_reopen(x)}(x: varargs[untyped]): untyped = sqlite3_api.blob_reopen(x)
    template vtab_config_tmpl*{vtab_config(x)}(x: varargs[untyped]): untyped = sqlite3_api.vtab_config(x)
    template vtab_on_conflict_tmpl*{vtab_on_conflict(x)}(x: varargs[untyped]): untyped = sqlite3_api.vtab_on_conflict(x)
    ## # Version 3.7.16 and later 
  
    template close_v2_tmpl*{close_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.close_v2(x)
    template db_filename_tmpl*{db_filename(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_filename(x)
    template db_readonly_tmpl*{db_readonly(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_readonly(x)
    template db_release_memory_tmpl*{db_release_memory(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_release_memory(x)
    template errstr_tmpl*{errstr(x)}(x: varargs[untyped]): untyped = sqlite3_api.errstr(x)
    template stmt_busy_tmpl*{stmt_busy(x)}(x: varargs[untyped]): untyped = sqlite3_api.stmt_busy(x)
    template stmt_readonly_tmpl*{stmt_readonly(x)}(x: varargs[untyped]): untyped = sqlite3_api.stmt_readonly(x)
    template stricmp_tmpl*{stricmp(x)}(x: varargs[untyped]): untyped = sqlite3_api.stricmp(x)
    template uri_boolean_tmpl*{uri_boolean(x)}(x: varargs[untyped]): untyped = sqlite3_api.uri_boolean(x)
    template uri_int64_tmpl*{uri_int64(x)}(x: varargs[untyped]): untyped = sqlite3_api.uri_int64(x)
    template uri_parameter_tmpl*{uri_parameter(x)}(x: varargs[untyped]): untyped = sqlite3_api.uri_parameter(x)
    template uri_vsnprintf_tmpl*{uri_vsnprintf(x)}(x: varargs[untyped]): untyped = sqlite3_api.uri_vsnprintf(x)
    template wal_checkpoint_v2_tmpl*{wal_checkpoint_v2(x)}(x: varargs[untyped]): untyped = sqlite3_api.wal_checkpoint_v2(x)
    ## # Version 3.8.7 and later 
  
    template auto_extension_tmpl*{auto_extension(x)}(x: varargs[untyped]): untyped = sqlite3_api.auto_extension(x)
    template bind_blob64_tmpl*{bind_blob64(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_blob64(x)
    template bind_text64_tmpl*{bind_text64(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_text64(x)
    template cancel_auto_extension_tmpl*{cancel_auto_extension(x)}(x: varargs[untyped]): untyped = sqlite3_api.cancel_auto_extension(x)
    template load_extension_tmpl*{load_extension(x)}(x: varargs[untyped]): untyped = sqlite3_api.load_extension(x)
    template malloc64_tmpl*{malloc64(x)}(x: varargs[untyped]): untyped = sqlite3_api.malloc64(x)
    template msize_tmpl*{msize(x)}(x: varargs[untyped]): untyped = sqlite3_api.msize(x)
    template realloc64_tmpl*{realloc64(x)}(x: varargs[untyped]): untyped = sqlite3_api.realloc64(x)
    template reset_auto_extension_tmpl*{reset_auto_extension(x)}(x: varargs[untyped]): untyped = sqlite3_api.reset_auto_extension(x)
    template result_blob64_tmpl*{result_blob64(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_blob64(x)
    template result_text64_tmpl*{result_text64(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_text64(x)
    template strglob_tmpl*{strglob(x)}(x: varargs[untyped]): untyped = sqlite3_api.strglob(x)
    ## # Version 3.8.11 and later 
  
    template value_dup_tmpl*{value_dup(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_dup(x)
    template value_free_tmpl*{value_free(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_free(x)
    template result_zeroblob64_tmpl*{result_zeroblob64(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_zeroblob64(x)
    template bind_zeroblob64_tmpl*{bind_zeroblob64(x)}(x: varargs[untyped]): untyped = sqlite3_api.bind_zeroblob64(x)
    ## # Version 3.9.0 and later 
  
    template value_subtype_tmpl*{value_subtype(x)}(x: varargs[untyped]): untyped = sqlite3_api.value_subtype(x)
    template result_subtype_tmpl*{result_subtype(x)}(x: varargs[untyped]): untyped = sqlite3_api.result_subtype(x)
    ## # Version 3.10.0 and later 
  
    template status64_tmpl*{status64(x)}(x: varargs[untyped]): untyped = sqlite3_api.status64(x)
    template strlike_tmpl*{strlike(x)}(x: varargs[untyped]): untyped = sqlite3_api.strlike(x)
    template db_cacheflush_tmpl*{db_cacheflush(x)}(x: varargs[untyped]): untyped = sqlite3_api.db_cacheflush(x)
    ## # Version 3.12.0 and later 
  
    template system_errno_tmpl*{system_errno(x)}(x: varargs[untyped]): untyped = sqlite3_api.system_errno(x)

when appType == "lib" and not defined(SQLITE_CORE) and not defined(SQLITE_OMIT_LOAD_EXTENSION):
  ## # This case when the file really is being compiled as a loadable 
  ## #  * extension 
  template sqlite_extension_init1*(): expr =
    var sqlite3_api {.inject.}: ptr sqlite3_api_routines = nil
  template sqlite_extension_init2*(v: expr) =
    sqlite3_api = v
  template sqlite_extension_init3*(): expr =
    var sqlite3_api {.inject, importc.}: ptr sqlite3_api_routines
    
  ## ## define SQLITE_EXTENSION_INIT1     const sqlite3_api_routines *sqlite3_api=0;
  ## ## define SQLITE_EXTENSION_INIT2(v)  sqlite3_api=v;
  ## ## define SQLITE_EXTENSION_INIT3     extern const sqlite3_api_routines *sqlite3_api;
else:
  ## # This case when the file is being statically linked into the 
  ## #  * application 
  template sqlite_extension_init1*(): expr = discard
  template sqlite_extension_init2*(v: expr): expr = discard
  template sqlite_extension_init3*(): expr = discard
  ## ## define SQLITE_EXTENSION_INIT1     /*no-op*/
  ## ## define SQLITE_EXTENSION_INIT2(v)  (void)v; /* unused parameter */
  ## ## define SQLITE_EXTENSION_INIT3     /*no-op*/