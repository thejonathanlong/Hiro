#!flask/bin/python
from Kensing import Kensing
import urllib, cStringIO, sqlite3
import json

k = Kensing()
thefile = open('/Users/jonathan_long/Desktop/image.png', 'rb').read()
# print thefile
# print k.photos_for_album("test")
k.insert_photo(thefile, "png")
k.insert_album("test")
photos = k.column_names(k.PHOTOS_TABLE)
print json.dumps({"photos":photos})
