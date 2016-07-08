class LogisticMeshesController < ApplicationController

  def create
    map_name = params[:name]
    mesh_string = params[:mesh]

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
