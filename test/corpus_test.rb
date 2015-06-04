require "minitest/autorun"

require "epitome/document"
require "epitome/corpus"

class CorpusTest < Minitest::Test
  def setup
    doc_one = "The cat likes to eat pasta. He wants more each time. Gorbachev was seen trynig to defuse the tension in the room with one of his hallmark jokes."
    doc_two = "Dog dog dog. Gorbachev prefer pesto sauce."
    @document_one = Epitome::Document.new(doc_one)
    @document_two = Epitome::Document.new(doc_two)
    document_collection = [@document_one, @document_two]
    @corpus = Epitome::Corpus.new(document_collection)
  end

  def test_document_preparation
    refute_empty @document_one.id
    refute_empty @document_two.id

    assert_equal ["The cat likes to eat pasta.", "He wants more each time.", "Gorbachev was seen trynig to defuse the tension in the room with one of his hallmark jokes."], @document_one.text
    assert_equal ["Dog dog dog.", "Gorbachev prefer pesto sauce."], @document_two.text
  end
  
  def test_corpus_generation
    assert_equal 2, @corpus.original_corpus.keys.size
    assert_equal 2, @corpus.original_corpus.values.size
  end

  def test_summary
    summary = @corpus.summary(4, 0.2)

    puts summary
    refute_empty summary
    assert_equal 4, summary.size
  end

  def test_weight
    text = "The market-sellers outside San Salvador's cathedral have been doing a roaring trade in recent days. A dollar for a poster of a smiling Oscar Romero or how about a baseball cap with his face on it? A driver winds down his window and stops outside a stall to hand over some cash for a t-shirt and then goes on his way. People are getting ready for a day of celebration. At least 250,000 people are expected to descend on the small capital of San Salvador on Saturday as they witness the beatification of one of the region's biggest heroes. Archbishop Oscar Romero was not just a churchman. He took a stand during El Salvador's darkest moments. El Salvador formally apologised for the murder of Archbishop Romero in 2010 At least 250,000 are expected in San Salvador to celebrate the beatification of Oscar Romero When the US-backed Salvadorean army was using death squads and torture to stop leftist revolutionaries from seizing power, he was not afraid to speak out in his weekly sermons. The law of God which says thou shalt not kill must come before any human order to kill. It is high time you recovered your conscience, he said in his last homily in March 1980, calling on the National Guard and police to stop the violence. I implore you, I beg you, I order you in the name of God: Stop the repression. That was a sermon that cost him his life. A day later, while giving mass, he was hit through the heart by a single bullet, killed by a right-wing death squad. With him died hopes of peace. In the months after Oscar Romero's assassination, the violence intensified and more than a decade of civil war followed. The conflict left around 80,000 people dead. Controversial figure Flying in to El Salvador, you land at the international airport named after Archbishop Romero. Your passport is stamped with his little portrait too. Small details that show he has a big following here. But he was not a figure loved by all. For some, he was more guerrilla than a man of God&*& He wasn't political but he lived in a very conflictive political time. Everything was politicised, says Father Jesus Delgado, Oscar Romero's friend and personal assistant. There was a line in the middle and the ones who supported the government were good and the ones who were against the government were bad - it was that simple. But he also faced opposition within the Church. Oscar Romero's path to sainthood had been stalled for years Several conservative Latin American cardinals in the Vatican blocked his beatification for years because they were concerned his death was prompted more by his politics than by his preaching. We cannot overlook that many of his most vocal opponents were in the church, says Professor Michael Lee, a theologian at Fordham University. It was not just a matter of faith and politics as two separate things but the political dimension of faith itself. Some linked Father Romero to Liberation Theology. It was a movement that grew out of the region's poverty and inequality with the belief that the Church could play a role in bringing about social change. Some radical priests became involved in revolutionary movements but friends of Oscar Romero say he was not one of them. Symbolic decision In the unstable political context of El Salvador though, there was a lot of mistrust. It took decades for that mentality to change. Not until Pope Francis became the first Latin American pontiff was his beatification unblocked. The Pope declared him a martyr who had died because of hatred of his faith, ending the decades-long debate. Francis becoming Pope represents a whole sea change because the Latin American church is now in charge of the universal church, says Dr Austen Ivereigh, author of a biography of Pope Francis. That's why this has huge symbolic significance, the unblocking of the cause of Romero. It really does signal the arrival of the Latin American church in Rome. Romero's younger brother has said that he remembers his brother as a committed man For Oscar Romero's supporters in El Salvador, this about turn has been a long time coming. Romero was their hero and that he is recognised as a saint of the church gives them huge affirmation and encouragement and inspiration, says Julian Filochowski, who is the chair of the Oscar Romero Trust in the UK. He's like Martin Luther King. It puts him in that same orbit as great iconic figures. In a country where religion is all important, he also divides opinions. The Catholic Church is undoubtedly powerful but more than a third of people here now identify themselves as evangelical. Several I spoke to said they did not recognise him as a saintly figure. Rising violence Flying the flag for the Romero family on Saturday is Gaspar Romero, the Archbishop's youngest brother who says he remembers his sibling as a hard-working and committed man. He was always very humble and dedicated to his studies, he says. He was committed to protecting the poor, if he was alive today he would be doing the same work. And it is work that many feel is more relevant than ever - El Salvador is fast becoming one of the most violent places in the world. Many feel the country is in a worse place than it ever was during civil conflict. This time though, there is no Oscar Romero to make a stand."


    @document = Epitome::Document.new(text)
    @corpus = Epitome::Corpus.new([@document])
    puts "-----"
    puts text
    puts "-----"

    summary = @corpus.summary(10, 0.2)
    
    puts summary

    puts "-----"
    puts summary
    refute_nil summary
  end
end
