component output="true" hint="Main Briefings component" initiation{

  this.dsn="I2M_USER";

//getHQProgram()
  public query function getHQProgram(){
    fn_result = 0;        
    try{                   
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getHQProgram');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


//getAllegationSource()
  public query function getAllegationSource(){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getAllegationSource');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


// getCityStateFromZip()
  remote query function getCityStateFromZip(
  			required numeric zip){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getCityStateFromZip');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.zip#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 

	  

//getManagementChallenges()
  public query function getManagementChallenges(){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getManagementChallenges');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


//selMaxComplaint()
  public query function selMaxComplaint(){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.selMaxComplaint');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


//getComplaintSources()
  remote query function getComplaintSources(){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getComplaintSources');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 

//getComplaintDocuments()
  public query function getComplaintDocuments(
    											required numeric case_id){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getComplaintDocuments');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.case_id#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 




//addComplaintInit()
  public void function addComplaintInit(

                                            required numeric CASE_AGENT,	
                                            required string  BUDGET_CODE,	
                                            required string  CITY_FIELD,	
                                            required string  DIRECTORATE,
                                            required string  violation,
                                            required string  DUE_DATE,	
                                            required date    initiation_date,	
                                            required string  IS_HOTLINE_NUMBER,	
                                            required string  MANCHALL,
                                          	required string  OFFICE,	
                                            required string  PROJECT_TYPE,	
                                            required string  ALLEGATION_SOURCE,	
                                            required string  STATE_FIELD,	
                                            required string  TITLE,	
                                            required numeric USER_ID,	
                                            required string  ZIP_CODE,
                                            required date    FISCAL_YEAR,
                                            required string	 GROUP_CODE,
                                            required string  maxID,
                                       				 string	 CONFIDENTIAL
  ){
    fn_result = 0;        
    try{                  
        var sp=new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.COMPLAINT_PKG.addComplaintInit'); 

        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.CASE_AGENT#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.BUDGET_CODE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.CITY_FIELD#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.DIRECTORATE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.violation#");
        sp.addParam(cfsqltype="cf_sql_date",type="in",value="#arguments.DUE_DATE#");
        sp.addParam(cfsqltype="cf_sql_date",type="in",value="#arguments.initiation_date#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.IS_HOTLINE_NUMBER#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.MANCHALL#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.OFFICE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.PROJECT_TYPE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.ALLEGATION_SOURCE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.STATE_FIELD#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.TITLE#");         
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.USER_ID#");         
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.ZIP_CODE#"); 
        sp.addParam(cfsqltype="cf_sql_date",type="in",value="#arguments.fiscal_year#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.GROUP_CODE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.maxID#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.CONFIDENTIAL#");      
        var sp_execute=sp.execute();         
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Complaint_Initiation_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 



//addComplaintDoc()
  public void function addComplaintDoc(
                                            required numeric	newid, 
                                            required string  	FILE_NAME,	
                                            required string  	file_desc,	
                                            required numeric  	uploaded_by,
                                            required string	 	DOC_APPLICATION_PATH
                                       


  ){
    fn_result = 0;        
    try{                  
        var sp=new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.COMPLAINT_PKG.addComplaintDoc'); 
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.newid#");     
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.FILE_NAME#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.file_desc#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.uploaded_by#");
      	sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.DOC_APPLICATION_PATH#");
        var sp_execute=sp.execute();         
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Complaint_Initiation_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 









//editComplaintInit()
  public void function editComplaintInit(

                                            required numeric CASE_AGENT,	
                                            required string  BUDGET_CODE,	
                                            required string  CITY_FIELD,	
                                            required string  DIRECTORATE,
                                            required string  violation,
                                            required date	 DUE_DATE,	
                                            required string  IS_HOTLINE_NUMBER,	
                                            required string  MANCHALL,
                                          	required numeric  OFFICE,	
                                            required string  PROJECT_TYPE,	
                                            required string  ALLEGATION_SOURCE,	
                                            required string  STATE_FIELD,	
                                            required string  TITLE,	
                                            required string  ZIP_CODE,
                                            required date    FISCAL_YEAR,
                                            required string	 GROUP_CODE,
                                             		 string	 CONFIDENTIAL,
                                            required numeric  ID
                                       				
  ){
    fn_result = 0;        
    try{                  
        var sp=new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.COMPLAINT_PKG.editComplaintInit'); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.CASE_AGENT#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.BUDGET_CODE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.CITY_FIELD#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.DIRECTORATE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.violation#");
        sp.addParam(cfsqltype="cf_sql_date",type="in",value="#arguments.DUE_DATE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.IS_HOTLINE_NUMBER#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.MANCHALL#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.OFFICE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.PROJECT_TYPE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.ALLEGATION_SOURCE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.STATE_FIELD#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.TITLE#");                
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.ZIP_CODE#"); 
        sp.addParam(cfsqltype="cf_sql_date",type="in",value="#arguments.fiscal_year#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.GROUP_CODE#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.CONFIDENTIAL#");  
        sp.addParam(cfsqltype="number",type="in",value="#arguments.ID#");             
        var sp_execute=sp.execute();         
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Complaint_Initiation_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 





  //selAllComplaints     
  public query function selAllComplaints(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.selAllComplaints');       
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 



  //selSpecificComplaint     
  public query function selSpecificComplaint(
  								      numeric   	id
  ){                                
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.selSpecificComplaint'); 
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#");      
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 



  //getAgentFormsDirectory     
  public query function getAgentFormsDirectory(
  								      numeric   	id
  ){                                
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getAgentFormsDirectory'); 
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#");      
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


 
 
 //selPeopleSubToPersonInRole()
  public query function selPeopleSubToPersonInRole(
  								      numeric   	p_person_id
  ){
    fn_result = 0;        
    try{                   
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('IGEMS_USER.JCT_PEOPLE_ROLES_PKG.selPeopleSubToPersonInRole');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.p_person_id#");   
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 
  
  
 
//getStaffRoles()
  public query function getStaffRoles(){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_PKG.getStaffRoles');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 
 
 
 
 
 
 


}
            
       
  


   


