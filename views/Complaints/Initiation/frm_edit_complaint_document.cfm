<cfimport prefix="i2m" tagLib="/aps/i2m/common/">
<cfimport prefix="igems" tagLib="/common">
<i2m:page_wrapper format="full" page_title="Investigations">
<cfscript>

  param name="url.id" default=0;
  param name="url.doc_id" default=0;

  // Include shared functions
  include "/common/shared_functions.cfm";
  
  // Declare variables and instantiate CFC
  try{

	//Set default for page errors and relate message	  	  
   	request.page_has_errors				= false;
   	request.page_load_error_message		= "";
	
	//Get encryption key and use it to decrypt request id
	request.key 						= cookie.key;
	request.doc_id						= decrypt( url.doc_id, request.key, 'AES/CBC/PKCS5Padding', 'HEX');
	//request.doc_id						= url.doc_id;
	
	    
	//Instatiate CFC's
	request.briefing_docs_cfc			= createObject("component","aps.i2m.cfc.briefings.briefing_docs_pkg");
	request.i2m_util_cfc				= createObject("component","aps.i2m.cfc.utility");
	
	//Function calls
	request.q_briefing_docs				= request.briefing_docs_cfc.selBriefingDoc(request.doc_id);
	
	//Get permissions
	request.q_permissions 				= getPermissions(cookie.current_user_id,11);
	
	//Variables	
   	request.auth_user					= false;
	request.rows_to_add                 = 0;

	Attrib.logon_cd 					= cookie.current_user_logon_code;
	Attrib.user_id 						= cookie.current_user_id;
	Attrib.briefing_id					= request.q_briefing_docs.briefing_id;	
	
		
	//Paths
	Attrib.urlPath						= "/aps/i2m/resources/briefings/#url.id#";
		
	WriteDump(var=request.q_permissions,expand=false,abort=false);//Debugging only
	WriteDump(var=request.q_briefing_docs,expand=false,abort=false);//Debugging only
   
   }
  catch(any excpt){handleError(excpt);}
  
  // Is the person accessing this page authorized?
  if(request.page_has_errors eq false){
  	// check for ASGTS_USER role
  	if(listFindNoCase(cookie.current_user_roles,'I2M_USER') neq 0){
    	request.auth_user=true;}
  }  
</cfscript>
<cfif structKeyExists(request,'page_has_errors') and request.page_has_errors eq true>
	<igems:page-error err_message="#request.page_load_error_message#">
