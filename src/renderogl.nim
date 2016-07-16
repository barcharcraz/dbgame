import opengl
import vecmath
import datatypes
import sqlite3
import datainterface

proc glsl(s: string): string = s

var vs = glsl"""
#version 440

struct mvp_t {
    mat4 proj;
    mat4 modelview;
};
uniform mvp_t mvp;
layout(location = 0) in vec3 vertex;
//layout(location = 1) in vec3 normal;
//layout(location = 2) in vec3 tangent;
//layout(location = 3) in vec3 bitangent;
//layout(location = 4) in vec3 texcoord;
void main(void) {
    gl_Position = mvp.proj * mvp.modelview * vec4(vertex, 1.0);
}
"""

var ps = glsl"""
#version 440
out vec4 color;
void main(void) {
    color = vec4(1.0, 0.0, 0.0, 1.0);
}
"""

var program: GLuint
var vbo: GLuint
var idxbuf: GLuint
var vao: GLuint
var view: Mat4f
var proj: Mat4f
proc init*() =
    var vsshader = glCreateShader(GL_VERTEX_SHADER)
    var psshader = glCreateShader(GL_FRAGMENT_SHADER)
    var vscstr = cstring(vs)
    var pscstr = cstring(ps)
    proj = vecmath.CreateOrthoMatrix(vec3f(-3, -3, -3), vec3f(3,3,3))
    view = vecmath.CreateViewMatrix(vec3f(3, 0, 0), vec3f(0,0,0))
    glShaderSource(vsshader, 1, cast[cstringarray](addr vscstr), nil)
    glShaderSource(psshader, 1, cast[cstringarray](addr pscstr), nil)
    glCompileShader(vsshader)
    glCompileShader(psshader)
    var success: GLint
    glGetShaderiv(vsshader, GL_COMPILE_STATUS, addr success)
    if success == GL_FALSE: raise newException(OSError, "Failed to Compile shader")
    glGetShaderiv(psshader, GL_COMPILE_STATUS, addr success)
    if success == GL_FALSE: raise newException(OSError, "Failed to Compile shader")
    program = glCreateProgram()
    glAttachShader(program, vsshader)
    glAttachShader(program, psshader)
    glLinkProgram(program)
    glGetProgramiv(program, GL_LINK_STATUS, addr success)
    if success == GL_FALSE: raise newException(OSError, "Failed to Link shader")
    glDetachShader(program, vsshader)
    glDetachShader(program, psshader)
    glDeleteShader(vsshader)
    glDeleteShader(psshader)
    glGenBuffers(1, addr vbo)
    glGenBuffers(1, addr idxbuf)
    glGenVertexArrays(1, addr vao)




proc render*(db: PSqlite3) =
  #var meshes = db.load(Mesh)
  glUseProgram(program)
  var projloc = glGetUniformLocation(program, "mvp.proj")
  var viewloc = glGetUniformLocation(program, "mvp.modelview")
  glUniformMatrix4fv(projloc, 1, false, addr proj.data[0])
  glUniformMatrix4fv(viewloc, 1, false, addr view.data[0])
  glBindVertexArray(vao)
  glEnableVertexAttribArray(0)
  glBindBuffer(GL_ARRAY_BUFFER, vao)

  glVertexAttribPointer(0, 3, cGL_FLOAT.GLenum, false, 0, nil)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, idxbuf)
  for m in db.load(Mesh, "mesh_data"):
    var mesh = m
    glBufferData(GL_ARRAY_BUFFER, mesh.vertices.len * sizeof(Vec3f), addr mesh.vertices[0], GL_STATIC_DRAW)
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, mesh.indices.len * sizeof(int32), addr mesh.indices[0], GL_STATIC_DRAW)
    glDrawElements(GL_TRIANGLES, mesh.indices.len.GLsizei, GL_UNSIGNED_INT, nil)



when isMainModule:
  import os
  import sqlite3_utils
  import glfw
  import db_sqlite
  import times
  var db: PSqlite3

  check(db): open(paramStr(1), db)
  db.exec(sql"PRAGMA synchronous = OFF")
  db.exec(sql"PRAGMA cache_size = -50000")
  glfw.init()
  var win = newGlWin(version = glv44)
  glfw.makeContextCurrent(win)
  loadExtensions()
  init()
  echo vbo
  echo vao
  echo idxbuf
  var t: float
  var cnt = 0
  var avg: float
  while not win.shouldClose:
    inc(cnt)
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    t = cpuTime()
    db.exec(sql"BEGIN TRANSACTION")
    db.render()
    db.exec(sql"END TRANSACTION")
    avg += cpuTime() - t
    if cnt mod 1000 == 0:
      echo("Frame time: ", avg)
      avg = 0
    win.update()
  win.destroy()
  glfw.terminate()
