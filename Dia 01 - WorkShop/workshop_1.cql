//consultas e comandos que foram utilizados para trabalhar com o exercício proposto no workshop

//*****************//
//**criar tabelas**//
//*****************//


//criar tabelas de usuários

DESC KEYSPACES;

USE chatsandra;

CREATE TABLE IF NOT EXISTS users (
  email       TEXT,
  name        TEXT,
  password    TEXT,
  user_id     UUID,
  PRIMARY KEY (( email ))
);

DESC TABLES;

//obs
//*Duplicar registros em diversas tabelas é comum em bancos noSQL, 
// pois o objetivo de bancos de dados não relacionais é a DESNORMALIZACAÇÃO dos dados.


//criar tabela de posts
CREATE TABLE IF NOT EXISTS posts_by_user (
user_id     UUID,
post_id     TIMEUUID,
room_id     TEXT,
text        TEXT,
PRIMARY KEY ((user_id), post_id)
) WITH CLUSTERING ORDER BY (post_id DESC);

//criar tabela posts por sala
CREATE TABLE IF NOT EXISTS posts_by_room (
room_id     TEXT,
post_id     TIMEUUID,
user_id     UUID,
text        TEXT,
PRIMARY KEY ((room_id), post_id)
) WITH CLUSTERING ORDER BY (post_id DESC);

//********//
//**CRUD**//
//********//

//create data

INSERT INTO users (
email,    // TEXT
name,     // TEXT
password, // TEXT
user_id   // UUID: id of a user
)
VALUES (
'jonasaacampos@hire-me.com',
'Jonas Campos',
'123456',
11111111-1111-1111-1111-111111111111
);

INSERT INTO users (email, name, password, user_id) VALUES (
'fred@qmail.net', 'Fred Fivey', 'qwerty',
55555555-5555-5555-5555-555555555555
);

INSERT INTO users (email, name, password, user_id) VALUES (
'nina@zmail.org', 'Nina Niney', 's3cr3t',
99999999-9999-9999-9999-999999999999
);


// Insert some data in the "posts_by_user" table
INSERT INTO posts_by_user (
user_id,  // UUID: unique id for a user
post_id,  // TIMEUUID: unique uuid + timestamp
room_id,  // TEXT: id of a chat room
text      // TEXT: the post content itself
)
VALUES (
11111111-1111-1111-1111-111111111111,
22222222-5cff-11ec-be16-1fedb0dfd057,
'#hiking',
'I climbed Mt. Gumbo yesterday ...'
);

INSERT INTO posts_by_user (user_id, post_id, room_id, text) VALUES (
11111111-1111-1111-1111-111111111111,
77777777-5cff-11ec-be16-1fedb0dfd057,
'#running', 'Who likes marathons here?'
);
INSERT INTO posts_by_user (user_id, post_id, room_id, text) VALUES (
11111111-1111-1111-1111-111111111111,
aaaaaaaa-5cff-11ec-be16-1fedb0dfd057,
'#hiking', '... and Mt. Gumbo was easy!!!'
);
INSERT INTO posts_by_user (user_id, post_id, room_id, text) VALUES (
55555555-5555-5555-5555-555555555555,
bbbbbbbb-5cff-11ec-be16-1fedb0dfd057,
'#hiking', 'For us humans Gumbo is a tough one...!'
);
INSERT INTO posts_by_user (user_id, post_id, room_id, text) VALUES (
99999999-9999-9999-9999-999999999999,
cccccccc-5cff-11ec-be16-1fedb0dfd057,
'#running', 'I just love marathons.'
);
INSERT INTO posts_by_user (user_id, post_id, room_id, text) VALUES (
11111111-1111-1111-1111-111111111111,
eeeeeeee-5cff-11ec-be16-1fedb0dfd057,
'#running', 'Same here!'
);
INSERT INTO posts_by_user (user_id, post_id, room_id, text) VALUES (
55555555-5555-5555-5555-555555555555,
ffffffff-5cff-11ec-be16-1fedb0dfd057,
'#hiking', 'I have to buy new boots.'
);


