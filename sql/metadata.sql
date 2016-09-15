CREATE TABLE metadata_types (
  type_id integer primary key,
  type_name text
);

CREATE TABLE metadata_types_fields (
  field_id integer primary key,
  field_name text,
  field_type text,
  type_id integer references metadata_types
);