class TravelerAccountCountValidator < ActiveModel::Validator
  # Limit the amount of accounts a traveler can have to 1
  # unless they have approval
  #
  def validate(record)
    if record.owner.present? && record.owner.accounts.count > 0 && !record.owner.admin? && !record.owner.account_creator
      record.errors.add :base, "You are only allowed to create a single account."
    end
  end
end
