component output="true" hint="Main complaint" initiation{

  this.dsn="I2M_USER";
 
//addComplaintStaff()
  public void function addComplaintStaff(
                                        
                                            required numeric  	user_id,
                                            required numeric  	case_agent,
                                            required string  	role_agent,
                                            required string	 	permission,
                                            required date	  	date_assigned,	
                                            required string  	grand_jury,
                                            required string		confidential

  ){
    fn_result = 0;        
    try{                  
        var sp=new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.COMPLAINT_STAFF_PKG.addComplaintStaff'); 
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.user_id#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.case_agent#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.role_agent#");
      	sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.permission#");
        sp.addParam(cfsqltype="cf_sql_date",type="in",value="#arguments.date_assigned#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.grand_jury#");
      	sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.confidential#");
        var sp_execute=sp.execute();         
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Complaint_Initiation_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


 
//getStaffRoles()
  public query function getStaffRoles(){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_STAFF_PKG.getStaffRoles');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Complaint_Initiation_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 
 
  
  
  
 //getAllStaff()
  remote query function getAllStaff(
                                      required	numeric	id	
  ){
    fn_result = 0;        
    try{                  
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.COMPLAINT_STAFF_PKG.getAllStaff');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Complaint_Initiation_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 
  

 
 
 
 
 

}
            
       
  


   


