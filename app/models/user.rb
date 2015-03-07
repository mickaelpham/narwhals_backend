class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :session_token, presence: true, uniqueness: true
  after_initialize :ensure_session_token

  # User
  def self.find_by_credentials(email, password)
    user = User.find_by_email_and_password(email, password)
    user && user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  # Session Token
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  # Capital One
  def has_capital_one_access_token?
    # TODO CHECK IF CAP ONE LOGIN IS OKAY
    true
  end
end
