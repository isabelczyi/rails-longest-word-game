require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    $letters = (0...10).map { ('A'..'Z').to_a[rand(25)] }
  end

  def score
    @attempt = params[:attempt]
    word_check = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}").read
    word_stats_hash = JSON.parse(word_check)
    check_one = word_stats_hash['found']
    attempt_array = @attempt.upcase.scan(/\w/)
    check_two = attempt_array.all? do |letter|
      attempt_array.count(letter) <= $letters.count(letter)
    end

    if check_one == true && check_two == true
      @response = "<strong>Congratulations!</strong> #{@attempt.upcase} is a valid English word!"
    elsif check_one == true && check_two == false
      @response = "Sorry but <strong>#{@attempt.upcase}</strong> can't be built out of #{$letters.join(', ')}."
    elsif check_one == false
      @response = "Sorry but <strong>#{@attempt.upcase}</strong> does not seem to be a valid English word..."
    end
  end
end
