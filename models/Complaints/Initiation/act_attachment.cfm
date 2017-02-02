<cfimport prefix="igems" tagLib="/common/"><cfimport prefix="hc" tagLib="/aps/hc/common/">
<hc:page_wrapper width="full" format="minimal">
<cfscript>
 try{
  include "/common/shared_functions.cfm";
  file_results = fileUpload('F:/hc/','form.filename','*','makeUnique');
  if(file_results.fileWasSaved eq true){
   request.cfc=createObject("component","aps.hc.cfc.person_sec_attachments_pkg");
   request.cfc.insPersonSecAttachment(form.description,file_results.contentSubType,file_results.fileSize,form.user_id,file_results.serverfile,form.person_id);
  }
  }
 catch(any excpt){handleError(excpt);}

</cfscript>
<cfif request.page_has_errors eq true>
 <igems:page_error>
<cfelse>

 <!---<cfdirectory action="list" directory="F:\hc\" name="dir">--->
 
 <cfoutput>
 <div class="row">
  <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
  <h4>Upload complete.</h4>
  </div>
 </div>
 <div class="row">
  <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
   <label for="server_file_name">Server file name</label>
  </div>
  <div class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
   <span id="server_file_name">#file_results.serverfile#</span>
  </div>
 </div>
 <div class="row">
  <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
   <label for="mime_type">File Type</label>
  </div>
  <div class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
   <span id="mime_type">#file_results.contentSubType#</span>
  </div>
 </div>
 <div class="row">
  <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
   <label for="file_size">File Size</label>
  </div>
  <div class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
   <span id="file_size">#file_results.fileSize#kB</span>
  </div>
 </div>
 <hr>
 <div class="row">
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-center">
   <button class="btn btn-primary" type="button" name="done_btn" onclick="javascript:opener.location.reload();self.close();">That was my last upload.</button>
  </div>
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-center">
   <a class="btn btn-info" href="/aps/hc/views/frm_attachment.cfm?p=#form.person_id#">I have another file to upload.</a>
  </div>
 </div>
 </cfoutput>
</cfif>
</hc:page_wrapper>