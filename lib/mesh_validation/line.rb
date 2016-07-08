module MeshValidation

  class Line

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming


    attr_accessor :origin, :destiny, :distance

    validates :origin, presence: true
    validates :destiny, presence: true
    validates :distance, numericality: { greater_than: 0.0 }

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def persisted?
      false
    end

  end
end
