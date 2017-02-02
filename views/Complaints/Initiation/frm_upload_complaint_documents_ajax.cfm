<cfsilent>
<cfscript>
		
	Attrib								= structNew();
	
	structAppend(Attrib,URL,true);
	
	//  Declare variables			
   	request.page_has_errors				= false;
   	request.page_load_error_message		= "";
   	request.auth_user					= false;

	//Instatiate CFC's
	request.people_cfc 					= createObject("component","aps.i2m.cfc.briefings.people_pkg");
	request.org_elements_cfc 			= createObject("component","cfc.organization_elements_pkg");
	request.complaint_docs_cfc			= createObject("component","aps.i2m.cfc.complaints.complaint_docs_pkg");
	
	//WriteDump(var=cookie,expand=true,abort=true);//Debugging only

	//Remap variables as necessary	
	Attrib.sdir 						= "document_directory/#Attrib.id#";
	Attrib.logon_cd 					= cookie.current_user_logon_code;
	Attrib.user_id 						= cookie.current_user_id;

</cfscript>
</cfsilent>

<!--- Page level error handling in case something went wrong above --->
<cfif request.page_has_errors eq true>
  <cf_page-error title="Page Error" err_message="#request.page_load_error_message#">
  <cfabort>
</cfif>


    <div class="container-fluid">
      
      <div class="row" style="margin-bottom:1em;">
        <div class="col-sm-12">
          <small>All entries are required</small></h4>
        </div>
      </div>
      
      <div class="row">
       <div class="col-sm-4 col-md-4 col-lg-4 col-sm-offset-4 col-md-offset-4 col-lg-offset-4" id="messages"></div>
      </div>

      <div class="row clearfix">
        <div class="col-md-12 column">
		
       	<cfoutput>

        <form 
        name    = "frmDocumentUpload" 
        method  = "POST" 
        enctype = "multipart/form-data" 
        role    = "form" 
        class   = "form-horizontal">

            <input type  = "hidden" 
                   name  = "briefing_id"
                   id    = "briefing_id"
                   value = "#Attrib.id#">
                           
            <input type  = "hidden" 
                   name  = "user_id"
                   id    = "user_id"
                   value = "#Attrib.user_id#">
                   
			<input type  = "hidden"
            	   name  = "file_type"
                   id    = "file_type"
                   value = "">
                   
			<input type  = "hidden"
            	   name  = "file_size"
                   id    = "file_size"
                   value = "">
                                      
           <div class="form-group">
            <div class="col-sm-6">
                
                <div id="uploader" class="uploader">Drop file(s) here or click Select Files button</div>
                
            </div>
          </div>
 
           <div class="form-group standby">
            <div class="col-sm-6">
                 Waiting for files...
            
                <span id="progress" class="progress"></span>
                
            </div>
          </div>
 
          <div class="form-group">
            <div class="col-sm-6">
            
                <span id="progress" class="progress"></span>
                
            </div>
          </div> 
                     
        </form>
        
        </cfoutput>

        </div>
      </div>
    </div>




<cfsilent>
<cfsavecontent variable="htmlHead"> 
<link rel="stylesheet" type="text/css" href="/aps/i2m/css/uploader-styles.css"></link>
</cfsavecontent>
<cfhtmlhead text="#htmlHead#"/>  
</cfsilent>  

