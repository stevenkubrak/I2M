 <cfimport prefix="igems" taglib="/common/">
<cfimport prefix="i2m" taglib="/aps/i2m/common/">

<cfscript>
	
	
	//WriteDump(var=form,expand=true,abort=true);//Debugging only

  //Include shared functions
  include "/common/shared_functions.cfm";
  // Declare variables

    
	
	request.page_has_errors=false;
    request.page_load_error_message="";
	
	//connection variables will have to go in here.
	

 	if(structKeyExists(form, "btn_action") AND form.btn_action EQ 'submit_for_approval'){
		form.req_status_id			= 4; 
	}

	request.i2m_cfc					= createObject("component","aps.i2m.cfc.complaints.initiation.initiation_pkg");
	request.qi2mRequest				= request.i2m_cfc.editComplaintInit(ArgumentCollection:form);

 
 </cfscript> 




 <cfif request.page_has_errors eq true>
  <i2m:page_wrapper page_title="i2m edit complaint initiation : edit complaint initiation">
  	<igems:page-error err_message="#request.page_load_error_message#">
  </i2m:page_wrapper>
<cfelse>
  <cflocation url="#application.base_path#/views/complaints/initiation/dsp_complaint_init.cfm" addToken="no"> 
</cfif>



