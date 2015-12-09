class Mailing < ActiveRecord::Base
  has_many :inscriptions

  def contains_user_invalide(uid)
    return self.inscriptions.where(:uid => uid).where(:valide => false).count > 0
  end

  def contains_user_valide(uid)
    return self.inscriptions.where(:uid => uid).where(:valide => true).count > 0
  end

end
