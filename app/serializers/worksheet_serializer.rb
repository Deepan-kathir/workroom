class WorksheetSerializer < ActiveModel::Serializer
  attributes :id, :session_start, :session_end, :content, :worked_hours, :approved_by_admin, :pending_approval
end