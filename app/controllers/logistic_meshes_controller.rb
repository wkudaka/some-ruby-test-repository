class LogisticMeshesController < ApplicationController

  def create
    map_name = params[:name]
    mesh_string = params[:mesh]

    mesh = MeshValidation::Mesh.new(mesh_string)

    #TODO: format responses
    if mesh.valid?

      map = Map.last_version_by_name(map_name)

      map = Map.new if map.nil?

      map.name = map_name
      map.points << mesh.get_points
      map.save
      render json: {}
    else

      render json: {}, status: 422
    end



  end

end
