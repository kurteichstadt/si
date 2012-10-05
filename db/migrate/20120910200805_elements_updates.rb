class Element < ActiveRecord::Base # Actual Element class file has page_id overwritten, so clear it out here
  set_table_name "si_elements"
end

class PageElement < ActiveRecord::Base
  set_table_name "si_page_elements"
  belongs_to :page
  belongs_to :element
end

class ElementsUpdates < ActiveRecord::Migration
  def self.up
    create_table :si_page_elements do |t|
      t.integer :page_id
      t.integer :element_id
      t.integer :position
      t.timestamps
    end
    add_index :si_page_elements, :page_id
    add_index :si_page_elements, :element_id
   
    add_column :si_elements, :total_cols, :string
    add_column :si_elements, :css_id, :string
    add_column :si_elements, :css_class, :string
    add_column :si_elements, :created_at, :datetime
    add_column :si_elements, :updated_at, :datetime
    add_column :si_elements, :related_question_sheet_id, :integer
    add_column :si_elements, :conditional_id, :integer
    add_column :si_elements, :tooltip, :text
    add_column :si_elements, :hide_label, :boolean, :default => false
    add_column :si_elements, :hide_option_labels, :boolean, :default => false
    add_column :si_elements, :max_length, :integer
    add_index :si_elements, :position
    
    Element.order("page_id, position").each do |element|
      if element.question_grid_id.blank?
        PageElement.create!(:page_id => element.page_id, :element_id => element.id, :position => element.position)
      end
    end
  end

  def self.down
  end
end
