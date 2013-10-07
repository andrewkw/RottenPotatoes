class Movie < ActiveRecord::Base
    def self.all_ratings
        self.select("DISTINCT(rating)").map { |movie| movie.rating }.sort
    end
end
