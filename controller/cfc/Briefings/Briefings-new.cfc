component output="true" hint="Main Briefings component" briefings{

  this.dsn="I2M_USER";

  //selMaxBriefing
  public query function selMaxBriefing(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selMaxBriefing');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Cookie.CURRENT_USER_ID#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


//addBriefing
  public void function addBriefing(
  									required numeric user_id,
                                    required string title,
                                    required date RO_date,
                                  	required string office,
                                    required string budget_code,
                                  	required string Presenter,
                                    required string organization,
                                    required string org_address,
                                    required string org_city,   
                                    required string org_state,
                                    required string org_zip,			
                                    required string comments,
                                    required string topic){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.BRIEFINGS_PKG.addBriefing');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.user_id#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.title#");
        sp.addParam(cfsqltype="cf_sql_date",type="in",value="#arguments.RO_date#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.office#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.budget_code#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.Presenter#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.organization#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_address#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_city#");  
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_zip#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.comments#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.topic#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
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

    
//selRecords
  public query function selRecords(required string state_valid){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('IGEMS_USER');
          sp.setProcedure('IGEMS_USER.REF_STATES_PKG.selRecords');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.state_valid#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 

/*//selBudgetCodes 
  public query function selBudgetCodes(string valid_flag){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selBudgetCodes');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid_flag#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } */

  //selBudgetCodes
  public query function selBudgetCodes(){
    fn_result = '';
    try{          
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG2.selBudgetCodes');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  }   

  //selTopics
  public query function selTopics(){
    fn_result = 0;
    try{          
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selTopics');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  }   

//selTopics
/*  public query function selTopics(string valid_flag = 0){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selTopics');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid_flag#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } */

     
     
//qBriefings     
  public query function selMyBriefings(required string p_user_id){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selMyBriefings');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.p_user_id#");
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
            
       
  


   


