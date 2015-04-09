class Computer < ActiveRecord::Base
  class_attribute :config
  self.config = Rails.application.config
    
  belongs_to :location
  
  scope :in_use, -> { where("current_username IS NOT NULL") }
  scope :not_in_use, -> { where("current_username IS NULL") }
  scope :last_ping_more_than_x_time_ago, ->(time) { where("last_ping IS NOT NULL AND last_ping < ?", time.ago) }
  
  def logon(username)
    if self.current_username != username
      self.current_username = username
    end
    self.ping
    self.keep_alive
  end
  
  def logoff
    if !self.current_username.nil?
      self.previous_username = self.current_username
    end
    self.current_username = nil
  end
  
  def is_in_use
    return !self.current_username.nil?
  end
  
  def ping
    self.last_ping = DateTime.now
  end
  
  def keep_alive
    self.last_keep_alive = DateTime.now
  end
end
