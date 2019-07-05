#!/usr/bin/tarantool

box.cfg{
   listen = 3302;
   memtx_memory = 512 * 1024 * 1024; -- 512MB
}

box.schema.user.passwd('admin', '123')

--box.execute('DROP TABLE clients')
--box.execute('CREATE TABLE clients (apikey VARCHAR(16) NOT NULL PRIMARY KEY, name VARCHAR(100) NOT NULL, enabled INTEGER NOT NULL)')
--box.execute("INSERT INTO clients VALUES ('1234567812345678', 'testa_klients', 1)")
--box.execute("UPDATE clients SET enabled=0 WHERE apikey='1234567812345678'")

require 'server'

require 'console'.start()
os.exit()