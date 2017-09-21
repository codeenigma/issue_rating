require_dependency 'issue'

module IssueModelPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development      
      validates_inclusion_of :rating, :in => 0..5, :allow_nil => true
    end

  end
  
  module ClassMethods
    
  end
  
  module InstanceMethods
  
  end
end

