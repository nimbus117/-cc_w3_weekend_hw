require('pry-byebug')
require_relative('db/sql_runner.rb')
require_relative('models/film.rb')
require_relative('models/customer.rb')

Film.delete_all
Customer.delete_all

film1 = Film.new({
  'title' => 'Evolution',
  'price' => 10
})
film1.save

film2 = Film.new({
  'title' => 'Amazing Grace',
  'price' => 10
})
film2.save

customer1 = Customer.new({
  'name' => 'Bob',
  'funds' => 50
})
customer1.save

customer2 = Customer.new({
  'name' => 'Mindy',
  'funds' => 70
})
customer2.save

binding.pry
nil
