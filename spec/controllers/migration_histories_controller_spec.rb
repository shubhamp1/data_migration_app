require 'rails_helper'

RSpec.describe MigrationHistoriesController, type: :controller do
  let(:history1) { create(:migration_history) }
  let(:history2) { create(:migration_history) }
  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe 'GET #index' do
    it 'assigns @histories in reverse order' do
      history1.save!
      history2.save!
      get :index

      expect(assigns(:histories)).to eq([history2, history1])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    context 'when the record exists' do
      it 'assigns the requested history to @history' do
        get :show, params: { id: history1.id }
        expect(assigns(:history)).to eq(history1)
      end

      it 'renders the show template' do
        get :show, params: { id: history1.id }
        expect(response).to render_template(:show)
      end
    end

    context 'when the record does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          get :show, params: { id: 0 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
