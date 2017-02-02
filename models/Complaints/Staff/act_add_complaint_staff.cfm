<cfimport prefix="igems" taglib="/common/">
<cfimport prefix="i2m" taglib="/aps/i2m/common/">

<cfscript>

	//WriteDump(var=form,expand=true,abort=true);//Debugging only

  //Include shared functions
  include "/common/shared_functions.cfm";
  // Declare variables

    
	
	request.page_has_errors=false; 
    request.page_load_error_message="";
	


 	if(structKeyExists(form, "btn_action") AND form.btn_action EQ 'submit_for_approval'){
		form.req_status_id			= 4; 
	}

	request.i2m_cfc					= createObject("component","aps.i2m.cfc.complaints.staff.complaint_staff_pkg");
	request.qi2mRequest				= request.i2m_cfc.addComplaintStaff(ArgumentCollection:form);
	


 </cfscript> 




 <cfif request.page_has_errors eq true>
  <i2m:page_wrapper page_title="i2m Add new Briefing : New i2m Briefing">
  	<igems:page-error err_message="#request.page_load_error_message#">
  </i2m:page_wrapper>
<cfelse>
  <cflocation url="#application.base_path#/views/complaints/staff/dsp_staff.cfm?id=#url.id#" addToken="no"> 
</cfif>

