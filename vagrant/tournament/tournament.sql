-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

\c tournament;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;

CREATE TABLE players (id serial primary key, name text);

CREATE TABLE matches (
  id serial primary key,
  winner int REFERENCES players(id)
  ON DELETE CASCADE,
  loser int REFERENCES players(id)
  ON DELETE CASCADE
);

CREATE VIEW win_count AS
    SELECT players.id, name, count(*) as wins
    FROM players JOIN matches
    ON players.id = matches.winner
    GROUP BY players.id
    ORDER BY wins DESC;

CREATE VIEW matches_played AS
    SELECT players.id, name, count(*) AS matches
    FROM players JOIN matches
    ON players.id = matches.winner OR players.id = matches.loser
    GROUP BY players.id
    ORDER BY matches DESC;

CREATE VIEW standings AS
    SELECT matches_played.id, matches_played.name, wins, matches
    FROM win_count RIGHT JOIN matches_played
    ON win_count.id = matches_played.id
    ORDER BY wins DESC;

CREATE VIEW standings2 AS
    SELECT id,
           name,
           (SELECT count(*) FROM matches WHERE players.id = matches.winner) AS wins,
           (SELECT count(*) FROM matches WHERE players.id = matches.winner OR
           players.id = matches.loser) AS matches
    FROM players
    ORDER BY wins DESC;

INSERT INTO players VALUES (default,'John');
INSERT INTO players VALUES (default,'Paul');
INSERT INTO players VALUES (default,'George');
INSERT INTO players VALUES (default,'Ringo');
INSERT INTO players VALUES (default,'Mick');
INSERT INTO players VALUES (default,'Keith');
--INSERT INTO players VALUES (default,'Brian');
INSERT INTO players VALUES (default,'Bill');
INSERT INTO players VALUES (default,'Charlie');


INSERT INTO matches VALUES (default,5,1);
INSERT INTO matches VALUES (default,6,2);
INSERT INTO matches VALUES (default,3,7);
INSERT INTO matches VALUES (default,4,8);
INSERT INTO matches VALUES (default,6,5);
INSERT INTO matches VALUES (default,3,4);
INSERT INTO matches VALUES (default,2,1);
INSERT INTO matches VALUES (default,8,7);


/*INSERT INTO matches VALUES (default,5,1);
INSERT INTO matches VALUES (default,6,2);
INSERT INTO matches VALUES (default,3,8);
INSERT INTO matches VALUES (default,4,9);
INSERT INTO matches VALUES (default,6,5);
INSERT INTO matches VALUES (default,3,4);
INSERT INTO matches VALUES (default,2,1);
INSERT INTO matches VALUES (default,8,9);*/
