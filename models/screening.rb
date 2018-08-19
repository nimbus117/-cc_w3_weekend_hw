class Screening
  attr_accessor :show_time, :film_id, :capacity
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @show_time = options['show_time']
    @film_id = options['film_id'].to_i
    @capacity = options['capacity'].to_i
  end

  def save
    sql = "
      INSERT INTO screenings
        (show_time, film_id, capacity)
      VALUES
        ($1, $2, $3)
      RETURNING id
    "
    values = [@show_time, @film_id, @capacity]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "
      UPDATE
        screenings
      SET
        (show_time, film_id, capacity) = ($1, $2, $3)
      WHERE
        id = $4
      "
    values = [@show_time, @film_id, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "
      DELETE FROM
        screenings
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
        tickets
      INNER JOIN
        customers
      ON
        customers.id = tickets.customer_id
      WHERE
        tickets.screening_id = $1
    " 
    values = [@id]
    screening_customers = SqlRunner.run(sql, values)
    Customer.map_items(screening_customers)
  end

  def tickets
    sql = "
      SELECT
        *
      FROM
        tickets
      WHERE
        screening_id = $1
    " 
    values = [@id]
    screening_tickets = SqlRunner.run(sql, values)
    Ticket.map_items(screening_tickets)
  end

  def ticket_count
      tickets.count
  end

  def ticket_count_sql
    sql = "
      SELECT
        COUNT(*)
      FROM
        tickets
      WHERE
        screening_id = $1
    "
    values = [@id]
    SqlRunner.run(sql, values)[0]['count'].to_i
  end

  def film
    sql = "
      SELECT
        *
      FROM
        films
      WHERE
        id = $1
    "
    values = [@film_id]
    returned_film = SqlRunner.run(sql, values)[0]
    Film.new(returned_film)
  end

  def Screening.map_items(screening_data)
    screening_data.map {|screening| Screening.new(screening)}
  end

  def Screening.all
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    Screening.map_items(screenings)
  end

  def Screening.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end
end
