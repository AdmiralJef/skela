module UsersHelper

  def user_signed_in?
    true
  end

  def edit_username_field
    form_for @user, remote: true do |f|
      f.text_field :email
    end
  end

  def destroy_user_link
    confirmation = 'Are you sure you want to delete this user?'
    link_to 'Delete User', user_path(@user), method: :delete, id: 'delete_user', data: { confirm: confirmation }
  end

end
