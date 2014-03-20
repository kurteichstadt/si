class ChangeApplyIdToAnswerSheetIdOnPayment < ActiveRecord::Migration
  def change
    rename_column :si_payments, :apply_id, :answer_sheet_id
  end
end
