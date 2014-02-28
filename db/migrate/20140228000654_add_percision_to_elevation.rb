class AddPercisionToElevation < ActiveRecord::Migration

  def up
    change_table :stations do |t|
      t.change :elevation, :decimal , precision: 15, scale: 2
    end
  end

  def down
    change_table :stations do |t|
      t.change :elevation, :decimal , precision: 6, scale: 2
    end
  end
end
        
      