class ApplySheet < ActiveRecord::Base
  set_table_name "si_apply_sheets"
  
  belongs_to :apply
  belongs_to :sleeve_sheet    # back to question sheet and retitle
  belongs_to :answer_sheet_question_sheet, :foreign_key => :answer_sheet_id
end

class SleeveSheet < ActiveRecord::Base
  set_table_name "si_sleeve_sheets"
  
  belongs_to :sleeve
  belongs_to :question_sheet
  has_many :apply_sheets  # people applying for this sheet
end

class ChangeAnswerSheetTable < ActiveRecord::Migration
  def self.up
    #First check to make sure we have QE models available
    Apply.where("id = 1")
    
    rename_table :si_character_references, :si_references
    rename_column :si_references, :apply_id, :applicant_answer_sheet_id
    rename_column :si_references, :sleeve_sheet_id, :question_id
    add_column :si_references, :relationship, :string
    add_column :si_references, :title, :string
    rename_column :si_references, :name, :last_name
    add_column :si_references, :first_name, :string
    rename_column :si_references, :token, :access_key
    add_column :si_references, :updated_at, :datetime
    add_column :si_references, :is_staff, :boolean
    execute("UPDATE si_references SET updated_at = created_at")
    execute("UPDATE si_references SET id = (id + 1000000)")  # Discourage answer_sheet_id conflicts with si_applies
    execute("ALTER TABLE si_references AUTO_INCREMENT = 1")  # Actually updates auto_increment to be max(auto_increment)
    
    rename_table :si_answer_sheets, :si_answer_sheet_question_sheets
    add_column :si_answer_sheet_question_sheets, :answer_sheet_id, :integer
    add_index :si_answer_sheet_question_sheets, :answer_sheet_id
    
    rename_column :si_answers, :answer_sheet_id, :answer_sheet_question_sheet_id
    add_column :si_answers, :answer_sheet_id, :integer
    add_index :si_answers, :answer_sheet_question_sheet_id
    add_index :si_answers, :answer_sheet_id
    
    Apply.find_each(:batch_size => 500) do |apply|
      ApplySheet.where("apply_id = #{apply.id}").each do |as|
        ss = as.sleeve_sheet
        if ss.assign_to == "applicant"
          asqs = as.answer_sheet_question_sheet
          asqs.answer_sheet_id = apply.id
          asqs.save!
          execute("UPDATE si_answers SET answer_sheet_id = #{apply.id} WHERE answer_sheet_question_sheet_id = #{asqs.id}")
        else
          ref = ReferenceSheet.where("applicant_answer_sheet_id = ?", apply.id).where("question_id = ?", ss.id).first
          asqs = as.answer_sheet_question_sheet
          asqs.answer_sheet_id = ref.id if ref
          asqs.save!
          execute("UPDATE si_answers SET answer_sheet_id = #{ref.id} WHERE answer_sheet_question_sheet_id = #{asqs.id}") if ref
        end
      end
    end
  end

  def self.down
  end
end
