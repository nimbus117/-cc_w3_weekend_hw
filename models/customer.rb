class Customer
  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save
    sql = "
      INSERT INTO customers
        (name, funds)
      VALUES
        ($1, $2)
      RETURNING id
    "
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "
      UPDATE
        customers
      SET
        (name, funds) = ($1, $2)
      WHERE
        id = $3
      "
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "
      DELETE FROM
        customers
      WHERE
        id = $1
      "
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films
    sql = "
      SELECT
        films.*
      FROM
        customers
      INNER JOIN
        tickets
      ON
        tickets.customer_id = customers.id
      INNER JOIN
        films
      ON
        films.id = tickets.film_id
      WHERE
        customers.id = $1
    " 
    values = [@id]
    films = SqlRunner.run(sql, values)
    Film.map_items(films)
  end

  def Customer.map_items(customer_data)
    customer_data.map {|customer| Customer.new(customer)}
  end

  def Customer.all
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    Customer.map_items(customers)
  end

  def Customer.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

end
