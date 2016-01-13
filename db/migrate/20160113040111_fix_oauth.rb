class FixOauth < ActiveRecord::Migration
  def change
    remove_column :users, :provider, :string
    remove_column :users, :uid, :integer

    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
