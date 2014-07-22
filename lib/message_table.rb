class MessageTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(message)
    insert_message_sql = <<-SQL
      INSERT INTO messages (message)
      VALUES ('#{message}')
      RETURNING id
    SQL

    @database_connection.sql(insert_message_sql).first["id"]
  end

  def all
    database_connection.sql("SELECT * FROM messages")
  end

  def find(id)
    database_connection.sql("SELECT * FROM messages WHERE id = #{id}").first
  end

  def update(id, attributes)

    update_sql = <<-SQL
    UPDATE messages
    SET message = '#{attributes[:message]}'
    WHERE id = #{id};
    SQL
    puts "--------------------------------"
    puts update_sql

    @database_connection.sql(update_sql)

  end

end#class end