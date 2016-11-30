

set(shaders_src
    debug_frag.glsl
    debug_vert.glsl
    )

add_custom_target(shaders SOURCES ${shaders_src})
