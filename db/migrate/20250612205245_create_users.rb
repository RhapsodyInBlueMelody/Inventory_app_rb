class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :firebase_uid
      t.string :email
      t.string :name
      t.string :avatar_url

      t.timestamps
    end
    add_index :users, :firebase_uid, unique: true
  end
end
