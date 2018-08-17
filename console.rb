require('pry-byebug')
require_relative('db/sql_runner.rb')
require_relative('models/film.rb')

Film.delete_all

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


binding.pry
nil
