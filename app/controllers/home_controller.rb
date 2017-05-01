class HomeController < ApplicationController
  def index
    @client = Client.create
  end
end
