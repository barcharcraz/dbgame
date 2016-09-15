from sqlalchemy.sql import text, select, join
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, ForeignKey
from pathlib import Path
from typing import Dict
class UserTypes:
    def __init__(self, engine = create_engine("sqlite://", echo=True)):
        self.engine = engine
        self.meta = MetaData()
        self.types = Table('metadata_types', self.meta,
                           Column('type_id', Integer, primary_key=True),
                           Column('type_name', String)
                           )
        self.type_fields = Table('metadata_types_fields', self.meta,
                                 Column('field_id', Integer, primary_key=True),
                                 Column('field_name', String),
                                 Column('field_type', String),
                                 Column('type_id', Integer, ForeignKey('metadata_types.type_id'))
                                 )
        self.meta.create_all(self.engine)
    def get_fields(self, typename: str) -> Dict[str, str]:
        s = select([self.type_fields]).select_from(self.type_fields.join(self.types)).where(self.types.type_name == typename)
        print(self.engine.execute(s).fetchall())

    def add_type(self, typename: str, fields: Dict[str, str]):
        with self.engine.begin() as conn:
            ins = self.types.insert().values(type_name=typename)
            result = conn.execute(ins)
            pk = result.inserted_primary_key
            for k, v in fields.items():
                ins = self.type_fields.insert().values(field_name=k, field_type=v, type_id=pk)
                conn.execute(ins)


    @classmethod
    def load(cls, filename: str):
        engine = create_engine("sqlite://" + filename, echo=True)
        return cls(engine)
