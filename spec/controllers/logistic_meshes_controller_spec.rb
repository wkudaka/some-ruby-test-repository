require 'rails_helper'

RSpec.describe LogisticMeshesController, type: :controller do

  describe 'POST #create with valid parameters' do

    it 'creates a map with points' do

      mesh_params = build(:valid_mesh)
      post :create, mesh_params, format: :json
      expect(response).to have_http_status(201)


      map = Map.where(:name => mesh_params[:name]).first

      expect(map).to be_instance_of(Map)
      expect(map.version).to eq(1)
      expect(map.points.size).to eq(5)
      expect(map.created_at).to be_instance_of(DateTime)


      #maps with same name have a different version
      mesh_params = build(:another_valid_mesh)
      post :create, mesh_params, format: :json
      map = Map.last_version_by_name(mesh_params[:name])
      expect(map.version).to eq(2)
    end

  end


  describe 'POST #create with INVALID parameters' do
    it 'should return a error if the mesh has a blank point' do

      mesh_params = build(:mesh_with_a_blank_point)

      post :create, mesh_params, format: :json
      expect(response).to have_http_status(422)

      #a map cant be created if is invalid....
      map = Map.where(:name => mesh_params[:name]).first
      expect(map).to be(nil)

    end


    it 'should return a error if the mesh has a negative distance' do

      mesh_params = build(:mesh_with_negative_distance)

      post :create, mesh_params, format: :json
      expect(response).to have_http_status(422)

      #a map cant be created if is invalid....
      map = Map.where(:name => mesh_params[:name]).first
      expect(map).to be(nil)

    end


    it 'should return a error if the mesh dont has a point' do

      mesh_params = build(:mesh_without_a_point)

      post :create, mesh_params, format: :json
      expect(response).to have_http_status(422)

      #a map cant be created if is invalid....
      map = Map.where(:name => mesh_params[:name]).first
      expect(map).to be(nil)

    end

    it 'should return a error if the map dont has a name' do

      mesh_params = build(:map_without_name)

      post :create, mesh_params, format: :json
      expect(response).to have_http_status(422)

      #a map cant be created if is invalid....
      map = Map.where(:name => mesh_params[:name]).first
      expect(map).to be(nil)

    end

    it 'should return a error if the mesh has a blank textfile' do

      mesh_params = build(:mesh_blank)

      post :create, mesh_params, format: :json
      expect(response).to have_http_status(422)

      #a map cant be created if is invalid....
      map = Map.where(:name => mesh_params[:name]).first
      expect(map).to be(nil)
    end


  end


end