class Mailing < ActiveRecord::Base
  validates :nom, presence: true, allow_blank: false, uniqueness: true, length: { maximum: 21 }
  validates :mail, presence: true, allow_blank: false, uniqueness: true, length: { maximum: 21 }
  validates :type_mailing, presence: true, allow_blank: false, length: { maximum: 21 }
  has_many :inscriptions, :dependent => :delete_all

  def contains_user_invalide(uid)
    return self.inscriptions.where(:uid => uid).where(:valide => false).count > 0
  end

  def contains_user_valide(uid)
    return self.inscriptions.where(:uid => uid).where(:valide => true).count > 0
  end

end
