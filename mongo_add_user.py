#!/usr/bin/env python

from os import environ
from pymongo import MongoClient

# mongodb_host          = environ.get('MONGO_HOST')
# mongodb_port          = environ.get('PRITUNL_MONGODB_SERVICE_PORT_MONGODB')
mongodb_root_password = environ.get('MONGODB_ROOT_PASSWORD')

client = MongoClient("pritunl-mongodb:27017",
                      username='root',
                      password='{}'.format(mongodb_root_password))
                      
pritunldb = client["pritunl"]
dblist = pritunldb.list_database_names()

if "pritunl" not in dblist:
    pritunldb = client["pritunl"]
    pritunldb.command("createUser", "admin", pwd="{}".format(mongodb_root_password), roles=["readWrite"])
else: 
    print("DB, and likely user, already exist") 

