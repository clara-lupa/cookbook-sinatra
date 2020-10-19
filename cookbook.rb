require 'csv'
require 'nokogiri'
require_relative 'recipe'
require_relative 'service'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    import_csv
    puts "cookbook initialized"
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    add_to_csv(recipe)
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    update_csv
  end

  def find(index)
    return @recipes[index]
  end

  def update_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.done?, recipe.author]
      end
    end
  end

  private

  def import_csv
    CSV.foreach(@csv_file_path) do |row|
      recipe = Recipe.new(row.first, row[1], row[2], row[3] == 'true', row[4])
      @recipes << recipe
    end
  end

  def add_to_csv(recipe)
    CSV.open(@csv_file_path, 'a+') do |row|
      row << [recipe.name, recipe.description, recipe.rating, recipe.done?, recipe.author]
    end
  end
end
