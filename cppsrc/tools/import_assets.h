//
// Created by barch on 9/30/2016.
//
#pragma once
#include <string>
#include <odb/database.hxx>
namespace dbgame {
    void import_assets(const std::string& filename, odb::database& db);
}
