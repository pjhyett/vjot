class JotsController < ApplicationController
  
  def create
    jots = JSON.parse(params[:jots])
    jots.each do |jot|
      if jot["id"] =~ /s/
        Jot.create :title => jot["title"], :body => jot["body"], :user_id => params[:user_id]
      else
        vjot = Jot.first(jot["id"])
        vjot.title = jot["title"]
        vjot.body  = jot["body"]
        vjot.save
      end
    end
    render :update do |page|
      page['saved'].show
    end
  end
  
end