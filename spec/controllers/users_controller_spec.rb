require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'GET #new' do
        it 'renders new users template successfully' do
            get :new
            expect(response).to be_success
            expect(response).to render_template(:new)
        end
    end

    describe 'POST #create' do
        context 'with valid params' do
            let(:user_params) do
                {user:{
                    username: 'lina-2020', 
                    password: 'password', 
                    email: '2020@aa.io', 
                    age: 6, 
                    political_affiliation: 'hufflepuff'}
                }
            end

            it 'logs in the user' do
                post :create, params: user_params
                user = User.find_by(username: 'lina-2020')
                expect(session[:session_token]).to eq(user.session_token) # testing login
            end

            it 'redirects to the users show page' do
                post :create, params: user_params
                user = User.find_by(username: 'lina-2020')
                expect(response).to redirect_to(user_url(user))
            end
        end

        context 'with invalid params' do
            it 'validates the presence of password and renders the new template with errors' do
                post :create, params: {user: {username: 'zack',email: 'zack@aa.io', password: ''}}
                expect(response).to render_template(:new)
                expect(flash[:errors]).to be_present
            end

        end
    end
end