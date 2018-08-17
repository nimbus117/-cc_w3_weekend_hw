class Film
  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save
    sql = "
      INSERT INTO films
        (title, price)
      VALUES
        ($1, $2)
      RETURNING id
    "
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "
      UPDATE
        films
      SET
        (title, price) = ($1, $2)
      WHERE
        id = $3
      "
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "
      DELETE FROM
        films
      WHERE
        id = $1
      "
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers
    sql = "
      SELECT
        customers.*
      FROM
        films
      INNER JOIN
        screenings
      ON
        films.id = screenings.film_id
      INNER JOIN
        tickets
      ON
        screenings.id = tickets.Screening_id
      INNER JOIN
        customers
      ON
        customers.id = tickets.customer_id
      WHERE
        films.id = $1
    " 
    values = [@id]
    customers = SqlRunner.run(sql, values)
    Customer.map_items(customers)
  end

  def customer_count
      customers.count
  end

  def Film.map_items(film_data)
    film_data.map {|film| Film.new(film)}
  end

  def Film.all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    Film.map_items(films)
  end

  def Film.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
