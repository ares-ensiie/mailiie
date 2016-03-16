class Inscription < ActiveRecord::Base
  belongs_to :mailing

  def user
    return User.find_by_uid(self.uid)
  end
end
