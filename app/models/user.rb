class User < ActiveRecord::Base
    before_save { self.email = email.downcase }

    validates :name, presence: true, length: { minimum: 3, maximum: 100 } 

    VALID_EMAIL_REGEX = /.+@.+/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

    has_secure_password
    validates :password, length: { minimum: 6 }
end
