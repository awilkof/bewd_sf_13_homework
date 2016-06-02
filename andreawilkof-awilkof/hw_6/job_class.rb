require 'pry'
require 'pry-byebug'

class Job_Listing
  attr_accessor :date, :name, :neighborhood, :url,

  def initialize(date, name, neighborhood, url)
    @date = date
    @name = name
    @neighborhood = neighborhood
    @url = url
  end

end
