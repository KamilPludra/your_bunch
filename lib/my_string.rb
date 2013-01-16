# my_string.rb
module BBCodeizer
  class << self
    Tags[:smiley1] = [/\:\-?\)/, '<img title=":)" src="/images/emoticons/smile.png" alt="smile"/>']
    Tags[:smiley2] = [/\;\-?\)/, '<img title=";)" src="/images/emoticons/wink.png" alt="wink" />']
    Tags[:smiley3] = [/\:\-?\(/, '<img title=":(" src="/images/emoticons/sad.png" alt="sad" />']

    TagList += [:smiley1, :smiley2, :smiley3]
  end
end