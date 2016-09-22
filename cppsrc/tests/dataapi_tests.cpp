//
// Created by barch on 9/18/2016.
//


#include <gtest/gtest.h>
#include <dbgame/dataapi.h>
#include <odb/database.hxx>
#include <odb/sqlite/database.hxx>
#include <odb/schema-catalog.hxx>
#include <glbinding/gl/gl.h>
#include <dbgame/dataapi/data_rendering.h>

using namespace odb::sqlite;
using namespace std;
using namespace odb;
using namespace Eigen;
class DatabaseTests : public ::testing::Test {
protected:

    odb::sqlite::database db;
    DatabaseTests() :
        db(":memory:")
    {}

    virtual void SetUp() {
        odb::transaction t(db.begin());
        schema_catalog::create_schema(db);
        t.commit();
    }
};

TEST_F(DatabaseTests, GLCallQueryWorks) {
    call c;
    c.count = 1337;
    c.program = 4;
    c.vao = 5;
    c.prim_type = gl::GL_TRIANGLE_STRIP;
    odb::transaction t(db.begin());
    auto id = db.persist(c);
    t.commit();
    call c2;
    t.reset(db.begin());
    db.load<call>(id, c2);
    t.commit();
    ASSERT_EQ(memcmp(&c, &c2, sizeof(call)), 0);

}

TEST_F(DatabaseTests, VectorStorageWorks) {
    Vector3f vec(3, 1.2, 0.001);
    vertex v;
    v.normal = vec;
    v.position = vec;
    v.texcoord = vec;
    odb::transaction t(db.begin());
    auto id = db.persist(v);
    t.commit();
    vertex v2;
    t.reset(db.begin());
    db.load<vertex>(id, v2);
    t.commit();
    ASSERT_EQ(v2.position, vec);
    ASSERT_EQ(v2.texcoord, vec);
    ASSERT_EQ(v2.normal, vec);
}