class Map
  include Neo4j::ActiveNode

  property :name
  property :version, type: Integer, default: 0
  property :created_at

  has_many :out, :points, type: :HAS_POINT

  validates :name, :presence => true

  before_save :increase_version_number

  def increase_version_number
    self.version += 1
  end

  def self.get_cheapest_route(route_info)

    result = Neo4j::Session.query("
        MATCH p=
          //filter by map name and version
          (m:Map {name:{map_name}, version:{version}})

          //include children
          -[:HAS_POINT*]
          ->(p1:Point {name:{origin}})
          -[:POINT_DISTANCE*]
          ->(p2:Point {name: {destiny}})

          //sum distances
        WITH p,reduce(s = 0, r IN rels(p) |
          CASE WHEN
              (type(r) = 'POINT_DISTANCE')
              THEN s + r.distance
              ELSE s + 0
          END
        ) AS distance

        //return the results
        //@TODO: find a way to remove the Map node from the response
        RETURN distance, extract (rel in nodes(p) | rel.name ) as paths

        ORDER BY distance ASC
        limit 1
        ",
          origin:route_info.origin,
          destiny:route_info.destiny,
          map_name:route_info.get_map.name,
          version:route_info.get_map.version
        ).first

    return if result.blank?

    cost = Map.calculate_cost(result.distance, route_info.autonomy, route_info.liter_value)

    #@TODO: find a way to remove the Map node from the neo4j query
    #first element is always the Map node
    result.paths.shift

    return {:cost => cost, :path => result.paths.join(" ")}

  end

  def self.search(params, actual_page, per_page)
    name = params[:name]

    map_query = Map

    if name.present?
      map_query = map_query.where("result_map.name =~ {name}").params(name:".*#{name}.*")
    end


    map_query.order(created_at: :desc).page(actual_page).per(per_page)
  end

  def self.calculate_cost(distance, autonomy, liter_value)
    used_liters = (distance.to_f / autonomy.to_f) * liter_value.to_f
  end



  scope :last_version_by_name, -> (name) {
    where(:name => name)
    .order(version: :desc)
    .first
  }

end
