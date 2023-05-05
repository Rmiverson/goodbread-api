module Sort
  def sort_recipe (arr, sort)
    case sort
    when 'date_asc'
      arr.sort_by { |recipe| recipe.created_at }
    when 'date_des'
      arr.sort_by { |recipe| recipe.created_at }.reverse()
    when 'a_z'
      arr.sort_by { |recipe| recipe.title }
    when 'z_a'
      arr.sort_by { |recipe| recipe.title }.reverse()
    else
      arr.sort_by { |recipe| recipe.created_at }
    end
  end

  def sort_tag (arr, sort)
    case sort
    when 'date_asc'
      arr.sort_by { |tag| tag.created_at }
    when 'date_des'
      arr.sort_by { |tag| tag.created_at }.reverse()
    when 'a_z'
      arr.sort_by { |tag| tag.label }
    when 'z_a'
      arr.sort_by { |tag| tag.label }.reverse()
    else
      arr.sort_by { |tag| tag.created_at }
    end
  end

  def sort_folder (arr, sort)
    case sort
    when 'date_asc'
      arr.sort_by { |folder| folder.created_at }
    when 'date_des'
      arr.sort_by { |folder| folder.created_at }.reverse()
    when 'a_z'
      arr.sort_by { |folder| folder.title }
    when 'z_a'
      arr.sort_by { |folder| folder.title }.reverse()
    else
      arr.sort_by { |folder| folder.created_at }
    end
  end
end
