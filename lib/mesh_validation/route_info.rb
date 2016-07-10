module MeshValidation

  #class that helps with route params validation
  class RouteInfo

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming


    attr_accessor :origin, :destiny, :map_name, :autonomy, :liter_value
    attr_reader :map

    validates :map_name, presence: true
    validates :origin, presence: true
    validates :destiny, presence: true
    validates :autonomy, numericality: { greater_than: 0.0 }
    validates :liter_value, numericality: { greater_than: 0.0 }

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def has_map?
      if get_map.blank?
        errors.add(:map, :blank, message:"not found!")
        return false
      end

      true
    end

    def get_map
       @map ||= Map.last_version_by_name(@map_name)
    end

    def persisted?
      false
    end

  end
end
