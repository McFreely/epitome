# Hemingway

A small gem to make your text shorter. It's an implementation of the Lexrank algorithm. You can use it on a single text, but lexrank is designed to be used on a collection of texts. But it works the same anyway.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hemingway'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hemingway

## Usage

Firstly, you need to create some documents.

```ruby
document_one = Hemingway::Document.new("The cat likes catnip. He rolls and rolls")
document_two = Hemingway::Document.new("The cat plays in front of the dog. The dog is placid.")
```

Then, organize your documents in a corpus

```ruby
document_collection = [document_one, document_two]
@corpus = Hemingway::Corpus.new(document_collection)
```

Finally, ask Ernest for a summary
```ruby
@corpus.summary(length=3)
```

This returns a nice, short text.

## Options
### Summary options
You can pass options to set the length of the expected summary, and set the similarity threshold
```ruby
@corpus.summary(5, 0.2)
```
The length is the number of sentences of the final output.

The threshold is a value between 0.1 and 0.3, but 0.2 is considered to give the best results (and thus the default value).

### Stopword option
When creating the corpus, you can set the language of the stopword list to be used
```ruby
@corpus = Hemingway::Corpus.new(document_collection, "fr")
```
The default value is english "en".
You can find more about the stopword filter [here](https://github.com/brenes/stopwords-filter).
## Contributing

1. Fork it ( https://github.com/[my-github-username]/hemingway/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
