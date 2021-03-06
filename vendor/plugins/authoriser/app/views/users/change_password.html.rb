panel t('panels.user'), :flash => true, :display_errors => 'user'  do
  block do
    caerus_form_for @user, :url => update_password_url do |user|
      fieldset t('.change_password') do
        user.hidden_field     :login
        user.password_field   :password
        user.password_field   :new_password
        user.password_field   :new_password_confirmation
      end
      submit_combo
    end
  end
end