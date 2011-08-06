class BookOwnership < ActiveRecord::Base
  enumerated_attribute :condition, %w(new like_new ^used)

  belongs_to :user
  belongs_to :book
  validates_presence_of :user_id, :book_id

  belongs_to :reserver, :class_name => 'User'
  validates_presence_of :reserver_id, :if => :offer?
  validates_presence_of :offer, :if => :reserver_id?

  validate :validate_reserver, :if => :reserver_id?
  validates_uniqueness_of :book_id, :scope => :user_id

  def validate_reserver
    if reserver_id == user_id
      errors.add :reserver_id, "Cannot reserve your own book"
      self.reserver_id = nil
      return false
    end
  end
#function is book reserved 
 
  def reserved?; !!reserver_id end

  def accepted?; !!accepted_at end

  def reserve! user, amount
    self.reserver = user
    self.reserver_id = user.id
    self.offer = amount
    self.offered_at = Time.now
    save.tap do |saved|
      Usermailer.reserve_notify(user).deliver if saved
    end
  end

  def reject!
    if accepted?
      errors.add :base, "offer has already been accepted, now it must be canceled"
    elsif !reserved?
      errors.add :base, "no offer has abeen made"
    else
      update_attributes :reserver_id => nil
    end
  end

  def accept!
    if accepted?
      errors.add :base, "offer has alread been accepted"
    elsif !reserved?
      errors.add :base, "no offer has abeen made"
    else
      update_attributes :accepted_at => Time.now
    end
  end

  def cancel!
    if !reserved?
      errors.add :base, "no offer has abeen made"
    elsif accepted?
      update_attributes :reserver_id => nil, :accepted_at => nil
    else
      errors.add :base, "can only cancel an accepted offer"
    end
  end

  def sell!
    # create a new ownership for the new owner
    # archive this ownership (maybe move it to an archive table)
    raise NotImplemtedError
  end
end
