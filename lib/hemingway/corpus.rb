module Hemingway
  class Corpus
    attr_reader :corpus
    def initialize(document_collection)
      @corpus = {}
      document_collection.each do |document|
        @corpus[document.id] = document.text
      end
    end
  end
end

