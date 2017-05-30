class Review < ApplicationRecord
  belongs_to :product
  before_create :set_type
  # before_create :increment_by_100

  def self.c
    Review.destroy_all
    ActiveRecord::Migration.
      execute("DELETE FROM sqlite_sequence WHERE name = 'reviews'")
  end

  private
  def set_type
    self.type = 'Review' if self.class.name == 'Review'
  end

  def increment_by_100
    m = ActiveRecord::Migration
    s = m.execute("SELECT seq FROM sqlite_sequence WHERE name = 'reviews';")
    if s[0].nil?
      m.execute("INSERT INTO sqlite_sequence(name,seq) VALUES('reviews', 99);")
    else
      m.execute("UPDATE sqlite_sequence SET seq = #{s[0]['seq']+99} WHERE name = 'reviews';")
    end
  end

end

class Comment < Review; end

class Text < Review; end
