class SiQuestionOption < ActiveRecord::Base
end

class Element < ActiveRecord::Base # Actual Element class file has page_id overwritten, so clear it out here
  set_table_name "si_elements"
end

class AddQuestionOptions < ActiveRecord::Migration
  def self.up
    create_table :si_question_options do |t|
      t.integer :question_id
      t.string :option, :limit => 50
      t.string :value, :limit => 50
      t.integer :position
      t.timestamps
    end
    add_index :si_question_options, :question_id
  
    Element.where(kind: "ChoiceField").where("style = 'drop-down' OR style = 'radio'").each do |element|
      content = element.content
      options = content.split("\n")
      counter = 1
      options.each do |option|
        array = option.split(";")
        if array.size == 1
          SiQuestionOption.create!(:question_id => element.id, :option => array[0], :value => array[0], :position => counter)
        else
          SiQuestionOption.create!(:question_id => element.id, :option => array[1], :value => array[0], :position => counter)
        end
        counter += 1
      end
    end
  end

  def self.down
  end
end
