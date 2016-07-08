class PointDistance
  include Neo4j::ActiveRel

  property :distance, type: Float

  from_class :Point
  to_class :Point

  type :POINT_DISTANCE
  # validates :distance, :presence => true




end
