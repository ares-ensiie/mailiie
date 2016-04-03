class Inscription < ActiveRecord::Base
  belongs_to :mailing
  default_scope { order(uid: 'asc') }

  def user
    return User.find_by_uid(self.uid)
  end

  def ldap_user
    ldap = Net::LDAP.new
    ldap.host = LDAP_CONFIG["host"]
    ldap.port = LDAP_CONFIG["port"]
    ldap.auth LDAP_CONFIG["auth_dn"], LDAP_CONFIG["auth_pass"]

    filter = Net::LDAP::Filter.eq( "uid", self.uid)
    treebase = LDAP_CONFIG["search_base"]

    results = ldap.search( :base => treebase, :filter => filter, :scope => Net::LDAP::SearchScope_WholeSubtree)
    if results.length == 1
      return results[0]
    else
      return nil
    end
  end
end
