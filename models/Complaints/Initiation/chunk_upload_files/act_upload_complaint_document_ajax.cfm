<cfscript>

	// These are the two fields that Plupload will post by default.
    param name="form.name" 			type="string";
    param name="form.file" 			type="string";
	param name="form.file_type" 	type="string" default="";
	param name="form.file_size" 	type="string" default="";
	
	//Custom fields	
	param name="form.briefing_id" 	type="numeric" default="0";
	param name="form.file_title" 	type="string" default="";
	param name="form.file_name" 	type="string" default="";
	param name="form.user_id" 		type="numeric" default="0";
	
	//Declare request variables			
   	request.page_has_errors				= false;
   	request.page_load_error_message		= "";
   	request.auth_user					= false;

	//Instatiate CFC's
	request.complaint_docs_cfc			= createObject("component","aps.i2m.cfc.complaints.initiation.complaint_docs_pkg");
		
	Attrib								= structNew();
	
	structAppend(Attrib,URL,true);
	structAppend(Attrib,FORM,true);		
	
	WriteDump(var="#form#",abort="false");//Debuging only
	
	//Custom Attributes	
	Attrib.ts						= TimeFormat(now(),'hhmiss') & DateFormat(now(),"mmddyyyy");
	
	//Paths
	//Attrib.dirpath 					= expandPath( "/aps/i2m/resources/briefings/#Attrib.briefing_id#" );	
	//.chunksdir						= expandPath( "/aps/i2m/resources/briefings/#Attrib.briefing_id#/chunks/" );
	Attrib.dirpath 					= "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#";	
	Attrib.chunksdir				= "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\chunks\";
		
	WriteDump(var=Attrib,expand=true,abort=false);//Debugging only
	
	//check if core directorys exists
	if( DirectoryExists("#Attrib.dirpath#") IS "No" ){
		DirectoryCreate(Attrib.dirpath);
	}	

	if( DirectoryExists("#Attrib.chunksdir#") IS "No" ){
		DirectoryCreate(Attrib.chunksdir);
	}
	
	//Remove disallowed characters and rename uploaded file
	Attrib.clean_file_name	= REReplace(form.name,"[^\w\-.]+","","ALL");	
	//Attributes.clean_file_name	= Attributes.ts & "_" & REReplace(form.name,"[^\w\-.]+","","ALL");	


	// We are executing a normal upload (ie, the entire file at once).
	if ( isNull( form.chunks ) ) {


		fileExtension = listLast( form.name, "." );

		//Check for existing file, copy to old directory if found
		if ( FileExists( "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#Attrib.clean_file_name#" ) ){
			
			if( DirectoryExists( "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\old\" ) IS "No" ){
				DirectoryCreate( "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\old\" );
			}
			
			fileMove(
				"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\Attrib.clean_file_name",
				"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\old\#createUUID()#-#Attrib.clean_file_name#"
			);
						
		}

		//Upload file
		fileMove(
			form.file,
			"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#"
		);
		
		//Rename uploaded file			
		fileMove(
			"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#form.name#",
			"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#Attributes.clean_file_name#"
		);


	// We are executing a chunked upload.
	} else {
		

		// Since we are dealing with chunks, instead of a full file, we'll be appending each
		// chunk to the known file, keeping the transient file out of main directory
		// until the chunking has been completed.
		upload = fileOpen( "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\chunks\#form.name#", "append" );

		// Append the current chunk to the end of the transient file.
		fileWrite( upload, fileReadBinary( form.file ) );
		fileClose( upload );

		// If this is the last of the chunks, the we can move the transient file 
		if ( form.chunk == ( form.chunks - 1 ) ) {

			fileExtension = listLast( form.name, "." );
			
			//Check for existing file, copy to old directory if found
			if ( FileExists( "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#Attrib.clean_file_name#" ) ){ 
				
				if( DirectoryExists( "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\old\" ) IS "No" ){
					DirectoryCreate( "F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\old\" );
				}
				
				fileMove(
					"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#Attrib.clean_file_name#",
					"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\old\#createUUID()#-#Attrib.clean_file_name#"
				);
							
			}
			
			fileMove(
				"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\chunks\#form.name#",
				"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#form.name#"
			);
			
			//Rename uploaded file			
			fileMove(
				"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#form.name#",
				"F:\ewpdev\i2m\resources\complaints\initiation\#Attrib.briefing_id#\#Attrib.clean_file_name#"
			);
			
			//Save file upload data to database
			Attrib.doc_file 			= Attrib.clean_file_name;
			Attrib.doc_title			= Attrib.name;
			Attrib.doc_mime				= Attrib.file_type;
			Attrib.doc_file_size		= Attrib.file_size;
			Attrib.doc_created_by		= Attrib.user_id; 
			
			//Call function to add record			
			setFile						= request.complaints_docs_cfc.addComplaintsDoc(argumentCollection=Attrib);
			
			//WriteDump(var="#Attributes#",abort="false");//Debuging only
			//WriteDump(var="#setFile#",abort="true");//Debuging only
				
		}


	}	

</cfscript>

<!--- Reset the content buffer. --->
<!---<cfcontent 
	type="text/plain" 
	variable="#charsetDecode( 'success', 'utf-8' )#"
	/>--->