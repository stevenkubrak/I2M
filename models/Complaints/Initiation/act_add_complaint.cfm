 <cfimport prefix="igems" taglib="/common/">
<cfimport prefix="i2m" taglib="/aps/i2m/common/">

<cfscript>
	//Attributes							= structNew();
	
	//structAppend(Attributes,FORM,true);	
		
	param name="Attributes.DATE" default="#form.due_date#";
	
	//WriteDump(var=form,expand=true,abort=true);//Debugging only

  //Include shared functions
  include "/common/shared_functions.cfm";
  // Declare variables

    
	
	request.page_has_errors=false; 
    request.page_load_error_message="";
	
	//connection variables will have to go in here.
	
	//--- set fiscal year --->
	Attributes.quater = datepart("q", Attributes.date);
	Attributes.fyear = DateFormat(Attributes.date, "yyyy");
	
	IF( Attributes.quater is 4 )
	{
		Attributes.fyear = Attributes.fyear + 1;
	}
	
	Attributes.Fiscal_year 				= DateFormat(CreateDate(Attributes.fyear, 1, 1), "mm/dd/yyyy");
	
	form.fiscal_year					= Attributes.Fiscal_year;
	

 	if(structKeyExists(form, "btn_action") AND form.btn_action EQ 'submit_for_approval'){
		form.req_status_id			= 4; 
	}

	request.i2m_cfc					= createObject("component","aps.i2m.cfc.complaints.initiation.initiation_pkg");
	request.qi2mRequest				= request.i2m_cfc.addComplaintInit(ArgumentCollection:form);
	
	//#form.maxid#
	
	if (DirectoryExists('F:/i2m/resources/complaints/#form.maxid#')) {
		file_results = fileUpload('F:/i2m/resources/complaints/#form.maxid#','form.file_name','*','makeUnique');
	}else{
		DirectoryCreate('F:/i2m/resources/complaints/#form.maxid#');
		file_results = fileUpload('F:/i2m/resources/complaints/#form.maxid#','form.file_name','*','makeUnique');
	}
	
	
	
	//Build the variables to pass into the doc form
				Attributes.file_name_old 							= 'F:/i2m/resources/complaints/#form.maxid#/#form.file_name#';	
				Attributes.newid 									= form.maxid;
				Attributes.file_desc								= form.file_desc;
				Attributes.uploaded_by								= form.user_id;
				Attributes.doc_application_path						= '/i2m/resources/complaints/#form.maxid#/';
				Attributes.creator_id								= form.user_id;
				stamp												= #DateFormat(Now(), "yyyymmdd")# & '_' & #TimeFormat(Now(), "hhmmss")# ;				
			   	Attributes.file_name 								= 'COMP-' & Attributes.fyear & '-' & #form.office# & '_' & 'I-' &#stamp# & '.' & file_results.ServerFileExt;
				Attributes.file_rename								= 'F:/i2m/resources/complaints/#form.maxid#/#Attributes.file_name#';
				
	//Rename that file			
	//filemove(#Attributes.file_name_old#,#Attributes.file_rename#);

	//WriteDump(var=attributes,expand=true,abort=true);//Debugging only				
				
				
	//send the info to the CFC			
				request.qi2mRequest2				= request.i2m_cfc.addComplaintDoc(argumentCollection=Attributes);
	
 </cfscript> 




 <cfif request.page_has_errors eq true>
  <i2m:page_wrapper page_title="i2m Add new Briefing : New i2m Briefing">
  	<igems:page-error err_message="#request.page_load_error_message#">
  </i2m:page_wrapper>
<cfelse>
  <cflocation url="#application.base_path#/views/complaints/staff/frm_add_staff.cfm?id=#Attributes.newid#" addToken="no"> 
</cfif>

