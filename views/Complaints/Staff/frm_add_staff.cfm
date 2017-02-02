<cfimport prefix="i2m" tagLib="/aps/i2m/common/">
<cfimport prefix="igems" tagLib="/common/">
<i2m:page_wrapper width="full" format="module" page_title="Investigations">

<cfscript>
user.name 							= cookie.CURRENT_USER_NAME;
user.id 							= cookie.CURRENT_USER_ID;
presenter_id 						= cookie.CURRENT_USER_ID;

  // Include shared functions
  include "/common/shared_functions.cfm";
  
  // Declare variables and instantiate CFC
  try{
	request.page_has_errors=false;
	request.page_load_error_message="";
	request.initiation_cfc 				= createObject("component","aps.i2m.cfc.Complaints.Initiation.Initiation_pkg");
	request.people_cfc 					= createObject("component","aps.i2m.cfc.Briefings.people_pkg");	
	request.complaint_staff_pkg_cfc 	= createObject("component","aps.i2m.cfc.Complaints.Staff.complaint_staff_pkg");	
	request.qGetPeople					= request.people_cfc.selPeopleForDrowdown('Y');
	request.getMaxComplaint				= request.initiation_cfc.selMaxComplaint();
   	request.getStaffRoles				= request.complaint_staff_pkg_cfc.getStaffRoles();
	
	permissionMachine					= ["R","RW","FC","NONE"];
	permissionsEnglish					= ["Read-Only","Read/Write","Full Control","No Access"];
	permissionsArray					= [permissionsEnglish,permissionMachine];
	
	statusList							= "N,Y";
   	request.q_permissions 				= getPermissions(cookie.current_user_id,11); 
   
   	
WriteDump(var=cookie,label="cookies",expand=false,abort=false);//Debugging only
WriteDump(var=request.qGetPeople,label="qGetPeople",expand=false,abort=false);//Debugging only
WriteDump(var=permissionsArray,label="permissionsArray",expand=false,abort=false);//Debugging only


	//gets fiscal year to display in complaint number
	function getFY(date){
		FYDate = CreateDate(Year(date),10,1);
		if(DateDiff("d",FYDate,date) GE 0){
			fiscal_year = Year(date) + 1;
		} else {
			fiscal_year = Year(date);
		}
		return fiscal_year;
	}
	fiscal_year = getFY(Now());
   }
 
//WriteDump(var=fiscal_year,label="fiscal_year",expand=false,abort=true);//Debugging only  
   
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
            <li class="active">Complaint Initiation Add Staff</li>
        </ul>
    </div>
</div>

<div class="row page-name">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
    	<h3>Complaint Initiation Add Staff</h3>
    </div>
</div>




<!--- 
File Name: frm_add_staff.cfm

Description:  I display a form to capture staff information.

History:
	Action									Date					Developer
	Recreated								7/7/2016				Steve Kubrak
 --->

<cfoutput>

<!---action="#application.base_path#/models/complaints/staff/act_add_complaint_staff.cfm?id=#url.id#"  --->

