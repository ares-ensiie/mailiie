class CustomMailing < ActiveRecord::Base

  def users
    ldap = Net::LDAP.new
    ldap.host = LDAP_CONFIG["host"]
    ldap.port = LDAP_CONFIG["port"]
    ldap.auth LDAP_CONFIG["auth_dn"], LDAP_CONFIG["auth_pass"]

    treebase = LDAP_CONFIG["search_base"]
    results = ldap.search( :base => treebase, :filter => self.filter, :scope => Net::LDAP::SearchScope_WholeSubtree)

    return results
  end
end
