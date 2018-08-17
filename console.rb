require('pry-byebug')
require_relative('db/sql_runner.rb')
require_relative('models/film.rb')
require_relative('models/customer.rb')
require_relative('models/ticket.rb')

Ticket.delete_all
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

ticket1 = Ticket.new({
  'film_id' => film1.id,
  'customer_id' => customer1.id
})
ticket1.save

ticket2 = Ticket.new({
  'film_id' => film2.id,
  'customer_id' => customer2.id
})
ticket2.save


binding.pry
nil
