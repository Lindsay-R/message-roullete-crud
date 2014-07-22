require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require "./lib/message_table"


class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @message_table = MessageTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    #@database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @message_table.all

    erb :home, locals: {messages: messages}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @message_table.create(message)
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id" do
    message = @message_table.find(params[:id])
    erb :"messages/show", locals: {message: message}
  end

  get "/messages/:id/edit" do
    message = @message_table.find(params[:id])
    erb :"messages/edit", locals: {message: message}
  end



  post "/messages" do
    id = @message_table.create(
      message: params[:message]
    )

    flash[:notice] = "message created"

    redirect "/messages/#{id}"
  end

  patch "/messages/:id" do
    @message_table.update(params[:id], {
      message: params[:message]
    })

    flash[:notice] = "message updated"

    redirect "/"
  end

  delete "/messages/:id" do
    @message_table.delete(params[:id])

    flash[:notice] = "message deleted"

    redirect "/"
  end



end#class end