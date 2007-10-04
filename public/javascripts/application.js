function swapPayment(type) {
	var views = document.getElementsByClassName("pay_view");
	for (i=0;i<views.length;i++){
		Element.hide(views[i]);
	}
	$('pay_' + type).show();
}

var CreditCard = Class.create();
CreditCard.prototype = {
	initialize : function(num) {
		this.number = num.replace(/ /g,"");
	},
	
	getType : function() {
		var mc_regEx = /^5[1-5]/;
		var visa_regEx = /^4/;
		var amex_regEx = /^3(4|7)/;
		var disc_regEx = /^6(011|5)/;
		
		if (mc_regEx.test(this.number)) return "master";
		else if (visa_regEx.test(this.number)) return "visa";
		else if (amex_regEx.test(this.number)) return "american_express";
		else if (disc_regEx.test(this.number)) return "discover";
		else return null;
	},
	
	validate : function() {
		if (this.getType() == null) return false;
//		if (this.number.length < 15 || this.number.length > 16) return false;
		return true;
	}
}

function checkCard(num) {
	var cc = new CreditCard(num);
	var icons = document.getElementsByClassName("cc_type");
	var isValid = cc.validate();
	
	if (isValid) {
		$('cc_invalid').hide();
		for (i=0;i<icons.length;i++) {
			icons[i].src = "/images/" + icons[i].id + "_off.gif";
			Element.show(icons[i]);
		}
		$('cc_' + cc.getType()).src = '/images/cc_' + cc.getType() + "_on.gif";
		$('payment_card_type').value = cc.getType();
	}
	else {
		for (i=0;i<icons.length;i++) {
			Element.hide(icons[i]);
			$('cc_invalid').show();
		}
	}
}

function searchCampuses(state_el_id, campus_el_id, url) {
	// This is really stupid.  You can't update select elements using an Updater.  IE doesn't allow innerHTML updates on select elements.
	new Ajax.Request('/campuses;search', {asynchronous:true, evalScripts:true, parameters: {state: $F(state_el_id)},
	                                      onSuccess: function(transport) {
										  	campuses = transport.responseText.split('|');
											$(campus_el_id).options.length = 0;
											$(campus_el_id).options.add(document.createElement("OPTION"));
											for(i=0;i<campuses.length;i++) {
												var optn = document.createElement("OPTION");
											    optn.text = campuses[i];
											    optn.value =campuses[i];
											    $(campus_el_id).options.add(optn);
											}
											
										  }
										  }); return false;
}

function searchProjects(show_all_el_id, project_el_id, url) {
	new Ajax.Request('/hr_si_projects;get_valid_projects', {asynchronous:true, evalScripts:true, parameters: { show_all: $F(show_all_el_id)},
	                                      onSuccess: function(transport) {
										  	projects = transport.responseText.split('|');
											$(project_el_id).options.length = 0;
											$(project_el_id).options.add(document.createElement("OPTION"));
											for(i=0;i<projects.length;i++) {
												pair = projects[i].split("::");
												var optn = document.createElement("OPTION");
												optn.text = pair[1];
												optn.value = pair[0];
												$(project_el_id).options.add(optn);
											}

  										}
											
										  }); return false;
}