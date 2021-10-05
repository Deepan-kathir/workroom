class Worksheet < ApplicationRecord
  #associations
  belongs_to :employee

  #validations
  validates :session_start, presence: true
  validate :validate_session_timings

  #callbacks
  after_save :update_worked_hours
  after_save :check_admin_approval

  #scope
  scope :pending_approvals, -> { where(pending_approval: true) }

  def validate_session_timings
    if (session_start.present? && session_end.present?) && session_start > session_end
      errors.add(:base, "Session start time can't precede session end time")
    end
  end

  def update_worked_hours
    return unless saved_change_to_session_end?

    hours_diff = ((session_end - session_start) / 3600)
    update_columns(worked_hours: hours_diff)
  end

  def check_admin_approval
    data = Worksheet.where('session_start >= (?) AND session_end <= (?)',
                           Date.today.beginning_of_day, Date.today.end_of_day)
    data.update_all(pending_approval: true) if data&.sum(:worked_hours) > 8.0
  end
end
