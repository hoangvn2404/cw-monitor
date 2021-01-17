require 'open-uri'
require 'pry'

class UpdatePriceJob < ApplicationJob
  queue_as :default

  def perform(w_id)
    w = Warrant.find w_id
    w.update_price
  end
end
