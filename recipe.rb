class Recipe
  attr_reader :name, :description, :rating, :author

  def initialize(name, description, rating, done, author)
    @name = name
    @description = description
    @rating = rating
    @done = done
    @author = author
  end

  def done?
    return @done
  end

  def mark_as_done
    @done = true
  end
end
