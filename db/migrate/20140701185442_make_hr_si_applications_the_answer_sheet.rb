class MakeHrSiApplicationsTheAnswerSheet < ActiveRecord::Migration
  def up
    queries = [ 
      "update si_answer_sheet_question_sheets a join hr_si_applications h on a.answer_sheet_id = h.apply_id set a.answer_sheet_id = h.applicationID",
      "update si_answers a join hr_si_applications h on a.answer_sheet_id = h.apply_id set a.answer_sheet_id = h.applicationID",
      "update si_apply_sheets_deprecated a join hr_si_applications h on a.answer_sheet_id = h.apply_id set a.answer_sheet_id = h.applicationID",
      "update si_payments a join hr_si_applications h on a.answer_sheet_id = h.apply_id set a.answer_sheet_id = h.applicationID",
      "update si_references a join hr_si_applications h on a.applicant_answer_sheet_id = h.apply_id set a.applicant_answer_sheet_id = h.applicationID"
    ]

    queries.each do |query|
      execute query
    end

    # update submitDate
    execute "update hr_si_applications apps join si_applies applies on apps.apply_id = applies.id set apps.submitDate = applies.submitted_at"
    execute "update hr_si_applications apps join si_applies applies on apps.apply_id = applies.id set apps.submitDate = applies.submitted_at"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
