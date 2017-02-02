<cfscript>

	// These are the two fields that Plupload will post by default.
	
	//Custom fields	
	param name="form.briefing_id" 		type="numeric" default=0;
	param name="form.doc_id" 			type="numeric" default=0;
	param name="form.file_title" 		type="string" default="";
	param name="form.file_name" 		type="string" default="";
	param name="form.user_id" 			type="numeric" default=0;
	param name="form.btn_action"		type="string" default="";
	param name="form.doc_status_id"		type="numeric" default=0;
	param name="form.doc_appv_comment"	type="string" default="";
	
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
	Attrib.doc_updated_by			= Attrib.user_id;
	Attrib.ts						= TimeFormat(now(),'hhmiss') & DateFormat(now(),"mmddyyyy");
	
	//Set status id based on action button
	switch(Attrib.btn_action){
		
		case "approver_resubmit_req":
			Attrib.doc_status_id	= 3;
			break;
		case "approve":
			Attrib.doc_status_id	= 2;
			break;
		default:	
			Attrib.doc_status_id	= 1;
	}	

	//Set resource directory	
	if( LISTCONTAINSNOCASE('igemsdev.epa.gov,igemstrain.epa.gov,igems.epa.gov',cgi.server_name) GT 0 )
	{
		Attrib.resourceDir			= "F:\ewpdev\i2m\resources\complaints\initiation";
	}
	else{
		Attrib.resourceDir			= "F:\ewpdev\i2m\resources\complaints\initiation";
	}	

	//Paths
	Attrib.dirpath 			= "#Attrib.resourceDir#\#Attrib.briefing_id#";
	
	if( LEN(Attrib.doc_file) EQ 0 ){
		Attrib.doc_file = Attrib.orig_file_name;
	}
	
	
	//Copy Attributes scope to setFile scope
	setFile.Attributes			= duplicate(Attrib);
	
	WriteDump(var=Attrib,expand=false,label="Attrib",abort=false); //Debugging only
					
	try
	{
	
		if( (structKeyExists(form,'doc_file') AND LEN(form.doc_file)) ){ 
			
			//check if dir exists
			if( DirectoryExists("#Attrib.dirpath#") IS "No" ){
				DirectoryCreate(Attrib.dirpath);
			}	

	
			//upload file
			//cffileRS						= cfc.cffile_upload('#Attrib.dirpath#\','file_name');
			//FileUpload(destination, filefield, accept, nameconflict)
			cffileRS 						= fileUpload(Attrib.dirpath,"doc_file", "*", "makeUnique");
			

			// NOTE:  Of you uncomment the dumps, the AJAX JSON response will fail! //
  			WriteDump(var=cffileRS,expand=false,label="cffileRS",abort=false); //Debugging only
			
			//Create DB record
			if( cffileRS.FileWasSaved ){

			   //Create unique file name
			   Attrib.newFile 			= createUUID() & '.' & cffileRS.ServerFileExt;
			   
			   //Rename file
				fileMove(
					"#Attrib.dirpath#/#cffileRS.ServerFile#",
					"#Attrib.dirpath#/#Attrib.newFile#"
				);
								
				structAppend(Attrib,cffileRS,true);	
				
				//Save file upload data to database
				Attrib.doc_file 			= Attrib.newFile;
				//Attrib.doc_title			= Attrib.doc_title;//clean
				Attrib.doc_mime				= cffileRS.contenttype;
				Attrib.doc_file_size		= cffileRS.filesize;

			}else{
				
				//Save file upload data to database
				Attrib.doc_file 			= Attrib.orig_file_name;
				Attrib.doc_title			= Attrib.orig_file_name;
			
			}

		}
				
		//Call function to add record			
		setFile						= request.briefing_docs_cfc.editBriefingDoc(argumentCollection=Attrib);
						
		// NOTE:  Of you uncomment the dumps, the AJAX JSON response will fail! //
		//WriteDump(var=setFile,expand=false,label="setFile",abort=true); //Debugging only
		
		//Redirect to documents list
		location('/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm?id=#Attrib.briefing_id#&remove=success');		
				
	}catch(any e){
		
		writeLog(type=e.type,text='Message: ' & e.message & ' Detail: ' & e.detail,file='Briefings_LOG');
		setFile.status						= 'error'; 
		
		//WriteDump(var=e,expand=true,label="Catched error",abort=true); //Debugging only
		//WriteDump(var=setFile,expand=false,label="setFile error",abort=true); //Debugging only
		
		//Redirect to documents list
	  	location('/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm?id=#Attrib.briefing_id#&remove=error');	

	}
	

</cfscript>