
#pragma once
namespace odb { class database; }
namespace dbgame {
namespace rendering {
namespace gl {
    
    void compile_shaders(odb::database &db);
    void compile_programs(odb::database &db);
}
}
}
