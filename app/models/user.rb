class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def ldap
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
