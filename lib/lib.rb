$LOAD_PATH << File.dirname(__FILE__)

require 'faye/websocket'
require 'thread'
require 'redis'
require 'json'
require 'erb'

require 'sinatra/base'
require 'resque'

require 'middleware/socket'
require 'gorilla'
require 'daemon'