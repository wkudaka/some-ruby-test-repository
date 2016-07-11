class LogisticMeshesController < ApplicationController

  def index

    actual_page = params[:actual_page]
    actual_page = 1 if actual_page.blank?

    per_page = params[:per_page]
    per_page = 10 if per_page.blank? || per_page.to_i > 100

    maps = Map.search(params, actual_page, per_page)

    render json:{
        data: maps,
        total_pages: maps.total_pages,
        total_count: maps.total_count,
        actual_page: actual_page

    }
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
