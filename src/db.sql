BEGIN TRANSACTION;
CREATE TABLE `scene_data` (
	`id`	INTEGER,
	`filename`	TEXT,
	`filedata`	BLOB,
	PRIMARY KEY(id)
);
CREATE TABLE "mesh_data" (
	`id`	integer,
	`scene`	integer,
	`name`	text,
	`vertices`	blob,
	`normals`	blob,
	`tangents`	blob,
	`bitangents`	blob,
	`indices`	blob,
	`texcoords`	blob,
	PRIMARY KEY(id),
	FOREIGN KEY(`scene`) REFERENCES `scene_data`(`id`) on delete cascade
);
CREATE TABLE "material_data" (
	`id` integer primary key,
	`scene` integer references scene_data(id) on delete cascade
);
CREATE TABLE "material_prop_data" (
	`id` integer primary key,
	`material` integer references material_data(id),
	`key` text,
	`semantic` integer,
	`index` integer,
	`data` blob
);
CREATE TABLE "texture_data" (
	id integer primary key,
	scene integer references scene_data(id) on delete cascade,
	width integer,
	height integer,
	format text,
	data blob
);
CREATE TABLE "camera_data" (
	id integer primary key,
	scene integer references scene_data(id) on delete cascade
);
-- this table is going to store the scene graph,
-- I don't want to rely on it for rendering so I'll
-- design some RCTE to propigate the transforms
CREATE TABLE "node_data" (
	id integer primary key
	scene integer references scene_data(id) on delete cascade,
	name text,
	transform blob, --4x4 float matrix
	parent integer references node_data(id) on delete cascade,

);

CREATE TABLE "node_mesh_data" (
	id integer primary key,
	node integer references node_data(id) on delete cascade,
	mesh integer references mesh_data(id)
);
COMMIT;
