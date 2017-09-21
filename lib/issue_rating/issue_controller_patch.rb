module IssueControllerPatch
  def self.included(base)
    base.class_eval do

      def update_with_plugin
        @issue = Issue.find(params[:id])
        if @issue.update_attributes(rating: params[:rating])
          respond_to do |format|
            format.js
          end
        end  
      end
      
      alias_method_chain :update, :plugin 
    end
  end
end