<!-- Load and initialize scripts. -->
<script type="text/javascript" src="/aps/i2m/js/external/plupload/js/plupload.full.min.js"></script>
<script type="text/javascript">

    (function( $, plupload ) {
				
        // Find and cache the DOM elements we'll be using.
        var dom = {
            uploader: $( "#uploader" ),
            percent: $( "#uploader span.percent" ),
            briefing_id: $( "#briefing_id" ),
            user_id: $( "#user_id" ),
			file_type: $( "#file_type" ),
			file_size: $( "#file_size" )
            
        };

        // Instantiate the Plupload uploader.
        var uploader = new plupload.Uploader({
            runtimes: "html5",
            url: "/aps/i2m/models/complaints/initiation/act_upload_complaint_document_ajax.cfm",
            drop_element: "uploader",
            browse_button: "selectFiles",
            container: "uploader",
            flash_swf_url: "/aps/i2m/js/external/plupload/js/Moxie.swf",
            urlstream_upload: true,
            file_data_name: "file",
            multipart: true,				
            multipart_params: {
                    "complaint_id": dom.briefing_id.val(),
                    "user_id": dom.user_id.val(),
					"file_type": dom.file_type.val(),
					"file_size": dom.file_size.val()
            },
			filters : {
				max_file_size : '2gb',
	 
				// Specify what files to browse for
				mime_types: [
					{title : "Image files", extensions : "jpeg,jpg,gif,png"},
					{title : "MS Office files", extensions : "doc,docx,xls,xlsx,ppt,pptx"},
					{title : "PDF files", extensions : "pdf"},
					{title : "Zip files", extensions : "zip"}
				]
			},
            chunk_size: "10mb",
            unique_names : false,
            max_retries: 3

        });

        // Set up the event handlers for the uploader.
        uploader.bind( "Init", handlePluploadInit );
        uploader.bind( "Error", handlePluploadError );
        uploader.bind( "FilesAdded", handlePluploadFilesAdded );
        uploader.bind( "QueueChanged", handlePluploadQueueChanged );
        uploader.bind( "BeforeUpload", handlePluploadBeforeUpload );
        uploader.bind( "UploadProgress", handlePluploadUploadProgress );
        uploader.bind( "ChunkUploaded", handlePluploadChunkUploaded );
        uploader.bind( "FileUploaded", handlePluploadFileUploaded );
        uploader.bind( "StateChanged", handlePluploadStateChanged );
        
        // Initialize the uploader (it is only after the initialization is complete that 
        // we will know which runtime load: html5 vs. Flash).
        uploader.init();

        // I provide access to the uploader and the file right before the upload is about 
        // to being. This allows for just-in-time altering of the settings.
        function handlePluploadBeforeUpload( uploader, file ) {
        
            console.log( "Upload about to start.", file.name );
			console.log( "Upload about to start. Mime:", file.type );
			console.log( "Upload about to start. Size:", file.size );
			dom.file_type.val(file.type);
			dom.file_size.val(file.size);
            
        }

        
        // I handle the successful upload of one of the chunks (of a larger file).
        function handlePluploadChunkUploaded( uploader, file, info ) {
        
            console.log( "Chunk uploaded.", info.offset, "of", info.total, "bytes." );				

        }


        // I handle any errors raised during uploads.
        function handlePluploadError() {
            
            console.warn( "Error during upload." );

        }


        // I handle the files-added event. This is different that the queue-changed event.
        // At this point, we have an opportunity to reject files from the queue.
        function handlePluploadFilesAdded( uploader, files ) {

            //Add a new container for each file uploaded
            plupload.each(files, function(file) {
                console.log('  File:', file);
                //console.log('File id: ' + file.id);//debugging only
                $( "#progress" ).append( '<div>Uploading - <span id="' + file.id + '" class="percent"></span>%</div><br>' );
            });

        }


        // I handle the successful upload of a whole file. Even if a file is chunked,
        // this handler will be called with the same response provided to the last
        // chunk success handler.
        function handlePluploadFileUploaded( uploader, file, response ) {
        
            console.log( "Entire file uploaded.", response );

        }


        // I handle the init event. At this point, we will know which runtime has loaded,
        // and whether or not drag-drop functionality is supported.
        function handlePluploadInit( uploader, params ) {

            console.log( "Initialization complete." );
            console.info( "Drag-drop supported:", !! uploader.features.dragdrop );

        }


        // I handle the queue changed event.
        function handlePluploadQueueChanged( uploader ) {

            console.log( "Files added to queue." );

            if ( uploader.files.length && isNotUploading() ){

                uploader.start();

            }

        }


        // I handle the change in state of the uploader.
        function handlePluploadStateChanged( uploader ) {

            if ( isUploading() ) {

                dom.uploader.addClass( "uploading" );

            } else {

                dom.uploader.removeClass( "uploading" );
				//Return to document list
				window.location = "/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm?id=" + dom.complaint_id.val();

            }

        }


        // I handle the upload progress event. This gives us the progress of the given 
        // file, NOT of the entire upload queue.
        function handlePluploadUploadProgress( uploader, file ) {

            console.info( "Upload progress:", file.percent );
            //console.log(file);

            //dom.percent.text( file.percent );
            
            $( "#"+file.id ).text( 'File:' + file.name + ' is ' + file.percent );

        }


        // I determine if the upload is currently inactive.
        function isNotUploading() {

            var currentState = uploader.state;

            return( currentState === plupload.STOPPED );

        }


        // I determine if the uploader is currently uploading a file (or if it is inactive).
        function isUploading() {

            var currentState = uploader.state;

            return( currentState === plupload.STARTED );

        }

    })( jQuery, plupload );

</script>