<cfelse>
    <div class="row">
        <div>
            <ul class="breadcrumb">
                <li><a href="/">IGEMS</a>
                <li><a href="/aps/i2m/">Investigations</a>
                <li><a href="/aps/i2m/views/briefings/dsp_briefings.cfm">Briefings</a></li>
                <li><a href="/aps/i2m/views/Briefings/dsp_briefings_documents.cfm?id=<cfoutput>#Attrib.briefing_id#</cfoutput>">Briefings Documents</a></li>
                <li class="active">Edit Document</li>
            </ul>
        </div>
    </div>
	<div class="row page-name">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
        	<h3>Edit Existing Briefing Document</h3>
        </div>
    </div>
  <cfoutput>
  
  <div class="row top" style="margin-top:2em">
    <!--- <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 text-right">
      <div class="dropdown">
        <a class="btn btn-success btn-sm dropdown-toggle"
           title="Add a new Document"
           onClick="i2m.showUploadModal(<cfoutput>#url.id#</cfoutput>,'adv');">
          <i class="icon-plus"></i> Add New</a>
        <a class="btn btn-default btn-sm"
           role="button" 
           id="dropdownMenu1" 
           data-toggle="dropdown" 
           aria-haspopup="true" 
           aria-expanded="true"><i class="icon-menu"></i> Options</a>
        <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenu1">
          <li>
            <a href="##" target="_blank">
              <i class="icon-export"></i> Export to PDF</a>
          </li>
          <li>
            <a href="##" target="_blank">
              <i class="icon-spreadsheet"></i> Export to Excel</a>
          </li>
           <li role="separator" class="divider"></li>
          <li>
            <a href="##">
              <i class="glyphicon glyphicon-info-sign"></i> Help</a>
          </li>           
        </ul>
      </div>
    </div> --->
    
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="nav nav-tabs">
                <li role="presentation" class="active"><a href="##">Edit Document</a></li>
                <li role="presentation"><a href="##">Document History</a></li>           
            </ul>
        </div>
    </div>
	</cfoutput> 
      
	<div class="form-group">
    
      <div class="col-xs-12">
    
          <p class="form-control-static uline">
            <small>All entries are required</small>
          </p>
    
      </div>
    
    </div>
    
	<cfoutput query="request.q_briefing_docs">
      <form  name  = "frmBriefingDocEdit" 
           id      = "frmBriefingDocEdit" 
           method  = "POST" 
           enctype = "multipart/form-data" 
           action  = "/aps/i2m/models/briefings/act_edit_briefing_document.cfm" 
           role    = "form" 
           class   = "form-horizontal">
           
      <input type  = "hidden" 
             name  = "briefing_id" 
             id    = "briefing_id" 
             value = "#briefing_id#">
             
      <input type  = "hidden" 
             name  = "doc_id" 
             id    = "doc_id" 
             value = "#doc_id#">
             
      <input type  = "hidden" 
             name  = "orig_file_name" 
             id    = "orig_file_name" 
             value = "#doc_file#">
             
      <input type  = "hidden" 
             name  = "doc_mime" 
             id    = "doc_mime" 
             value = "#doc_mime#">
             
      <input type  = "hidden" 
             name  = "doc_file_size" 
             id    = "doc_file_size" 
             value = "#doc_file_size#">
             
      <input type  = "hidden" 
             name  = "user_id" 
             id    = "user_id" 
             value = "#Attrib.user_id#">

      <input type  = "hidden" 
             name  = "btn_action" 
             id    = "btn_action" 
             value = "">

      <div class="form-group">

          <label class="control-label col-xs-2" for="file_title">Title</label>

          <div class="col-xs-10">

              <input type    = "text" 
                   name      = "doc_title" 
                   id        = "doc_title" 
                   class     = "form-control"
                   maxlength = "100"
                   value     = "#trim(doc_title)#"
                   onKeyUp   = "i2m.countChars(100,this.value.length,'doc_title_len');" />
              <span id="doc_title_len"></span>

          </div>

      </div>
    
      <div class="form-group">

          <label class="control-label col-xs-2">Current file</label>

          <div class="col-xs-10">

              <p class="form-control-static uline">#doc_file#</p>

          </div>

      </div>
      
      <div class="form-group">

          <label class="control-label col-xs-2" for="doc_file">New file</label>

          <div class="col-xs-10">

              <input type    = "file" 
                   name      = "doc_file" 
                   id        = "doc_file" 
                   class     = "form-control"
                   placeholder="File" />

          </div>

      </div>
      
      <div class="form-group">

          <label class="control-label col-xs-2">Created by</label>

          <div class="col-xs-10">

              <p class="form-control-static uline">#doc_created_by_name#</p>

          </div>

      </div>    

      <div class="form-group">

          <label class="control-label col-xs-2">Created date</label>

          <div class="col-xs-10">

              <p class="form-control-static uline">#doc_created_date#</p>

          </div>

      </div>

      <div class="form-group">

          <label class="control-label col-xs-2">Updated by</label>

          <div class="col-xs-10">

              <p class="form-control-static uline">#doc_updated_by_name#</p>

          </div>

      </div>
      
      <div class="form-group">

          <label class="control-label col-xs-2">Updated date</label>

          <div class="col-xs-10">

              <p class="form-control-static uline">#doc_updated_date#</p>

          </div>

      </div> 
           
    <!--- Space holder --->
	<div class="row form-group">
      <div class="col-md-8">
        &nbsp;
      </div>
    </div>
	
    <hr style="width: 100%; color: black; height: 1px; background-color:black;" />    
    
    <!--- Action buttons --->
    <div class="form-group">
      <div class="col-md-12">

        <button name    = "btn_action" 
                value   = "save" 
                class   = "save_button btn btn-primary" 
                type    = "submit"
                title   = "Save document">Save</button> 
 
         <button name    = "btn_action" 
                value   = "approve" 
                class   = "approve_button btn btn-primary" 
                type    = "submit"
                title   = "Approve document">Approve</button>
 
         <button name   = "show_approver_comment"
         		id		= "show_approver_comment" 
                value   = "show_approver_comment" 
                class   = "btn btn-warning" 
                type    = "button"
                title   = "Request document resubmittal">Request Resubmittal</button>
                 
        <button name    = "btn_action" 
                value   = "remove_document"
                class   = "btn btn-danger" 
                type    = "button"
                onClick = "deleteDocument()" 
                title   = "Delete document">Delete document</button>
          
        <a name  = "btnCancel" 
           id    = "btnCancel" 
           href  = "/aps/i2m/views/Briefings/dsp_complaint_documents.cfm?id=#Attrib.briefing_id#" 
           title = "Cancel and return to document list" 
           class = "btn btn-default">Cancel</a>
      
      </div>
    </div>    
    <!--- End Action buttons --->
    

    <!--Bootsrap Modal Dialogs-->
    <!-- Approver Comments Modal -->
    <div class="modal modal-wide modal-float-higher fade" id="approver-comment-modal" tabindex="-1" role="dialog" aria-labelledby="approver-comment-modal-label" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="approver-comment-modal-label">Comments</h4>
          </div>
          <div class="modal-body" id="approver-comments">
            <div id="messages"></div>
            <!--Loaded via ajax-->
            <textarea class="form-control" id="doc_appv_comment" name="doc_appv_comment"></textarea>	
          </div>
          <div class="modal-footer">
            
            <cfoutput>                        
            
            <button name="btn_action" id="approver_resubmit_req" value="approver_resubmit_req" class="btn btn-warning btn-sm" hidden="true" type="submit">
                Save &amp; Submit Comments
            </button>
                                             
            <button type="button" 
                    id="supv_close_btn"
                    class="btn btn-default" 
                    data-dismiss="modal"
                    onclick="javascript:void(0);">Close</button>
            </cfoutput>
            
          </div>
        </div>
      </div>
    </div>    
    <!-- /.modal --> 
    <!--Bootsrap Modal Dialogs-->  
        
    </form>

    </cfoutput>

  
  <igems:htmlFoot>
	<script type="text/javascript">
	
	function saveFile(){
		var doc_title = $( '#doc_title' ).val();
		
		if( doc_title == ''){
			alert('Please enter a title for the selected file.');
			return false;
		}
		else{
			$( '.save_button' ).attr('disabled', 'disabled');
			$( '.save_button' ).text('Uploading...');
			$( '#btn_action' ).val('Save');
			//Submit upload form
			document.frmBriefingDocEdit.submit();
		}
		
	}
	
	function deleteDocument(){
    if( confirm('Permanently delete this document?\nClick OK to continue, Cancel to reconsider.') == true){
      $("#frmBriefingDocEdit").attr("action","/aps/i2m/models/briefings/act_remove_briefing_document.cfm");
			document.frmBriefingDocEdit.submit();}		
	}
	
	$(document).ready(function(){
		$('#doc_title').focus();
		
		//File name change event handler
		$('#doc_file').on('change',function(){
			
			//If file title is  empty, set it to the selected file name
			if( $( '#doc_title' ).val().length == 0 ){
				var filename = getFilename($('#doc_file').val());
				$( '#doc_title' ).val( filename );	
			}
			
		});

		//Comment handlers
		function showApproverComments(){
			//alert('Show approver comment button clicked when adding');//Debugging only
			$( '#approver-comment-modal' ).modal({show:true,backdrop:'static'});
		}
  		
		//Handle edit form validation
        $('#frmBriefingDocEdit').submit(function(){
			var has_errors=false;

			if(has_errors == true){
				alert('Please complete all required entries.');return false;
			}
					  
			//Check for comments
			//if( $('#doc_appv_comment').val() == ''){alert('Comments are required.');showApproverComments();return false;}

		});

		//Add click event to resubmit request button
		$( '#show_approver_comment' ).on('click',function(){
			 //alert('Show approver comment button clicked when adding');//Debugging only
			 showApproverComments();
		});
	

	});


    </script>
  </igems:htmlFoot>
</cfif>


</i2m:page_wrapper>
