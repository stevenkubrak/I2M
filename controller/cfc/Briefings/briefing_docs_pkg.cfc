component output="true" hint="Briefing documents component" briefing_docs{

  	this.dsn="I2M_USER";
	
    //init
    public function init(){
        variables.DSN = "I2M_USER";
        return this;
    } 

    //selBriefingDocs
    public query function selBriefingDocs(
    	required string p_id
    ){
        fn_result = 0;        
        try{          
            sp=new storedProc();
            sp.setDatasource('I2M_USER');
            sp.setProcedure('I2M_USER.BRIEFING_DOCS_PKG.selBriefingDocs');
            sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.p_id#");
            sp.addProcResult(name="proc_results");
            sp_execute=sp.execute();
            fn_result=sp_execute.getProcResultSets().proc_results;
            return fn_result;          
    	}catch(any excpt){
        	writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
        	throw(message=excpt.message,detail=excpt.detail);}
    } 

    //selBriefingDoc
    public query function selBriefingDoc(
    	required string doc_id
    ){
        fn_result = 0;        
        try{          
            sp=new storedProc();
            sp.setDatasource('I2M_USER');
            sp.setProcedure('I2M_USER.BRIEFING_DOCS_PKG.selBriefingDoc');
            sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_id#");
            sp.addProcResult(name="proc_results");
            sp_execute=sp.execute();
            fn_result=sp_execute.getProcResultSets().proc_results;
            return fn_result;
            }
            catch(any excpt){
        		writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='Briefings_LOG');
        		throw(message=excpt.message,detail=excpt.detail);}
    } 
    
    //addBriefingDoc
    public void function addBriefingDoc(
        required numeric briefing_id,
        required string doc_title,
        required string doc_file,
        required string doc_mime,
        required string doc_file_size,
        required numeric doc_created_by){
    try{
        var sp = new storedProc();
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.BRIEFING_DOCS_PKG.addBriefingDoc');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.briefing_id#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_title#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_file#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_mime#");
        sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_file_size#");
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.doc_created_by#");
        var sp_exec = sp.execute();
        }
        catch(any excpt){
        	writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
        	throw(message=excpt.message,detail=excpt.detail);}
    }     


    //editBriefingDoc
    public function editBriefingDoc(
		required numeric doc_id,
        required string doc_title,
        required string doc_file,
        required string doc_mime,
        required string doc_file_size,
        required numeric doc_updated_by,
        		 numeric doc_status_id,
         		 string doc_appv_comment       
        ){
    	try{
            Attrib.setStatus	= {};
            Attrib.setStatus.Arg=duplicate(Arguments);
            Attrib.setStatus.success=false;
            var sp = new storedProc();
            sp.setDatasource('#this.dsn#');
            sp.setProcedure('I2M_USER.BRIEFING_DOCS_PKG.editBriefingDoc');
            sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.doc_id#");        
            sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_title#");
            sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_file#");
            sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_mime#");
            sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_file_size#");
            sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.doc_updated_by#");
            sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.doc_status_id#");
            sp.addParam(cfsqltype="cf_sql_varchar",type="in",value="#arguments.doc_appv_comment#");
            var sp_exec = sp.execute();
            Attrib.setStatus.success=true;
            return Attrib;
        }
        catch(any excpt){
        	writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
        	throw(message=excpt.message,detail=excpt.detail);}
    }       
    
    
    //removeBriefingDoc
    public function removeBriefingDoc(
        required numeric doc_id,
        required numeric doc_removed_by
    ){
    try{
        var sp = new storedProc();
        Attrib.setStatus	= {};
        Attrib.setStatus.Arg=duplicate(Arguments);
        
        sp.setDatasource('#this.dsn#');
        sp.setProcedure('I2M_USER.BRIEFING_DOCS_PKG.removeBriefingDoc');
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.doc_id#"); 
        sp.addParam(cfsqltype="cf_sql_numeric",type="in",value="#arguments.doc_removed_by#");
        var sp_exec = sp.execute();
        Attrib.setStatus.success=true;
    	return Attrib;
    	}
        catch(any excpt){
            writeLog(type=excpt.type,text='Message: ' & excpt.message & ' Detail: ' & excpt.detail,file='I2M_LOG');
            throw(message=excpt.message,detail=excpt.detail);}
    }   


}