
def fixture_file_path(filename)
  file_path = File.join(Rails.root, 'spec', 'fixtures', filename)
end

FactoryGirl.define do

  ##################### valid data #####################
  path = fixture_file_path("simple_valid_mesh.txt")
  factory :valid_mesh, class: Hash do
    name "SP"
    mesh File.read(path)
    initialize_with { attributes }
  end


  ##################### invalid data ###################

  path = fixture_file_path("simple_valid_mesh.txt")
  factory :map_without_name, class: Hash do
    name ""
    mesh File.read(path)
    initialize_with { attributes }
  end


  #mesh_with_a_blank_point
  path = fixture_file_path("mesh_with_a_blank_point.txt")
  factory :mesh_with_a_blank_point, class: Hash do
    name "SP"
    mesh File.read(path)
    initialize_with { attributes }
  end

  #mesh_with_negative_distance
  path = fixture_file_path("mesh_with_negative_distance.txt")
  factory :mesh_with_negative_distance, class: Hash do
    name "SP"
    mesh File.read(path)
    initialize_with { attributes }
  end

  #mesh_without_a_point
  path = fixture_file_path("mesh_without_a_point.txt")
  factory :mesh_without_a_point, class: Hash do
    name "SP"
    mesh File.read(path)
    initialize_with { attributes }
  end
end
