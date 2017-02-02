<cfsilent>
<!--- 
File Name: dsp_complaint_investigative_plan.cfm

Description:  I display a form to capture case information.

History:
	Action									Date					Developer
	Created									1/23/2017				Calvert Acklin
 --->
</cfsilent>
<cfimport prefix="i2m" tagLib="/aps/i2m/common/">
<cfimport prefix="igems" tagLib="/common/">
<i2m:page_wrapper width="full" format="module" page_title="Investigations">

<cfscript>
	user.name 							= cookie.CURRENT_USER_NAME;
	user.id 							= cookie.CURRENT_USER_ID;
	presenter_id 						= cookie.CURRENT_USER_ID;
	binary_list							= "Y,N";
	
	param name="url.id" default="0";
	
	// Include shared functions
	include "/common/shared_functions.cfm";
  
	// Declare variables and instantiate CFC
	try{
		
		request.page_has_errors				= false;
		request.page_load_error_message		= "";
		request.auth_user					= false;
		request.org_elements_cfc 			= createObject("component","cfc.organization_elements_pkg");
		request.briefings_cfc 				= createObject("component","aps.i2m.cfc.Briefings.Briefings_pkg");
		request.initiation_cfc 				= createObject("component","aps.i2m.cfc.Complaints.Initiation.Initiation_pkg");
		request.people_cfc 					= createObject("component","aps.i2m.cfc.Briefings.people_pkg");	
			
		request.getComplaint				= request.initiation_cfc.selSpecificComplaint(#url.id#);
	
		WriteDump(var=request.getComplaint,label="getComplaint",expand=false,abort=false);//Debugging only
	
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

<cfoutput>
<div class="row">
    <div>
        <ul class="breadcrumb">
            <li><a href="/">IGEMS</a>
            <li><a href="/aps/i2m/">Investigations</a>
            <li><a href="/aps/i2m/views/complaints/initiation/frm_edit_complaint_init.cfm?id=#url.id#">Complaint</a>      
            <li class="active">Investigative Plan</li>
        </ul>
    </div>
</div>

<div class="row page-name">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
    	<h3>Investigative Plan</h3>
    </div>
</div>

<form 
action="##" 
class="form" 
id="complaint_inv_plan" 
name="complaint_inv_plan" 
method="post" 
role="form" 
enctype="multipart/form-data">

    <input type="hidden" value="#cookie.current_user_id#" name="user_id">
    <input type="hidden" value="#request.getComplaint.fiscal_year#" name="fiscal_year">
    <input type="hidden" value="U" name="group_code" />
    <input type="hidden" value="#url.id#" name="id" />


    <!---Complaint tabs--->
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="nav nav-tabs">
                <li role="presentation"><a href="/aps/i2m/views/complaints/initiation/frm_edit_complaint_init.cfm?id=#url.id#">Complaint Initiation</a></li>
                <li role="presentation" class="active"><a href="/aps/i2m/views/complaints/inv_plan/dsp_complaint_investigative_plan.cfm?id=#url.id#">Inv Plan</a></li>
                <li role="presentation"><a href="##">Individuals/Institutions</a></li>   
                <li role="presentation"><a href="##">Staff</a></li>
                <li role="presentation"><a href="##">Violations</a></li>  
                <li role="presentation"><a href="##">Related Cases</a></li>
                <li role="presentation"><a href="##">Joint Agencies</a></li>   
                <li role="presentation"><a href="##">Regions</a></li>
                <li role="presentation"><a href="/aps/i2m/views/complaints/initiation/dsp_complaint_documents.cfm?id=#url.id#">Documents</a></li>                   
                 
            </ul>
        </div>
    </div>  
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ul class="nav nav-tabs">
                <li role="presentation"><a href="##">Tech/Support</a></li>
                <li role="presentation"><a href="##">Referrals</a></li>
                <li role="presentation"><a href="##">Photos</a></li>   
                <li role="presentation"><a href="##">Alert</a></li>
                <li role="presentation"><a href="##">Chron Log</a></li> 
                <li role="presentation"><a href="##">Close</a></li> 
            </ul>
        </div>
    </div>  
    <!---End Complaint tabs--->
    
    <!--- Complaint info tag --->  
    <div class="row">
        <div class="col-sm-6"><label id="wp_designator_label">Title</label></div>
        <div class="col-sm-6"><label id="wp_title_label">Status</label></div>
    </div>
    
    <div class="row" style="margin-bottom:1em">
        <div class="col-sm-6" aria-labelledby = "wp_designator_label">Title</div>
        <div class="col-sm-6" aria-labelledby = "wp_title_label">Open/Closed</div>
    </div> 
    <div class="row">
        <div class="col-sm-6"><label id="wp_designator_label">Complaint No.:</label></div>
        <div class="col-sm-6"><label id="wp_title_label">Assigned Agent:</label></div>
    </div>
    
    <div class="row" style="margin-bottom:1em">
        <div class="col-sm-6" aria-labelledby = "wp_designator_label">Complaint number</div>
        <div class="col-sm-6" aria-labelledby = "wp_title_label">First and Last Name</div>
    </div> 
	<!--- End Complaint info tag --->  

    <br />

    
    <div class="row">
    
    <!---<div class="row"></div>--->
    	<div class="col-md-12">
            <h5 class="text-left">
                <strong>Complaint Information</strong>
            </h5>
        </div>
    

		<div class="col-md-6">
			
			<form role="form">
				<div class="form-group">
					 
					<label for="exampleInputEmail1">
						Email address
					</label>
					<input type="email" class="form-control" id="exampleInputEmail1">
				</div>
				<div class="form-group">
					 
					<label for="exampleInputPassword1">
						Password
					</label>
					<input type="password" class="form-control" id="exampleInputPassword1">
				</div>
				<div class="form-group">
					 
					<label for="exampleInputFile">
						File input
					</label>
					<input type="file" id="exampleInputFile">
					<p class="help-block">
						Example block-level help text here.
					</p>
				</div>
				<div class="checkbox">
					 
					<label>
						<input type="checkbox"> Check me out
					</label>
				</div> 
				<button type="submit" class="btn btn-default">
					Submit
				</button>
			</form> 
			<button type="button" class="btn btn-default">
				Default
			</button>
		</div>
		<div class="col-md-6">
			<form role="form">
				<div class="form-group">
					 
					<label for="exampleInputEmail1">
						Email address
					</label>
					<input type="email" class="form-control" id="exampleInputEmail1">
				</div>
				<div class="form-group">
					 
					<label for="exampleInputPassword1">
						Password
					</label>
					<input type="password" class="form-control" id="exampleInputPassword1">
				</div>
				<div class="form-group">
					 
					<label for="exampleInputFile">
						File input
					</label>
					<input type="file" id="exampleInputFile">
					<p class="help-block">
						Example block-level help text here.
					</p>
				</div>
				<div class="checkbox">
					 
					<label>
						<input type="checkbox"> Check me out
					</label>
				</div> 
				<button type="submit" class="btn btn-default">
					Submit
				</button>
			</form>
		</div>
	</div>    
	<div class="row">
		<div class="col-md-12">
			<h5>Violations</h5>
			<table class="table">
				<thead>
					<tr>
						<th>
							##
						</th>
						<th>
							Product
						</th>
						<th>
							Payment Taken
						</th>
						<th>
							Status
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							1
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							01/04/2012
						</td>
						<td>
							Default
						</td>
					</tr>
					<tr class="active">
						<td>
							1
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							01/04/2012
						</td>
						<td>
							Approved
						</td>
					</tr>
					<tr class="success">
						<td>
							2
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							02/04/2012
						</td>
						<td>
							Declined
						</td>
					</tr>
					<tr class="warning">
						<td>
							3
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							03/04/2012
						</td>
						<td>
							Pending
						</td>
					</tr>
					<tr class="danger">
						<td>
							4
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							04/04/2012
						</td>
						<td>
							Call in to confirm
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<h3>
				Allegations
			</h3>
			<table class="table">
				<thead>
					<tr>
						<th>
							##
						</th>
						<th>
							Product
						</th>
						<th>
							Payment Taken
						</th>
						<th>
							Status
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							1
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							01/04/2012
						</td>
						<td>
							Default
						</td>
					</tr>
					<tr class="active">
						<td>
							1
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							01/04/2012
						</td>
						<td>
							Approved
						</td>
					</tr>
					<tr class="success">
						<td>
							2
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							02/04/2012
						</td>
						<td>
							Declined
						</td>
					</tr>
					<tr class="warning">
						<td>
							3
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							03/04/2012
						</td>
						<td>
							Pending
						</td>
					</tr>
					<tr class="danger">
						<td>
							4
						</td>
						<td>
							TB - Monthly
						</td>
						<td>
							04/04/2012
						</td>
						<td>
							Call in to confirm
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

    <div class="col-md-8">
        <br />
    </div>

</form>

</cfoutput>
</cfif>



<igems:htmlFoot>
<script></script>
</igems:htmlFoot>

</i2m:page_wrapper>