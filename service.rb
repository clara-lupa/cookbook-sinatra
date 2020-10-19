require 'open-uri'
require 'nokogiri'

class Service
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def scrape_allmyrecipes
    url = "https://www.allrecipes.com/search/?wt=#{@ingredient}"
    # file = 'strawberry.html~'  # replace with open-uri
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    recipes_title_and_descr = extract_title_and_description(doc)
    recipes_ratings = extract_ratings(doc)
    recipes_authors = extract_authors(doc)
    recipes = recipes_title_and_descr.each_with_index do |rec_hash, index|
      rec_hash[:rating] = recipes_ratings[index]
      rec_hash[:author] = recipes_authors[index]
    end
    return recipes
  end

  private

  def extract_title_and_description(doc)
    recipes = doc.search('.fixed-recipe-card__img')
    recipes = recipes.map do |nok_el|
      alt_text = nok_el.attribute('alt').to_s.split(/Recipe.*-/)
      { title: alt_text.first.strip, description: alt_text.last.strip }
    end
    return recipes.first(5)
  end

  def extract_ratings(doc)
    ratings = doc.search('.stars')
    ratings = ratings.map do |nok_el|
      rating_string = nok_el.attribute('aria-label').to_s
      rating_string.match(/\d\.?(\d{2})?/)[0].to_f.round
    end
    return ratings.first(5)
  end

  def extract_authors(doc)
    authors = doc.search('h4') # ('.fixed-recipe-card__img')
    authors = authors.map do |nok_el|
      nok_el.text.delete("By").strip
    end
    return authors.first(5)
  end
end
