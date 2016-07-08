require 'rails_helper'

RSpec.describe LogisticMeshesController, type: :controller do

  describe 'POST #create with valid parameters' do

    it 'creates a map with points' do

      mesh_params = build(:valid_mesh)

      post :create, mesh_params, format: :json
      expect(response).to have_http_status(200)


      map = Map.where(:name => mesh_params[:name]).first

      expect(map).to be_instance_of(Map)
      expect(map.version).to eq(1)
      expect(map.points.size).to eq(5)
      expect(map.created_at).to be_instance_of(DateTime)


    end


    it 'creates a map with a updated version' do

      mesh_params = build(:valid_mesh)

      #first map
      post :create, mesh_params, format: :json
      expect(response).to have_http_status(200)

      #second map
      post :create, mesh_params, format: :json
      expect(response).to have_http_status(200)


      map = Map.last_version_by_name(mesh_params[:name])
      expect(map.version).to eq(2)

    end

  end


  describe 'POST #create with INVALID parameters' do
    it 'should return a error if the mesh has a blank point' do

      mesh_params = build(:mesh_with_a_blank_point)

      post :create, mesh_params, format: :json
      expect(response).to have_http_status(422)

      map = Map.where(:name => mesh_params[:name]).first
      expect(map).to be(nil)

    end

  end


end