// Insert some data in the "posts_by_room" table
INSERT INTO posts_by_room (user_id, post_id, room_id, text) VALUES (
11111111-1111-1111-1111-111111111111,
22222222-5cff-11ec-be16-1fedb0dfd057,
'#hiking', 'I climbed Mt. Gumbo yesterday ...'
);

INSERT INTO posts_by_room (user_id, post_id, room_id, text) VALUES (
11111111-1111-1111-1111-111111111111,
77777777-5cff-11ec-be16-1fedb0dfd057,
'#running', 'Who likes marathons here?'
);
INSERT INTO posts_by_room (user_id, post_id, room_id, text) VALUES (
11111111-1111-1111-1111-111111111111,
aaaaaaaa-5cff-11ec-be16-1fedb0dfd057,
'#hiking', '... and Mt. Gumbo was easy!!!'
);
INSERT INTO posts_by_room (user_id, post_id, room_id, text) VALUES (
55555555-5555-5555-5555-555555555555,
bbbbbbbb-5cff-11ec-be16-1fedb0dfd057,
'#hiking', 'For us humans Gumbo is a tough one...!'
);
INSERT INTO posts_by_room (user_id, post_id, room_id, text) VALUES (
99999999-9999-9999-9999-999999999999,
cccccccc-5cff-11ec-be16-1fedb0dfd057,
'#running', 'I just love marathons.'
);
INSERT INTO posts_by_room (user_id, post_id, room_id, text) VALUES (
11111111-1111-1111-1111-111111111111,
eeeeeeee-5cff-11ec-be16-1fedb0dfd057,
'#running', 'Same here!'
);
INSERT INTO posts_by_room (user_id, post_id, room_id, text) VALUES (
55555555-5555-5555-5555-555555555555,
ffffffff-5cff-11ec-be16-1fedb0dfd057,
'#hiking', 'I have to buy new boots.'
);

//read data

// Read (some columns of) rows in a certain partition of "posts_by_user" table
SELECT post_id, room_id, text FROM posts_by_user
WHERE user_id = 11111111-1111-1111-1111-111111111111;

// Read (some columns of) posts from a certain room (= a certain partition)
SELECT user_id, text FROM posts_by_room WHERE room_id = '#hiking';

// Read the whole "posts_by_room" table
SELECT * FROM posts_by_room;
// (warning: not suitable for large tables in production)


// Read all data from the posts_by_room table,
// convert post_id into a timestamp, and label the column "post_date"
SELECT user_id, dateOf(post_id) AS post_date, text FROM posts_by_room
WHERE room_id = '#hiking';

//update data

// ** Just for reference: **
INSERT INTO posts_by_user (user_id, post_id, room_id, text) VALUES (
	11111111-1111-1111-1111-111111111111,
	aaaaaaaa-5cff-11ec-be16-1fedb0dfd057,
	'#hiking', '... and Mt. Gumbo was NOT easy!!!');
	
	SELECT post_id, room_id, text FROM posts_by_user
WHERE user_id = 11111111-1111-1111-1111-111111111111;

UPDATE posts_by_user
SET text = '... and Mt. Gumbo was NOT easy!!!'
WHERE user_id = 11111111-1111-1111-1111-111111111111
AND   post_id = aaaaaaaa-5cff-11ec-be16-1fedb0dfd057;

SELECT post_id, room_id, text FROM posts_by_user
	WHERE user_id = 11111111-1111-1111-1111-111111111111;
	
//remove data

SELECT post_id, room_id, text FROM posts_by_user
WHERE user_id = 55555555-5555-5555-5555-555555555555;

DELETE FROM posts_by_user
WHERE user_id = 55555555-5555-5555-5555-555555555555
AND post_id = bbbbbbbb-5cff-11ec-be16-1fedb0dfd057;

SELECT post_id, user_id, text FROM posts_by_room WHERE room_id = '#hiking';

DELETE FROM posts_by_room
WHERE room_id = '#hiking'
AND post_id = bbbbbbbb-5cff-11ec-be16-1fedb0dfd057;

SELECT post_id, room_id, text FROM posts_by_user
WHERE user_id = 55555555-5555-5555-5555-555555555555;

SELECT post_id, user_id, text FROM posts_by_room WHERE room_id = '#hiking';
