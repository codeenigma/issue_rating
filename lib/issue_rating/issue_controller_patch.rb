module IssueControllerPatch
  def self.included(base)
    base.class_eval do
      # Insert overrides here, for example:
  
      
      def update_with_plugin
        @issue = Issue.find(params[:id])
        if @issue.update_attributes(rating: params[:rating])
          respond_to do |format|
            format.js
          end
        end  
      end
      
      alias_method_chain :update, :plugin # This tells Redmine to allow me to extend show by letting me call it via "show_without_plugin" above.        # I can outright override it by just calling it "def show", at which case the original controller's method will be overridden instead of extended.

    end
  end
end