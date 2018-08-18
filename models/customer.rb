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
        screenings
      ON
        screenings.id = tickets.screening_id
      INNER JOIN
        films
      ON
        screenings.film_id = films.id
      WHERE
        customers.id = $1
    " 
    values = [@id]
    films = SqlRunner.run(sql, values)
    Film.map_items(films)
  end

  def tickets
    sql = "
      SELECT
        *
      FROM
        tickets
      WHERE
        customer_id = $1
    "
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    Ticket.map_items(tickets)
  end

  def ticket_count
    tickets.count
  end

  def ticket_sql_count
    sql = "
      SELECT
        COUNT(*)
      FROM
        tickets
      WHERE
        customer_id = $1
    "
    values = [@id]
    SqlRunner.run(sql, values)[0]['count'].to_i
  end

  def buy_ticket(screening)
    capacity = screening.capacity
    total_bookings = screening.tickets.count
    price = screening.film.price
    # p capacity
    # p total_bookings
    # p price

    if capacity - total_bookings > 0
      if @funds >= price

        bought_ticket = Ticket.new({
          'screening_id' => screening.id,
          'customer_id' => @id
        })
        bought_ticket.save
        
        @funds -= price
        update
      end
    end
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
