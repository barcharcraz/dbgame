type BaseTest = object
    t: int

proc test(inTest: var BaseTest, t: int = 8192) =
    inTest.t = t
    echo(inTest.t)
    echo(t)
static:
    var lol = BaseTest()
    test(lol)