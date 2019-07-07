#!/usr/bin/tarantool

local home_dir = os.getenv("HOME")
local DATA_DIR = home_dir .. "/Projects/Tarantool_Test/data"

print(DATA_DIR)

box.cfg{
   listen = 3302,
   memtx_memory = 512 * 1024 * 1024, -- 512MB
   memtx_dir = DATA_DIR,
   vinyl_dir = DATA_DIR,
   wal_dir = DATA_DIR
}

box.schema.user.passwd('admin', '123')

box.execute('DROP TABLE IF EXISTS clients')
box.execute([[CREATE TABLE clients (apikey VARCHAR(16) PRIMARY KEY, 
                                    name VARCHAR(50), 
                                    enabled INTEGER)]])
local params = {}
params[1] = '1234567812345678'
params[2] = 'testa_klients'
params[3] = 1

box.execute("INSERT INTO clients VALUES ($1, $2, $3)", params)
--box.execute("UPDATE clients SET enabled=0 WHERE apikey='1234567812345678'")

require 'server'

require 'console'.start()
os.exit()