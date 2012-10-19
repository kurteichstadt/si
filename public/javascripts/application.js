$(function() {
	// Payment submission
	$('.submit_payment').live('click', function() {
		var form = $(this).closest('form');
		$.ajax({url: $(this).attr('data-url'), data: form.serializeArray(), type: 'POST', dataType:'script',
                       beforeSend: function (xhr) {
                           $('body').trigger('ajax:loading', xhr);
                       },
                       complete: function (xhr) {
                           $('body').trigger('ajax:complete', xhr);
                       },
                       error: function (xhr, status, error) {
                           $('body').trigger('ajax:failure', [xhr, status, error]);
                       }
						});
		return false;
	});
});

function swapPayment(type) {
	$(".pay_view").hide();
	$('#pay_' + type).show();
}

function searchCampuses(state_el_id, campus_el_id, application_id) {
	$('#spinner_' + campus_el_id).show();
	$.ajax({url: '/campuses/search', 
					dataType:'script', 
					data: {state: $('#' + state_el_id).val(), dom_id: campus_el_id, id: application_id}, 
					type: 'POST'
					}); 
}

function searchProjects(show_all_el_id, project_el_id, url) {
  $.ajax({url: '/hr_si_projects/get_valid_projects', 
          asynchronous:true, 
          evalScripts:true, 
          dataType:'script', 
          data: { show_all: $('#' + show_all_el_id).is(':checked'), dom_id: project_el_id},
          type: 'POST',
         }); return false;
}