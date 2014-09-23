class TopUser
  #top tweeting users - exports as CSV
  def self.perform(term)
    csv = CSV.open("#{File.dirname(__FILE__)+"/../results/top_user_for_"+term}.csv", "w")
    csv << ["Screen Name", "Number of times they tweeted"]
    Dataset.get(term).collect(&:screen_name).counts.each do |k,v|
      csv << [k,v]
    end
    csv.close
  end
end