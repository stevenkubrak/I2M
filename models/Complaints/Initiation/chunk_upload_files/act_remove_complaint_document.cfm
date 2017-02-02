<cfscript>

	// These are the two fields that Plupload will post by default.
    param name="form.name" 			type="string" default="";
    param name="form.file" 			type="string" default="";
	param name="form.file_type" 	type="string" default="";
	param name="form.file_size" 	type="string" default="";
	
	//Custom fields	
	param name="form.briefing_id" 	type="numeric" default="0";
	param name="form.doc_id" 		type="numeric" default="0";
	param name="form.file_title" 	type="string" default="";
	param name="form.file_name" 	type="string" default="";
	param name="form.user_id" 		type="numeric" default="0";
	
	//Declare request variables			
   	request.page_has_errors				= false;
   	request.page_load_error_message		= "";
   	request.auth_user					= false;

	//Instatiate CFC's
	request.briefing_docs_cfc			= createObject("component","aps.i2m.cfc.briefings.briefing_docs_pkg");
		
	Attrib								= structNew();
	
	structAppend(Attrib,URL,true);
	structAppend(Attrib,FORM,true);		
	
	WriteDump(var="#form#",label="form",expand=false,abort="false");//Debuging only
	
	//Custom Attributes	
	Attrib.doc_removed_by				= Attrib.user_id;
	
	WriteDump(var=Attrib,label="Attrib top",expand=false,abort=false);//Debugging only
	
	try{
		
	  
	  //Call function to remove a record			
	  request.setFile					= request.briefing_docs_cfc.removeComplaintDoc(argumentCollection=Attrib);
	  
	  //WriteDump(var="#Attrib#",abort="false");//Debuging only
	  //WriteDump(var="#request.setFile#",label="request",abort=true);//Debuging only
	  
	  //Redirect to documents list
	  location('/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm?id=#Attrib.briefing_id#&remove=success');
					
		
	}catch(any e){
		
		writeLog(type=e.type,text='Message: ' & e.message & ' Detail: ' & e.detail,file='Briefings_LOG');
		//WriteDump(var="#e#",label="Error",abort=true);//Debuging only
		
		//Redirect to documents list
	  	location('/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm?id=#Attrib.briefing_id#&remove=error');
	
	}

</cfscript>