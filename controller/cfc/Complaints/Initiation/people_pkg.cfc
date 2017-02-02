component {

  this.dsn="IGEMS_USER";

  public query function validateUser(required string user_name){
    try{
      var sp=new storedProc();
          sp.setDataSource('#this.dsn#');
          sp.setProcedure('IGEMS_USER.PEOPLE_PKG.validateUser');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.user_name#");
          sp.addProcResult(name="proc_results");
      var sp_exec=sp.execute();
      var fn_result=sp_exec.getProcResultSets().proc_results;
      return fn_result;}
    catch(any excpt){
      writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='SYSTEM');
      throw(message=excpt.message,detail=excpt.detail);}
  }

  public query function selPeopleForDrowdown(required string valid){
    try{
      var sp=new storedProc();
          sp.setDataSource('#this.dsn#');
          sp.setProcedure('IGEMS_USER.PEOPLE_PKG.selPeopleForDropdown');
          sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.valid#");
          sp.addProcResult(name="proc_results");
      var sp_execute=sp.execute();
      var fn_result=sp_execute.getProcResultSets().proc_results;
      return fn_result;}
    catch(any excpt){
      writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='SYSTEM');
      throw(message=excpt.message,detail=excpt.detail);}
  }  
  
  public string function getIgemsLogonCode(required numeric person_id){
    try{
      var sp=new storedProc();
          sp.setDataSource('#this.dsn#');
          sp.setProcedure('IGEMS_USER.PEOPLE_PKG.getIgemsLogonCode');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.person_id#");
          sp.addParam(cfsqltype="cf_sql_varchar",type="out",variable="proc_result");     
      var sp_execute=sp.execute();
      var fn_result=sp_execute.getProcOutVariables().proc_result;
      return fn_result;}
    catch(any excpt){
      writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='SYSTEM');
      throw(message=excpt.message,detail=excpt.detail);}
  }
  

  public query function getPerson(required numeric person_id){
    try{
      var sp=new storedProc();
          sp.setDataSource('#this.dsn#');
          sp.setProcedure('IGEMS_USER.PEOPLE_PKG.getPerson');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.person_id#");
          sp.addProcResult(name="proc_results");
      var sp_execute=sp.execute();
      var fn_result=sp_execute.getProcResultSets().proc_results; 
      return fn_result;}
    catch(any excpt){
      writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='SYSTEM');
      throw(message=excpt.message,detail=excpt.detail);}
  } 

  public string function admUpdate(required numeric person_id,
                                 required string logon_code,
                                 required string email,
                                 required numeric user_id,
                                 required numeric priv_user_id){
  try{
    sp=new storedProc();
    sp.setDataSource('#this.dsn#');
    sp.setProcedure('IGEMS_USER.PEOPLE_PKG.admUpdate');
    sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.person_id#");
    sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.logon_code#");
    sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.email#");
    sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.user_id#");
    sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.priv_user_id#");
    sp.execute();
    return 'SUCCESS';}
  catch(any excpt){
    writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='ADM_ERRORS');
    throw(message=excpt.message,detail=excpt.detail);}  
  }
  
 public string function getFullName(required numeric person_id){
   try{
     var sp=new storedProc();
         sp.setDatasource('#this.dsn#');
         sp.setProcedure('IGEMS_USER.PEOPLE_PKG.getFullName');
         sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.person_id#");
         sp.addParam(cfsqltype="cf_sql_varchar",type="out",variable="proc_result");
     var sp_exec=sp.execute();
     var fn_result=sp_exec.getProcOutVariables().proc_result;
     return fn_result;}
   catch(any excpt){
    writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='ADM_ERRORS');
    throw(message=excpt.message,detail=excpt.detail);} 
 }
 
 public void function updateWorkProfile(required numeric person_id,
                                                 string  room_number,
                                        required string  work_phone,
                                                 string  work_cell,
                                        required numeric user_id,
                                        required numeric priv_user_id){
  try{
    var wp = REReplace(arguments.work_phone,'[^0-9]','','ALL');
    if( trim(arguments.work_cell) neq ''){var wc = REReplace(arguments.work_cell,'[^0-9]','','ALL');} else{wc=0;}
    var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('IGEMS_USER.PEOPLE_PKG.updateWorkProfile');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in", value="#arguments.person_id#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in", value="#arguments.room_number#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in", value="#wp#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in", value="#wc#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in", value="#arguments.user_id#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in", value="#arguments.priv_user_id#");
    var sp_exec = sp.execute();}
  catch(any excpt){
    writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='SYSTEM');
    throw(message=excpt.message,detail=excpt.detail);}
 }

  public query function selIncomingPersonnel(required string timeframe){
    try{
      var sp=new storedProc();
          sp.setDataSource('#this.dsn#');
          sp.setProcedure('IGEMS_USER.PEOPLE_PKG.selIncomingPersonnel');
          sp.addParam(cfsqltype='cf_sql_varchar',type='in',value='#arguments.timeframe#');
          sp.addProcResult(name='proc_results');
      var sp_exec = sp.execute();
      var fn_result = sp_exec.getProcResultSets().proc_results;
          return fn_result;}
    catch(any excpt){
      writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='ADMINISTRATION_ERRORS');
      throw(message=excpt.message,detail=excpt.detail);}
   
 }

  public query function selOutgoingPersonnel(required string timeframe){
    try{
      var sp=new storedProc();
          sp.setDataSource('#this.dsn#');
          sp.setProcedure('IGEMS_USER.PEOPLE_PKG.selOutgoingPersonnel');
          sp.addParam(cfsqltype='cf_sql_varchar',type='in',value='#arguments.timeframe#');
          sp.addProcResult(name='proc_results');
      var sp_exec = sp.execute();
      var fn_result = sp_exec.getProcResultSets().proc_results;
          return fn_result;}
    catch(any excpt){
      writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='ADMINISTRATION_ERRORS');
      throw(message=excpt.message,detail=excpt.detail);}
   
 }

}