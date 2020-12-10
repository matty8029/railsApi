module Api
	module V1
		class PostsController < ApplicationController
			before_action :set_user, only:[:show, :update, :destroy]
			
			def index
				if User.nill
					render json: {status:'Fault', message:'No User'}
				else	
					users = User.order(created_at: :desc)
					render json: {status:'Success', message:'Load posts', data:users}
				end
			end
			
			def show
				render json:{status: 'Success', message: 'Load the post' ,data: @user}
			end
			
			def set_user
				@user = User.find(params[:id])
			end
		end
	end
end
