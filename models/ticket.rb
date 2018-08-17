class Ticket
  attr_accessor :screening_id, :customer_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @screening_id = options['screening_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  def save
    sql = "
      INSERT INTO tickets
        (screening_id, customer_id)
      VALUES
        ($1, $2)
      RETURNING id
    "
    values = [@screening_id, @customer_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = "
      UPDATE
        tickets
      SET
        (screening_id, customer_id) = ($1, $2)
      WHERE
        id = $3
      "
    values = [@screening_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "
      DELETE FROM
        tickets
      WHERE
        id = $1
      "
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def Ticket.map_items(ticket_data)
    ticket_data.map {|ticket| Ticket.new(ticket)}
  end

  def Ticket.all
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    Ticket.map_items(tickets)
  end

  def Ticket.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

end
