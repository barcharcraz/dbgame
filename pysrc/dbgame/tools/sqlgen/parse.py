import sqlparse
from typing import *
import typing


def eval_types(hints):
    result = []
    for name, value in hints:
        if isinstance(value, str):
            value = typing._ForwardRef(value)
        value = typing._eval_type(value, globals(), locals())
        result.append((name, value))
    return result

def parse(sql: str):
    result = []
    ast = sqlparse.parse(sql)
    assert(len(ast) == 1)
    ast = ast[0]
    sublists = list(ast.get_sublists())
    if ast.get_type() == 'SELECT':
        selectedCols = sublists[0]
        if type(selectedCols) is sqlparse.sql.IdentifierList:
            selectedCols = selectedCols.get_identifiers()
        else:
            selectedCols = [selectedCols]

        for ident in selectedCols:
            result.append((ident.get_name(), ident.get_typecast()))
    return eval_types(result)


def map_type(mapping: Dict[Type, str], typ) -> str:
    if type in mapping:
        return mapping[type]
    selectedType = None
    for key, value in mapping.items():
        if issubclass(typ, key):
            if selectedType is None or issubclass(key, selectedType):
                selectedType = key
            elif issubclass(selectedType, key):
                pass
            else:
                raise Exception("Error: Could not resolve type")
    if selectedType is None:
        raise Exception("Error: Could not resolve type")
    result = mapping[selectedType]
    if hasattr(typ, '__args__'):
        result = result.format(*[map_type(mapping, x) for x in typ.__args__])
    return result