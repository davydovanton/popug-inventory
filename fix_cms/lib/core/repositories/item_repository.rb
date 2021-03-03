class ItemRepository < Hanami::Repository
  def all_for_fix
    root.where(status: 'broken').map_to(Item).to_a
  end

  def fix(item_id, account_id)
    transaction do
      item = update(item_id, account_id: nil, status: 'fixed')
      item_fix_repo.create(account_id: account_id, item_id: item_id, status: 'fixed')
      item
    end
  end

  def update_broken_status(public_id, payload)
    transaction do
      item = root.where(public_id: public_id).one!
      update(item.id, break_count: item.break_count + 1, status: 'broken', **payload)
      item_fix_repo.create(item_id: item.id, status: 'broken')
      item
    end
  end

private

  def item_fix_repo
    @item_fix_repo ||= ItemFixRepository.new
  end
end
