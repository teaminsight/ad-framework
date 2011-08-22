require 'assert'

class AD::Framework::StructuralClass

  class BaseTest < Assert::Context
    desc "AD::Framework::StructuralClass"
    setup do
      @class = AD::Framework::StructuralClass
      @instance = @class.new
    end
    subject{ @instance }
    
    should have_accessors :meta_class, :errors, :fields
    should have_instance_methods :connection
    should have_class_methods :connection
    
    should have_instance_methods :schema
    should have_class_methods :schema
    
    should have_instance_methods :reload
    should have_class_methods :find, :first, :all
    
    should "set fields to an instance of AD::Framework::Fields" do
      assert_instance_of AD::Framework::Fields, subject.fields
    end    
    should "set errors to an instance of a Hash" do
      assert_instance_of Hash, subject.errors
    end
    should "return the framework's connection with a call to #connection" do
      assert_equal AD::Framework.connection, subject.class.connection
      assert_equal subject.class.connection, subject.connection
    end
  end
  
  class InheritedTest < Assert::Context
    desc "a structural class"
    setup do
      @class = Class.new(AD::Framework::StructuralClass) do
        ldap_name "something"
        rdn :name
      
        def name; "something"; end
      end
      @instance = @class.new
      @instance.schema.attributes << :name
    end
    subject{ @instance }
    
    should "have a custom inspect" do
      expected = "#<#{subject.class} "
      expected += subject.attributes.collect{|k, v| "#{k}: #{v.inspect}" }.join(", ")
      expected += ">"
      assert_equal expected, subject.inspect
    end
  end

end
