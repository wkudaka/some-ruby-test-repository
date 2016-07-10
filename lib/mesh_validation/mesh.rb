module MeshValidation
  #class that helps with mesh string validations
  class Mesh

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming


    attr_accessor :lines, :lines_errors

    def initialize(mesh_string)
      @lines = []
      @lines_errors = []

      if mesh_string.blank?
        @lines_errors << "empty file"
        return
      end

      mesh_lines = mesh_string.split("\n")
      create_and_validate_lines(mesh_lines)

    end

    def create_and_validate_lines(mesh_lines)

      mesh_lines.each_with_index do |line, line_index|
        line_arr = line.split(" ")

        line_atts = {
          :origin => line_arr[0],
          :destiny => line_arr[1],
          :distance => line_arr[2].to_f
        }

        line = MeshValidation::Line.new(line_atts)

        if !line.valid?

          line.errors.messages.each do |key, messages|

            messages.each do |msg|
              @lines_errors << "Line:#{line_index+1} - #{key}: #{msg}"
            end

          end

        end

        lines << line

      end
    end

    def valid?
      lines_errors.size === 0
    end

    def get_points
      created_points = {}

      @lines.each do |line|

        #create points
        origin_point = get_or_create_point(created_points, line.origin)
        destiny_point = get_or_create_point(created_points, line.destiny)

        #create the relationship
        origin_point.points.create(destiny_point, distance:line.distance)
      end

      #return all points as an array
      created_points.values
    end

    private

    def get_or_create_point(created_points, name)
      point = created_points[name]

      if point.nil?
        point = Point.new(name:name)
        created_points[name] = point
      end

      point
    end

  end
end
