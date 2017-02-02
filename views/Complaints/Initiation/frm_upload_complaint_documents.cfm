<cfsilent>
<cfscript>
		
	Attributes						= structNew();
	
	structAppend(Attributes,URL,true);
	
	//  Declare variables			
	request.page_has_errors	= false;
	request.page_load_error_message	= "";
	request.current_user_id = session.userData.emp_id;
	request.username = session.appUserName;
	request.attach_cfc = CreateObject("component","1811.cfc.time_attachments");
	
	Attributes.sdir = "timesheet_directory/#Attributes.timesheet_id#";
	Attributes.logon_cd = session.appuser;
	Attributes.user_id = session.userid;
	Attributes.show_inactive = "N";

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
        <h4>Attachment upload form<br>
        <small>All entries are required</small></h4>
      </div>
    </div>
    <div class="row">
     <div class="col-sm-4 col-md-4 col-lg-4 col-sm-offset-4 col-md-offset-4 col-lg-offset-4" id="messages"></div>
    </div>
    
    <cfoutput>
      <form name    = "frmAttachmentUpload" 
            id      = "frmAttachmentUpload"
            method  = "POST"
            action  = "/1811/_models/ts_attachments/ts_attachment_upload_act.cfm" 
            enctype = "multipart/form-data" 
            role    = "form" 
            class   = "form-horizontal">
                      
        <input type  = "hidden" 
               name  = "tid"
               id    = "tid"
               value = "#Attributes.timesheet_id#">
                       
        <input type  = "hidden" 
               name  = "user_id"
               id    = "user_id"
               value = "#Attributes.user_id#">
                                  
        <div class="form-group">

            <label class="control-label col-xs-2" for="file_title">Title</label>

            <div class="col-xs-10">

                <input type      = "text" 
                     name      		= "file_title" 
                     id        		= "file_title" 
                     class     		= "form-control"
                     maxlength 		="100"
                     placeholder	="Title" 
                     onKeyUp   		= "ts.countChars(100,this.value.length,'file_title_len');"/>
                <span class="no_error" id="file_title_len">100 characters maximum</span>

            </div>

        </div>

        <div class="form-group">

            <label class="control-label col-xs-2" for="file_name">File</label>

            <div class="col-xs-10">

                <input type    = "file" 
                     name      = "file_name" 
                     id        = "file_name" 
                     class     = "form-control"
                     maxlength ="100"
                     placeholder="File" />
                <span id="file_name_len" class="bg-danger">Please upload only PDF format files.</span>

            </div>

        </div>
      
      </form>

    </cfoutput>

  </div>
  

<script>	
	
	var timesheet_id = $( '#tid' ).val();
	 
	function uploadFile(){ 
	 		
		var file_title 	= $( '#file_title' ).val();
		var file_name 	= $( '#file_name' ).val();
		var has_error 	= 0;
		var error_msg 	= 'Attachment Error\nThe system cannot process your attachment as submitted.\n Please';
		
		//Check for title and file selection
		if( file_title == ''){
			++has_error;
			error_msg += ' enter an attachment title';
		}
		if( file_name == '' ){
			++has_error;
			if(has_error == 1){error_msg += ' select a file';}
			else if(has_error == 2){error_msg += ' and select a file';}
		}
		if($('#file_name').val() != '') {            
			
			$.each($('#file_name').prop("files"), function(k,v){
				var filename = v['name'];    
				var ext = filename.split('.').pop().toLowerCase();
				if($.inArray(ext, ['pdf']) == -1) {
					++has_error;
					error_msg += ' upload only PDF format files';
					//alert('Please upload only PDF format files.');
					return false;
				}
			});        
		}
		if(has_error != 0){
			error_msg += '.';
			alert(error_msg);
			return false;
		}
		
		if(has_error == 0){
			//Change upload file name message
			$( '#file_name_len' ).removeClass('bg-danger');
			$( '#file_name_len' ).addClass('bg-success');
			
			//Disable upload button to prevent duplicate upload
			$( '.upload_button' ).attr('disabled', 'disabled');
			$( '.upload_button' ).text('Uploading...');
			
			//Submit upload form
			$('#frmAttachmentUpload').submit();
		}
	}
	
$('#frmAttachmentUpload').submit(function(e) { 

		var form = $(this);
		var formdata = false;
		if(window.FormData){
			formdata = new FormData(form[0]);
		}

		var formAction = form.attr('action');

		$.ajax({
			type        : 'POST',
			url         : formAction,
			cache       : false,
			data        : formdata ? formdata : form.serialize(),
			dataType	: 'json',
			contentType : false,
			processData : false,

			success: function(response) { console.log(response);
				
				//alert(response.STATUS);
				if(response.STATUS && response.STATUS == 'success') {
					$('#messages').addClass('alert alert-success').text(response.STATUS);
     ts.openAttachmentsList(timesheet_id);
					$( '.upload_button' ).removeAttr('disabled');
					$( '.upload_button' ).html('<span class="glyphicon glyphicon-save"></span> Upload attachment');
				} else {
					$('#messages').addClass('alert alert-danger').text(response.STATUS);
					$( '.upload_button' ).text('Uploading...');
					$( '.upload_button' ).removeAttr('disabled');
					$( '.upload_button' ).html('<span class="glyphicon glyphicon-save"></span> Upload attachment');  
				}
			},
   error: function (XMLHttpRequest, textStatus, errorThrown){
                alert("Status: " + textStatus);
                alert("Error: " + errorThrown);}
		});
		e.preventDefault();
	});
			
</script>

<cfsetting showdebugoutput="no"/>