require "scalpel"
require "stopwords"

module Hemingway
  class Document
    attr_reader :id
    attr_reader :text
    def initialize(text)
      @id = SecureRandom.uuid
      @text = clean text
    end

    def clean(text)
      text = text.downcase
      
      # Cut the text into its constituent sentences
      sentences = Scalpel.cut text
      
      # Filter the stopword in each sentence
      filter = Stopwords::Snowball::Filter.new "en"
      sentences.map {|sentence| filter.filter(sentence.split).join(" ")}
    end
  end
end
