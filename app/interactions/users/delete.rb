class Users::Delete < ActiveInteraction::Base
  object :user, class: User
  string :current_password

  def execute
    if user.valid_password?(current_password)
      # Accounts::SuspendJob.perform_later user.account.id, true
    else
      errors.add(:current_password, I18n.t('accounts.errors.invalid_password'))
    end
  end
end
