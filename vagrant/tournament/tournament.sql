-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

\c tournament;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS matches;

CREATE TABLE players ( id serial primary key,name text);

CREATE TABLE matches (
  id serial primary key,
  winner int REFERENCES players(id)
  ON DELETE CASCADE,
  loser int REFERENCES players(id)
  ON DELETE CASCADE
);

INSERT INTO players VALUES (default,'John');
INSERT INTO players VALUES (default,'Paul');
INSERT INTO players VALUES (default,'George');
INSERT INTO players VALUES (default,'Ringo');
INSERT INTO players VALUES (default,'Mick');
INSERT INTO players VALUES (default,'Keith');
INSERT INTO players VALUES (default,'Brian');
INSERT INTO players VALUES (default,'Bill');
INSERT INTO players VALUES (default,'Charlie');
