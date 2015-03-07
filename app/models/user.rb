class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :session_token, presence: true, uniqueness: true
  after_initialize :ensure_session_token, :ensure_co_credentials

  has_many :transactions
  has_many :goals

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
    session_token
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  # Capital One
  def ensure_co_credentials
    (co_user_id && co_authentication_token) || get_co_credentials!
  end

  def get_co_credentials!
    resp = CapitalOneClient.login(email: email, password: password)
    return false unless resp.error == 'no-error'
    self.co_user_id, self.co_authentication_token = resp.uid, resp.token
    self.save
  end

  def co_credentials
    {
      user_id:              co_user_id,
      authentication_token: co_authentication_token,
      api_token:            'HackathonApiToken'
    }
  end

  def session
    @session ||= CapitalOneClient.session(co_credentials)
  end

  def fetch_transactions
    fetched_co_transaction_ids = transactions.pluck(:co_transaction_id)

    session.transactions.reverse.each do |t|
      next if fetched_co_transaction_ids.include? t['transaction-id']

      transactions.create({
        co_transaction_id: t['transaction-id'],
        co_account_id: t['account-id'],
        merchant: t['merchant'],
        raw_merchant: t['raw-merchant'],
        co_account_id: t['account-id'],
        is_pending: t['is-pending'],
        transaction_time: Date.parse(t['transaction-time']),
        categorization: t['categorization']
      })
    end
  end

  def fetch_projected_transactions(month, year)
    session.projected_transactions(month: month, year: year)
  end
end
