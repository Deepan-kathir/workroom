class Api::V1::EmployeesController < ActionController::API
  # Authentication not implemented
  # API for getting employee list with working hours

  def index
    # filter based on current month, day and week basis
    dates = if params[:filter_type] == 'weekly'
              { start_date: DateTime.now.beginning_of_week, end_date: DateTime.now.end_of_week }
            elsif params[:filter_type] == 'monthly'
              { start_date: DateTime.now.beginning_of_month, end_date: DateTime.now.end_of_month }
            elsif params[:filter_type] == 'daily' || params[:filter_type].blank?
              { start_date: Date.today.beginning_of_day, end_date: Date.today.end_of_day }
            end

    # filter based on given date range
    if params[:filter_start_date].present? && params[:filter_end_date].present?
      dates = { start_date: params[:filter_start_date].to_datetime, end_date: params[:filter_end_date].to_datetime }
    end
    order_type = params[:order] == 'high' ? 'Desc' : 'Asc'

    employees = Employee.joins(:worksheets)
                        .where('worksheets.session_start >= (?) AND worksheets.session_end <= (?)',
                               dates[:start_date], dates[:end_date])
                        .group(:id).select('employees.id', 'SUM(worked_hours) as no_of_hours_worked',
                                           :name, :email, :company_id, :is_admin)
                        .order("no_of_hours_worked #{order_type}")
    render json: employees, status: :ok
  end

  # list of no_of_hours_worked - for admin
  def pending_approval
    @worksheets = Worksheet.pending_approvals
    render json: @worksheets, status: :ok
  end
end
