class ItemRepository < Hanami::Repository
  relations :accounts

  def booked_for_account(account_id)
    root
      .where(status: 'lock', account_id: account_id)
      .map_to(Item).to_a
  end

  def all_for_account(id)
    if accounts.by_pk(id).one.role == 'admin'
      root.map_to(Item).to_a
    else
      root.where(status: 'free').map_to(Item).to_a
    end
  end

  def book(item_id, account_id)
    transaction do
      item = update(item_id, account_id: account_id, status: 'lock')
      item_status_repo.create(account_id: account_id, item_id: item_id, status: 'lock')
      item
    end
  end

  def unbook(item_id, account_id)
    transaction do
      item = update(item_id, account_id: nil, status: 'free')
      item_status_repo.create(account_id: account_id, item_id: item_id, status: 'free')
      item
    end
  end

  def broken(item_id, account_id)
    transaction do
      item = update(item_id, account_id: nil, status: 'broken')
      item_status_repo.create(account_id: account_id, item_id: item_id, status: 'broken')
      item
    end
  end

  def fix(public_id, payload)
    transaction do
      item = root.where(public_id: public_id).one
      item = update(item.id, **payload, account_id: nil, status: 'free')
      item_status_repo.create(item_id: item.id, status: 'free')
      item
    end
  end

private

  def item_status_repo
    @item_status_repo ||= ItemStatusRepository.new
  end
end
