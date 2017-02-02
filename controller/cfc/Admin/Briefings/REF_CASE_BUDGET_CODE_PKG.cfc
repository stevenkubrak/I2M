component output="true" hint="Main Briefings component" briefings{

  this.dsn="I2M_USER";

//addCaseBudgetCode
 public void function addCaseBudgetCode(

                                    required string code,
                                    required string desc,
                                    required string valid){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.addCaseBudgetCode');
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.code#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.desc#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }     

  
  
  
 
//updateCaseBudgetCode
  public void function updateCaseBudgetCode(
  									required numeric id,
                                    required string code,
                                 	required string desc,
                                    required string valid){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.updateCaseBudgetCode');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.code#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.desc#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }       
  
 
 
 //removeCaseBudgetCode
  public void function removeCaseBudgetCode(
  									required numeric user_id,
  									required numeric id
                                    
                                   ){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.removeCaseBudgetCode'); 
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Cookie.CURRENT_USER_ID#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#url.id#"); 
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }   
 
  

//selTopics
  public query function selTopics(string valid_flag){
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
  } 



//selCaseTopics
public query function selCaseTopics(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.REF_DISCUS_TOPICS_PKG.selCaseTopics');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


   
 //selSpecificCaseTopic 
  public query function selSpecificCaseTopic(
  									  required numeric id){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.REF_DISCUS_TOPICS_PKG.selSpecificCaseTopic');
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
  
  
//addCaseTopics
 public void function addCaseTopics(

                                    required string description,
                                    required string valid){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_DISCUS_TOPICS_PKG.addCaseTopics');
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.description#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }     


//updateCaseTopics
  public void function updateCaseTopics(
  									required numeric id,
                                 	required string description,
                                    required string valid){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_DISCUS_TOPICS_PKG.updateCaseTopics');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.description#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }       
  
 
 //removeCaseTopics
  public void function removeCaseTopics(
  									required numeric id
                                   ){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_DISCUS_TOPICS_PKG.removeCaseTopics');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#url.id#"); 
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }   














































     
//selMyBriefings     
  public query function selMyBriefings(required numeric presenter_id){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selMyBriefings');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="26002");
          //sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Argument.presenter_id#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


//selThisBriefing
  public query function selThisBriefing(
  										required string p_id
                                        //,required string p_user_id
                                        ){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selThisBriefing');
          //sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.p_user_id#");
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.p_id#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  }  
  
  

//getOIPerson
  public query function getOIPerson(required string getOIPerson){
    try{
      var sp=new storedProc();
          sp.setDataSource('#this.dsn#');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.getOIPerson');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.getOIPerson#");
          sp.addProcResult(name="proc_results");
      var sp_execute=sp.execute();
      var fn_result=sp_execute.getProcResultSets().proc_results; 
      return fn_result;}
    catch(any excpt){
      writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='SYSTEM');
      throw(message=excpt.message,detail=excpt.detail);}
  } 


}
            
       
  


   


