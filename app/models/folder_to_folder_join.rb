class FolderToFolderJoin < ApplicationRecord
    belongs_to :child_folder, class_name: "Folder"
    belongs_to :parent_folder, class_name: "Folder"
end
