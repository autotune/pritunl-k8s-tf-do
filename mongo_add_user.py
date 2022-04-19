#!/usr/bin/env python 

from os import environ 
from pymongo import MongoClient

mongodb_host          = environ.get('MONGO_HOST')
mongodb_port          = environ.get('PRITUNL_MONGODB_SERVICE_PORT_MONGODB')
mongodb_root_password = environ.get('MONGODB_ROOT_PASSWORD')

client = MongoClient("{}:{:03d}").format(mongodb_host, mongodb_port)  
client.admin.authenticate('root', '%s')
client.testdb.add_user('newTestUser', 'Test123', roles=[{'role':'readWrite','db':'testdb'}])
