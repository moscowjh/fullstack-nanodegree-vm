#
import bleach
# Database access functions for the web forum.
#
import psycopg2
# Database connection

# Get posts from database.


def GetAllPosts():
    DB = psycopg2.connect("dbname=forum")
    c = DB.cursor()
    c.execute("SELECT time, content FROM posts ORDER BY time DESC")
    posts = [{'content': str(row[1]), 'time': str(row[0])}
             for row in c.fetchall()]
    posts.sort(key=lambda row: row['time'], reverse=True)
    DB.close()
    return posts

# Add a post to the database.


def AddPost(content):
    cleaned_content = bleach.clean(content, strip=True)
    bleach.clean('<br>script()</br>')
    DB = psycopg2.connect("dbname=forum")
    c = DB.cursor()
    # c.execute("INSERT INTO posts(content) VALUES ('%s')" % content)
    c.execute("INSERT INTO posts(content) VALUES(%s)",
              (cleaned_content,))
    DB.commit()
    DB.close()
