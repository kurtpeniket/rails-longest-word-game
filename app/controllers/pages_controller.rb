require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def new
    grid
  end

  def score
    @attempt = params[:word]
    run_game(@attempt, grid)
  end

  private 

  def grid
    letters_arr = ('A'...'Z').to_a
    @grid = letters_arr.sample(10)
  end

  def in_grid?(attempt, grid)
    @attempt.chars.all? { |letter| @attempt.count(letter) <= @grid.count(letter) }
  end
  
   def run_game(attempt, grid)

    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    data = URI.open(url).read
    hash_check = JSON.parse(data)
    if hash_check["found"] && in_grid?(@attempt.upcase, @grid) == true
      return "Well done!"
    elsif hash_check["found"] == true && in_grid?(@attempt.upcase, @grid) == false
      return "The letters for #{@attempt} were not in the grid"
    elsif hash_check["found"] == false && in_grid?(@attempt.upcase, @grid) == true
      return "That was not a vaild English word"
    else
      return "Invaild word"
    end
  end
end
