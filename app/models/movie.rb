class Movie < ActiveRecord::Base
    def self.all_ratings
        return self.select(:rating).map(&:rating).uniq
    end
    
    def self.with_ratings(ratings)
        return self.where(rating: ratings)
    end
end