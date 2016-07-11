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
      mesh_params = build(:valid_mesh)
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

  describe 'GET #route with valid parameters' do

    before(:each) do
      mesh_params = build(:valid_mesh)
      post :create, mesh_params, format: :json
    end

    it 'should return the correct path and cost' do

      route_params = {
        :map_name => "SP",
        :origin => "A",
        :destiny => "D",
        :autonomy => 10,
        :liter_value => 2.5,
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(200)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      data = body_response[:data]

      expect(data[:cost]).to be 6.25
      expect(data[:path]).to eql "A B D"

    end

    it 'should return path not found' do

      route_params = {
        :map_name => "SP",
        :origin => "A",
        :destiny => "Z",
        :autonomy => 10,
        :liter_value => 2.5,
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(200)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      data = body_response[:data]

      expect(body_response[:message].downcase).to include("not found")
      expect(data).to be nil

    end

  end




  describe 'GET #route with INVALID parameters' do

    before(:each) do
      mesh_params = build(:valid_mesh)
      post :create, mesh_params, format: :json
    end

    it 'should return a error if origin is blank' do

      route_params = {
        :map_name => "SP",
        :origin => "",
        :destiny => "D",
        :autonomy => 10,
        :liter_value => 2.5
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(422)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      error = body_response[:errors].first

      expect(error).to include("be blank")

    end


    it 'should return a error if destiny is blank' do

      route_params = {
        :map_name => "SP",
        :origin => "A",
        :destiny => "",
        :autonomy => 10,
        :liter_value => 2.5
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(422)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      error = body_response[:errors].first

      expect(error).to include("be blank")

    end

    it 'should return a error if autonomy is blank' do

      route_params = {
        :map_name => "SP",
        :origin => "A",
        :destiny => "B",
        :liter_value => 2.5
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(422)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      error = body_response[:errors].first

      expect(error).to include("not a number")

    end

    it 'should return a error if liter_value is blank' do

      route_params = {
        :map_name => "SP",
        :origin => "A",
        :destiny => "B",
        :autonomy => 10,
        :liter_value => nil
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(422)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      error = body_response[:errors].first

      expect(error).to include("not a number")

    end


    it 'should return a error if autonomy has a negative value' do

      route_params = {
        :map_name => "SP",
        :origin => "A",
        :destiny => "B",
        :autonomy => -10,
        :liter_value => 2.5
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(422)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      error = body_response[:errors].first

      expect(error).to include("greater than")

    end


    it 'should return a error if autonomy has a negative value' do

      route_params = {
        :map_name => "SP",
        :origin => "A",
        :destiny => "B",
        :autonomy => 10,
        :liter_value => -2.5
      }

      get :route, route_params, format: :json

      expect(response).to have_http_status(422)

      body_response = JSON.parse(response.body, :symbolize_names => true)
      error = body_response[:errors].first

      expect(error).to include("greater than")

    end

  end


  describe 'GET #index' do

    before(:each) do
      5.times do |index|
        mesh_params = build(:valid_mesh, :name => "Some data #{index}" )
        post :create, mesh_params, format: :json
      end
    end

    describe 'GET #index with valid parameters' do

      it 'should return a list of maps' do

        params = {}

        get :index, params, format: :json

        expect(response).to have_http_status(200)

        body_response = JSON.parse(response.body, :symbolize_names => true)
        data = body_response[:data]

        expect(data.count).to be 5
        expect(body_response[:total_pages]).to be 1
        expect(body_response[:total_count]).to be 5
        expect(body_response[:actual_page]).to be 1

      end

      it 'should return the correct number of maps based on the per_page parameter' do

        params = {
          :per_page => 1
        }

        get :index, params, format: :json

        body_response = JSON.parse(response.body, :symbolize_names => true)
        data = body_response[:data]

        expect(data.count).to be 1
        expect(body_response[:total_pages]).to be 5
        expect(body_response[:total_count]).to be 5
        expect(body_response[:actual_page]).to be 1

      end

      it 'should return the correct number of maps based on the name parameter' do

        params = {
          :name => "Some data 2"
        }

        get :index, params, format: :json

        body_response = JSON.parse(response.body, :symbolize_names => true)
        data = body_response[:data]

        expect(data.count).to be 1
        expect(body_response[:total_pages]).to be 1
        expect(body_response[:total_count]).to be 1
        expect(body_response[:actual_page]).to be 1

      end

    end


  end

end