<form 
action="#application.base_path#/models/complaints/staff/act_add_complaint_staff.cfm" 
class="form" 
id="initcomplaint_staff" 
name="initcomplaint_staff" 
method="post" 
role="form" 
enctype="multipart/form-data">

    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="nav nav-tabs">
                <li role="presentation" class="active"><a href="##">Staff</a></li>
            </ul>
        </div>
    </div>  
    
 <input type="hidden" value="#cookie.current_user_id#" name="user_id">
 <input type="hidden" value="#url.id#" name="case_id">

    <div class="form-group" id="agent_group">
		<div class="col-md-8">
        <label class="control-label" for="case_agent">Staff</label>
        <select class="form-control" name="case_agent" id="case_agent" title="Case Agent">
        <cfloop query="request.qGetPeople">
             <option value="#PERSON_ID#"#isSelected(PERSON_ID,cookie.current_user_id)# >#full_name#</option>
        </cfloop>
        </select>
     	</div>
    </div>
		
    <div class="form-group" id="role_group">
		<div class="col-md-8">
        <label class="control-label" for="role_agent">Role</label>
        <select class="form-control" name="role_agent" id="role_agent" title="Role">
        <cfloop query="request.getStaffRoles">
             <option value="#code#">#description#</option>
        </cfloop>
        </select>
     	</div>
    </div>

    <br clear="all" />
     <div class="form-group" id="Permission_group">
		<div class="col-sm-2">
        <label class="control-label" for="permission">Permission</label>
        <select class="form-control" name="permission" id="Permission" title="Permission">
            <cfloop index="i" from="1" to="4" step="1">
        		<option value="#permissionMachine[i]#">#permissionsEnglish[i]#</option>
        	</cfloop>
        </select>  
     </div>
    </div>

    <br clear="all" />
    <div class="form-group" style="padding-left:15px;" id="due_date_group">
        <div class="input-group col-md-4">
        	<label class="control-label" for="date_assigned">Date Assigned</label>
        </div>
        <div class="input-group col-sm-4">
        	<input type="text" id="date_assigned" name="date_assigned" class="form-control" value="" title="Date Assigned">
            <div class="input-group-addon">
                <i class="glyphicon glyphicon-calendar" onclick="$('##date_assigned').datepicker('show');"></i>
            </div>
        </div>
    </div>

     <div class="form-group" id="grand_jury_group">
		<div class="col-sm-2">
        <label class="control-label" for="grand_jury">Grand Jury</label>
        <select class="form-control" name="grand_jury" id="grand_jury" title="grand_jury">
            <cfloop list="#statusList#" index="i" delimiters=",">
        		<option value="#i#">#i#</option>
        	</cfloop>
        </select>  
     </div>
    </div>
 
     <br clear="all" />
     <div class="form-group" id="Confidential_group">
		<div class="col-sm-2">
        <label class="control-label" for="confidential">Confidential</label>
        <select class="form-control" name="confidential" id="confidential" title="Confidential">
            <cfloop list="#statusList#" index="i" delimiters=",">
        		<option value="#i#">#i#</option>
        	</cfloop>
        </select>  
     </div>
    </div>




</cfoutput>



    <br clear="all" />  

    <div class="form-group">
        <div class="col-md-8">
        <button class="btn btn-primary" 
        name="btn_save"
        title="Save changes to this role" 
        type="submit"> Save</button>
        
        <button class="btn btn-info" 
        name="clear"
        title="Save changes to this role" 
        type="reset"> Clear</button>     
        
        <button class="btn btn-default"
        name="close_button"
        title="Close this form"
        type="button" onclick="history.back()"> Back</button>
        </div> 
    </div>  

</form>
</cfif>



 <igems:htmlFoot>
<script>
 


 
        $(document).ready(function(){
		
			
        // Set focus
        $('#case_agent').focus();


		//datepicker() functionality
		$('#permission').on('focus',function(){$('#date_assigned').datepicker('hide')});
		$('#date_assigned').datepicker();
		$('#date_assigned').datepicker().on('changeDate',function(ev){$('#date_assigned').datepicker('hide')});			
		$('#grand_jury').on('focus',function(){$('#date_assigned').datepicker('hide')});


        // Validate form
		 $('form#initcomplaint_staff').validate({
			rules: {
					date_assigned:{
					  required: true
					}
				//end rules
				},
				
				messages: {
					date_assigned: {
						required: "Please enter a Date Assigned"
					}
				//end messages 
				},
				  
			
			//highlight the error
			highlight: function(element) {
				$(element).closest('.form-group').addClass('has-error');
			},
			//clear the error when the user fixes
			unhighlight: function(element) {
				$(element).closest('.form-group').removeClass('has-error').addClass('has-success');
			},
		
		
		 errorElement: 'span',
				errorClass: 'help-block',
				errorPlacement: function(error, element) {
					if(element.parent('.input-group').length) {
						error.insertAfter(element.parent());
					} else {
						error.insertAfter(element);
					}
				}
				
		
		
		
		//end validate
		});
		
		 //end jQuery
		}); 

		
    </script>
  </igems:htmlFoot>

</i2m:page_wrapper>

