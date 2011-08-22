module AD
  module Framework
    module Patterns

      module Searchable
        class << self

          def included(klass)
            klass.class_eval do
              extend AD::Framework::Patterns::Searchable::ClassMethods
              include AD::Framework::Patterns::Searchable::InstanceMethods
            end
          end

        end
        
        module InstanceMethods
          
          def reload
            # TODO
          end
          
        end

        module ClassMethods

          def find(dn)
            if dn !~ /DC=|CN=/
              dn = [ "CN=#{dn}", self.treebase ].compact.join(", ")
            end
            args = { :dn__eq => dn, :size => 1 }
            ldap_entry = self.connection.search(args).first
            fields = AD::Framework::Fields.new(ldap_entry)
            fields.build_entry
          end
          
          def first
            # TODO
          end
          
          def all
            # TODO
          end

        end

      end

    end
  end
end
