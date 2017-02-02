component output="true" hint="Briefings history component" briefings{

  this.dsn="I2M_USER";

  //selHistoryRecords
  public query function selHistoryRecords(required numeric brief_id)
  {
    fn_result = 0;
    try{          
          sp=new storedProc();
          sp.setDatasource('#this.dsn#');           
          sp.setProcedure('I2M_USER.BRIEFINGS_HIST_PKG.selHistoryRecords');
          sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.brief_id#");
          sp.addProcResult(name="proc_results");
          sp_execute=sp.execute();
          fn_result=sp_execute.getProcResultSets().proc_results;
          return fn_result;          
    }
    catch(any excpt){
          writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
          throw(message=excpt.message,detail=excpt.detail);}
  } 
            
        
}