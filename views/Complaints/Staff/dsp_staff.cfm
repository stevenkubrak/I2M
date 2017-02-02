<cfimport prefix="i2m" tagLib="/aps/i2m/common/">
<cfimport prefix="igems" tagLib="/common/">
<i2m:page_wrapper width="full" format="module" page_title="Investigations">

<cfscript>
user.name 							= cookie.CURRENT_USER_NAME;
user.id 							= cookie.CURRENT_USER_ID;
presenter_id 						= cookie.CURRENT_USER_ID;
//this is a test
  // Include shared functions
  include "/common/shared_functions.cfm";
  
  // Declare variables and instantiate CFC
  try{
	request.page_has_errors=false;
	request.page_load_error_message="";
	request.auth_user=false;
	request.isAdmin=false;

	request.initiation_cfc 				= createObject("component","aps.i2m.cfc.Complaints.Initiation.Initiation_pkg");
	request.people_cfc 					= createObject("component","aps.i2m.cfc.Briefings.people_pkg");	
	request.complaint_staff_pkg_cfc 	= createObject("component","aps.i2m.cfc.Complaints.Staff.complaint_staff_pkg");	
	request.qGetPeople					= request.people_cfc.selPeopleForDrowdown('Y');
	request.getMaxComplaint				= request.initiation_cfc.selMaxComplaint();
	request.q_permissions 				= getPermissions(cookie.current_user_id,11);
	request.getAllStaff					= request.complaint_staff_pkg_cfc.getAllStaff(url.id);
   	request.qGetPeople					= request.people_cfc.selPeopleForDrowdown('Y');
	

	list_people								=	#valueList(request.qGetPeople.person_id)#;
   
  }
  catch(any excpt){handleError(excpt);}
  
  // Is the person accessing this page authorized?
  if(request.page_has_errors eq false){
   // check for I2M_USER role
   if(listFindNoCase(cookie.current_user_roles,'I2M_USER') neq 0){
     request.auth_user=true;}
   // check for I2M_ADMIN role
   if(listFindNoCase(cookie.current_user_roles,'I2M_ADMIN') neq 0){
     request.isAdmin=true;}
  }  	
  


WriteDump(var=request.qGetPeople,label="qGetPeople",expand=false);//Debugging only
WriteDump(var=list_people,label="list_people",expand=false);//Debugging only
</cfscript>
<cfif structKeyExists(request,'page_has_errors') and request.page_has_errors eq true>
  <igems:page-error err_message="#request.page_load_error_message#">
<cfelse>

<div class="row top">

 <!-- Navigation column -->
 <div class="col-lg-2">
  <cfif structKeyExists(cookie, 'isRemoteLogin')>
  <i2m:briefing_nav active_nav="staff" isAdmin="#request.isAdmin#"/>
  <cfelse>
  <i2m:nav active_nav="staff" isAdmin="#request.isAdmin#"/>
  </cfif>
 </div>

<cfoutput>

    <!-- Content column -->
    <div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
    
     <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12  text-right"><br />
            <cfif structKeyExists(request.q_permissions,"PERMISSION_NAME") and hasPermission(request.q_permissions,"CAN_REVIEW_CASE")>  
                <a href="frm_add_staff.cfm?id=#url.id#" class="btn btn-success">Add New Staff</a>
            </cfif>
        </div> 
    </div> 
	<br />
        <table class="table table-striped table-condensed" id="displayTable">
            <thead>
            <tr class="table_head">
                <th align="center" scope="col">Assigned</th>
                <th align="center" scope="col">Released</th>
                <th align="center" scope="col">Staff</th>
                <th align="center" scope="col">Role</th>
                <th align="center" scope="col">Permission</th>
                <th align="center" scope="col">Hours (Cost)</th>
                <th align="center" scope="col">Access</th> 
                <th align="center" scope="col">EDIT</th>
                <th align="center" scope="col">DELETE</th> 
            </tr>
            </thead>
            
        <tbody>


<!---    <div class="form-group" id="agent_group">
		<div class="col-md-8">
        <label class="control-label" for="case_agent">Staff</label>
        <select class="form-control" name="case_agent" id="case_agent" title="Case Agent">
        <cfloop query="request.qGetPeople">
             <option value="#PERSON_ID#"#isSelected(request.getAllStaff.EMPLOYEE_ID)# >#full_name#</option>
        </cfloop>
        </select>
     	</div>
    </div>
 --->






            <!---See All Current Staff ---> 
               <cfloop query="request.getAllStaff">
                <tr>
                    <td>#DateFormat(request.getAllStaff.ASSIGNED_DATE, "mm/dd/yyyy")#</td>
                    <td>#DateFormat(request.getAllStaff.RELEASED_DATE, "mm/dd/yyyy")#</td>

                    <td>#request.getAllStaff.EMPLOYEE_ID#<br />
                    
                    <!---NEED TO DO A JOIN IN THE DB. THIS ISNT WORKING --->
						<cfif #isInListTF(list_people,request.getAllStaff.EMPLOYEE_ID)#>#request.qGetPeople.FULL_NAME#</cfif> 
                    </td>
                    
                    <td>#request.getAllStaff.ROLE_CODE#</td>
                    <td>#request.getAllStaff.PERMISSION_CODE#</td>
                    <td>#request.getAllStaff.TIME_ADD#</td>
                    <td>
                        <cfif GRAND_JURY NEQ ''>Grand Jury<cfelse>&nbsp;</cfif>
                    </td>
                    <td align="center">EDIT</td>
                    <td align="center">DELETE</td> 
                </tr>
            </cfloop>
            
            </tbody>
            
            </table>
		
	</div>
		
</cfoutput>

</div>

  <igems:htmlFoot>
	<script>
        $(document).ready(function(){
            $('#displayTable').DataTable();
        });
    </script>
  </igems:htmlFoot>
</cfif>



</i2m:page_wrapper>
