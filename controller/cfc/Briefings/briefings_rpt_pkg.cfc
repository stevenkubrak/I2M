component output="true" hint="Briefings report component" briefings{

  this.dsn="I2M_USER";

  //selResourceCenters
  public query function selResourceCenters(required string filter_by, required string start_date, required string end_date){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_RPT_PKG.selResourceCenters');
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.filter_by#"); 
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.start_date#"); 
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.end_date#");          
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;         
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 

  //selResourceCenter
  public query function selResourceCenter(required string filter_by, required numeric office_id, required string start_date, required string end_date){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_RPT_PKG.selResourceCenter');         
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.filter_by#");
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.office_id#");
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.start_date#"); 
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.end_date#");          
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;         
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 

  //selFieldOffice
  public query function selFieldOffice(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('IGDBA.PKG_FIELD_OFFICE.selFieldOffice');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 

       
  //selOfficesByCenter     
  public query function selOfficesByCenter(required numeric office_id){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_RPT_PKG.selOfficesByCenter');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.office_id#");         
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 

  //selBriefingsByResourceCenter     
  public query function selBriefingsByResourceCenter(required string filter_by, required numeric office_id, required string start_date, required string end_date){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_RPT_PKG.selBriefingsByResourceCenter');          
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.filter_by#");
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.office_id#");
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.start_date#"); 
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.end_date#");          
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  }   

  //selBriefingsByOffice     
  public query function selBriefingsByOffice(required string filter_by, required numeric office_id, required string start_date, required string end_date){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_RPT_PKG.selBriefingsByOffice');          
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.filter_by#");
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.office_id#");          
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.start_date#"); 
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.end_date#");         
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  }  

  //selBriefingsByPresenter     
  public query function selBriefingsByPresenter(required string filter_by, required numeric office_id, required numeric presenter_id, required string start_date, required string end_date){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_RPT_PKG.selBriefingsByPresenter');
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.filter_by#");
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.office_id#");          
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.presenter_id#");
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.start_date#"); 
          sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.end_date#");         
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