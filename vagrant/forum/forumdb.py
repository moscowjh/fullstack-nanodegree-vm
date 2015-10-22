#
# Database access functions for the web forum.
#
import psycopg2
# Database connection

# Get posts from database.


def GetAllPosts():
    DB = psycopg2.connect("dbname=forum")
    c = DB.cursor()
    c.execute("SELECT time, content FROM posts ORDER BY time DESC")
    posts = [{'content': str(row[1]), 'time': str(row[0])} for row in DB]
    posts.sort(key=lambda row: row['time'], reverse=True)
    DB.close()
    return posts

# Add a post to the database.


def AddPost(content):
    DB = psycopg2.connect("dbname=forum")
    c = DB.cursor()
    c.execute("INSERT INTO posts(content) VALUES ('%s')" % content)
    DB.commit()
    DB.close()
    '''
    Args:
      content: The text content of the new post.
    t = time.strftime('%c', time.localtime())
    DB.append((t, content)) '''
