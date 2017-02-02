<cfimport prefix="i2m" tagLib="/aps/i2m/common/">
<cfimport prefix="igems" tagLib="/common/">
<i2m:page_wrapper page_title="Investigations">

<cfscript>
  
  param name="url.id" default=0;
  
  // Include shared functions
  include "/common/shared_functions.cfm";
  
  // Declare variables and instantiate CFC
  try{
	
	//Check for key in cookie scope
	if( !structKeyExists(cookie,"key") ){
		//Generate encryption key
		cookie.key	= generateSecretKey('AES');
	}
	
	//Set default for page errors and relate message	  
   	request.page_has_errors				= false;
   	request.page_load_error_message		= "";

	//Instatiate CFC's
	request.initiation_docs_cfc			= createObject("component","aps.i2m.cfc.complaints.initiation.initiation_pkg");
	request.i2m_util_cfc				= createObject("component","aps.i2m.cfc.utility");
	
	//Function calls
	request.q_complaint_docs			= request.initiation_docs_cfc.getComplaintDocuments(42530);

	//Get permissions
	request.q_permissions 				= getPermissions(cookie.current_user_id,11);
	
	 //variables
   	request.auth_user					= false;
	request.rows_to_add                 = 0;

	request.key							= cookie.key;
	 	
	//Paths
	Attributes.urlPath					= "/aps/i2m/resources/complaints/#url.id#";
	
	//WriteDump(var=request.q_permissions,expand=false,abort=false);//Debugging only	
	//WriteDump(var=request.q_briefing_docs,expand=false,abort=true);//Debugging only
   
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
    <div class="row top">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
        	<h3>Add Initiation Report</h3>
        </div>
    </div>
    
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="breadcrumb">
                <li><a href="/">IGEMS</a>
                <li><a href="/aps/i2m/">Investigations</a>
                <li><a href="/aps/i2m/views//complaints/initiation/frm_complaint_init.cfm">Complaint Initiation</a></li>
                <li class="active">Documents</li>
            </ul>
        </div>
    </div>

  <cfoutput>
  
  <div class="row top" style="margin-top:2em">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 text-right">
      <div class="dropdown">
        <a class="btn btn-success btn-sm dropdown-toggle"
           title="Add a new Document"
           onClick="i2m.showUploadModal(<cfoutput>#url.id#</cfoutput>,'adv');">
          <i class="icon-plus"></i> Add New</a>
<!---        <a class="btn btn-default btn-sm"
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
        </ul> --->
      </div>
    </div>

    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="nav nav-tabs">
                <li role="presentation"><a href="/aps/i2m/views/complaints/initiation/frm_complaint_init.cfm">Complaint Initiation</a></li>
                <li role="presentation"><a href="##">Individuals/Institutions</a></li>   
                <li role="presentation"><a href="##">Staff</a></li>
                <li role="presentation"><a href="##">Violations</a></li>  
                <li role="presentation"><a href="##">Related Cases</a></li>
                <li role="presentation"><a href="##">Joint Agencies</a></li>   
                <li role="presentation"><a href="##">Regions</a></li>
                <li role="presentation" class="active"><a href="/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm">Documents</a></li>                   
                <li role="presentation"><a href="##">Tech/Support</a></li> 
            </ul>
        </div>
    </div>  

    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="nav nav-tabs">
                <li role="presentation"><a href="##">Referrals</a></li>
                <li role="presentation"><a href="##">Photos</a></li>   
                <li role="presentation"><a href="##">Alert</a></li>
                <li role="presentation"><a href="##">Chron Log</a></li> 
                <li role="presentation"><a href="##">Close</a></li>         
            </ul>
        </div>
    </div>  

	</cfoutput>  
    
	<!--- Space holder --->
	<div class="row form-group">
      <div class="col-md-8">
        &nbsp;
      </div>
    </div>
    
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

            <table class="table table-striped table-condensed" id="document_table">
                <thead>
                    <tr>
                        <th width="2%"></th>
                        <th width="4%">&nbsp;</th>
                        <th width="22%" scope="col" role="columnheader">Title&nbsp;&nbsp;<small>(click to open)</small></th>
                        <th width="10%" scope="col" role="columnheader">Status</th>
                        <th width="10%" scope="col" role="columnheader">Uploaded date</th>
                        <th width="15%" scope="col" role="columnheader">Uploaded by</th>	
                        <th width="10%" scope="col" role="columnheader">Updated date</th>
                        <th width="15%" scope="col" role="columnheader">Updated by</th>
                        <th width="10%" scope="col" role="columnheader">&nbsp;</th>
                    </tr>
                </thead>
				<cfoutput>
                <tfoot>
                	 <td colspan="8">#request.q_complaint_docs.recordcount# matching <cfif request.q_complaint_docs.recordcount eq 1>row<cfelse>rows</cfif></td>
                </tfoot>
                </cfoutput>
                
                <tbody>                
               <cfoutput query="request.q_complaint_docs">
                <cfscript>
					//Encrypt doc id
					//session.single_doc_id		= encrypt( doc_id, request.key, 'AES/CBC/PKCS5Padding', 'HEX');
					request.single_doc_id		= encrypt( id, request.key, 'AES/CBC/PKCS5Padding', 'HEX');;
					//request.single_doc_id		= doc_id;
				</cfscript>
                <tr>
                    <td class="text-center">&nbsp;</td>
                    <td class="text-center">#request.i2m_util_cfc.getExtensionImage(file_name)#</td>
                    <td align="left">
                        <a id  = "#CASE_ID#" 
                        href   = "#URLDecode(Attributes.urlPath)#/#file_name#"
                        title  = "Open this attachment"
                        target = "_blank">#file_name#</a>
                    </td>
                    <td>#status_code#</td>
                    <td>#created_date#</td>
                    <td>#creator_id#</td>
                    <td>#updated_date#</td>
                    <td>#updator_id#</td>
                    <td>
                    	<a name	="edit_btn_#id#" 
                        id		="edit_btn_#id#"
                        href	="/aps/i2m/views/complaints/initiation/frm_edit_complaint_document.cfm?doc_id=#request.single_doc_id#" 
                        class   = "btn btn-primary">Edit document</a>                        
                    </td>
                
                </tr>
                </cfoutput> 
                
                 <cfif request.rows_to_add gt 0>
                  <cfloop from="1" to="#request.rows_to_add#" index="i">
                  <tr>
                  	<td colspan="9" style="padding:.6em">&nbsp;</td>
                  </tr>
                  </cfloop>
                <cfelseif request.q_complaint_docs.recordcount EQ 0> 
                  <tr>
                    <td colspan="9" style="padding:.6em">There are no records of this type.</td>
                  </tr>  
                </cfif>  
                
                </tbody>  
            </table>        
        
        </div>
    </div>

    <!--Bootsrap Modal Dialogs-->
    <!-- Upload Modal -->
    <div class="modal modal-wide modal-float-higher fade" id="upload-modal" tabindex="-1" role="dialog" aria-labelledby="upload-modal-label" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="upload-modal-label">Document upload form</h4>
          </div>
          <div class="modal-body" id="uploads">
            <div id="messages"></div>
            <!--Loaded via ajax-->	
          </div>
          <div class="modal-footer">
            
            <cfoutput>
            
            <button class = "btn btn-primary"
                  type="button" 
                  name  = "selectFiles"
                  id    = "selectFiles"
                  value="selectFiles">
            <span class="glyphicon glyphicon-folder-open"></span> Select Files</button>                                 

            <button type="button" 
                id="close_btn"
                class="btn btn-default" 
                data-dismiss="modal">
            <span class="glyphicon glyphicon-remove"></span> Cancel
            </button>            
            
            </cfoutput>
            
          </div>
        </div>
      </div>
    </div>    
    <!-- /.modal -->
     
    <!--Bootsrap Modal Dialogs-->  

  
  <igems:htmlFoot>
	<script charset="UTF-8" src="/lib/jquery/jquery-2.1.3.min.js" type="text/javascript"></script>
    <script charset="UTF-8" src="/lib/jquery/datatables.min.js"></script>
    <script charset="UTF-8" src="/lib/bootstrap/js/bootstrap.min.js" defer></script>
    <script charset="UTF-8" src="/lib/bootstrap/js/bootstrap-accessibility.min.js" defer></script>
    <script charset="UTF-8" src="/js/igems.js" type="text/javascript" defer></script>
    <script>
		$(document).ready(function(){
			$('#document_table').DataTable();
		});    
    </script>
  </igems:htmlFoot>
</cfif>


</i2m:page_wrapper>
