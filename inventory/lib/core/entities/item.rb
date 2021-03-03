class Item < Hanami::Entity
  def free?
    status == 'free'
  end
end
