require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require "./lib/message_table"
require "./lib/comment_table"


class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @message_table = MessageTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @comment_table = CommentTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
  end

# -----get-----
  get "/" do
    messages = @message_table.all
    comments_by_message_id = @comment_table.all.group_by{ |comment| comment["message_id"]}  #group by message id???
    erb :home, locals: {messages: messages, comments_by_message_id: comments_by_message_id}
  end

  get "/messages/:id/edit" do
    message = @message_table.find(params[:id])
    erb :"messages/edit", locals: {message: message}
  end

  get "/messages/:id/comment" do
    message = @message_table.find(params[:id])
    erb :"messages/comment", locals: {message: message}
  end




# -----post-----
  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @message_table.create(message)
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  post "/comments/:id/comment" do
    comment = params[:comment]
    if comment.length <= 140
      @comment_table.create(comment, params[:id])
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect "/comments/#{params[:id]}/comment"
    end

    flash[:error] = "comment added"

    redirect "/"
  end


  #   comment = params[:comment]
  #   message_id = params[:message_id] #not sure if :id is right
  #   if comment.length <= 140
  #     @comment_table.create(comment, message_id)
  #   else
  #     flash[:error] = "Comment must be less than 140 characters."
  #   end
  #   redirect "/"
  # end




# -----patch-----
  patch "/messages/:id" do

    message = params[:message]
    if message.length <= 140
      @message_table.update(params[:id],message)
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect "/messages/#{params[:id]}/edit"
    end

    flash[:error] = "message updated"

    redirect "/"
  end


# -----delete-----
  delete "/messages/:id" do
    @message_table.delete(params[:id])

    flash[:error] = "message deleted"

    redirect "/"
  end



end#class end