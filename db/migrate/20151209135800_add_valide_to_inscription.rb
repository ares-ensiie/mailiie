class AddValideToInscription < ActiveRecord::Migration
  def change
    add_column :inscriptions, :valide, :boolean
  end
end
