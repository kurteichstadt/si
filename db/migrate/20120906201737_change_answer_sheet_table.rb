class ChangeAnswerSheetTable < ActiveRecord::Migration
  def self.up
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
    
    rename_table :si_answer_sheets, :si_answer_sheet_question_sheets
    add_column :si_answer_sheet_question_sheets, :answer_sheet_id, :integer
    add_index :si_answer_sheet_question_sheets, :answer_sheet_id
    
    rename_column :si_answers, :answer_sheet_id, :answer_sheet_question_sheet_id
    add_column :si_answers, :answer_sheet_id, :integer
    add_index :si_answers, :answer_sheet_question_sheet_id
    add_index :si_answers, :answer_sheet_id
    
    Apply.find_each(:batch_size => 500) do |apply|
      apply.apply_sheets.each do |as|
        asqs = as.answer_sheet_question_sheet
        asqs.answer_sheet_id = apply.id
        asqs.save!
        ss = as.sleeve_sheet
        if ss.assign_to == "applicant"
          execute("UPDATE si_answers SET answer_sheet_id = #{apply.id} WHERE answer_sheet_question_sheet_id = #{asqs.id}")
        else
          ref = ReferenceSheet.where("applicant_answer_sheet_id = ?", apply.id).where("question_id = ?", ss.id).first
          execute("UPDATE si_answers SET answer_sheet_id = #{ref.id} WHERE answer_sheet_question_sheet_id = #{asqs.id}") if ref
        end
      end
    end
  end

  def self.down
  end
end
