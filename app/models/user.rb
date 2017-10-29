class User < ApplicationRecord
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:twitch]

  has_one :bot, dependent: :destroy

  validates :time_zone, presence: true
  validates :username, presence: true, uniqueness: true

  validate :password_complexity

  scope :find_for_twitch_oauth, lambda { |auth|
    user_params = auth.slice(:provider, :uid)
    user_params[:email] = auth.info.email
    user_params[:username] = auth.info.name
    user_params[:avatar] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:time_zone] = 'GMT'
    user_params[:token_expiry] = nil
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      user.save
    end
    user
  }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
    elsif conditions[:username].nil?
      find_by(conditions)
    else
      find_by(username: conditions[:username])
    end
  end

  def password_complexity
    return unless
      password.present? &&
      !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).+$/)
    errors.add(
      :password,
      'must be 6 character long,
      must include at least one lowercase letter,
      one uppercase letter, one digit and one special character'
    )
  end

  def self.send_reset_password_instructions(attributes = {})
    recoverable = find_recoverable_or_initialize_with_errors(
      reset_password_keys,
      attributes, :not_found
    )

    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error = :invalid)
    (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |_key, value| value.blank? }

    if attributes.size == required_attributes.size
      if attributes.key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else
        record = find_by(attributes)
      end
    end

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end
    record
  end

  def self.find_record(login)
    find_by(['username = :value OR email = :value', { value: login }])
  end
end
