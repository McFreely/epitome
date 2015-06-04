require 'matrix'
require 'stopwords'
require 'pry'

module Epitome
  class Corpus
    attr_reader :original_corpus
    def initialize(document_collection, lang="en")
      # lang is the language used to initialize the stopword list
      @lang = lang

      # Massage the document_collection into a more workable form
      @original_corpus = {}
      document_collection.each { |document| @original_corpus[document.id] = document.text }
      @clean_corpus = {}
      @original_corpus.each do |key, value|
        @clean_corpus[key] = clean value
      end

      # Dictionary of term-frequency for each word
      # to avoid unnecessary computations
      @word_tf_doc = {}

      # Just the sentences
      @sentences = @original_corpus.values.flatten

      # The number of documents in the corpus
      @n_docs = @original_corpus.keys.size
      
    end

    def summary(summary_length, threshold=0.2)
      s = @clean_corpus.values.flatten
      # n is the number of sentences in the total corpus
      n = @clean_corpus.values.flatten.size

      # Vector of Similarity Degree for each sentence in the corpus
      degree = Array.new(n) {0.00} 

      # Square matrix of dimension n = number of sentences
      cosine_matrix = Matrix.build(n) do |i, j|
        if idf_modified_cosine(s[i], s[j]) > threshold
          degree[i] += 1.0
          1.0
        else
          0.0
        end
      end
      
      # Similarity Matrix
      similarity_matrix = Matrix.build(n) do |i,j|
        degree[i] == 0 ? 0.0 : ( cosine_matrix[i,j] / degree[i] )
      end

      # Random walk ala PageRank
      # in the form of a power method
      results = power_method similarity_matrix, n, 0.85

      # Ugly sleight of hand to return a text based on results
      # <Array>Results => <Hash>Results => <String>ResultsText
      h = Hash[@sentences.zip(results)]
      return h.sort_by {|k, v| v}.reverse.first(summary_length).to_h.keys
    end

    private
    def clean(sentence_array)
      # Clean the sentences a bit to avoid unnecessary operations
      #
      # Create stopword filter
      filter = Stopwords::Snowball::Filter.new @lang 
      sentence_array.map do |s| 
        s = s.downcase
        filter.filter(s.split).join(" ")
      end
    end

    def n_docs_including_w(word)
      # Count the number of documents in the corpus containing the word
      # Look for the word in the dictionnary first, calculate if not present
      @word_tf_doc.fetch(word) do |w|
        count = 0
        docs = []

        # Concanate the each document sentences to make it easier to search
        @clean_corpus.values.each { |sentences| docs << sentences.join(" ") }

        # Here, we user an interpolated string instead of a regex to avoid
        # weird corner cases
        docs.each { |s| count += 1 if s.include? "#{word}" }

        @word_tf_doc[w] = count
        count
      end
    end

    def idf(word)
      # Number of documents in which word appears
      # Inverse Frequency Smooth (as per wikipedia article)
      result = Math.log( @n_docs / n_docs_including_w(word) )

      # Return 1 to avoid words having all the same td_idf by multiplying by 0
      return result == 0 ? 1.0 : result 
    end

    def tf(sentence, word)
      # Number of occurences of word in sentence
      sentence.scan(word).count
    end

    def sentence_tfidf_sum(sentence)
      # The Sum of tfidf values for each of the words in a sentence
      sentence.split(" ")
        .map { |word|  (tf(sentence, word)**2) * idf(word) }
        .inject(:+)
    end

    def idf_modified_cosine(x, y)
      # Compute the similarity between two sentences x, y
      # using the modified cosine tfidf formula
      numerator = (x + " " + y).split(" ")
                    .map { |word| tf(x, word) * tf(y, word) * (idf(word)**2) }
                    .inject(:+)

      denominator = Math.sqrt(sentence_tfidf_sum(x)) * Math.sqrt(sentence_tfidf_sum(y))
      numerator / denominator
    end      

    def power_method(matrix, n, e)
      # Accept a stochastic, irreducible & aperiodic matrix M
      # Accept a matrix size n, an error tolerance e
      # Output Eigenvector p
      
      # init values
      t = 0
      p = Vector.elements(Array.new(n) { (1.0 / n) * 1} )
      sigma = 1

      until sigma < e
        t += 1
        prev_p = p.clone
        p = matrix.transpose * prev_p
        sigma = (p - prev_p).norm
      end
      
      p.to_a
    end
  end
end

