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

  scope :last_version_by_name, -> (name) {
    where(:name => name)
    .order(version: :desc)
    .first
  }

end
