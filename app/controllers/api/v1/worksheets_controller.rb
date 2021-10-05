class Api::V1::WorksheetsController < ActionController::API
  before_action :set_employee, only: %i[index update create]
  before_action :set_worksheet, only: %i[update]
  before_action :set_date_time, only: %i[create update]

  def index
    @worksheets = @employee.worksheets.all
    render json: @worksheets, status: :ok
  end

  def create
    @worksheet = @employee.worksheets.new(worksheet_params)
    if @worksheet.save
      render json: @worksheet, status: :ok
    else
      render json: @worksheet.errors, status: 422
    end
  end

  def update
    if @worksheet.update(worksheet_params)
      render json: @worksheet, status: :ok
    else
      render json: @worksheet.errors, status: 422
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_employee
    @employee = Employee.find_by(id: params[:employee_id])
    render json: { error: 'Employee not found' }, status: 422 unless @employee
  end

  def set_worksheet
    @worksheet = @employee.worksheets.find(params[:id])
  end

  def set_date_time
    params[:worksheet][:session_start] = params[:worksheet][:session_start].to_datetime
    params[:worksheet][:session_end] = params[:worksheet][:session_end].to_datetime
  end

  # Only allow a list of trusted parameters through.
  def worksheet_params
    params.require(:worksheet).permit(:session_start, :session_end, :content)
  end
end
