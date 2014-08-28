class RenameSiPaymentsAnswerSheetIdToApplicationId < ActiveRecord::Migration
  def change
    rename_column :si_payments, :answer_sheet_id, :application_id
  end
end
