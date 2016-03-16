class CreateCustomMailings < ActiveRecord::Migration
  def change
    create_table :custom_mailings do |t|
      t.string :mail
      t.string :filter

      t.timestamps null: false
    end
  end
end
