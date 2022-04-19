#!/usr/bin/env python 

from os import environ 
from pymongo import MongoClient

mongodb_host          = environ.get('MONGO_HOST')
mongodb_port          = environ.get('PRITUNL_MONGODB_SERVICE_PORT_MONGODB')
mongodb_root_password = environ.get('MONGODB_ROOT_PASSWORD')

client = MongoClient("pritunl-mongo:2107",
                      username='root',
                      password='{}'.format(mongodb_root_password))

client.testdb.add_user('newTestUser', 'Test123', roles=[{'role':'readWrite','db':'testdb'}])
