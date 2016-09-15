from typing import *
from .parse import parse, map_type
TYPE_MAPPING = {
    Sequence: "std::vector<{}>",
    int: "long long",
    float: "double",
    Dict: "std::unordered_map<{}, {}>"
}

def fields_from_query(query: str) -> List[str]:
    field_templ = "{type} {name};"
    fields = []
    hints = parse(query)
    for name, type in hints:
        fields.append(field_templ.format(name=name, type=map_type(TYPE_MAPPING, type)))
    return fields

def class_from_query(query: str, objname: str) -> str:
    template = ("class {name} {{\n"
                "{fields}\n"
                "}};")
    fields = fields_from_query(query)
    fields = ["    " + x for x in fields]
    fields = "\n".join(fields)
    return template.format(name=objname, fields=fields)

def load_from_query(query: str, objname: str) -> str:
    template = ("template<>\n"
                "{objname} load<{objname}>(sqlite3_stmt* stm) {{\n"
                "    {objname} result;\n"
                "    {assignments}\n"
                "    return result;\n"
                "}}\n")
    fields = fields_from_query(query)
    hints = parse(query)
    assignment_template = "result.{field} = load_{type}(stm, {i});"
    assignments = []
    for i, val in enumerate(hints):
        name, typ = val
        assignments.append(assignment_template.format(field=name, type=typ.__name__, i=i))
    assignments[1:] = ["    " + x for x in assignments[1:]]
    assignments = "\n".join(assignments)
    return template.format(objname=objname, assignments=assignments)

