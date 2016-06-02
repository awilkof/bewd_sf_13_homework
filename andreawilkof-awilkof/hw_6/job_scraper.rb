require 'pry'
require 'pry-byebug'
require 'mechanize'
require_relative 'job_class'
require 'csv'

#Prestep - inspect page and API to get an understanding of what will be scraped
  #IDs of query spaces:
    #search_distance, postal, query
  #IDs of attributes to use:
      #
#1 - Connect with mechanize and then review what comes back
def connect_scraper
  Mechanize.new
end

def search_results(form_values)
  results = form_values.submit
  results.search('p.row')
end

#Pass through parameters and save search results, then use other methods to use it
def scrape_it(position, url)
  connect_scraper.history_added = Proc.new { sleep 23.0}

  connect_scraper.get(url) do |search_page|
#This is where we manually enter the search parameters
    form_values = search_page.form_with(id: 'searchform') do |search|
      search['query'] = position
    end
    #Make these results raw results, then parse results using the new value
    raw_results = search_results(form_values)
    parse_results(raw_results)
  end
end

def parse_results(raw_results)

  raw_results.each do |listing|
    link = listing.css('a')[1]
    date = listing.search('span.pl').text[32..-50]
    name = link.text.strip
    neighborhood = listing.search('span.pnr').text[3..-13]
    url = "https://newyork.craigslist.org" + link.attributes["href"].value

    #Could not get this to work though it seems like it should be fine
    #Error was about scope of date, and I tried several things to get it to work.
    #Below saves each of the job listing instances to a j. scenario to be saved
    #j = Job_Listing.new(date, name, neighborhood, url)
    results = []

    #if the j. worked, this would be results << [j.date, j.name, j.neighborhood, j.url]
    #Since I couldn't get it, I figured this was the more direct way of making it happen.
    results << [date, name, neighborhood, url]
    create_csv(results)
  end
end

def create_csv(results)
  CSV.open("job_listings.csv", "w+") do |csv_file|
    results.each do |row|
      csv_file << row
    end
  end
end


#Query name and url
url = 'https://newyork.craigslist.org/search/wri'
position = "content"

#Not sure which parameters go in here...
scrape_it(url, position)




#parameter of keyword, in the area on the page (---body)
#if that area includes then save procede/save it to the array
#else, nothing
#Postingbody.includes?(keyword)
