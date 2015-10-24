
import sqlite3, os
from JELPrettyPrint import JELPrettyPrint as printer
from datetime import datetime

class Kensing(object):
	#############
	#Table Names#
	#############
	PHOTOS_TABLE = "Photos"
	ALBUMS_TABLE = "Albums"
	COMMENTS_TABLE = "Comments"
	PHOTOALBUM_TABLE = "PhotoAlbum"
	PHOTOTAG_TABLE = "PhotoTag"
	TAG_TABLE = "Tag"
	DB_NAME = "Kensing.db"

	#################
	#Photo Properties#
	#################
	photo_properties = ["photoDestination", "dateCreated", "favorite"]
	photo_property_qualifiers = ['TEXT NOT NULL', 'TEXT NOT NULL', 'INTEGER']

	###################
	#Album properties#
	###################
	album_properties = ["name", "cover_photo"]
	album_property_qualifiers = ['TEXT NOT NULL UNIQUE', 'TEXT']

	#################
	#photoalbum Properties#
	#################
	photoalbum_properties = ["photoID", "albumID"]
	photoalbum_property_qualifiers = ['INTEGER NOT NULL', 'INTEGER NOT NULL', 'FOREIGN KEY(photoID) REFERENCES ' + PHOTOS_TABLE + '(ID), FOREIGN KEY(albumID) REFERENCES ' + ALBUMS_TABLE + '(ID)']

	###################
	#Tag properties#
	###################
	tag_properties = ["name"]
	tag_property_qualifiers = ['TEXT NOT NULL UNIQUE']

	#################
	#phototag Properties#
	#################
	phototag_properties = ["tagID", "photoID"]
	phototag_property_qualifiers = ['INTEGER NOT NULL', 'INTEGER NOT NULL', 'FOREIGN KEY(tagID) REFERENCES ' + TAG_TABLE + '(ID), FOREIGN KEY(photoID) REFERENCES ' + PHOTOS_TABLE + '(ID)']

	#################
	#Comment Properties#
	#################
	comment_properties = ["description", "photoID"]
	comment_property_qualifiers = ['TEXT NOT NULL', "INTEGER NOT NULL", "FOREIGN KEY(photoID) REFERENCES " + PHOTOS_TABLE + "(ID)"]

	PHOTO_BASE_STORAGE = os.path.expanduser('http://127.0.0.1:5000/photo_storage/')
	def __init__(self):
		if not os.path.exists(self.PHOTO_BASE_STORAGE):
			os.makedirs(self.PHOTO_BASE_STORAGE)

		db = sqlite3.connect(self.DB_NAME)
		cursor = db.cursor()
		create_PHOTOS_TABLE_command = Kensing.create_table_command_with_properites_and_qualifiers(self.PHOTOS_TABLE, self.photo_properties, self.photo_property_qualifiers)
		create_albums_table_command = Kensing.create_table_command_with_properites_and_qualifiers(self.ALBUMS_TABLE, self.album_properties, self.album_property_qualifiers)
		create_photoalbum_table_command = Kensing.create_table_command_with_properites_and_qualifiers(self.PHOTOALBUM_TABLE, self.photoalbum_properties, self.photoalbum_property_qualifiers, False)
		create_tag_table_command = Kensing.create_table_command_with_properites_and_qualifiers(self.TAG_TABLE, self.tag_properties, self.tag_property_qualifiers)
		create_phototag_command = Kensing.create_table_command_with_properites_and_qualifiers(self.PHOTOTAG_TABLE, self.phototag_properties, self.phototag_property_qualifiers, False)
		create_comments_command = Kensing.create_table_command_with_properites_and_qualifiers(self.COMMENTS_TABLE, self.comment_properties, self.comment_property_qualifiers)
		printer.pretty_print('Creating Photos Table with command: ' + create_PHOTOS_TABLE_command)
		printer.pretty_print('Creating PhotoAlbum Table with command: ' + create_photoalbum_table_command)
		printer.pretty_print('Creating albums Table with command: ' + create_albums_table_command)
		printer.pretty_print('Creating tag Table with command: ' + create_tag_table_command)
		printer.pretty_print('Creating phototag Table with command: ' + create_phototag_command)
		printer.pretty_print('Creating comment Table with command: ' + create_comments_command)
		cursor.execute(create_PHOTOS_TABLE_command)
		cursor.execute(create_albums_table_command)
		cursor.execute(create_photoalbum_table_command)
		cursor.execute(create_tag_table_command)
		cursor.execute(create_phototag_command)
		cursor.execute(create_comments_command)
		# self.save()
		db.commit()

	@staticmethod
	def create_table_command_with_properites_and_qualifiers(table_name, properties, qualifiers, shouldHavePrimaryKeyID=True):
		command = 'CREATE TABLE IF NOT EXISTS ' + table_name + '('
		if shouldHavePrimaryKeyID:
			command = command + 'ID INTEGER PRIMARY KEY ASC, '
		property_index = 0
		for qualifier in qualifiers:
			# Index is less than properties and qualifiers - we have more of each
			if property_index == len(properties) - 1 and property_index == len(qualifiers) - 1:
				the_property = properties[property_index]
				command = command + ' ' + the_property + ' ' + qualifier
			elif property_index < len(properties) and property_index < len(qualifiers):
				the_property = properties[property_index]
				command = command + ' ' + the_property + ' ' + qualifier + ','
			elif property_index == len(qualifiers) - 1: # We only have more qualifiers
				command = command + ' ' + qualifier
			else: # We don't have any more of either
				command = command + ' ' + qualifier + ','
			property_index = property_index + 1
		return command + ')'
	
	@staticmethod
	def insert_statement(table_name, properties, values):
		insert = 'INSERT into ' + table_name + '('
		property_index = 0
		for the_property in properties:
			insert = insert + the_property
			if property_index != len(properties) - 1:
				insert = insert + ','
			property_index = property_index + 1
		
		property_index = 0
		insert = insert + ') values('
		for value in values:
			insert = insert + '?'
		# 	insert = insert + '\'' + str(value) + '\''
			if property_index != len(values) - 1:
				insert = insert + ','
			property_index = property_index + 1
		insert = insert + ')'
		print "Insert - " + str(insert)
		return insert

	def insert_photos_statement(self, values):
		return self.insert_statement(self.PHOTOS_TABLE, self.photo_properties, values)

	def insert_album_statement(self, values):
		return self.insert_statement(self.ALBUMS_TABLE, self.album_properties, values)

	def insert_photoalbum_statement(self, values):
		return self.insert_statement(self.PHOTOALBUM_TABLE, self.photoalbum_properties, values)

	def insert_phototag_statement(self, values):
		return self.insert_statement(self.PHOTOTAG_TABLE, self.phototag_properties, values)

	def insert_tag_statement(self, values):
		return self.insert_statement(self.TAG_TABLE, self.tag_properties, values)

	#Mark: Album Methods

	def insert_album(self, name, cover_photo=""):
		values = [name, cover_photo_ID]
		insert = self.insert_album_statement(values)
		self.__commit(insert, values)
		printer.pretty_print_positive("Added Album " + insert)

	def set_album_cover_photo(self, album_name, photoDestination):
		album_id = self.get_id_for_album(album_name)
		update = 'UPDATE ' + self.ALBUMS_TABLE + ' set cover_photo=\'' + str(photoDestination) + '\' where ID=' + str(album_id)
		self.__update(update)
		printer.pretty_print_positive(update)
	
	# def set_album_cover_to_photoDestination(self, album_name, photoDestination):
	# 	photoID = self.get_photoID_from_URL(photoDestination)
	# 	self.set_album_cover_photo(album_name, photoID)

	def get_all_albums(self):
		select = 'SELECT * from ' + str(self.ALBUMS_TABLE)
		albums = self.__execute(select).fetchall()
		albums_dict = self.albums_with_columns(albums)
		return albums_dict

	def get_id_for_album(self, name):
		select = 'SELECT * from ' + str(self.ALBUMS_TABLE) + ' where name=\'' + str(name) + '\''
		album = self.__execute(select)
		return album.fetchone()[0]

	def get_album_for_name(self, name):
		select = 'SELECT * from ' + self.ALBUMS_TABLE + ' where name=\'' + str(name) + '\''
		album = self.__execute(select).fetchone()
		album_dict = self.albums_with_columns([album])
		return album_dict

	#Mark: Photo Methods
	def insert_photo(self, photo_URL, favorite=0):
		# nextUniqueID = len(self.get_all_photos()) + 1
		values = [photo_URL, str(datetime.now()), favorite]

		insert = self.insert_photos_statement(values)
		print "Insert: " + str(insert)
		self.__commit(insert, values)
		printer.pretty_print_positive("Added Photo "+ insert)

	def get_photos_for_album(self, name):
		album_id = self.get_id_for_album(name)
		select = 'SELECT * from ' + self.PHOTOS_TABLE + ' as P JOIN ' + self.PHOTOALBUM_TABLE + ' as A on P.id=A.photoID where albumID=' + str(album_id)
		photos = self.__execute(select).fetchall()
		return self.photos_with_columns(photos)

	def get_bounded_photos_in_album(self, albumName, upperbound, lowerbound=0):
		album_id = self.get_id_for_album(albumName)
		select = 'SELECT * from ' + self.PHOTOS_TABLE + ' as P JOIN ' + self.PHOTOALBUM_TABLE + ' as A on P.id=A.photoID where albumID=' + str(album_id) + ' LIMIT ' + str(lowerbound) + ', ' + str(upperbound)
		photos = self.__execute(select).fetchall()
		resulting_photos = self.photos_with_columns(photos)
		print resulting_photos
		return resulting_photos

	def add_photo_to_album_by_id(self, photoID, albumName):
		printer.pretty_print_error("FIRST ONE")
		album_id = self.get_id_for_album(albumName)
		values = [photoID, album_id]
		insert = self.insert_photoalbum_statement(values)
		print "INSERT: " + str(insert)
		print "Values: " + str(values)
		self.__commit(insert, values)

	def add_photo_to_album(self, photoURL, albumName):
		printer.pretty_print_error("SECOND ONE")
		self.add_photo_to_album_by_id(self.get_photoID_from_URL(photoURL), albumName)
		printer.pretty_print("Added photo " + str(photoURL) + " to album " + str(albumName))

	def get_photoID_from_URL(self, url):
		# printer.pretty_print(url)
		select = 'SELECT * from ' + self.PHOTOS_TABLE + ' where photoDestination=\''+str(url)+'\''
		printer.pretty_print("Executing select: " + str(select))
		photo = self.__execute(select).fetchone()
		return photo[0]

	def get_all_photos(self):
		select = 'SELECT * from ' + str(self.PHOTOS_TABLE)
		photos = self.__execute(select).fetchall()
		return self.photos_with_columns(photos)

	def get_photo_for_id(self, photoID):
		select = 'SELECT * from ' + str(self.PHOTOS_TABLE) + 'where id=' + str(photoID)
		photo = self.__execute(select).fetchone()
		return self.photos_with_columns([photo])

	def get_all_favorites(self):
		select = 'SELECT * from ' + str(self.PHOTOS_TABLE) + ' where favorite=1'
		favorites = self.__execute(select).fetchall()
		return self.photos_columns(favorites)

	def favorite_photo(self, photoID):
		update = 'UPDATE ' + self.PHOTOS_TABLE + ' set favorite=1 where photoID=' + str(photoID)
		self.__update(update)
		printer.pretty_print_positive("Update favorites: " + str(update))

	def get_bounded_photos(self, upperbound, lowerbound=0):
		select = 'SELECT * from ' + self.PHOTOS_TABLE + ' LIMIT ' + str(lowerbound) + ', ' + str(upperbound)
		photos = self.__execute(select).fetchall()
		resulting_photos = self.photos_with_columns(photos)
		print resulting_photos
		return resulting_photos

	def get_photo_for_url(self, url):
		select = 'SELECT * from ' + self.PHOTOS_TABLE + ' where photoDestination=\'' + url + '\''
		photo = self.__execute(select).fetchone()
		resulting_photos = self.photos_with_columns([photo])
		return resulting_photos

	def get_photos_with_tag(self, tagName):
		tagID = self.get_id_for_tag_named(tagName)
		select = 'SELECT * from ' + self.PHOTOS_TABLE + ' as P JOIN ' + self.PHOTOTAG_TABLE + ' as T on P.id=T.photoID where tagID=' + str(tagID)
		print "Select - " + str(select)
		photos = self.__execute(select).fetchall()
		resulting_photos = self.photos_with_columns(photos)
		return resulting_photos

	#Mark: Tag Methods
	def get_id_for_tag_named(self, name):
		select = 'SELECT * from ' + self.TAG_TABLE + ' where name=\'' + str(name) + '\''
		results = self.__execute(select).fetchone()
		return results[0] 

	def add_tag_to_photo(self, photoID, tagName):
		tagID = self.get_id_for_tag_named(tagName)
		values = [tagID, photoID]
		insert = self.insert_phototag_statement(values)
		print "INSERT PHOTOTAG" + insert
		self.__commit(insert, values)

	def add_tag(self, tagName):
		values = [tagName]
		insert = self.insert_tag_statement(values)
		self.__commit(insert, values)
		printer.pretty_print(insert)

	#Mark: Comment Methods
	def get_comments_for_photoID(photoID):
		select = 'SELECT * from ' + self.COMMENTS_TABLE + " where photoID="+str(photoID)
		comments = self.__execute(select).fetchall()
		return self.comments_with_columns(comments)

	#Mark: Column Helpers
	def get_column_names(self, table_name):
		select = 'SELECT * from ' + str(table_name)
		cursor = self.__execute(select)
		return [description[0] for description in cursor.description]

	def photos_columns(self):
		return self.get_column_names(self.PHOTOS_TABLE)

	def albums_columns(self):
		return self.get_column_names(self.ALBUMS_TABLE)

	def tags_columns(self):
		return self.get_column_names(self.TAG_TABLE)

	def comment_columns(self):
		return self.get_column_names(self.COMMENTS_TABLE)

	#Mark: SQL Helpers
	def __execute(self, statement):
		db = sqlite3.connect(self.DB_NAME)
		cursor = db.cursor()
		executed = cursor.execute(statement)
		printer.pretty_print("Executed: " + str(statement))
		return executed

	def __update(self, statement):
		db = sqlite3.connect(self.DB_NAME)
		cursor = db.cursor()
		committed = cursor.execute(statement)
		printer.pretty_print("Prepared for Commit: " + str(statement))
		db.commit()
		printer.pretty_print("Saving to the database.")

	def __commit(self, statement, values):
		db = sqlite3.connect(self.DB_NAME)
		cursor = db.cursor()
		committed = cursor.execute(statement, values)
		printer.pretty_print("Prepared for Commit: " + str(statement))
		db.commit()
		printer.pretty_print("Saving to the database.")
		db.close()

	#Mark: List of Dictionary Helpers
	def photos_with_columns(self, photos):
		resulting_photos = []
		columns = self.photos_columns()
		for photo in photos:
			resulting_photos.append(dict(zip(columns, photo)))
		return resulting_photos

	def albums_with_columns(self, albums):
		resulting_albums = []
		columns = self.albums_columns()
		for album in albums:
			resulting_albums.append(dict(zip(columns, album)))
		return resulting_albums

	def tags_with_columns(self, tags):
		resulting_tags = []
		columns = self.tags_columns()
		for tag in tags:
			resulting_tags.append(dict(zip(columns, tags)))
		return resulting_tags

	def comments_with_columns(self, comments):
		resulting_comments = []
		columns = self.comment_columns()
		for comment in comments:
			resulting_comments.append(dict(zip(columns, comments)))
		return resulting_comments
