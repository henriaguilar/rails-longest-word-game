class GamesController < ApplicationController
  def new
    @letters = (0...10).to_a.map { ('a'..'z').to_a.sample }
  end

  def parsing(word)
    require 'open-uri'
    require 'json'

    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    doc = JSON.parse(open(url).read)
    return doc["found"]
  end

  def score
    @guessed_word = params[:word].downcase
    @guessed_letters = @guessed_word.split('')
    @letters = params[:letters].split(' ')

    @good_guess = true
    @guessed_letters.each do |guessed_letter|
      letter_index = @letters.index(guessed_letter)
      if letter_index.nil?
        @good_guess = false
      else
        @letters.delete_at(letter_index)
      end
    end

    @english_guess = parsing(@guessed_word)
    if @good_guess && @english_guess
      @message = "Congratulations! #{@guessed_word.upcase} is a valid English word!"
    elsif @english_guess == false
      @message = "Sorry but #{@guessed_word.upcase} does not seem to be a valid English word..."
    else
      @message = "Sorry buy #{@guessed_word.upcase} can't be buld out of #{params[:letters].upcase}"
    end
  end
end
