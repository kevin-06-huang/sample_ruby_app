# much like how we generate a controller, we generate a UserMailer which,
# analogous to a controller, also generates the appropriate view for the
# template (two view for each action though, one for HTML email and one for
# plain text). The command to generate the mailer is as followed:
# $ rails generate mailer UserMailer account_activation password_reset
# also note that the layouts can be altered in app/views/layouts/

class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  # this method is generated with the command we used above; we then
  # modified it according to listing 10.11. Like in a controller where the
  # instance variables are available to its corresponding views, instance
  # variables in mailer are also available in its views
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject

  # this is added from listing 10.43
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
