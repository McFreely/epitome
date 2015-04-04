require 'matrix'

module Hemingway
  class Corpus
    attr_reader :corpus
    def initialize(document_collection)
      # Massage the document_collection into a more workable form
      @corpus = {}
      document_collection.each { |document| @corpus[document.id] = document.text }

      # Dictionary of term-frequency for each word
      # to avoid unnecessary computations
      @word_tf_doc = {}

      # Just the sentences
      @sentences = @corpus.values.flatten

      # The number of documents in the corpus
      @n_docs = @corpus.keys.size
    end

    def summary(summary_length, threshold=0.2)
      s = @sentences
      # n is the number of sentences in the total corpus
      n = @corpus.values.flatten.size

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
    def n_docs_including_w(word)
      # Count the number of documents in the corpus containing the word
      # Look for the word in the dictionnary first, calculate if not present
      @word_tf_doc.fetch(word) do |w|
        count = 0
        docs = []

        # Concanate the each document sentences to make it easier to search
        @corpus.values.each { |sentences| docs << sentences.join(" ") }

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
      Math.log( @n_docs / n_docs_including_w(word) )
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

