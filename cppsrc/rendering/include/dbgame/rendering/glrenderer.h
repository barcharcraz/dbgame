
#pragma once
namespace odb {class database; }
namespace dbgame {
namespace rendering {
namespace gl {
    
    void create_vertex_buffers(odb::database &db);
    void create_index_buffers(odb::database &db);
    void create_vertex_arrays(odb::database &db);
    void create_opengl_calls(odb::database &db);
    void execute_draws(odb::database &db);
    
}
}
}
