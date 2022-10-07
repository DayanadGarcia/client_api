module Api
	module V1
		class ClientsController < ApplicationController   
		    def index
          client = Client.order('last_purchase');
          render json: {status: 'SUCCESS', message: 'Client list.', data:client}, status: :ok
		    end

		    def show
          client = Client.find(params[:id])
          render json: {status: 'SUCCESS', message: 'Client founded.', data:client}, status: :ok
		    end

		    def create
          client = Client.new(client_params)
          if client.save
			      render json: {status: 'SUCCESS', message: 'Client added.', data:client}, status: :ok
			    else
			      render json: {status: 'ERROR', message: 'Can not add the client.', data:client.err}, status: :unprocessable_entity
			    end
		    end

		    def update
          client = Client.find(params[:id])
          if client.update(client_params)
			      render json: {status: 'SUCCESS', message: 'Client updated.', data:client}, status: :ok
			    else
			      render json: {status: 'ERROR', message: 'Can not update client.', data:client}, status: :unprocessable_entity
			    end
		    end

		    def destroy
          client = Client.find(params[:id])
          client.destroy
			    render json: {status: 'SUCCESS', message: 'Client deleted.', data:client}, status: :ok
		    end

		    private
		    def client_params
			    params.permit(:name, :phone, :last_purchase)
		    end
		end
	end
end