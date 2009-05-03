column :width => 6, :before => 3, :after => 3 do
  @user = User.new
  panel t('panels.login'), :flash => true  do
    block do
      caerus_form_for @user, :url => session_path do |user|
        fieldset t('log_in') do
          user.text_field     :login        
          user.password_field :password           
          user.check_box      :remember_me?
        end
      
        submit_combo :text => 'login'
      end
    end
  end

end
