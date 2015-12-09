class CreateInscription < ActiveRecord::Migration
  def change
    create_table :inscriptions do |t|
      t.belongs_to :mailing, index: true
      t.string :uid
    end
  end
end
