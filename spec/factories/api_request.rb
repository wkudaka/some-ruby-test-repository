
def fixture_file_path(filename)
  file_path = File.join(Rails.root, 'spec', 'fixtures', filename)
end

def get_file_to_upload(filename)
  path = fixture_file_path(filename)
  ActionDispatch::Http::UploadedFile.new(:tempfile => File.new(path), :filename => "mesh.txt")
end

FactoryGirl.define do

  ##################### valid data #####################
  factory :valid_mesh, class: Hash do
    name "SP"
    mesh get_file_to_upload("simple_valid_mesh.txt")
    initialize_with { attributes }
  end

  factory :another_valid_mesh, class: Hash do
    name "SP"
    mesh get_file_to_upload("simple_valid_mesh2.txt")
    initialize_with { attributes }
  end


  ##################### invalid data ###################

  factory :map_without_name, class: Hash do
    name ""
    mesh get_file_to_upload("simple_valid_mesh.txt")
    initialize_with { attributes }
  end

  #blank mesh
  factory :mesh_blank, class: Hash do
    name "SP"
    mesh get_file_to_upload("mesh_blank.txt")
    initialize_with { attributes }
  end

  #mesh_with_a_blank_point
  factory :mesh_with_a_blank_point, class: Hash do
    name "SP"
    mesh get_file_to_upload("mesh_with_a_blank_point.txt")
    initialize_with { attributes }
  end

  #mesh_with_negative_distance
  factory :mesh_with_negative_distance, class: Hash do
    name "SP"
    mesh get_file_to_upload("mesh_with_negative_distance.txt")
    initialize_with { attributes }
  end

  #mesh_without_a_point
  factory :mesh_without_a_point, class: Hash do
    name "SP"
    mesh get_file_to_upload("mesh_without_a_point.txt")
    initialize_with { attributes }
  end
end
