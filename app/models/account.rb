# == Schema Information
#
# Table name: accounts
#
#  id                  :bigint           not null, primary key
#  account_users_count :integer          default(0)
#  active              :boolean
#  approved            :boolean
#  available_now       :boolean
#  billing_email       :string
#  customer_type       :integer          default("traveler")
#  description         :text
#  domain              :string
#  extra_billing_info  :text
#  facebook_social     :string
#  instagram_social    :string
#  linkedin_social     :string
#  name                :string           not null
#  personal            :boolean          default(FALSE)
#  stripe_onboarded    :boolean
#  subdomain           :string
#  tagline             :string
#  x_social            :string
#  youtube_social      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :bigint
#  stripe_account_id   :string
#
# Indexes
#
#  index_accounts_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#

class Account < ApplicationRecord
  RESERVED_DOMAINS = [Jumpstart.config.domain]
  RESERVED_SUBDOMAINS = %w[app help support]

  enum customer_type: {traveler: 0, guide: 1}
  belongs_to :owner, class_name: "User"
  has_many :account_invitations, dependent: :destroy
  has_many :account_users, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :users, through: :account_users
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :account_ratings, foreign_key: :target_account_id, dependent: :destroy
  has_many :tours, dependent: :destroy
  has_one :billing_address, -> { where(address_type: :billing) }, class_name: "Address", as: :addressable
  has_one :shipping_address, -> { where(address_type: :shipping) }, class_name: "Address", as: :addressable
  has_one :operating_location, dependent: :destroy
  has_one :account_rating_detail, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :account_language_taggings, class_name: "AccountLanguageTagging", dependent: :destroy
  has_many :languages, class_name: "LanguageTag", through: :account_language_taggings, source: :language_tag
  has_many :account_activity_taggings, class_name: "AccountActivityTagging", dependent: :destroy
  has_many :activities, class_name: "ActivityTag", through: :account_activity_taggings, source: :activity_tag
  has_many :scheduled_tours, through: :tours

  scope :personal, -> { where(personal: true) }
  scope :impersonal, -> { where(personal: false) }
  scope :sorted, -> { order(personal: :desc, name: :asc) }

  has_noticed_notifications
  has_one_attached :avatar
  has_many_attached :photos

  pay_customer stripe_attributes: :stripe_attributes
  pay_customer default_payment_processor: :stripe

  validates :avatar, resizable_image: true
  validates :name, presence: true
  # validates_with TravelerAccountCountValidator, on: :create

  # To require a domain or subdomain, add the presence validation
  validates :domain, exclusion: {in: RESERVED_DOMAINS, message: :reserved}, uniqueness: {allow_blank: true}
  validates :subdomain, exclusion: {in: RESERVED_SUBDOMAINS, message: :reserved}, format: {with: /\A[a-zA-Z0-9]+[a-zA-Z0-9\-_]*[a-zA-Z0-9]+\Z/, message: :format, allow_blank: true}, uniqueness: {allow_blank: true}
  accepts_nested_attributes_for :operating_location, allow_destroy: true

  validates :photos, content_type: [:png, :jpg, :jpeg], size: {less_than: 4.megabytes, message: "must be less than 4MB in size"}

  after_create do
    # Create a default schedule
    schedules.create!(name: "Default Schedule", active: true)
    # Create stripe account for guides
    create_stripe_account
  end

  def find_or_build_billing_address
    billing_address || build_billing_address
  end

  # Email address used for Pay customers and receipts
  # Defaults to billing_email if defined, otherwise uses the account owner's email
  def email
    billing_email? ? billing_email : owner.email
  end

  def impersonal?
    !personal?
  end

  def personal_account_for?(user)
    personal? && owner_id == user.id
  end

  def owner?(user)
    owner_id == user.id
  end

  # An account can be transferred by the owner if it:
  # * Isn't a personal account
  # * Has more than one user in it
  def can_transfer?(user)
    impersonal? && owner?(user) && users.size >= 2
  end

  def latitude
    operating_location&.latitude
  end

  def longitude
    operating_location&.longitude
  end

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_path(avatar.variant(resize_to_limit: [50, 50]), only_path: true) : nil
  end

  # Transfers ownership of the account to a user
  # The new owner is automatically granted admin access to allow editing of the account
  # Previous owner roles are unchanged
  def transfer_ownership(user_id)
    previous_owner = owner
    account_user = account_users.find_by!(user_id: user_id)
    user = account_user.user

    ApplicationRecord.transaction do
      account_user.update!(admin: true)
      update!(owner: user)

      # Add any additional logic for updating records here
    end

    # Notify the new owner of the change
    Account::OwnershipNotification.with(account: self, previous_owner: previous_owner).deliver_later(user)
  rescue
    false
  end

  # Used for per-unit subscriptions on create and update
  # Returns the quantity that should be on the subscription
  def per_unit_quantity
    account_users_count
  end

  # Used for stripe account creation for guides
  def create_stripe_account
    return unless guide?

    account = Stripe::Account.create(
      type: "standard"
    )

    update!(stripe_account_id: account.id)
  end

  def stripe_setup_link(base_url)
    unless stripe_onboarded
      if stripe_account_id.nil?
        create_stripe_account
      end
      Stripe::AccountLink.create({account: stripe_account_id, refresh_url: base_url, return_url: base_url, type: "account_onboarding"}).url
    end
  end

  private

  # Attributes to sync to the Stripe Customer
  def stripe_attributes(*args)
    {address: billing_address&.to_stripe}.compact
  end
end
