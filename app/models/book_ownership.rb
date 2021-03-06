class BookOwnership < ActiveRecord::Base
  enumerated_attribute :condition, %w(new like_new ^used)

  belongs_to :user
  belongs_to :book
  # technically this should be limited through a join table that has uniqueness
  # but we can't trust uniquenes because we are soliciting this data from users
  belongs_to :course
  validates_presence_of :user_id, :book_id, :course_id, :school_id

  belongs_to :reserver, :class_name => 'User'
  validates_presence_of :reserver_id, :if => :offer?
  validates_presence_of :offer, :if => :reserver_id?

  validate :validate_reserver, :if => :reserver_id?
  validates_uniqueness_of :book_id, :scope => :user_id

  before_validation :set_school_id
  def set_school_id
    self.school_id = user.school_id if new_record?
  end

  def validate_reserver
    if reserver_id == user_id
      errors.add :reserver_id, "Cannot reserve your own book"
      self.reserver_id = nil
      return false
    end
  end

  scope :recently_requested, ->(){
    t = (Time.now - 30.days)
    where {(reserver_id != nil) & ((accepted_at >= t) | (offered_at >= t))}
  }
 
  def reserved?; !!reserver_id end

  def accepted?; !!accepted_at end

  def pending
    reserver_id && !accepted_at
  end

  def reserve! reserver, amount
    self.reserver = reserver
    self.reserver_id = reserver.id
    self.offer = amount
    self.offered_at = Time.now
    save!
    BookOwnershipMailer.reserve(self).deliver
  end

  def reject!
    if accepted?
      errors.add :base, "offer has already been accepted, now it must be canceled"
    elsif !reserved?
      errors.add :base, "no offer has abeen made"
    else
      BookOwnershipMailer.reject(self, reserver).deliver
      self.reserver_id = nil
      save
    end
  end

  def accept!
    if accepted?
      errors.add :base, "offer has alread been accepted"
    elsif !reserved?
      errors.add :base, "no offer has abeen made"
    else
      self.accepted_at = Time.now
      save
    end
    BookOwnershipMailer.accept(self).deliver
  end

  def cancel!
    if !reserved?
      errors.add :base, "no offer has abeen made"
    elsif accepted?
      BookOwnershipMailer.reject(self, reserver).deliver
      self.reserver_id = nil
      self.accepted_at = nil
      save
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
