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

listing = pritunldb.command('usersInfo')['users']

users = []

for user in range(0, len(listing)):
    users.append(listing[user]['user'])

if 'pritunl' not in users:
    print('pritunl user not found, creating pritunl user')
    pritunldb.command("createUser", "pritunl", pwd="{}".format(mongodb_root_password), roles=["readWrite"])
else:
    print('pritunl user found, exiting!')
    exit
