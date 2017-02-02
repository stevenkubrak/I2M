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
                                    required string brief_liason,
                                    required string created_date,
                                  	required string office,
                                    required string budget_code,
                                  	required string Presenter,
                                    		 string coPresenter,
                                    required string organization,
                                    required string org_address,
                                    required string org_city,   
                                    required string org_state,
                                    required string org_zip,			
                                    required string comments,
                                    required string topic,
                                   	required string briefing_number){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.BRIEFINGS_PKG.addBriefing');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.user_id#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.title#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.brief_liason#");
        sp.addParam(cfsqltype="cf_sql_string",type="in",value="#Arguments.created_date#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.office#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.budget_code#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.Presenter#");
        if(!structKeyExists(arguments,'coPresenter')){arguments.coPresenter = '';}
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.coPresenter#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.organization#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_address#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_city#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_state#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_zip#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.comments#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.topic#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.briefing_number#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }     


//editBriefing
  public void function editBriefing(
  									required numeric brief_id,
  									required numeric user_id,
                                    required string title,
                                 	required string brief_liason,
                                    required string created_date,
                                  	required string office,
                                    required string budget_code,
                                  	required string Presenter,
                                    		 string coPresenter,
                                    required string organization,
                                    required string org_address,
                                    required string org_city,   
                                    required string org_state,
                                    required string org_zip,			
                                    required string comments,
                                    required string topic,
                                   	required string briefing_number){    
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.BRIEFINGS_PKG.editBriefing');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.brief_id#"); 
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.user_id#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.title#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.brief_liason#");
        sp.addParam(cfsqltype="cf_sql_string",type="in",value="#arguments.created_date#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.office#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.budget_code#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.Presenter#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.coPresenter#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.organization#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_address#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_city#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_state#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.org_zip#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.comments#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.topic#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.briefing_number#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }       


//editBriefingRemove
  public void function editBriefingRemove(
  									required numeric id,
  									required numeric user_id
                                   ){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.BRIEFINGS_PKG.editBriefingRemove');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#"); 
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.user_id#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }   


//editRestoreBriefing
  public void function editRestoreBriefing(
  									required numeric id,
  									required numeric user_id
                                   ){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.BRIEFINGS_PKG.editRestoreBriefing');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#"); 
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.user_id#");
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

//selValidBudgetCodes 
  public query function selValidBudgetCodes(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selValidBudgetCodes');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 
  
  
 //selCaseBudgetCode 
  public query function selCaseBudgetCode(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.selCaseBudgetCode');
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  }  
  
  
 //selSpecificCaseBudgetCode 
  public query function selSpecificCaseBudgetCode(
  									  required numeric id){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.selSpecificCaseBudgetCode');
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
  
  
//addCaseBudgetCode
 public void function addCaseBudgetCode(

                                    required string code,
                                    required string description,
                                    required string valid){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.addCaseBudgetCode');
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.code#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.description#");
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
                                 	required string description,
                                    required string valid){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.updateCaseBudgetCode');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.id#"); 
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.code#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.description#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid#");
      var sp_exec = sp.execute();}
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
   }       
  
 
 
 //removeCaseBudgetCode
  public void function removeCaseBudgetCode(
  									required numeric id
                                   ){
    try{
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.REF_CASE_BUDGET_CODE_PKG.removeCaseBudgetCode');
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
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.presenter_id#");         
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 
  
  
  //getSubordinateBriefings     
  public query function getSubordinateBriefings(required numeric presenter_id){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.getSubordinateBriefings');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#Arguments.presenter_id#");         
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



  //qSelAllBriefings     
  public query function qSelAllBriefings(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.qSelAllBriefings');       
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


  //qSelResourceCenter     
  public query function qSelResourceCenter(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.qSelResourceCenter');       
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


  //qSelThisCenter     
  public query function qSelThisCenter(
  										required numeric BRIEFINGS_OFFICE){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.qSelThisCenter');  
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.BRIEFINGS_OFFICE#");    
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


  //qSelThisCenter     
  public query function selOfficeBriefings(
  										required numeric BRIEFINGS_OFFICE){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selOfficeBriefings');  
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.BRIEFINGS_OFFICE#");    
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 



  //qselOfficeBriefings     
  public query function qselOfficeBriefings(
  										required numeric org_element_id,
  										required numeric presentor,                           
  										required numeric presenter_id,
  										required numeric co_presenter_ids                                   
                                        ){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.selOfficeBriefings');  
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.org_element_id#");  
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.presentor#");      
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.presenter_id#");  
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.co_presenter_ids#");  
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 


  //qSelAllDeletedBriefings     
  public query function qSelAllDeletedBriefings(){
    fn_result = 0;        
    try{          
          sp=new storedProc();
          sp.setDatasource('I2M_USER');
          sp.setProcedure('I2M_USER.BRIEFINGS_PKG.qSelAllDeletedBriefings');       
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
            
       
  


   


