class User < ActiveRecord::Base
    validates :handle,
              presence: true,
              length: { minimum: 2 },
              uniqueness: true
              
    validates_numericality_of :zip
    validates_numericality_of :tweet_count
    validates_numericality_of :follower_count
    validates_presence_of :name
    has_many :events
    
    
    #stocks
    has_many :transactions
    has_many :stocks_following
    has_one  :balance
end
