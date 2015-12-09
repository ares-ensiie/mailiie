class AddCreatorToMailing < ActiveRecord::Migration
  def change
    add_column :mailings, :creator, :string
  end
end
