require 'rails_helper'

RSpec.describe PatientsController, type: :controller do
  let(:patient1) { create(:patient) }
  let(:patient2) { create(:patient) }
  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe 'GET #index' do
    it 'assigns @patients in reverse order' do
      patient1.save!
      patient2.save!

      get :index
      expect(assigns(:patients)).to eq([patient2, patient1])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested patient to @patient' do
      get :show, params: { id: patient1.id }
      expect(assigns(:patient)).to eq(patient1)
    end

    it 'renders the show template' do
      get :show, params: { id: patient1.id }
      expect(response).to render_template(:show)
    end

    it 'returns a successful response' do
      get :show, params: { id: patient1.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #upload_csv' do
    context 'when no file is uploaded' do
      it 'sets a flash alert and renders index' do
        post :upload_csv
        expect(flash[:alert]).to eq('Please upload a CSV file.')
        expect(response).to render_template(:index)
      end
    end

    context 'when the uploaded file is not a CSV' do
      it 'sets a flash alert and renders index' do
        file = fixture_file_upload('test_data.csv', 'text/plain')
        post :upload_csv, params: { file: file }

        expect(flash[:alert]).to eq('Uploded file format is not CSV file.')
        expect(response).to render_template(:index)
      end
    end

    context 'when a valid CSV file is uploaded' do
      let(:file) { fixture_file_upload('test_data.csv', 'text/csv') }
      let(:result) do
        {
          success_records: 5,
          failed_records: 0
        }
      end

      it 'calls the migration service and redirects with success flash' do
        post :upload_csv, params: { file: file }
        expect(flash[:notice]).to include('Migration completed! Imported 5 patients')
        expect(response).to redirect_to(patients_path)
      end
    end
  end
end
