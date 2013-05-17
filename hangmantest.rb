@dictionary = File.readlines("2of12.txt").map {|word| word.chomp("\n")}
@alphabet = ('a'..'z').to_a




def guess(hint_array, guessed_letters)
  candidate_words = @dictionary.select do |word|
    word.chomp.length == hint_array.length
  end

  hint_string = hint_array.join.gsub('_','.')

  candidate_words = candidate_words.select do |word|
    word.match /#{hint_string}/
  end

  candidate_letters = @alphabet.select do |letter|
    candidate_words.join.include?(letter) && !guessed_letters.include?(letter)
  end

  letter_frequencies = Hash.new(0)

  p candidate_words

  candidate_words.each do |word|
    candidate_letters.each do |letter|
      letter_frequencies[letter] += 1 if word.include? letter
    end
  end

  p letter_frequencies
  p letter_frequencies.values.max

  most_common_letter = nil
  highest_frequency = 0

  letter_frequencies.each do |key, value|
    most_common_letter, highest_frequency = key, value if value > highest_frequency
  end

  most_common_letter
end

p guess(%w{_ _ t}, %w{c a t})