<cfimport prefix="i2m" tagLib="/aps/i2m/common/">
<cfimport prefix="igems" tagLib="/common/">
<i2m:page_wrapper width="full" format="module" page_title="Investigations">

<!--- 
File Name: dsp_complaint_init.cfm

Description:  I display the list of complaints.

History:
	Action									Date					Developer
	Recreated								10/2/2016				Steve Kubrak
 --->

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
	request.initiation_cfc 				= createObject("component","aps.i2m.cfc.Complaints.Initiation.Initiation_pkg");
	request.people_cfc 					= createObject("component","aps.i2m.cfc.Briefings.people_pkg");		
	request.getHQProgram				= request.initiation_cfc.getHQProgram();
	request.getAllegationSource			= request.initiation_cfc.getAllegationSource();
	request.getComplaintSources			= request.initiation_cfc.getComplaintSources();
	request.selAllComplaints			= request.initiation_cfc.selAllComplaints();

//WriteDump(var=request.selAllComplaints,label="selAllComplaints",expand=false,abort=false);//Debugging only
   
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
        <li class="active">Open Complaints</li>
      </ul>
    </div> 
  </div>
  <div class="row page-name">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
      <h3>Open Complaints</h3>
    </div>
  </div>

<cfoutput>

   <table class="table table-striped table-condensed" id="displayTable">
		<thead>
		<tr class="table_head">
		  	<th align="center" width="10%" scope="col">Case Number</th>
			<th align="center" width="30%" scope="col">Title</th>
			<th align="center" scope="col">Date Opened</th>
			<th align="center" scope="col">Due Date</th>  
			<th align="center" scope="col">Days Open</th>   
		</tr>
		</thead>
		
	<tbody>

		<!---Sel all Open Complaints ---> 
           <cfloop query="request.selAllComplaints">
           <cfscript>
           		days_open 					= DateDiff("d",request.selAllComplaints.CREATED_DATE,Now());
           </cfscript>
            <tr>
                <td><a href="frm_edit_complaint_init.cfm?id=#request.selAllComplaints.id#" title="Edit Complaint">#request.selAllComplaints.CASE_NUMBER#</a></td>			
                <td>#request.selAllComplaints.title#</td>
                <td>#DateFormat(request.selAllComplaints.CREATED_DATE, "mm/dd/yyyy")#</td>
                <td>#DateFormat(request.selAllComplaints.DUE_DATE, "mm/dd/yyyy")#</td>
                <td>#days_open#</td>      
            </tr>
        </cfloop>
		</tbody>
		</table>

</cfoutput>

</cfif>

 <igems:htmlFoot>
	<script>
     
        $(document).ready(function(){
           // $('#displayTable').DataTable();
		   var table = $('#displayTable').DataTable({
			  'order': [2, 'desc'],
			  "deferRender": true
		   })
       });
		
    </script>
      
  </igems:htmlFoot>

</i2m:page_wrapper>

