module Api
	module V1
		require 'csv'
		class UsersController < ApplicationController
			before_action :set_user, only:[:show, :update, :destroy]
					
			def index	
				users = User.order(created_at: :desc)
				render json: {status:'Success', message:'Load posts', data:users}
			end
			
			
			def show
				if !@user
					@users = User.order(created_at: :desc)
					send_users_csv(@users)
				else
					render json:{status: 'Success', message: 'Load the post' ,data: @user, params: params[:id]}
				end
			end
			
			def self.csv_attributes
				["id", "name", "email", "create_at", "update_at"]
			end
			
			def send_users_csv(users)
				csv_data =CSV.generate do |csv|
					csv << ["id", "name", "email", "created_at", "updated_at"]
					users.each do |user|
						value = [user.id, user.email, user.created_at, user.updated_at]
						csv << value
					end
				end
				send_data(csv_data, filename:"user_all.csv")
			end
			
			def create
				user = User.new(user_params)
				if user.save
					render json: {status:'SUCCESS', data: user}
				else
					render json: {status: 'ERROR', data: user.error}
				end
			end
			
			def destroy
				@user.delete
				render json:{status:'SUCCESS', data: @user}
			end
			
			def update
				if @user.update(user_params)
					render json:{status: 'SUCCESS', message: 'Updated the user', data:@user}
				else 
					render json:{status: 'ERROR', message: 'Not Updated', data: @user.errors }
				end
			end
			
			private
			
			def set_user
				@user = User.find_by(id: params[:id])
			end
			
			def user_params
				params.require(:user).permit(:name, :email)
			end
		end
	end
end
