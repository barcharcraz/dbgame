import imgui
import glfw
import opengl

var
  g_win: Win
  g_time: float
  g_mousepressed: array[3, bool]
  g_mousewheel: float32
  g_fonttex: GLuint
  g_prog: GLuint
  g_ps: GLuint
  g_vs: GLuint
  g_vbo: GLuint
  g_vao: GLuint
  g_elms: GLuint



proc ogl_imgui_renderDrawListsFn(data: ptr ImDrawData) {.cdecl.} =
  var io = igGetIO()
  var fb_width = int(io.DisplaySize.x * io.DisplayFramebufferScale.x)
  var fb_height = int(io.DisplaySize.y * io.DisplayFramebufferScale.y)
  if fb_width == 0 or fb_height == 0:
    return
  
  var last_blend_src, last_blend_dst: GLint
  var last_blend_equation_rgb, last_blend_equation_alpha: GLint
  

proc ogl_imgui_setClipboardTextFn(text: cstring) {.cdecl.} =
  g_win.clipboardStr = $text

proc ogl_imgui_getClipboardTextFn(): cstring {.cdecl.} =
  result = clipboardStr(g_win)

proc ogl_imgui_mouseBtnCb(o: Win,
  btn: MouseBtn,
  pressed: bool,
  modKeys: ModifierKeySet) =
  
  if pressed and ord(btn) < 3:
    g_mousepressed[ord(btn)] = true

proc ogl_imgui_scrollCb(o: Win, offset: tuple[x,y: float]) =
  g_mousewheel += float32(offset.y)

proc ogl_imgui_keyCb(o: Win, key: Key, scancode: int, action: KeyAction,
  modKeys: ModifierKeySet) =

  var io = igGetIO()
  if action == kaDown:
    io.KeysDown[ord(key)] = true
  if action == kaUp:
    io.KeysDown[ord(key)] = false

proc ogl_imgui_charCb(o: Win, codePoint: Rune) =
  var io = igGetIO()
  if ord(codePoint) > 0 and ord(codePoint) < 0x10000:
    ImGuiIO_AddInputCharacter(cushort(ord(codePoint)))

proc ogl_imgui_CreateFontsTexture() = 
  var io = igGetIO()
  var pixels: ptr cuchar
  var width, height: cint
  
  ImFontAtlas_GetTexDataAsRGBA32(io.Fonts, addr pixels, addr width, addr height, nil)

  glGenTextures(1, addr g_fonttex)
  glBindTexture(GL_TEXTURE_2D, g_fonttex)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, FL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels)
  ImFontAtlas_SetTexID(io.Fonts, cast[pointer](g_fonttex))
  glBindTexture(GL_TEXTURE_2D, 0)
  



proc ogl_imgui_init(win: Win): bool =
  var io = imgui.igGetIO()
  io.KeyMap[ImGuiKey_Tab] = ord(keyTab)
  io.KeyMap[ImGuiKey_LeftArrow] = ord(keyLeft)
  io.KeyMap[ImGuiKey_RightArrow] = ord(keyRight)
  io.KeyMap[ImGuiKey_UpArrow] = ord(keyUp)
  io.KeyMap[ImGuiKey_DownArrow] = ord(keyDown)
  io.KeyMap[ImGuiKey_PageUp] = ord(keyPageUp)
  io.KeyMap[ImGuiKey_PageDown] = ord(keyPageDown)
  io.KeyMap[ImGuiKey_Home] = ord(keyHome)
  io.KeyMap[ImGuiKey_End] = ord(keyEnd)
  io.KeyMap[ImGuiKey_Delete] = ord(keyDelete)
  io.KeyMap[ImGuiKey_Backspace] = ord(keyBackspace)
  io.KeyMap[ImGuiKey_Enter] = ord(keyEnter)
  io.KeyMap[ImGuiKey_Escape] = ord(keyEscape)
  io.KeyMap[ImGuiKey_A] = ord(keyA)
  io.KeyMap[ImGuiKey_C] = ord(keyC)
  io.KeyMap[ImGuiKey_V] = ord(keyV)
  io.KeyMap[ImGuiKey_X] = ord(keyX)
  io.KeyMap[ImGuiKey_Y] = ord(keyY)
  io.KeyMap[ImGuiKey_Z] = ord(keyZ)
  io.RenderDrawListsFn = ogl_imgui_renderDrawListsFn

  win.mouseBtnCb = ogl_imgui_mouseBtnCb
  win.scrollCb = ogl_imgui_scrollCb
  win.keyCb = ogl_imgui_keyCb
  win.charCb = ogl_imgui_charCb

  result = true

proc glsl(s: string): string = s
proc ogl_imgui_initGl() =
  var vert_shader = glsl"""
    #version 430
    layout(location=0) uniform mat4 projMtx;
    layout(location=0) in vec2 pos;
    layout(location=1) in vec2 uv;
    layout(location=2) in vec4 color;
    out vec2 frag_uv;
    out vec4 frag_color;
    void main() {
      frag_uv = uv;
      frag_color = color;
      gl_Position = projMtx * vec4(pos.xy, 0, 1);
    }
  """
  var pix_shader = glsl"""
    #version 430
    layout(location=1) uniform sampler2D tex;
    in vec2 frag_uv;
    in vec4 frag_color;
    out vec4 out_color;
    void main() {
      out_color = frag_color * texture(tex, frag_uv.st);
    }
  """

  g_prog = glCreateProgram()
  g_vs = glCreateShader(GL_VERTEX_SHADER)
  g_ps = glCreateShader(GL_FRAGMENT_SHADER)
  glShaderSource(g_vs, 1, cast[cstringarray](addr vert_shader[0]), nil)
  glShaderSource(g_ps, 1, cast[cstringarray](addr pix_shader[0]), nil)
  glCompileShader(g_vs)
  glCompileShader(g_ps)
  glAttachShader(g_prog, g_vs)
  glAttachShader(g_prog, g_ps)
  glLinkProgram(g_prog)

  glGenBuffers(1, addr g_vbo)
  glGenBuffers(1, addr g_elms)

  glGenVertexArrays(1, addr g_vao)
  glBindVertexArray(g_vao)
  glBindBuffer(GL_ARRAY_BUFFER, g_vbo)
  glEnableVertexAttribArray(0)
  glEnableVertexAttribArray(1)
  glEnableVertexAttribArray(2)
  
  



proc ogl_imgui_nextFrame() =
