-- Table definitions for the tournament project.
--
-- Assumes `psql` CLI is available and connects to it.
-- Drops any previous tables/relations before creating new ones.


\c tournament;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;

-- create tables `players` and `matches`

CREATE TABLE players (id serial primary key, name text);

CREATE TABLE matches (
  id serial primary key,
  winner int REFERENCES players(id)
  ON DELETE CASCADE,
  loser int REFERENCES players(id)
  ON DELETE CASCADE
);

-- `standings` is the view called by 'playerStandings()' in `tournament.py`

CREATE VIEW standings AS
    SELECT id,
           name,
           (SELECT count(*) FROM matches WHERE players.id = matches.winner) AS wins,
           (SELECT count(*) FROM matches WHERE players.id = matches.winner OR
           players.id = matches.loser) AS matches
    FROM players
    ORDER BY wins DESC;

-- `rank` view is used to create 'pairings' for the swissPairings function in
-- `tournament.py`

CREATE VIEW rank AS
    SELECT row_number() OVER (ORDER BY wins DESC), id, name, wins FROM standings;

CREATE VIEW pairings AS
    SELECT a.id AS aid, a.name AS aname, b.id AS bid, b.name AS bname
    FROM rank as a, rank as b WHERE a.row_number % 2 = 0
    AND a.row_number-1 = b.row_number;

-- Insert statements below were used in testing this file and can be ignored.

/*INSERT INTO players VALUES (default,'John');
INSERT INTO players VALUES (default,'Paul');
INSERT INTO players VALUES (default,'George');
INSERT INTO players VALUES (default,'Ringo');
INSERT INTO players VALUES (default,'Mick');
INSERT INTO players VALUES (default,'Keith');
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


INSERT INTO matches VALUES (default,5,1);
INSERT INTO matches VALUES (default,6,2);
INSERT INTO matches VALUES (default,3,8);
INSERT INTO matches VALUES (default,4,9);
INSERT INTO matches VALUES (default,6,5);
INSERT INTO matches VALUES (default,3,4);
INSERT INTO matches VALUES (default,2,1);
INSERT INTO matches VALUES (default,8,9);*/

/* following views  - `win_count`, `matches_played`, and 'standings' are an
alternate implementation of the playerStandings functionaliy but failed unit
test because players were not appearing in standings before any matches played.
Leaving this in the file in case someone wants to work on it further.

CREATE VIEW win_count AS
    SELECT winner, COALESCE(count(*),0) as wins
    FROM matches, players WHERE players.id = matches.winner
    GROUP BY winner
    ORDER BY wins DESC;

CREATE VIEW matches_played AS
    SELECT players.id, name, COALESCE(count(*),0) AS matches
    FROM matches, players
    WHERE players.id = matches.winner OR players.id = matches.loser
    GROUP BY players.id
    ORDER BY matches DESC;

-- create view 'standings' which is called by `playerStandings()` in tournament.py

CREATE VIEW standings AS
    SELECT matches_played.id, matches_played.name, COALESCE (win_count.wins,0)
    AS wins, COALESCE (matches_played.matches,0) AS matches
    FROM matches_played LEFT JOIN win_count
    ON matches_played.id = win_count.winner OR wins=0
    ORDER BY wins DESC; */
