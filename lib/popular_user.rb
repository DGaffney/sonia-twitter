class PopularUser
  extend Twitter::Extractor
  #top tweeting users - exports as CSV
  def self.perform(term)
    csv = CSV.open("#{File.dirname(__FILE__)+"/../results/popular_user_for_"+term}.csv", "w")
    csv << ["Screen Name", "Number of times they tweeted"]
    self.counts_for_mentioned_users(term).each do |k,v|
      csv << [k,v]
    end
    csv.close
  end
  
  def self.counts_for_mentioned_users(term)
    Dataset.get(term).collect(&:text).map do |text|
      usernames = self.extract_mentioned_screen_names(text)
    end.flatten.counts
  end
end
# TopUser.perform("#yesallwomen")
# TopUser.perform("#yesallwhitewomen")
# TopUser.perform("#notallwomen")
# PopularUser.perform("#yesallwomen")
# PopularUser.perform("#yesallwhitewomen")
# PopularUser.perform("#notallwomen")