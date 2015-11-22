This is the Jason Horowitz's implementation of the Udacity FSND Swiss Pairings Tournament project.

Project needs to be run in an environment with PostgreSQL and the psycopg2 driver.  They are both present in the Vagrant vm provided by Udacity.

Install the files `tournament.sql`, `tournament.py` and `tournament_test.py` in the same directory in the Vagrant environment. Other files in this project do not need to be present.

To create the the tournament database with all needed tables and views, stay in the same directory and:
- go to the psql CLI (run `psql` at the Linux command prompt)
- import the tournament.sql file (`=> \i tournament.sql;`)
which connects to the tournament db, cleans up any old tables/relations and creates the new tables and views.

Get to a Linux command prompt in the same directory either from a fresh terminal window or by quitting the psql CLI (`=>\q`).

At the Linux command prompt run tournament_test.py (`vagrant/tournament$ python tournament_test.py`).  If everything is correct and the database is installed properly you will get messages that all eight unit tests pass.
