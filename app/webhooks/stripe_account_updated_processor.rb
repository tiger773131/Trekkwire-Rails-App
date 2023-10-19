class StripeAccountUpdatedProcessor
  def call(event)
    if event.account
      customer_account = Account.find_by(stripe_account_id: event.account)

      if customer_account&.guide?
        customer_account.update!(stripe_onboarded: event.data.object.details_submitted)
      end
    end
  end
end
