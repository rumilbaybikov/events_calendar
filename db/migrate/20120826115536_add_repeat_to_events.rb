class AddRepeatToEvents < ActiveRecord::Migration
  def change
    add_column :events, :repeat, :int, :default => 0
  end
end
