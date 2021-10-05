require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :controller do

  describe 'List API' do
    company = Company.create!(email: 'Company1', email: 'company1@gmail.com')
    context 'Valid' do
      it 'Employee list and worked hours on default/day basics ' do
        10.times do |i|
          employee = company.employees.create!(email: "user#{i}@sample.com", name: "User#{i}")
          employee.worksheets.create!(session_start: Time.now, session_end: Time.now + 1.hour)
        end
        get :index, format: :json
        expect(response).to have_http_status(200)
        expect(parsed_response.size).to eq(10)
      end

      it 'Employee list and worked hours on week basics ' do
        10.times do |i|
          employee = company.employees.create!(email: "user#{i}@sample.com", name: "User#{i}")
          employee.worksheets.create!(session_start: Time.now + 2.days, session_end: Time.now + 2.days + 1.hour)
        end
        get :index, params: { filter_type: 'weekly' }, format: :json
        expect(response).to have_http_status(200)
        expect(parsed_response.size).to eq(10)
      end


      it 'Employee list and worked hours on month basics' do
        10.times do |i|
          employee = company.employees.create!(email: "user#{i}@sample.com", name: "User#{i}")
          employee.worksheets.create!(session_start: Time.now + 2.weeks, session_end: Time.now + 2.weeks + 1.hour)
        end
        get :index, params: { filter_type: 'monthly' }, format: :json
        expect(response).to have_http_status(200)
        expect(parsed_response.size).to eq(10)
      end
    end
  end
end