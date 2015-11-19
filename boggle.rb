# To run this program in IRB:
# > load 'boggle.rb'
# > @p = Boggle.new
# => #<Boggle:0x007fe9a774afe8 @boggle=[["n", "a", "i", "a"], ["e", "o", "l", "w"], ["e", "t", "a", "t"], ["r", "o", "l", "t"]]>
# > @p.tally_points
# => 10

class Boggle
  load 'words.rb'

  MAX_ROW = 4
  MAX_COL = 4
  NUM_DICES = MAX_ROW * MAX_COL

  DICE_1 = 'aeaneg'; DICE_2 = 'ahspco'; DICE_3 = 'aspffk'; DICE_4 = 'objoab'
  DICE_5 = 'iotmuc'; DICE_6 = 'ryvdel'; DICE_7 = 'lreixd'; DICE_8 = 'eiunes'
  DICE_9 = 'wngeeh'; DICE_10 = 'lnhnrz'; DICE_11 = 'tstiyd'; DICE_12 = 'owtoat'
  DICE_13 = 'erttyl'; DICE_14 = 'toessi'; DICE_15 = 'terwhv'; DICE_16 = %w[n u i h m qu]

  # Distribution:
  # A-6    H-5    O-7    V-2
  # B-2    I-6    P-2    W-3
  # C-2    J-1    Qu-1   X-1
  # D-3    K-1    R-5    Y-3
  # E-11   L-4    S-6    Z-1
  # F-2    M-2    T-9
  # G-2    N-6    U-3

  def initialize
    dices = [DICE_1, DICE_2, DICE_3, DICE_4,
              DICE_5, DICE_6, DICE_7, DICE_8,
              DICE_9, DICE_10, DICE_11, DICE_12,
              DICE_13, DICE_14, DICE_15, DICE_16]

    shuffled = shuffle_dices(dices)

    @boggle = []
    @boggle << get_row(shuffled[0..3])
    @boggle << get_row(shuffled[4..7])
    @boggle << get_row(shuffled[8..11])
    @boggle << get_row(shuffled[12..15])
  end

  def score_of(word)
    valid_words = dictionary_by_length
    if valid_words[word.length-3].include? word
      length = word.length
      case
      when length == 3 || length == 4
        1
      when length == 5
        2
      when length == 6
        3
      when length == 7
        5
      when length == 8
        11
      when length > 8
        11 + (length - 8)
      else
        0
      end
    else
      0
    end
  end

  def tally_points
    output = {}
    total = 0
    found_words.each do |w|
      score = score_of(w)
      output[w] = score if score > 0
      total += score
    end
    puts "Total score is #{total}."
    output.each { |k, v| puts("--#{k} is #{v} point(s).") }
  end

  def shuffle_dices(dices)
    dices.shuffle
  end

  def get_row(dices)
    row = []
    dices.each { |dice| row << dice[0] }
    return row
  end

  def adjacent?(dice_1, dice_2)
    # dice_1 and dice_2 are arrays [x][y]
    return false if dice_1 == dice_2
    # calculate distance
    (dice_1[0] - dice_2[0])**2 + (dice_1[1] - dice_2[1])**2 <= 2
  end

  def get_adjacent_of(dice)
    adjacent_dices = []
    (0..3).each do |i|
      (0..3).each do |j|
        adjacent_dices << [i,j] if adjacent?(dice, [i,j])
      end
    end
    return adjacent_dices
  end

  def random(r)
    p = Random.new
    p.rand(r)
  end

  def to_next(dice)
    where_to_go = get_adjacent_of(dice)
    return where_to_go[random(where_to_go.length)]
  end

  def traverse(max_length)
    letters = []
    old_dice = []
    current_dice = [random(0..3), random(0..3)]
    covered = {}
    covered_words = {}
    word_length = 3

    # search for words from length=3 to length=16
    while word_length <= max_length
      $i = 0
      covered[word_length] = []
      covered_words[word_length] = []

      while $i < word_length

        surround = get_adjacent_of(current_dice)

        if ( surround & covered[word_length] ).length == surround.length
          $i = word_length + 1

        else
          next_dice = to_next(current_dice)
          if !covered[word_length].include? next_dice

            old_dice, current_dice = current_dice, next_dice
            covered[word_length] << old_dice
            covered_words[word_length] << get_letter(old_dice)

            $i += 1
          end
        end
      end
      word_length += 1

    end
    return covered_words
  end

  def get_letter(dice)
    @boggle[dice[0]][dice[1]]
  end

  def found_words
    # Each player play time is 3 minutes.
    found_words = []
    5.times do
      traverse(3).values.each { |v| found_words << v.join } # 3s for each traverse
      traverse(4).values.each { |v| found_words << v.join } # 3s * (5*3) = 45s
      traverse(5).values.each { |v| found_words << v.join }
    end
    3.times do
      traverse(6).values.each { |v| found_words << v.join } # 8s each
      traverse(7).values.each { |v| found_words << v.join } # 8s * (3*2) = 48s
    end
    1.times do
      traverse(8).values.each { |v| found_words << v.join } # 12.5s each
      traverse(9).values.each { |v| found_words << v.join } # 12.5s * (1*3) = 37.5s
      traverse(10).values.each { |v| found_words << v.join }
    #   traverse(11).values.each { |v| found_words << v.join }
    #   traverse(12).values.each { |v| found_words << v.join }
    #   traverse(13).values.each { |v| found_words << v.join }
    #   traverse(14).values.each { |v| found_words << v.join }
    #   traverse(15).values.each { |v| found_words << v.join }
    #   traverse(16).values.each { |v| found_words << v.join }
    end
    return found_words.uniq
  end

  def dictionary_by_length
    length_3 = []; length_4 = []; length_5 = []; length_6 = []; length_7 = [];
    length_8 = []; length_9 = []; length_10 = []; length_11 = []; length_12 = [];
    length_13 = []; length_14 = []; length_15 = []; length_16 = []; excluded = [];

    dictionary.each do |d|
      word_length = d.length
      case word_length
      when 3
        length_3 << d
      when 4
        length_4 << d
      when 5
        length_5 << d
      when 6
        length_6 << d
      when 7
        length_7 << d
      when 8
        length_8 << d
      when 9
        length_9 << d
      when 10
        length_10 << d
      when 11
        length_11 << d
      when 12
        length_12 << d
      when 13
        length_13 << d
      when 14
        length_14 << d
      when 15
        length_15 << d
      when 16
        length_16 << d
      else
        excluded << d
      end
    end
    return [length_3, length_4, length_5, length_6, length_7, length_8, length_9, length_10,
            length_11, length_12, length_13, length_14, length_15, length_16]
  end

end