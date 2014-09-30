require 'time'
class Dataset
  def self.path
    File.dirname(__FILE__)+"/../data/all.tsv"
  end

  def self.keys
    [:twitter_id, :user_id, :time, :unknown_1, :unknown_2, :source, :unknown_3, :unknown_4, :unknown_5, :text, :name, :screen_name]
  end

  def self.full_dataset
    self.clean_up(File.read(self.path).split("\n").collect{|x| Hash[self.keys.zip(x.split("\t"))]})
  end

  def self.clean_up(dataset)
    dataset.map do |r|
      r.twitter_id = r.twitter_id.to_i
      r.user_id = r.user_id.to_i
      r.time = Time.parse(r.time)
      r
    end
  end

  def self.pruned_by(term)
    self.full_dataset.select{|x| x.text.downcase.include?(term)}
  end

  def self.get(term)
    self.pruned_by(term)
  end

  def self.export(term)
    csv = CSV.open(File.dirname(__FILE__)+"/../datasets/#{term.gsub("#", "")}.tsv", "w")
    first = true
    self.get(term).each do |r|
      if first
        csv << keys = (r.keys|[:permalink])
        first = false
      end
      vals = r.values
      vals << "http://www.twitter.com/#{r.screen_name}/status/#{r.twitter_id}"
      csv << vals
    end
    puts "Stored in #{File.dirname(__FILE__)+"/../datasets/#{term.gsub("#", "")}.tsv"}!"
  end
end
#usage: Dataset.get("#yesallwomen") - note that this is case insensitive! YESALLWOMEN is just as good.

# Dataset.export("#yesallwomen")
