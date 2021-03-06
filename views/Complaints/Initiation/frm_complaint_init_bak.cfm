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
	request.auth_user=false;
	request.org_elements_cfc 			= createObject("component","cfc.organization_elements_pkg");
	request.briefings_cfc 				= createObject("component","aps.i2m.cfc.Briefings.Briefings_pkg");
	request.initiation_cfc 				= createObject("component","aps.i2m.cfc.Complaints.Initiation.Initiation_pkg");
	request.people_cfc 					= createObject("component","aps.i2m.cfc.Briefings.people_pkg");		
	request.getHQProgram				= request.initiation_cfc.getHQProgram();
	request.getAllegationSource			= request.initiation_cfc.getAllegationSource();
	request.getComplaintSources			= request.initiation_cfc.getComplaintSources();
	request.qBudgetCodes				= request.briefings_cfc.selValidBudgetCodes();
	request.org_elements				= request.org_elements_cfc.selChildOrgElementsQuery(6,'Y');			
	orgList 							= ValueList(request.org_elements.ORG_ELEMENT_ID,",");   	
	request.qGetOIPeople				= request.briefings_cfc.getOIPerson(#orgList#);  
	request.org_elements				= request.org_elements_cfc.selChildOrgElementsQuery(6,'Y');			
	request.qGetPeople					= request.people_cfc.selPeopleForDrowdown('Y');
	request.getManChall					= request.initiation_cfc.getManagementChallenges();
	request.getMaxComplaint				= request.initiation_cfc.selMaxComplaint();
   
   
   
//WriteDump(var=cookie,label="cookies",expand=false,abort=false);//Debugging only
//WriteDump(var=request.qGetPeople,label="qGetPeople",expand=false,abort=false);//Debugging only
//WriteDump(var=request.getAllegationSource,label="getAllegationSource",expand=false,abort=false);//Debugging only


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
action="#application.base_path#/models/complaints/initiation/act_add_complaint.cfm" 
class="form" 
id="initcomplaint" 
name="initcomplaint" 
method="post" 
role="form" 
enctype="multipart/form-data">

    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="nav nav-tabs">
                <li role="presentation" class="active"><a href="/aps/i2m/views/complaints/initiation/frm_complaint_init.cfm">Complaint Initiation</a></li>
                <li role="presentation"><a href="##">Individuals/Institutions</a></li>   
                <li role="presentation"><a href="##">Staff</a></li>
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

    <div class="form-group" id="title_group">
        <div class="col-md-8">
            <label for="title" class="control-label">Title</label>
            <input type="Text" class="form-control" name="title" id="title" title="Complaint Title" onKeyUp="javascript:igems.countChars(500,this.value.length,'comments_len')">
            <p  id="comments_len"></p>
        </div>
    </div>

    <div class="form-group" id="initiation_date">
        <div class="col-md-8">
            <label for="title" class="control-label">Date Opened</label>
            <input type="hidden" name="initiation_date" id="initiation_date" value="#DateFormat(Now(), 'mm/dd/yyyy')#">
            <span title="Date Opened">#DateFormat(Now(), 'mm/dd/yyyy')#</span>
        </div>
    </div>
    
    <br clear="all" />   
        
    <div class="form-group" style="padding-left:15px;" id="due_date_group">
        <div class="input-group col-md-4">
        	<label class="control-label" for="due_date">Due Date</label>
        </div>
        <div class="input-group col-sm-4">
        	<input type="text" id="due_date" name="due_date" class="form-control" value="" title="Due Date">
            <div class="input-group-addon">
                <i class="glyphicon glyphicon-calendar" onclick="$('##due_date').datepicker('show');"></i>
            </div>
        </div>
    </div>

    <div class="form-group" id="initiation_date">
        <div class="col-md-8">
            <label for="title" class="control-label">Type</label>
            <input type="hidden" id="project_type" name="project_type" value="CP"/>
            <span>Complaint</span>
        </div>
    </div>

    
      <div class="form-group" id="office_group">
		<div class="col-md-8">
        <label class="control-label" for="office">Office</label>
        <select class="form-control" name="office" id="office" title="Select an office">
        <option value="">Select an office...</option>		
           <cfloop query="request.org_elements">
		  	<option value="#ORG_ELEMENT_ID#"#isSelected(ORG_ELEMENT_ID,request.qGetOIPeople.ORG_ELEMENT_ID)#>#ORG_ELEMENT_NAME#</option>
		  </cfloop>
        </select>
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

      <div class="form-group" id="source_group">
		<div class="col-md-8">
        <label class="control-label" for="allegation_source">Source</label>
        <select class="form-control" name="allegation_source" id="allegation_source" title="Select a Complaint Source">
        <option value="">Select a Complaint Source</option>		
           <cfloop query="request.getAllegationSource">
				<option value="#code#" >#code# #description#</option>
		  </cfloop>
        </select>
     </div> 
    </div>

      <div class="form-group" id="hotline_group">
		<div class="col-md-8">
        <label class="control-label" for="is_hotline_number">Hotline Number</label>
        <input type="text" id="is_hotline_number" name="is_hotline_number" value="">&nbsp;<i>YYYY-0000</i>
     </div> 
    </div>    

	          
      <div class="form-group" id="directorate_group">
		<div class="col-md-8">
        <label class="control-label" for="directorate">Category</label>  
            <select class="form-control" name="directorate" id="directorate" title="Directorate">
                <cfloop query="request.getHQProgram">
                    <option value="#code#" >#description#</option>
                </cfloop>
            </select>       
     </div> 
    </div>

    <div class="form-group" id="violation-group">
		<div class="col-md-8">
        <label class="control-label" for="violation">Sub-Category</label>
        <select class="form-control" name="violation" id="violation" title="Violation" size="10">
  			<cfloop query="request.getComplaintSources">
                <option value="#code#">(#code#) #description#</option>
            </cfloop>
        </select>	       
     </div>
    </div>   

    <div class="form-group" id="budget_group">
		<div class="col-md-8">
        <label class="control-label" for="budget_code">Budget Codes</label>
        <select class="form-control" name="budget_code" id="budget_code" title="Budget Code">
  			<cfloop query="request.qBudgetCodes">
                <option value="#code#" >#description#</option>
            </cfloop>
        </select>
     </div>
    </div>

		<input type="hidden" name="sec_all" id="sec_all" value="" />
		<input type="hidden" name="sec_all_code" id="sec_all_code" value="" />

    <div class="form-group" id="offense_group">
		<div class="col-md-8">
        <label class="control-label" for="location">Location of Offense</label><br />
        <label class="control-label" for="state_display">State</label>
        <div id="state_display"></div>
        <label class="control-label" for="city_display">City</label>
        <div id="city_display"></div>
        <input type="hidden" class="form-control" name="state_field" id="state_field" value="" title="Offense State">
        
        <input type="hidden" class="form-control" name="city_field" id="city_field" value="" title="Offense City">
        <label class="control-label" for="zip_Code">Zip</label>
		<input type="text" name="zip_Code" id="zip_Code" value="" onkeyup="getCityStateByZip(this.value);" maxlength="10">
     </div>
    </div>

            
     <div class="form-group" id="manChall_group">
		<div class="col-md-8">
        <label class="control-label" for="manchall">Management Challenges</label>
        <select class="form-control" name="manchall" id="manchall" title="Management Challenges">
  			<cfloop query="request.getManChall">
                <option value="#code#">#description#</option>
            </cfloop>
        </select>
     </div>
    </div>
    
     <div class="form-group" id="Confidential_group">
		<div class="col-md-8">
        <label class="control-label" for="confidential">Confidential</label>
       	<input type="Checkbox" name="confidential" id="confidential"> <span class="hint"> (Requires AIG or Deputy Approval)</span>
     </div>
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
        $(document).ready(function(){
		
			
        // Set focus
        $('#title').focus();


		//datepicker() functionality
		$('#title').on('focus',function(){$('#due_date').datepicker('hide')});
		$('#due_date').datepicker();
		$('#due_date').datepicker().on('changeDate',function(ev){$('#due_date').datepicker('hide')});			
		$('#office').on('focus',function(){$('#due_date').datepicker('hide')});
        });


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
				},
				
		
		
		
		//end validate
		});
		
		//end jQuery
		};

		
    </script>
  </igems:htmlFoot>

</i2m:page_wrapper>

