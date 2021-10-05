class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :is_admin, :company_id, :no_of_hours_worked
end