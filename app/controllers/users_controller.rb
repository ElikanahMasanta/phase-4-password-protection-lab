class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
        
        def create
            new_user = User.create!(user_params)
            session[:user_id] = new_user.id
            render json: new_user, status: :created
        end
    
        def show
            user = User.find_by(id: session[:user_id])
            if user
                render json: user
            else
                render json: {error: "Not authorized"}, status: :unauthorized
            end
        end
    
        private
    
        def invalid_record(invalid)
            render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
        end
    
        def user_params
            params.permit(:username, :password, :password_confirmation)
        end
    end