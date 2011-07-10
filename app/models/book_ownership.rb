class BookOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  belongs_to :reserver, :class_name => 'User'

  validates_presence_of :user_id, :book_id
  validates_presence_of :reserver_id, :if => :offer?
  validates_presence_of :offer, :if => :reserver_id?

  def reserved?; !!reserver_id end

  def accepted?; !!accepted_at end

  def offer! user, amount
    self.reserver = user
    self.offer = amount
    self.offered_at = Time.now
    save!
  end

  def reject!
    if accepted?
      errors.add :base, "offer has already been accepted, now it must be canceled"
    elsif !offered?
      errors.add :base, "no offer has abeen made"
    else
      update_attribute :reserver_id => nil
    end
  end

  def offered?
    !!offer && offered_at?
  end

  def accept!
    if accepted?
      errors.add :base, "offer has alread been accepted"
    elsif !offered?
      errors.add :base, "no offer has abeen made"
    else
      update_attribute :accepted_at => Time.now
    end
  end

  def cancel!
    if accepted?
      update_attribute :reserver_id => nil, :accepted_at => Time.now
    elsif !offered?
      errors.add :base, "no offer has abeen made"
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
