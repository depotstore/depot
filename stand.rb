# require "active_record"
#
# ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
# database: 'db/development.sqlite3')
#
# class Order < ActiveRecord::Base
# end
require "./config/environment.rb"

order = Order.find(1)
puts order.name
