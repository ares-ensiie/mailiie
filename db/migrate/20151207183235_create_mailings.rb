class CreateMailings < ActiveRecord::Migration
  def change
    create_table :mailings do |t|
      t.string :nom
      t.string :mail
      t.string :type_mailing

      t.timestamps null: false
    end
  end
end
