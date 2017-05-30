class ResetIdSequenceInReviews < ActiveRecord::Migration[5.0]
  def up
    # execute "DELETE from sqlite_sequence where name = 'reviews'"
    execute("UPDATE sqlite_sequence SET seq = 100 WHERE name = 'reviews';")
  end

  def down
    say "Can't recover previous sequence"
  end
end
