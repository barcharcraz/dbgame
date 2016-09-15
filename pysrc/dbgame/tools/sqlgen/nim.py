from .parse import parse, map_type
from typing import *
from typing import T
TYPE_MAPPING = {
    Sequence: "seq[{}]",
    int: "int64",
    float: "float",
    Dict: "Table[{}, {}]"
}



def fields_from_query(query: str) -> List[str]:
    field_templ = '{name}: {type}'
    fields = []
    hints = parse(query)
    for name, type in hints.items():
        fields.append(field_templ.format(name=name, type=map_type(TYPE_MAPPING, type)))
    return fields

def object_from_query(query: str, objname: str, objtype = 'object') -> str:
    fields = fields_from_query(query)
    fields = ['  ' + x for x in fields]
    field_str = "\n".join(fields)
    return("type {name} = {objtype}\n"
           "{fields}".format(name=objname, fields=field_str, objtype=objtype))

def tuple_from_query(query: str) -> str:
    fields = fields_from_query(query)
    return 'tuple[{fields}]'.format(fields=", ".join(fields))
