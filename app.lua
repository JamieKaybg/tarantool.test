#!/usr/bin/tarantool

local crypto = require('crypto')

box.cfg{
   listen = 3302;
   memtx_memory = 512 * 1024 * 1024; -- 512MB
}

box.schema.user.passwd('admin', '123')

--print(crypto.digest.sha256('1234567812345678'))

box.execute('DROP TABLE IF EXISTS clients')
box.execute('CREATE TABLE clients (apikey VARCHAR(32) PRIMARY KEY, name VARCHAR(100), enabled INTEGER)')
box.execute("INSERT INTO clients VALUES (?, 'testa_klients', 1)", { crypto.digest.sha256('1234567812345678') })
--box.execute("UPDATE clients SET enabled=0 WHERE apikey='1234567812345678'")

require 'server'

require 'console'.start()
os.exit()