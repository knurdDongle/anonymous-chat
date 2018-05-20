class AddIndexUniqueTokenInSessions < ActiveRecord::Migration[5.1]
  def change
    add_index :sessions, :token, unique: true
  end
end
