class Point
  include Neo4j::ActiveNode

  property :name

  validates :name, :presence => true

  has_one :in, :map, type: :HAS_POINT
  has_many :out, :points, rel_class: :PointDistance

end
