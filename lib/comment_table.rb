class CommentTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(comment, message_id)
    insert_comment_sql = <<-SQL
      INSERT INTO comments (comment, message_id)
      VALUES ('#{comment}','#{message_id}')
      RETURNING id
    SQL

    @database_connection.sql(insert_comment_sql).first["id"]
  end

  def find(message_id)
    database_connection.sql("SELECT comment FROM comments WHERE message_id = #{message_id}")
  end


  def all
    database_connection.sql("SELECT * FROM comments")
  end

  def group
    group_comment_sql = <<-SQL
      SELECT comments.comment, messages.message, messages.id
      FROM messages
      INNER JOIN comments ON comments.message_id = messages.id
      GROUP BY comments.comment, messages.message, messages.id

    SQL

    @database_connection.sql(group_comment_sql) #.first["id"] #RETURNING id
  end



end#class end