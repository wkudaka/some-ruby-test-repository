class LogisticMeshesController < ApplicationController

  def index

  end

  def route
    route_params = {
      :map_name => params[:map_name],
      :origin => params[:origin],
      :destiny => params[:destiny],
      :autonomy => params[:autonomy],
      :liter_value => params[:liter_value]
    }

    route_info = MeshValidation::RouteInfo.new route_params

    if route_info.has_map? && route_info.valid?

      data = Map.get_cheapest_route(route_info)
      render json: {
        message: data.present? ? "Success!!" : "Path not found!",
        data: data
      }

    else

      render json: {
        errors:route_info.errors.full_messages
      }, status: 422

    end
  end


  def create
    map_name = params[:name]
    mesh_file = params[:mesh]

    mesh_string = mesh_file.read if mesh_file.respond_to?(:read)


    mesh = MeshValidation::Mesh.new(mesh_string)

    map = Map.last_version_by_name(map_name)
    map = Map.new(name:map_name) if map.nil?

    if map.valid? && mesh.valid?

      map.name = map_name
      map.points << mesh.get_points
      map.save

      render json: {
        message: "Successfully created!"
      }, status: :created
    else

      errors_arr = map.errors.full_messages + mesh.lines_errors
      render json: {
        errors:errors_arr
      }, status: 422

    end

  end

end
