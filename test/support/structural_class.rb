module AD
  class Top < AD::Framework::StructuralClass

    ldap_name "top"
    treebase "OU=Stuff"
    rdn :name

    attributes :name, :system_flags, :display_name, :description

  end
end
AD::Framework.register_structural_class(AD::Top)