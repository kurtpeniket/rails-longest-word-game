require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def new
    grid
  end

  def score
    @attempt = params[:word]
    run_game(@attempt, grid, 10, 5)
  end

  private 

  def grid
    letters_arr = ('A'...'Z').to_a
    @grid = letters_arr.sample(10)
  end

  def in_grid?(attempt, grid)
    @attempt.chars.all? { |letter| @attempt.count(letter) <= @grid.count(letter) }
  end
  
  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : @attempt.size * (1.0 - time_taken / 60.0)
  end

  def run_game(attempt, grid, start_time, end_time)

    total_time = end_time - start_time
  
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    data = URI.open(url).read
    hash_check = JSON.parse(data)
    if hash_check["found"] && in_grid?(@attempt.upcase, @grid) == true
      return @result = {
        time: total_time,
        score: compute_score(@attempt, total_time),
        message: "well done!"
      }
    elsif hash_check["found"] == true && in_grid?(@attempt.upcase, @grid) == false
      return @result = {
        time: total_time,
        score: 0,
        message: "not in the grid"
      }
    elsif hash_check["found"] == false && in_grid?(@attempt.upcase, @grid) == true
      return @result = {
        time: total_time,
        score: 0,
        message: "not an english word"
      }
    else
      return "invaild word"
    end
  end
end
