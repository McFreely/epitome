require "scalpel"
require "securerandom"

module Epitome
  class Document
    attr_reader :id
    attr_reader :text
    def initialize(text)
      @id = SecureRandom.uuid
      @text = Scalpel.cut text
    end
  end
end
