caerus_form_for campaign, :html => {:multipart => true} do |campaign|
  fieldset campaign.object.new_record? ? t('.new_campaign') : t('.edit_campaign', :name => campaign.object.name) do
    if @property || !campaign.object.new_record?
      campaign.hidden_field :property_id
    else
      campaign.collection_select :property_id, user_scope(:property, current_user).all, :id, :name
    end
    campaign.hidden_field   :account_id
    campaign.text_field     :name
    campaign.datetime_select  :effective_at
    campaign.text_area      :description
    campaign.text_field     :cost,          :validate => :validations
    campaign.text_field     :code, :disabled => 'disabled' unless campaign.object.new_record?
  end
  fieldset t('.distribution') do
    campaign.text_field     :distribution,  :validate => :validations
    campaign.text_field     :bounces,       :validate => :validations
    campaign.text_field     :unsubscribes,  :validate => :validations
  end
  fieldset t('.parameters') do
    campaign.text_field     :source
    campaign.text_field     :content
    campaign.text_field     :medium, :disabled => true
    campaign.text_field     :contact_code
  end
  fieldset t('.html') do
    campaign.file_field     :email_html, :accept => 'text/html'
    campaign.text_field     :image_directory
    campaign.check_box      :preview_available if current_user.is_administrator?    
  end
  submit_combo
end
