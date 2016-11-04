//
// Created by barch on 10/5/2016.
//

#include <fbxsdk.h>
#include <string>
#include <odb/database.hxx>
#include <exception>
using namespace std;

class fbx_exception : public runtime_error {
    using runtime_error::runtime_error;
};

namespace dbgame {

void import_assets(const string &filename, odb::database &db) {
    FbxManager* sdk_manager = FbxManager::Create();
    FbxIOSettings *io_settings = FbxIOSettings::Create(sdk_manager, IOSROOT);
    sdk_manager->SetIOSettings(io_settings);

    FbxImporter *importer = FbxImporter::Create(sdk_manager, "");

    bool result = importer->Initialize(filename.c_str(), -1, sdk_manager->GetIOSettings());
    if(!result) {
        throw fbx_exception(importer->GetStatus().GetErrorString());
    }

}

}