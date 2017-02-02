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
	//request.getMaxComplaint.MaxID		= 86016;
    request.q_permissions 				= getPermissions(cookie.current_user_id,11);
	 
    request.getAllStaff					= request.complaint_staff_pkg_cfc.getAllStaff(request.getMaxComplaint.maxid);
   				
	//request.getStaffRoles				= request.complaint_staff_pkg_cfc.getStaffRoles();
   
   
WriteDump(var=request,label="request",expand=false,abort=false);//Debugging only
//WriteDump(var=request.qAllStaff,label="qAllStaff",expand=false,abort=false);//Debugging only
WriteDump(var=request.getMaxComplaint,label="getMaxComplaint",expand=false,abort=false);//Debugging only
WriteDump(var=request.getAllStaff,label="qAllStaff",expand=false,abort=false);//Debugging only


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
            <li class="active">Complaint Initiation</li>
        </ul>
    </div>
</div>

<div class="row page-name">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
    	<h3>Complaint Initiation</h3>
    </div>
</div>




<!--- 
File Name: dsp_complaint_init.cfm

Description:  I display a form to capture case information.

History:
	Action									Date					Developer
	Recreated								7/7/2016				Steve Kubrak
 --->

<cfoutput>



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
                <li role="presentation"><a href="/aps/i2m/views/complaints/initiation/frm_complaint_init.cfm">Complaint Initiation</a></li>
                <li role="presentation"><a href="##">Individuals/Institutions</a></li>   
                <li role="presentation" class="active"><a href="##">Staff</a></li>
                <li role="presentation"><a href="##">Violations</a></li>  
                <li role="presentation"><a href="##">Related Cases</a></li>
                <li role="presentation"><a href="##">Joint Agencies</a></li>   
                <li role="presentation"><a href="##">Regions</a></li>
                <li role="presentation"><a href="/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm">Documents</a></li>                   
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

 <input type="hidden" value="#cookie.current_user_id#" name="user_id">
 <input type="hidden" value="#fiscal_year#" name="fiscal_year">
 <input type="hidden" value="U" name="group_code" />
 <input type="hidden" value="#request.getMaxComplaint.maxID#" name="maxID" />


        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12  text-right"><br />
                <cfif structKeyExists(request.q_permissions,"PERMISSION_NAME") and hasPermission(request.q_permissions,"CAN_REVIEW_CASE")>  
                    <a href="frm_add_staff.cfm" class="btn btn-success">Add New Staff</a>
                </cfif>
            </div> 
        </div>



    <div class="form-group" id="title_group">
        <div class="col-md-8">
            <label for="title" class="control-label">Title</label>
            <input type="Text" class="form-control" name="title" id="title" title="Complaint Title" onKeyUp="javascript:igems.countChars(500,this.value.length,'comments_len')">
            <p  id="comments_len"></p>
        </div>
    </div>


    <div class="form-group" id="agent_group">
		<div class="col-md-8">
        <label class="control-label" for="case_agent">Agent</label>
        <select class="form-control" name="case_agent" id="case_agent" title="Case Agent">
        <cfloop query="request.qGetPeople">
             <option value="#PERSON_ID#"#isSelected(PERSON_ID,cookie.current_user_id)# >#full_name#</option>
        </cfloop>
        </select>
     	</div>
    </div>



		
    <div class="form-group" id="">
    
    
    </div>

</cfoutput>


        <div class="col-md-8">
       		<br />
        </div> 

         

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
        type="button"> Close</button>
        </div> 
    </div>  

</form>
</cfif>



 <igems:htmlFoot>
<script>
 
 	// function to autopopulate the state and city fields based on the zip code entered
		function getCityStateByZip(zip_code){
		
			 if( zip_code.length >= 5){ 
			
				$.ajax({type:"get",
						 url:"/aps/i2m/cfc/Complaints/Initiation/initiation_pkg.cfc?returnformat=json",
						 data:{method:"getCityStateFromZip",zip:zip_code},
						 dataType:"JSON",
						 success:function(data){
						$('#state_display').empty();
						$('#city_display').empty();
						$('#state_field').empty();
						$('#city_field').empty();
						for (var i=0;i<data.DATA.length;++i){
							$('#state_display').html(data.DATA[i][2]);	
							$('#city_display').html(data.DATA[i][0]);
							$('#state_field').val(data.DATA[i][1]);	
							$('#city_field').val(data.DATA[i][0]);
						}
					}
						,error:function (XMLHttpRequest, textStatus, errorThrown){
								   alert("Status: " + textStatus); 
								   alert("Error: " + errorThrown);}
				});
				
			}
			
		};

 
        $(document).ready(function(){
		
			
        // Set focus
        $('#title').focus();


		//datepicker() functionality
		$('#title').on('focus',function(){$('#due_date').datepicker('hide')});
		$('#due_date').datepicker();
		$('#due_date').datepicker().on('changeDate',function(ev){$('#due_date').datepicker('hide')});			
		$('#office').on('focus',function(){$('#due_date').datepicker('hide')});


        // Validate form
		 $('form#initcomplaint').validate({
			rules: {
					title:{
					  required: true
					},
					due_date: {
					  required: true
					},
					office: {
					  required: true
					},
				   case_agent:{
					  required: true
					},		
					allegation_source: {
					  required: true
					},
					is_hotline_number: {
					  required: true
					},
					directorate: {
					  required: true
					},
					violation: {
					  required: true
					},
					budget_code: {
					  required: true
					},
					zip_Code: {
					  required: true
					},
					manchall: {
					  required: true
					}
				//end rules
				},
				
				messages: {
					title: {
						required: "Please enter a Title"
					},
					  due_date: {
						required: "Please enter a Due Date"
					},
					office: {
					  required: "Please select an Office"
					},
				   case_agent:{
					  required: "Please select an Agent"
					},		
					allegation_source: {
					  required: "Please select a Source"
					},
					is_hotline_number: {
					  required: "Please enter a Hotline number"
					},
					directorate: {
					  required: "Please select a category"
					},
					violation: {
					  required: "Please select a Sub-Category"
					},
					budget_code: {
					  required: "Please select a Budget Code"
					},
					zip_Code: {
					  required: "Please enter a Zip Code"
					},
					manchall: {
					  required: "Please select a Management Challenge"
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

