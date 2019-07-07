local http = require('http.server')
local json = require("json")
local log = require('log')
local client = require 'client'.model()

local function unauthorized()
    return {
        status = 401,
        headers = { ['content-type'] = 'application/json' },
        body = json.encode({ message='Piekļuve liegta' })            
    }
end

local function authorize(req)
    local apikey = req.headers['x-apikey']

    if apikey == nil then
        log.error('[%s] Nav norādīts ApiKey', req.peer.host)
        return unauthorized()
    end

    local params = {}
    params[1] = apikey
    local db_client = box.execute("SELECT * FROM clients WHERE apikey=$1", params)
    
    if db_client.rows[1] == nil then
        log.error('[%s] ApiKey %s neeksistē', req.peer.host, apikey)
        return unauthorized()
    end

    if db_client.rows[1][client.ENABLED] == 0 then
        log.error('[%s] Klients %s ir atspējots', req.peer.host, db_client.rows[1][client.NAME])
        return unauthorized()
    end

    return { 
        status = 200, 
        client = db_client.rows[1] 
    }
end

local function client_handler(req)
    local auth_result = authorize(req)
    if auth_result.status ~= 200 then
        return auth_result
    end
    local result = { client = auth_result.client }
    local resp = req:render({ json = result })
    return resp
end

local httpd = http.new(nil, 8080, { 
    log_requests = false, 
    charset = "utf-8", 
    app_dir = "./wwwroot" 
})

httpd:route({ path = "/" }, function(req) return req:redirect_to('/admin/') end)
httpd:route({ path = '/admin/', file = 'index.html' })
httpd:route({ path = '/client/', method = 'GET' }, client_handler)
httpd:start()
