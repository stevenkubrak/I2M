<cfcomponent displayname="UtilityComponent" hint="Contains utilities for global use" >

  <!--- init() --->
  <cffunction name="init">
    <cfset variables.dsn = application.starsdb>
	<cfreturn this />
  </cffunction>

  <!--- addRowNumbers() --->
  <cffunction name="addRowNumbers" access="public" returntype="query">
    <cfargument name="queryName" required="yes" type="query" />

    <cfset var iLooop = "" />
    <cfset var rowArray = arrayNew(1) />
    <cfset var thisQuery = duplicate(arguments.queryName) />

    <cfif thisQuery.recordCount GT 0>
      <cfloop from="#thisQuery.recordCount#" to="1" index="iLoop" step="-1">
        <cfset rowArray[iLoop] = toString(iLoop) />
      </cfloop>
    </cfif>

    <cfset queryAddColumn(thisQuery, "ROW", rowArray) />

    <cfreturn thisQuery />
  </cffunction>

  <!--- getRowColor() --->
  <cffunction name="getRowColor" access="public" returntype="any">
    <cfargument name="num" required="yes" type="any" />
	<cfargument name="even" required="yes" type="any" />
	<cfargument name="odd" required="yes" type="any" />
	
	<cfscript>

		if(Arguments.num MOD 2 EQ 0){
			return Arguments.even;
		} else {
			return Arguments.odd;
		}
		
	</cfscript>

  </cffunction>

  <!--- checkGridSort() --->
  <cffunction name="checkGridSort" access="public" returntype="struct">
    <cfargument name="argGrid" required="yes" type="struct" />
    <cfargument name="varGrid" required="yes" type="struct" />

    <cfset var chkGrid = structNew() />

    <cfif len(trim(arguments.argGrid.gridsortcolumn)) GT 0
      AND trim(arguments.argGrid.gridsortcolumn) NEQ "ROW">
      <cfset chkGrid.sortColumn = trim(arguments.argGrid.gridsortcolumn) />
    <cfelse>
      <cfset chkGrid.sortColumn = trim(arguments.varGrid.sortColumn) />
    </cfif>

    <cfif listFindNoCase("ASC,DESC", trim(arguments.argGrid.gridsortdirection))>
      <cfset chkGrid.sortDirection = trim(arguments.argGrid.gridsortdirection) />
    <cfelse>
      <cfset chkGrid.sortDirection = trim(arguments.varGrid.sortDirection) />
    </cfif>

    <cfreturn chkGrid />
  </cffunction>

  <!--- checkForData() --->
  <cffunction name="checkForData" access="public" returntype="query">
    <cfargument name="queryName" required="yes" type="query" />

    <cfset var hideGridRow = TRUE />
    <cfset var thisQuery = duplicate(arguments.queryName) />

    <cfloop list="#thisQuery.columnList#" index="thisColumn">
      <cfif len(trim(thisQuery[thisColumn][1])) GT 0>
        <cfset hideGridRow = FALSE />
        <cfbreak />
      </cfif>
    </cfloop>

    <cfif hideGridRow>
      <cfset thisQuery = queryNew(thisQuery.columnList) />
    </cfif>

    <cfreturn thisQuery />
  </cffunction>

  <!--- formatPath() --->
  <cffunction access="public" name="formatPath" returntype="string" output="no">
    <cfargument name="thisPath" required="yes" type="string" />

    <cfscript>
      var formattedPath = lCase(replace(replace(replace(replace(arguments.thisPath, " ", "", "ALL"), "/", "", "ALL"), "-", "", "ALL"), " ", "", "ALL"));
      return formattedPath;
    </cfscript>
  </cffunction>

  <!--- formatTitle() --->
  <cffunction access="public" name="formatTitle" returntype="string" output="no">
    <cfscript>
      var thisTitle = "";

      if (isDefined("request.theTitle")) {
        thisTitle = thisTitle & trim(request.theTitle);
      }

      if (isDefined("request.subArea")) {
        if (len(trim(thisTitle)) GT 0) {
          thisTitle = thisTitle & " &ndash; ";
        }

        thisTitle = thisTitle & trim(request.subArea);
      }

      //if (len(trim(arguments.tabsOne))) {
      //  if (len(trim(thisTitle)) GT 0) {
      //    thisTitle = thisTitle & " &ndash; ";
      //  }

      //  thisTitle = thisTitle & trim(arguments.tabsOne);

      //  if (len(trim(arguments.tabsTwo))) {
      //    thisTitle = thisTitle & " &ndash; " & arguments.tabsTwo;

      //    if (len(trim(arguments.tabsThr))) {
      //      thisTitle = thisTitle & " &ndash; " & arguments.tabsThr;
      //    }
      //  }
      //}

      if (len(trim(thisTitle)) GT 0 AND isDefined("url.fid")) {
        thisTitle = thisTitle & " &ndash; " & url.fid;
      }

      return thisTitle;
    </cfscript>
  </cffunction>

  <!--- getCatchOutput() --->
  <cffunction name="getCatchOutput" access="public" output="true" returntype="any">
    <cfargument name="catchStruct" required="yes" />
    <cfset var dataMSG = "" />

    <cfsavecontent variable="dataMSG"><cfoutput>
Message: #arguments.catchStruct.message#, Details: #arguments.catchStruct.Detail#<cfif structKeyExists(arguments.catchStruct, "NativeErrorCode") AND trim(arguments.catchStruct.NativeErrorCode) NEQ "">, 
Native Error: #arguments.catchStruct.NativeErrorCode#</cfif>
    </cfoutput></cfsavecontent>

    <cfreturn dataMSG />
  </cffunction>

  <!--- getHost() --->
  <cffunction name="getHost" access="public" output="true" returntype="any">
    <cfargument name="webServerName" default="" />

    <cfset var webServer = "" />

    <cfswitch expression="#arguments.webservername#">
      <cfcase value="igemsdev.epa.gov">
        <cfset webServer = "&nbsp;(DEV)" />
      </cfcase>

      <cfcase value="127.0.0.1,localhost">
        <cfset webServer = "&nbsp;(LOCAL)" />
      </cfcase>

      <cfdefaultcase>
        <cfset webServer = "&nbsp;(TIGER Web)" />
      </cfdefaultcase>
    </cfswitch>

    <cfreturn webServer />
  </cffunction>

  <!--- getSessionVar() --->
  <cffunction name="getSessionVar" access="remote" output="false" returntype="string">
    <cfargument name="name" type="string" required="true" />
    <cfreturn session[arguments.name] />
  </cffunction>

  <!--- getStringPath() --->
  <cffunction access="public" name="getStringPath" returntype="string" output="no">
    <cfargument name="thisKey" required="yes" type="string" />
    <cfargument name="thisSub" required="no"  type="string" default="" />

    <cfscript>
      var structPointer = evaluate("session.active" & left(request.subArea, 3) & arguments.thisSub & "Tabs_" & request.formattedFID);
      return structPointer[arguments.thisKey];
    </cfscript>
  </cffunction>

  <!--- resetStruct() --->
  <cffunction name="deleteForm" returntype="string" output="no">
    <cfargument name="thisForm" required="no"  type="struct" default="" />
    <cfset var message = "">
	<cfloop list="#arguments.thisForm.fieldnames#" index="fld">
		<cfif StructKeyExists(arguments.thisForm,fld)>
			<cfset StructDelete(arguments.thisForm,fld)>
		</cfif>	
		<cfset StructDelete(arguments.thisForm,"fieldnames")>
		<cfset message = "Deleted">
	</cfloop>   
	<cfreturn message />
  </cffunction>

  <!--- getSuffixes() --->
  <cffunction name="getSuffixes" returntype="query">
    <cfset var qry = queryNew("suffix") />
    <cfset queryAddRow(qry, 5) />
    <cfset querySetCell(qry, "suffix", "I",   1) />
    <cfset querySetCell(qry, "suffix", "II",  2) />
    <cfset querySetCell(qry, "suffix", "III", 3) />
    <cfset querySetCell(qry, "suffix", "Jr.", 4) />
    <cfset querySetCell(qry, "suffix", "Sr.", 5) />
    <cfreturn qry />
  </cffunction>

  <!--- getFromTo() --->
  <cffunction name="getFromTo" returntype="query">
    <cfset var qry = queryNew("value, text") />
    <cfset queryAddRow(qry, 2) />
    <cfset querySetCell(qry, "value", "FROM", 1) />
    <cfset querySetCell(qry, "text",  "FROM", 1) />
    <cfset querySetCell(qry, "value", "TO",   2) />
    <cfset querySetCell(qry, "text",  "TO",   2) />
    <cfreturn qry />
  </cffunction>

  <!--- getYesNo() --->
  <cffunction name="getYesNo" returntype="query">
    <cfset var qry = queryNew("value, text") />
    <cfset queryAddRow(qry, 2) />
    <cfset querySetCell(qry, "value", "Y",   1) />
    <cfset querySetCell(qry, "text",  "Yes", 1) />
    <cfset querySetCell(qry, "value", "N",   2) />
    <cfset querySetCell(qry, "text",  "No",  2) />
    <cfreturn qry />
  </cffunction>

  <!--- getActive() --->
  <cffunction name="getActive" returntype="query">
    <cfset var qryActive = queryNew("CODE, DESCRIPTION") />
    <cfset queryAddRow(qryActive, 2) />
    <cfset querySetCell(qryActive, "CODE", "ACTV",   1) />
    <cfset querySetCell(qryActive, "DESCRIPTION",  "Active", 1) />
    <cfset querySetCell(qryActive, "CODE", "END",    2) />
    <cfset querySetCell(qryActive, "DESCRIPTION",  "Ended",  2) />
    <cfreturn qryActive />
  </cffunction>


  <!--- getYesNoStatus() --->
  <cffunction name="getYesNoStatus" returntype="query">
    <cfset var qry = queryNew("Code, Description") />
    <cfset queryAddRow(qry, 2) />
    <cfset querySetCell(qry, "Code", "1",   1) />
    <cfset querySetCell(qry, "Description",  "Yes", 1) />
    <cfset querySetCell(qry, "Code", "0",  2) />
    <cfset querySetCell(qry, "Description",  "No",  2) />
    <cfreturn qry />
  </cffunction>

  <!--- getTimeofDay() --->
  <cffunction name="getTimeofDay" returntype="query">
    <cfset var qryTimeofDay = queryNew("value, text") />
    <cfset queryAddRow(qryTimeofDay, 2) />
    <cfset querySetCell(qryTimeofDay, "value", "AM", 1) />
    <cfset querySetCell(qryTimeofDay, "text",  "AM", 1) />
    <cfset querySetCell(qryTimeofDay, "value", "PM", 2) />
    <cfset querySetCell(qryTimeofDay, "text",  "PM", 2) />
    <cfreturn qryTimeofDay />
  </cffunction>

  <!--- initCap() --->
  <cffunction access="public" name="initCap" returntype="string" output="no"> 
    <cfargument name="stringIn" required="yes" type="string">

    <cfscript>
      var capStr = REReplace( arguments.stringIn, "([a-z]{1})", "\U\1", "ONE" );
      return capStr;
    </cfscript>
  </cffunction>
  
  <!--- returnNull() --->
  <cffunction name="returnNull" access="public" returntype="any" output="no"> 
    <cfargument name="stringIn" required="yes" type="string">
    <cfset var returnStr = "">
    <cfif Len(Trim(arguments.stringIn)) GT 0>
    	<cfset returnStr = arguments.stringIn>
	<cfelse>
		<cfset returnStr = "null">
	</cfif>
	<cfreturn returnStr />
  </cffunction>

  <!--- pageToLoad() --->
  <cffunction name="pageToLoad" access="remote" returntype="string">
    <cfargument name="thisPage" required="yes" type="string" />

    <cfset var pageContent = "" />

    <cfsavecontent variable="pageContent"><div style="margin-top:5px; margin-left:5px;">
      <cfinclude template="/#request.dirRoot#/#arguments.thisPage#" />
    </div></cfsavecontent>

    <cfreturn pageContent />
  </cffunction>

  <!--- resetActiveTabs() --->
  <cffunction name="resetActiveTabs" access="public" returntype="struct" output="false">
    <cfscript>
      var tempTabOne = "";
      var tempTabTwo = "";
      var tempTabThr = "";
      var structPointer = structNew();

      for (i=1; i<=listLen(this.mainTabs); i++) {
        tempTabOne = formatPath(listGetAt(this.mainTabs, i));
        structPointer[tempTabOne] = tempTabOne;

        if (isDefined("this." & tempTabOne & "Tabs")) {
          tempTabTwo = formatPath(listFirst(evaluate("this." & tempTabOne & "Tabs")));
          structPointer[tempTabOne] = structPointer[tempTabOne] & "/" & tempTabTwo;

          if (isDefined("this." & tempTabOne & "SubTabs_1")) {
            tempTabThr = formatPath(listFirst(evaluate("this." & tempTabOne & "SubTabs_1")));
            structPointer[tempTabOne] = structPointer[tempTabOne] & "/" & tempTabThr;
          }
        }
      }

      structPointer["default"] = structPointer[formatPath(listFirst(this.mainTabs))];
      return structPointer;
    </cfscript>
  </cffunction>

  <!--- resetActiveSubTabs() --->
  <cffunction name="resetActiveSubTabs" access="public" returntype="struct" output="false">
    <cfscript>
      var tempTabOne = "";
      var structPointer = structNew();

      for (i=1; i<=listLen(this.mainTabs); i++) {
        tempTabOne = formatPath(listGetAt(this.mainTabs, i));

        if (isDefined("this." & tempTabOne & "Tabs")) {
          for (j=1; j<=listLen(evaluate("this." & tempTabOne & "Tabs")); j++) {
            if (isDefined("this." & tempTabOne & "SubTabs_" & j)) {
              structPointer[tempTabOne & "_" & formatPath(listGetAt(evaluate("this." & tempTabOne & "Tabs"), j))] = formatPath(listFirst(evaluate("this." & tempTabOne & "SubTabs_" & j)));
            }
          }
        }
      }

      return structPointer;
    </cfscript>
  </cffunction>

  <!--- setSessionVar() --->
  <cffunction name="setSessionVar" access="remote" output="false" returntype="boolean">
    <cfargument name="name" type="string" required="true" />
    <cfargument name="value" type="string" required="true" />

    <cfset session[arguments.name] = arguments.value />

    <cfreturn true />
  </cffunction>

  <!--- setStringPath() --->
  <cffunction access="public" name="setStringPath" returntype="void" output="no">
    <cfargument name="thisKey"  required="yes" type="string" />
    <cfargument name="thisPath" required="yes" type="string" />
    <cfargument name="thisSub"  required="no"  type="string" default="" />

    <cfscript>
      var structPointer = evaluate("session.active" & left(request.subArea, 3) & arguments.thisSub & "Tabs_" & request.formattedFID);
      structPointer[arguments.thisKey] = arguments.thisPath;
    </cfscript>
  </cffunction>

	<!--- // CountryList() --->
	<cffunction name="CountryList" access="remote" returntype="any">	  
	  <cfset var qryCountryList = "">
	  <cfquery name="qryCountryList" datasource="#application.starsdb#">
		  SELECT *
		  FROM #application.DB#.IV_REF_COUNTRY
		  ORDER BY SORT_ORDER ASC,DESCRIPTION ASC
	  </cfquery> 
	  <cfreturn qryCountryList />
	</cffunction>
	
	<!--- // StateList() --->
	<cffunction name="StateList" access="remote" returntype="any">	  
	  
	  <cfset var qryStateList = "">	  
	  
	  <cfquery name="qryStateList" datasource="#application.starsdb#">
		  SELECT * 
		  FROM #application.DB#.IV_REF_STATES 
		  WHERE valid_flag = <cfqueryparam value="Y"/>
		  ORDER BY description
	  </cfquery>
	  
	  <cfreturn qryStateList />
	</cffunction>
	
	<!--- getStateList() --->
	<cffunction name="getStateList" access="remote" returntype="any">	  
	  
	  <cfset var qryStateList = "">	  	
	  
	  <cfquery name="qryStateList" datasource="#application.starsdb#">
		  SELECT code,
		  			 DECODE(description,'Guam','Guam (C)','Commonwealth of the Northern Marina Islands', 'Northern Marianas (C)',DESCRIPTION) AS DESCRIPTION, 
		  			 region_code
		  FROM #application.DB#.IV_REF_STATES 
		  WHERE valid_flag = <cfqueryparam value="Y"/>
		  ORDER BY description
	  </cfquery>
		  
	  <cfreturn qryStateList />
	</cffunction>
	
	<!--- // getZip() --->
	<cffunction name="getZip" access="remote" returntype="any">	  
	  <cfargument name="zip_code" type="string" default="" required="yes" />
	  
	  <cfset var Zip = "">	  
		
		<cfquery name="Zip" datasource="#application.starsdb#">
			SELECT * 
			FROM #application.igemsdb#.zipcodes
			WHERE zip_code = <cfqueryparam value="#Left(arguments.zip_code, 5)#"/>
		</cfquery>
		
		<cfcontent reset="yes"/>
	  <cfreturn Zip />
	</cffunction>

	<!--- // getCityStateFromZip() --->
	<cffunction name="getCityStateFromZip" access="remote" returntype="any">	  
	  <cfargument name="zip_code" type="string" default="" required="yes" />
	  
	  <cfset var qCityStateFromZip = "">	  
		
		<cfquery name="qCityStateFromZip" datasource="#application.starsdb#">
			SELECT 
				Z.CITY,
				Z.STATE,
				S.DESCRIPTION
			FROM 
				#application.igemsdb#.ZIPCODES Z,
				IGDBA.STATES S
			WHERE
				Z.STATE = S.CODE
			AND S.VALID_FLAG = <cfqueryparam value="Y"/>
			AND Z.ZIP_CODE = <cfqueryparam value="#Left(arguments.zip_code, 5)#"/> 
		</cfquery>
		
		<cfscript>
		sLocation.CITY = qCityStateFromZip.CITY;
		sLocation.STATE = qCityStateFromZip.STATE;
		sLocation.STATE_DESC = qCityStateFromZip.DESCRIPTION;
		</cfscript>

		<cfcontent reset="yes"/>
	  <cfreturn sLocation />
	</cffunction>
	
	<!--- // getState() --->
	<cffunction name="getState" access="remote" returntype="any">	  
	  <cfargument name="state" type="string" default="" required="yes" />
	  
	  <cfset var qState = "">	  
		
		<cfquery name="qState" datasource="#application.starsdb#">
			
			SELECT DISTINCT 
				S.DESCRIPTION
			FROM 
				IGDBA.STATES S
			WHERE
				S.VALID_FLAG = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
			AND S.CODE = <cfqueryparam value="#arguments.state#"/>
			ORDER BY S.DESCRIPTION
			
		</cfquery>
	  
	  <cfreturn qState />
	</cffunction>

	<!--- // getCityStateFromState() --->
	<cffunction name="getCityStateFromState" access="remote" returntype="any">	  
	  <cfargument name="state" type="string" default="" required="yes" />
	  
	  <cfset var qCityStateFromState = "">	  
		
		<cfquery name="qCityStateFromState" datasource="#application.starsdb#">			
			
			SELECT DISTINCT 
				Z.CITY
			FROM 
				IGDBA.ZIPCODES Z
			WHERE
				Z.STATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#state#">
			ORDER BY Z.CITY

		</cfquery>		

		<cfcontent reset="yes"/>
	  <cfreturn qCityStateFromState />
	</cffunction>

	<!--- // getZipFromCityState() --->
	<cffunction name="getZipFromCityState" access="remote" returntype="any">	  
	  <cfargument name="state" type="string" default="" required="yes" />
	  <cfargument name="city" type="string" default="" required="yes" />

	  <cfset var qZipFromCityState = "">	  
		
		<cfquery name="qZipFromCityState" datasource="#application.starsdb#">
			
			SELECT DISTINCT 
				Z.ZIP_CODE,
				Z.CITY,
				Z.STATE
			FROM 
				IGDBA.ZIPCODES Z,
				IGDBA.STATES S
			WHERE
				Z.STATE = S.CODE
			
			AND Z.STATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.state#">
			AND Z.CITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.city#">
			AND S.VALID_FLAG = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
			ORDER BY ZIP_CODE

		</cfquery>		

		<cfcontent reset="yes"/>
	  <cfreturn qZipFromCityState />
	</cffunction>

	<!--- // getLocality --->
	<cffunction name="getLocality" access="remote" returntype="any">	  
	  
	  <cfset var qLocality = "">	  
		
		<cfquery name="qLocality" datasource="#application.starsdb#">
			SELECT 
				L.CODE, 
				L.DESCRIPTION, 
				L.SEQ
			FROM 
				#application.DB#.IV_CASE_LOCALITY L
			ORDER BY L.SEQ
		</cfquery>
	  
	  <cfreturn qLocality />
	</cffunction>

	<!--- // getResourceCenters --->
	<cffunction name="getResourceCenters" access="remote" returntype="any">	  
	  
	  <cfset var qResourceCenters = "">	  
		
		<cfquery name="qResourceCenters" datasource="#application.starsdb#">
			SELECT 
				DISTINCT RC.OIG_RESOURCE_CENTER OI_RESOURCE_CENTER
			FROM 
				igdba.V_OIG_RESOURCE_CENTERS RC
			WHERE 
				RC.OIG_RESOURCE_CENTER IS NOT NULL
			ORDER BY RC.OIG_RESOURCE_CENTER 
		</cfquery>
	  
	  <cfreturn qResourceCenters />
	</cffunction>
	
	<!--- // getDivisions --->
	<cffunction name="getDivisions" access="remote" returntype="any">	  
	  
	  <cfset var qDivisions = "">	  
		
		<cfquery name="qDivisions" datasource="#application.starsdb#">
			SELECT 
			   D.DIVISION_ID, 
			   D.DIVISION_CODE, 
			   D.DIVISION_NAME, 
			   D.AIG_OFFICE_CODE, 
			   D.AIG_CODE, 
			   D.DIRECTORATE_ID, 
			   D.MANAGER, 
			   D.EFF_DATE
			FROM IGDBA.DIVISIONS D
			WHERE    
				D.VALID_FLG = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
			AND D.AIG_CODE IN (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="1,2,3,5,6,8,10">)
			ORDER BY D.DIVISION_NAME
		</cfquery>
	  
	  <cfreturn qDivisions />
	</cffunction>
	
	<!--- // getDivisionsOI --->
	<cffunction name="getDivisionsOI" access="remote" returntype="any">	  
	  
	  <cfset var qDivisions = "">	  
		
		<cfquery name="qDivisions" datasource="#application.starsdb#">	
			SELECT DISTINCT                
				EMP.DIVISION_CODE CODE,
				EMP.TEAM_NAME DESCRIPTION    
			FROM   
				IGDBAP.V_EMPLOYEES EMP
			WHERE
				EMP.AIG_ID IN (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="1,2,3,5,6,8,10">)
			ORDER BY TEAM_NAME	
		</cfquery>
	  
	  <cfreturn qDivisions />
	</cffunction>
		
	<!--- // getDivisionsLocations --->
	<cffunction name="getDivisionsLocations" access="remote" returntype="any">	  
	  <cfargument name="AIG_ID" default="5" hint="AIG_ID from EMP_LOCATION">
	  <cfset var qDivisionsLocations = "">	  
		
		<cfquery name="qDivisionsLocations" datasource="#application.starsdb#">
			SELECT DISTINCT
				EL.LOCATION_NAME,
				EL.LOCATION_ID,
				EL.LOCATION_MAIL_ADDR1,
				EL.LOCATION_ID, 
				EL.LOCATION_NAME, 
				EL.LOCATION_CITY,
				EL.LOCATION_STATE_CODE, 
				EL.LOCATION_MAIL_ADDR1, 
				EL.LOCATION_MAIL_ADDR2,
				EL.LOCATION_MAIL_ADDR3, 
				EL.LOCATION_MAILCODE, 
				EL.LOCATION_MAIL_ZIPCODE,
				EL.LOCATION_PHYSICAL_ADDR1, 
				EL.LOCATION_PHYSICAL_ADDR2, 
				EL.LOCATION_PHYSICAL_ADDR3,
				EL.LOCATION_PHYSICAL_ZIPCODE, 
				EL.LOCATION_CODE, 
				EL.OI_RESOURCE_CENTER,
				EMP.DIVISION_CODE,
				EMP.TEAM_NAME    
			FROM   IGDBAP.V_EMPLOYEES EMP, 
				   IGDBA.EMP_LOCATION EL
			WHERE   
				EMP.LOCATION_CODE = EL.LOCATION_CODE
			AND EL.VALID_FLG = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
			AND EMP.AIG_ID IN (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#Arguments.AIG_ID#">)
		</cfquery>
	  
	  <cfreturn qDivisionsLocations />
	</cffunction>

	<!--- // getRegionByStateCode --->
	<cffunction name="getRegionByStateCode" access="remote" returntype="any">
		<cfargument name="sstate" default="" required="true" hint="State abbreviation">
	  
	  <cfset var qRegion = "">	  
		
		<cfquery name="qRegion" datasource="#application.starsdb#">	
			SELECT DISTINCT
				R.CODE,
				R.DESCRIPTION AS REGION_DESC    
			FROM
				IGDBAP.IV_STATES S,
				IGDBAP.IV_REGIONS R
			WHERE
				S.REGION_CODE = R.CODE
			AND S.CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.sstate#">
		</cfquery>
	  
	  <cfreturn qRegion />
	</cffunction>	
	
	<!--- // getFormattedTimestamp() --->
     <cffunction name="getFormattedTimestamp" access="remote" returntype="any">      
      <cfargument name="inDate" default="" required="yes" hint="mm/dd/yyyy" />
      <cfargument name="inHour" default="" required="yes" hint="00-23" />
      <cfargument name="inMinute" default="" required="yes" hint="1-59" />
      <cfargument name="inMeridiem" default="" required="yes" hint="AM or PM" />
 
      	  <cfscript>         
         
		  var FormattedTimestamp = ''; 
           
          //End Date/Time
          if(Arguments.inMeridiem EQ "PM" AND Arguments.inHour LT 12){
                    Arguments.thisHour = Arguments.inHour + 12;
          }else{
               // for GMT, 12 must be set to 00 for AM
               if(Arguments.inHour EQ 12){
                    Arguments.thisHour = "00";              
               }else{
                    Arguments.thisHour = Arguments.inHour;
                    }
               }
         
          Arguments.FormattedTime = Arguments.thisHour & ':' & Arguments.inMinute & ':00';
		  FormattedTimestamp = createODBCDateTime(dateFormat(Arguments.inDate,'mm/dd/yyyy') & ' ' & timeFormat(ARGUMENTS.FormattedTime,'HH:mm:ss'));
         
          </cfscript>
      	<cfreturn FormattedTimestamp />
     </cffunction>
	 
	 <!--- queryColumnsToStruct --->
	 <cffunction name="queryColumnsToStruct" access="public" returntype="any"> 
	 	<cfargument name="objectQuery" type="query" required="yes" />
		<cfargument name="keyColumn" type="string" required="yes" />
		<cfset var returnStruct = StructNew() />
		<cfset var valueColumn = arguments.keyColumn />
		<cfset var testQuery = arguments.objectQuery />		
			<cfloop list="#valueColumn#" index="colName">
				<cfset StructInsert(returnStruct,"#colName#",Evaluate("testQuery.#colName#"))>
			</cfloop>			
		 <cfreturn returnStruct />
	</cffunction>
	
	<!--- queryColumnsToArray --->
	<cffunction name="queryColumnsToArray" access="public" returntype="any"> 
	 	<cfargument name="objectQuery" type="query" required="yes" />
		<cfargument name="keyColumn" type="string" required="yes" />
		<cfset var returnArray = ArrayNew(1) />
		<cfset var valueColumn = arguments.keyColumn />
		<cfset var testQuery = arguments.objectQuery />	
		<cfset var keyVal = "">
		<cfset var ax = 0>
		<cfloop query="testQuery">
			<cfset ax = ax + 1>	
			<cfset stepStruct = structNew()>		
			<cfloop list="#valueColumn#" index="colName">
				<cfset stepStruct["#colName#"] = Evaluate("testQuery.#colName#")>
			</cfloop>
			<cfset returnArray[ax] = stepStruct>
		</cfloop>					
		 <cfreturn returnArray />
	</cffunction>
	
	<!--- CapFirst --->
	<cffunction name="CapFirst" returntype="string" output="false">
		<cfargument name="str" type="string" required="true" />	
		<cfset var newstr = "" />
		<cfset var word = "" />
		<cfset var separator = "" />		
		<cfloop index="word" list="#LCase(arguments.str)#" delimiters=" ">
			<cfset newstr = newstr & separator & UCase(left(word,1)) />
			<cfif len(word) gt 1>
				<cfset newstr = newstr & right(word,len(word)-1) />
			</cfif>
			<cfset separator = " " />
		</cfloop>	
		<cfreturn newstr />
	</cffunction>
	
	<!--- NullValueReplace() --->
	<cffunction name="NullValueReplace" returntype="string" output="false">
		<cfargument name="str" type="string" required="true" />	
		<cfset var newstr = "" />
			<cfif Len(Trim(arguments.str)) IS 0>
				<cfset newstr = 0>
			<cfelse>
				<cfset newstr = arguments.str>
			</cfif>		
		<cfreturn newstr />
	</cffunction>

	<!--- attributes scope functions --->
	<!--- AttributeEquals --->
	<cffunction name="AttributeEquals" output="false">
		<cfargument name="k" type="string" required="true">
		<cfargument name="v" type="any" required="true">
		<cfreturn StructKeyExists(attributes, k) AND attributes[k] eq v>
	</cffunction>
	
	<!--- AttributeEmpty --->
	<cffunction name="AttributeEmpty" output="false">
		<cfargument name="k" type="string" required="true">
		<cfreturn StructKeyExists(attributes, k) AND attributes[k] eq "">
	</cffunction>
	
	<!--- AttributeNotEmpty --->
	<cffunction name="AttributeNotEmpty" output="false">
		<cfargument name="k" type="string" required="true">
		<cfreturn StructKeyExists(attributes, k) AND attributes[k] neq "">
	</cffunction>
	
	<!--- generic scope/struct functions --->
	<!--- StructKeyEquals --->
	<cffunction name="StructKeyEquals" output="false">
		<cfargument name="st" type="struct" required="true">
		<cfargument name="k" type="string" required="true">
		<cfargument name="v" type="any" required="true">
		<cfreturn StructKeyExists(st, k) AND st[k] eq v>
	</cffunction>
	
	<!--- array functions --->
	<!--- ArrayKeyToList --->
	<cffunction name="ArrayKeyToList" output="false">
		<cfargument name="a" type="array" required="true">
		<cfargument name="k" type="string" required="true">
		<cfset l = "">
		<cfloop index="i" from="1" to="#arrayLen(a)#">
			<cfset l = ListAppend(l, a[i][k])>
		</cfloop>
		<cfreturn l>
	</cffunction>
	
	<!--- other --->
	<!--- SeparateCaps --->
	<cffunction name="SeparateCaps" output="false">
		<cfargument name="s" type="string" required="true">
		<cfreturn Trim(REReplace(s,"(fld)*(^.|[A-Z0-9])"," \u\2","all"))>
	</cffunction>
	
	<!--- TrueFalseFormat --->
	<cffunction name="TrueFalseFormat" output="false">
		<cfargument name="b" type="any" required="true">
		<cfif YesNoFormat(b)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<!--- tag name functions --->
	<!--- getMyParentTag --->
	<cffunction name="getMyParentTag" output="false">
		<cfargument name="list" type="string" required="true">
		<cfreturn ListGetAt(REReplace(list, "(CF[A-Z]+)", "", "all"), 2)>
	</cffunction>

	<!--- getThisTagName --->
	<cffunction name="getThisTagName" output="false">
		<cfreturn Replace(ListGetAt(getBaseTagList(), 1), "CF_", "")>
	</cffunction>
	
	<!--- coldext var attribute function --->
	<!--- validateVarAttribute --->
	<cffunction name="validateVarAttribute" returntype="string" output="false">
		<cfargument name="parentTag" type="string" required="true">
		<cfif parentTag eq "CF_ONREADY">
			<cfif AttributeEmpty("var")>
				<cfreturn getThisTagName() & Int(Rand()*1000)>
			<cfelse>
				<cfreturn attributes.var>
			</cfif>
		<cfelse>
			<cfif AttributeNotEmpty("var") OR AttributeNotEmpty("renderTo") OR AttributeNotEmpty("renderToJS")>
				<cfthrow message="Attribute validation error in #getThisTagName()# tag: 'var', 'renderTo' and 'renderToJS' are not valid here">
			</cfif>
			<cfreturn "">
		</cfif>
	</cffunction>

	<!--- getReplaceWordText() --->
	<cffunction name="getReplaceWordText" returntype="any" output="false">
		<cfargument name="filePath" type="string" required="true" />
		<cfargument name="newFilePath" type="string" required="false" />		
		<cfargument name="case_number" default=" " type="string" required="false" />
		<cfargument name="case_title" default=" " type="string" required="false" />	
		<cfargument name="submitter" default=" " type="string" required="false" />	
		<cfargument name="reviewer" default=" " type="string" required="false" />	
		<cfargument name="approver" default="" type="string" required="false" />
		<cfargument name="date_submitted" default=" " type="string" required="false" />	
		<cfargument name="date_reviewed" default=" " type="string" required="false" />	
		<cfargument name="date_approved" default="" type="string" required="false" />	

		<cflock name="ObjectConnectionCreation" type="exclusive" timeout="20"> 
		
		<!--- Try to connect to the Word application object --->
		<CFTRY>
			<!--- If it exists, connect to it --->
			<CFOBJECT
				ACTION="CONNECT"
				CLASS="Word.Application"
				NAME="objWord"
				TYPE="COM">
		  <CFCATCH>
			<!--- The object doesn't exist, so create it --->
			<CFOBJECT
				ACTION="CREATE"
				CLASS="Word.Application"
				NAME="objWord"
				TYPE="COM">
		  </CFCATCH>
		</CFTRY>
		
		<CFTRY>
		
			<CFSCRIPT>
			
			/*Define text placeholders to be replaced*/
			caseNumberPlaceHolder = '<case_number>';
			caseTitlePlaceHolder = '<case_title>';
			submitterPlaceHolder = '<submitter>';			
			reviewerPlaceHolder = '<reviewer>';			
			approverPlaceHolder = '<approver>';
			
			dateSubmittedPlaceHolder = '<date_submitted>';
			dateReviewedPlaceHolder = '<date_reviewed>';
			dateApprovedPlaceHolder = '<date_approved>';
			
			/*Define Replace type*/
			wdReplaceAll = 2;
			
			/*Open word*/
			objWord.Visible = FALSE;
			/*Open document*/
			objDoc = objWord.Documents.Open('#Arguments.filePath#');
			/* set up selection parameters */
			objSelection = objWord.Selection();
			
			objSelection.Find.ClearFormatting();
			/*objSelection.Find.Text = "test";
			objSelection.Find.Forward = TRUE;*/
			
			/* set replace value */
			objSelection.Find.Replacement.ClearFormatting();	  
			/*objSelection.Find.Replacement.Text = "text I want in my word doc";*/
			
			/* execute search and replace */
			objSelection.Find.Execute(caseNumberPlaceHolder,1,1,0,0,0,1,1,1,Arguments.case_number,wdReplaceAll);
			objSelection.Find.Execute(caseTitlePlaceHolder,1,1,0,0,0,1,1,1,Arguments.case_title,wdReplaceAll);
			objSelection.Find.Execute(submitterPlaceHolder,1,1,0,0,0,1,1,1,Arguments.submitter,wdReplaceAll);
			objSelection.Find.Execute(reviewerPlaceHolder,1,1,0,0,0,1,1,1,Arguments.reviewer,wdReplaceAll);
			objSelection.Find.Execute(approverPlaceHolder,1,1,0,0,0,1,1,1,Arguments.approver,wdReplaceAll);
			
			objSelection.Find.Execute(dateSubmittedPlaceHolder,1,1,0,0,0,1,1,1,Arguments.date_submitted,wdReplaceAll);
			objSelection.Find.Execute(dateReviewedPlaceHolder,1,1,0,0,0,1,1,1,Arguments.date_reviewed,wdReplaceAll);
			objSelection.Find.Execute(dateApprovedPlaceHolder,1,1,0,0,0,1,1,1,Arguments.date_approved,wdReplaceAll);
												
			/* Save the document to a location */
			if( len(trim(Arguments.newFilePath)) GT 0 )
			{
				objDoc.SaveAs('#Arguments.newFilePath#');
			}
			else
			{
				objDoc.SaveAs('#Arguments.filePath#');
			}
			
			/* Close the document */
			objDoc.Close();
			
			/* Quit Word - Call twice to ensure winword.exe process removal */						
			objWord.Quit();
			objWord.Quit();
			
			sStatus.statusText = "Success";
			sStatus.arguments = duplicate(Arguments);
			</CFSCRIPT>
						
			<cfcatch>
				<cfscript>
				sStatus.statusText = "Error";
				sStatus.errorText = cfcatch.Message & ' - ' & cfcatch.Detail;
				sStatus.arguments = duplicate(Arguments);
				</cfscript>
			</cfcatch>
		
		</CFTRY>
		</cflock>
		
		<cfreturn sStatus>				
	</cffunction>
	
	<!--- structToJSON --->
	<cffunction name="structToJSON" returnType="string" access="public" output="false" hint="Converts a struct into JSON.">
		<cfargument name="data" type="struct" required="true" />
		<cfargument name="rootelement" type="string" required="true" />
		<cfset var s = createObject('java','java.lang.StringBuffer').init("") />
		<cfset var keys = structKeyList(arguments.data) />
		<cfset var key = "" />
		<cfset var d1="" />
		<cfset var d2="," />
		<cfset s.append('{"#arguments.rootelement#":[{') />
		<cfloop index="key" list="#keys#">
			<cfset s.append('#d1#"#key#":"#safeText(arguments.data[key])#"') />
			<cfset d1=d2 />
		</cfloop>
		<cfset s.append("}]}") />
		<cfreturn s.toString() />
	</cffunction>
	
	<!--- RomanNumeralsFormatByNumber --->
	<cffunction name="RomanNumeralsFormatByNumber" returntype="string" displayname="Convert to roman numerals">
		<cfargument name="number" type="numeric" required="yes" displayname="The required number to pass in">
	 
		<cfscript>
		
		/*from http://www.cflib.org/udf/RomanFormat*/

		/* declare variables */
		var RomOut = ""; // string to be returned
		var RomList = "M,D,C,L,X,V,I"; // list of roman numerals
		var DecList = "1000,500,100,50,10,5,1"; // list of equivalents to roman numerals
		
		/* variables used in looping */
		var i = 1;
		var j = 1;
		
		/* implement the subtraction rule by converting the in strings to the out strings later */
		var RomReplaceInList = "DCCCC,CCCC,LXXXX,XXXX,VIIII,IIII";
		var RomReplaceOutList = "CM,CD,XC,XL,IX,IV";
		
		/* convert lists to arrays for easier access */
		var RomArray = ListToArray(RomList);
		var DecArray = ListToArray(DecList);
		var RomReplaceInArray = ListToArray(RomReplaceInList);
		var RomReplaceOutArray = ListToArray(RomReplaceOutList);
		
		/* hack off the decimal part of the incoming argument */
		DecIn = int(Arguments.number);
		
		/* generate the raw Roman string */
		i = 1;
		while (DecIn GT 0) {
			if (DecIn - DecArray[i] GTE 0) {
				DecIn = DecIn - DecArray[i];
				RomOut = RomOut & RomArray[i];
				} else {
				i = i + 1;
			}
		}
		
		/* apply the subtraction rule to the raw Roman string */
		for (j = 1; j LTE ArrayLen(RomReplaceInArray); j = j + 1) {
			RomOut = Replace(RomOut, RomReplaceInArray[j], RomReplaceOutArray[j]);
		}
		
		return RomOut;
			
		</cfscript>
		
	</cffunction>

	<!--- // HTMLConvert() --->
	<cffunction name="HTMLConvert" access="remote" returntype="string" output="no" hint="removes html formatting from given string variable">		
		<cfargument name="string_to_convert" required="yes" >
		<cfargument name="conversionType" default="HTML2RTF" required="yes" hint="HTML2RTF = convert html to RTF; HTML2PLAIN = convert HTML to Plain text(ASCI)">
		
		<cfscript>
		
		var _text = ARGUMENTS.string_to_convert;
		
		/*
		* The .*? section tells the regular expression that we're looking for anything at all (.), as much as necessary (*), but no more than we need to find the first > (?)
		* In a regular expression, parentheses are used for (among other things) storing a string in a backreference. You can think of a backreference as a variable internal to a regex call.
		* So instead of replacing the substring matched by our regular expression with an empty string, we will replace it with our backreference. Backreferences are numbered from one -- i.e. \1.
		 
		Example string: myText = "<span style="text-decoration: underline; font-weight: bold;">Department of Interior (DOI)</span>"
		Example RegEx:	REReplaceNoCase(myText,'<span style=\"text-decoration: underline; font-weight: bold;\">(.*?)<\/span>','<u><b> \1  <\/b><\/u>','ALL')
		
			   Output:  <u><b>Department of Interior (DOI)</u></b>		
		*/
	
		if( Arguments.conversionType eq "HTML2RTF" ){
						
		//Conversion of HTML to RTF		
		_text = REReplaceNoCase(_text,'<b style=""><u><span style="font-size: 12pt; font-family: ;Times New Roman;;">(.*?)</span></u></b>','{\b\\ul \1\\ul0\b0}','ALL');            
		_text = REReplaceNoCase(_text,'<span style="font-style: italic; text-decoration: underline; font-weight: bold;">(.*?)</span>','{\i\\ul\b \1\b0\\ul0\i0} ','ALL');
		_text = REReplaceNoCase(_text,'<span style="font-style: italic; font-weight: bold;">(.*?)</span>','{\i\b \1  \b0\i0}','ALL');
		_text = REReplaceNoCase(_text,'<span style="font-weight: bold;">(.*?)</span>','{\b \1 \b0}','ALL');
		_text = REReplaceNoCase(_text,'<span style="font-style: italic;">(.*?)</span>','{\i \1 \i0}','ALL');
		_text = REReplaceNoCase(_text,'<span style="text-decoration: underline; font-style: italic;">(.*?)</span>','{\\ul\i \1 \i0\\ul0}','ALL');
		_text = REReplaceNoCase(_text,'<span lang=EN>(.*?)</span>','\1','ALL');
		_text = REReplaceNoCase(_text,'<SPAN lang=EN>(.*?)</SPAN>','\1','ALL');            
		_text = REReplaceNoCase(_text,'<span (.*?)>(.*?)</span>','\2','ALL');
		_text = REReplaceNoCase(_text,'<SPAN (.*?)>(.*?)</SPAN>','\2','ALL');
		_text = REReplaceNoCase(_text,'<i>(.*?)</i>','{\i \1 \i0}','ALL');
		_text = REReplaceNoCase(_text,'<b><u>(.*?)</u></b>','{\b \\ul \1\\ul0\b0}','ALL');
		_text = REReplaceNoCase(_text,'<B><U>(.*?)</U></B>','{\b\ \ul \1 \\ul0\b0}','ALL');
		_text = REReplaceNoCase(_text,'<B><U>(.*?)\n<P align=left>(.*?)</U></B>','{\ql\b \\ul \2\\ul0\b0}','ALL');            
		_text = REReplaceNoCase(_text,'<B><U><P align=left>(.*?)</U></B>(.*?)<BR></P>','{\ql\b \\ul \1\\ul0\b0 \2}','ALL');            
		_text = REReplaceNoCase(_text,'<b><u>(.*?)\n<p align=left>(.*?)</u></b>','{\ql\b \\ul \2\\ul0\b0}','ALL');
		_text = REReplaceNoCase(_text,'<P align=left>(.*?)</U></B>(.*?)</P>','{\ql\b \\ul \1\\ul0\b0 \2}','ALL');
		_text = REReplaceNoCase(_text,'<P align=justify>(.*?)</B>(.*?)</P>','{\ql\b \1\b0 \2}','ALL');            
		_text = REReplaceNoCase(_text,'<b>(.*?)</b>','{\b \1 \b0}','ALL');
		_text = REReplaceNoCase(_text,'<B>(.*?)</B>','{\b \1 \b0}','ALL');            
		_text = REReplaceNoCase(_text,'<u>(.*?)</u>','\\ul \1\\ul0','ALL');
		_text = REReplaceNoCase(_text,'<U>(.*?)</U>','\\ul \1\\ul0','ALL');
		_text = REReplaceNoCase(_text,'<STRONG>(.*?)</STRONG>','{\b \1 \b0}','ALL');
		_text = REReplaceNoCase(_text,'<strong>(.*?)</strong>','{\b \1 \b0}','ALL');
		_text = REReplaceNoCase(_text,'<TABLE(.*?)>(.*?)</TABLE>','\2','ALL');
		text = REReplaceNoCase(_text,'<TABLE(.*?)>','ALL');
		_text = REReplaceNoCase(_text,'<table(.*?)>(.*?)</table>','\2','ALL');
		_text = REReplaceNoCase(_text,'<table(.*?)>','','ALL');
		_text = REReplaceNoCase(_text,'<TBODY(.*?)>(.*?)</TBODY>','\2','ALL');
		_text = REReplaceNoCase(_text,'<tbody(.*?)>(.*?)</tbody>','\2','ALL');            
		__text = REReplaceNoCase(_text,'<TBODY>','','ALL');
		_text = REReplaceNoCase(_text,'</TBODY>','','ALL');
		_text = REReplaceNoCase(_text,'<tbody>','','ALL');
		_text = REReplaceNoCase(_text,'</tbody>','','ALL');
		_text = REReplaceNoCase(_text,'<TR>','','ALL');
		_text = REReplaceNoCase(_text,'<tr>','','ALL');
		_text = REReplaceNoCase(_text,'<TD>','','ALL');
		_text = REReplaceNoCase(_text,'<td>','','ALL');             
		_text = REReplaceNoCase(_text,'<div align="center">(.*?)</div>','\qc','ALL');
		_text = REReplaceNoCase(_text,'<div style="text-align: right;">(.*?)</div>','\qr','ALL');
		_text = REReplaceNoCase(_text,'<div style="text-align: left;">(.*?)</div>','\ql','ALL');
		_text = REReplaceNoCase(_text,'&nbsp;',' ','ALL');
		_text = REReplaceNoCase(_text,'&amp;','&','ALL');                       
		_text = REReplaceNoCase(_text,'<P align=left></P>','\par','ALL');
		_text = REReplaceNoCase(_text,'<P align=left><BR>(.*?)</P>','\1\par','ALL');
		_text = REReplaceNoCase(_text,'<P align=left>(.*?)</P>','\par \1','ALL');
		_text = REReplaceNoCase(_text,'<P align="left">(.*?)</P>','\ql \1','ALL');
		_text = REReplaceNoCase(_text,'<P align=right>(.*?)</P>','\qr \1\par ','ALL');
		_text = REReplaceNoCase(_text,'<P align="right">(.*?)</P>','\qr \1','ALL');
		_text = REReplaceNoCase(_text,'<P align=center>(.*?)</P>','\qc \1','ALL');
		_text = REReplaceNoCase(_text,'<P align="center">(.*?)</P>','\qc \1','ALL');
		_text = REReplaceNoCase(_text,'<p>(.*?)</p>','\par \1\par','ALL');
		
		_text = REReplaceNoCase(_text,'<P(.*?)>(.*?)</P>','\par \2','ALL');
		_text = REReplaceNoCase(_text,'<p(.*?)>(.*?)</p>','\par \2','ALL');
		_text = REReplaceNoCase(_text,'<p>(.*?)<p>','\par \1\par','ALL');
		_text = REReplaceNoCase(_text,'<P>(.*?)<P>','\par \1\par','ALL');
		_text = REReplaceNoCase(_text,'<P>(.*?)','\par \1','ALL');
		_text = REReplaceNoCase(_text,'(.*?)<P>','\par \1','ALL');
		_text = REReplaceNoCase(_text,'(.*?)<P>(.*?)','\1 \par\2','ALL');
		_text = REReplaceNoCase(_text,'(.*?)<br>','\1 \par ','ALL');
		_text = REReplaceNoCase(_text,'(.*?)<BR>','\1 \par ','ALL');
		_text = REReplaceNoCase(_text,'(.*?)<br />','\1 \par ','ALL');
		_text = REReplaceNoCase(_text,'(.*?)<BR />','\1 \par ','ALL');		  
		_text = REReplaceNoCase(_text,'<br>','\par ','ALL');
		_text = REReplaceNoCase(_text,'<BR>','\par ','ALL');
		_text = REReplaceNoCase(_text,'<br />','\par ','ALL');
		_text = REReplaceNoCase(_text,'<BR />','\par ','ALL');
		
		_text = REReplaceNoCase(_text,'<OL>(.*?)</OL>','\1 ','ALL');
							
		_text = REReplaceNoCase(_text,'<FONT color=##0000ff>(.*?)</FONT>','\1','ALL');
		_text = REReplaceNoCase(_text,'<FONT color=##FFFFFF>(.*?)</FONT>','\1','ALL');
		_text = REReplaceNoCase(_text,'<FONT color=##0000ff>(.*?)</FONT>','\1','ALL');
		_text = REReplaceNoCase(_text,'<FONT color=##FFFFFF>(.*?)</FONT>','\1','ALL');
		_text = REReplaceNoCase(_text,'<FONT face=Helv,Arial size=2>(.*?)</FONT>','\1','ALL');            
		_text = REReplaceNoCase(_text,'<FONT size=(.*?)>(.*?)</FONT>','\2','ALL');            
		_text = REReplaceNoCase(_text,'<FONT face=Helv,Arial size=2>(.*?)</FONT>','\1','ALL');                        
		_text = REReplaceNoCase(_text,'<FONT(.*?)>(.*?)</FONT>','\2','ALL');
		_text = REReplaceNoCase(_text,'<FONT(.*?)>','','ALL');
		_text = REReplaceNoCase(_text,'<font(.*?)>(.*?)</font>','\2','ALL');
		_text = REReplaceNoCase(_text,'<font(.*?)>','','ALL');           
		_text = REReplaceNoCase(_text,'<SUP>(.*?)</SUP>','','ALL');
		_text = REReplaceNoCase(_text,'<DIR>(.*?)</DIR>','','ALL');
		_text = REReplaceNoCase(_text,'<DIR>','','ALL');
		_text = REReplaceNoCase(_text,'</DIR>','','ALL');
		_text = REReplaceNoCase(_text,'<(.*?)>(.*?)</(.*?)>','ALL');
		
		
		_text = REPLACE(_text,'<SPAN lang=EN>','','ALL');
		_text = REPLACE(_text,'</SPAN>','','ALL');
		_text = REPLACE(_text,'&nbsp',' ','ALL');
		_text = REPLACE(_text,'&NBSP',' ','ALL');
		_text = REPLACE(_text,'&nbsp;',' ','ALL');
		_text = REPLACE(_text,'&NBSP;',' ','ALL');
		_text = REPLACE(_text,'&amp','&','ALL');
		_text = REPLACE(_text,'&amp','&','ALL');
		_text = REPLACE(_text,'&AMP','&','ALL');
		_text = REPLACE(_text,'&amp;','&','ALL');
		_text = REPLACE(_text,'&amp;','&','ALL');
		_text = REPLACE(_text,CHR(146),CHR(39),'ALL');
		_text = REPLACE(_text,'</FONT>','','ALL');
		_text = REPLACE(_text,'<B><U>','','ALL');
		_text = REPLACE(_text,'<B>','','ALL');
		_text = REPLACE(_text,'<U>','','ALL');
		_text = REPLACE(_text,'<OL>','','ALL');
		_text = REPLACE(_text,'</OL>','','ALL');
		_text = REPLACE(_text,'<P align=left>','','ALL');
		_text = REPLACE(_text,'<P>','\par','ALL');
		_text = REPLACE(_text,'<p>','\par','ALL');
		_text = REPLACE(_text,'’',CHR(39),'ALL');
		_text = REPLACE(_text,'“',CHR(34),'ALL');
		_text = REPLACE(_text,'”',CHR(34),'ALL');    
		_text = TRIM(_text);
		
		}
		else if( Arguments.conversionType eq "HTML2PLAIN" ){
	
		//Conversion of HTML to PLAIN Text
		_text = REReplaceNoCase(_text,'<b style=\"\"><u><span style=\"font-size: 12pt; font-family: &quot;Times New Roman&quot;;\">(.*?)<\/span><\/u><\/b>','{\b\\ul \1 \\ul0\b0}','ALL');
		_text = REReplaceNoCase(_text,'<span style=\"font-style: italic; text-decoration: underline; font-weight: bold;\">(.*?)<\/span>','{\i\\ul\b \1 \b0\\ul0\i0} ','ALL');
		_text = REReplaceNoCase(_text,'<span style=\"font-style: italic; font-weight: bold;\">(.*?)<\/span>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<span style=\"font-weight: bold;\">(.*?)<\/span>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<span style=\"font-style: italic;\">(.*?)<\/span>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<span style=\"text-decoration: underline; font-style: italic;\">(.*?)<\/span>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<i>(.*?)<\/i>',' \1 ','ALL');	
		_text = REReplaceNoCase(_text,'<b><u>(.*?)<\/b><\/u>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<B><U>(.*?)<\/B><\/U>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<b>(.*?)<\/b>',' \1 ','ALL');	
		_text = REReplaceNoCase(_text,'<B>(.*?)<\/B>',' \1 ','ALL');	
		_text = REReplaceNoCase(_text,'<u>(.*?)<\/u>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<u>(.*?)<\/u>',' \1 ','ALL');	
		_text = REReplaceNoCase(_text,'<STRONG>(.*?)<\/STRONG>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<strong>(.*?)<\/strong>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<br>',' ','ALL');
		_text = REReplaceNoCase(_text,'<div align=\"center\">(.*?)<\/div>',' ','ALL');
		_text = REReplaceNoCase(_text,'<div style=\"text-align: right;\">(.*?)<\/div>',' ','ALL');
		_text = REReplaceNoCase(_text,'<div style=\"text-align: left;\">(.*?)<\/div>',' ','ALL');
		_text = REReplaceNoCase(_text,'\&nbsp;','  ','ALL');
		_text = REReplaceNoCase(_text,'<P align=left>(.*?)<\/p>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<P align=\"left\">(.*?)<\/p>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<P align=right>(.*?)<\/p>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<P align=\"right\">(.*?)<\/p>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<P align=center>(.*?)<\/p>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<P align=\"center\">(.*?)<\/p>',' \1 ','ALL');
		_text = REReplaceNoCase(_text,'<p>(.*?)</p>',' \1 ','ALL');
		}
		
		return _text;
	</cfscript>	
	
	</cffunction>
	
	<!--- XHTMLParagraphFormat --->	
	<cffunction name="XHTMLParagraphFormat" returntype="string" output="false">
		<cfargument name="str" required="true" type="string">
		<cfreturn REReplace(arguments.str, "\r+\n\r+\n", "<br /><br />", "ALL")>
	</cffunction>

	<!--- setSiteStats --->
	<cffunction name="setSiteStats" access="remote" returntype="void">
		<cfargument name="TEMPLATE" type="string" required="no">
		<cfargument name="QUERY_STRING" type="string" required="no">
		<cfargument name="PATH_TRANSLATED" type="string" required="no">
		<cfargument name="HTTP_REFERER" type="string" required="no">
		<cfargument name="HTTP_USER_AGENT" type="string" required="no">
		<cfargument name="REMOTE_ADDR" type="string" required="no">
		
		<cfset var qryInsertStats = queryNew('tempCol')>
		
		<cfquery name="qryInsertStats" datasource="#application.starsdb#">
			INSERT INTO #application.DB#.IV_SITE_STATS 
			(
				TEMPLATE,
				QUERY_STRING,
				PATH_TRANSLATED,
				HTTP_REFERER,
				USER_AGENT,
				REMOTE_ADDR
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TEMPLATE#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.QUERY_STRING#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PATH_TRANSLATED#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.HTTP_REFERER#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.HTTP_USER_AGENT#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.REMOTE_ADDR#" />
			)
		</cfquery>
		
	</cffunction>
	
	<!--- localUrl --->
	<cffunction name="localUrl" >
	  <cfargument name="file" />
	  <cfset var fpath = ExpandPath(file)>
	  <cfset var f="">
	  <cfset f = createObject("java", "java.io.File")>
	  <cfset f.init(fpath)>
	  <cfreturn f.toUrl().toString()>
	</cffunction>	 	  
	
	<!--- // getPermissionCodes --->
	<cffunction name="getPermissionCodes" access="remote" returntype="any">	  
	  
	  <cfset var qPermissionCodes = "">	  
		
		<cfquery name="qPermissionCodes" datasource="#application.starsdb#">
			SELECT P.CODE AS PERMISSION,
			       P.DESCRIPTION AS PERM_DESC
			FROM #application.DB#.IV_REF_PERMISSIONS P
			WHERE P.VALID_FLAG = 'Y'
		</cfquery>
	  
	  <cfreturn qPermissionCodes />
	</cffunction>
	
	<!--- // getPermissionName --->
	<cffunction name="getPermissionName" access="remote" returntype="any">	  
	  <cfargument name="code" required="true" type="string">
	  
	  <cfset var qPermissionName = "">	  
		
		<cfquery name="qPermissionName" datasource="#application.starsdb#">
			SELECT P.DESCRIPTION
			FROM #application.DB#.IV_REF_PERMISSIONS P
			WHERE P.VALID_FLAG = 'Y'
				AND P.CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.code#">
		</cfquery>
	  
	  <cfset sl_desc = qPermissionName.description>
	  
	  <cfreturn sl_desc />
	</cffunction>
	
	<!--- getExtensionImage --->
	<cffunction name="getExtensionImage" access="remote" returntype="any">	  
	  <cfargument name="file_name" required="true" type="string">
	
		<cfscript>
			var imageSrc = '';
			var docExt = ListLast(Arguments.file_name,".");
			
			switch(docExt)
			{
				case "doc":
				case "docx":
				case "dot":
				case "dotx":
				case "rtf":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/page_white_word.png" alt="open" border="0" title="MS Word/RTF">';
					break;
				case "pdf":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/page_white_acrobat.png" alt="open" border="0" title="PDF">';
					break;					
				case "text":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/page_white_text.png" alt="open" border="0" title="Text">';
					break;
				case "xls":
				case "xlsx":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/page_excel.png" alt="open" border="0" title="MS Excel">';
					break;					
				case "ppt":
				case "pptx":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/page_white_powerpoint.png" alt="open" border="0" title="MS PowerPoint">';
					break;
				case "jpg":
				case "jpeg":
				case "gif":
				case "png":
				case "bmp":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/picture.png" alt="open" border="0" title="Image">';
					break;
				case "zip":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/compress.png" alt="zip" border="0" title="Zip">';
					break;
				case "msg":
					imageSrc = '<img src="/aps/i2m/img/icons/fam/email_attach.png" alt="Email" border="0" title="Email">';
					break;
				default:
					imageSrc = '<img src="/aps/i2m/img/icons/fam/page_white_text.png" alt="File" border="0" title="File">';
					break;									
				
			}

		</cfscript>
		
		<cfreturn imageSrc>
	</cffunction>
	
	<cffunction name="businessDaysAdd" access="remote" returntype="any" description="Works just like dateAdd() @author Billy Cravens">
		<cfargument name="date" type="date" required="yes"/>
		<cfargument name="number" type="numeric" required="yes"/>
	 
		<cfscript>

		var cAdded = 0;
		var tempDate = date;
		var direction = compare(number,0);
		
		while (cAdded LT abs(number)) {
			
			tempDate = dateAdd("d",direction,tempDate);
			
			if (dayOfWeek(tempDate) GTE 2 AND dayOfWeek(tempDate) LTE 6) {
			  cAdded = incrementValue(cAdded);
			}
		}
		
		return tempDate;

		</cfscript>
		
	</cffunction>
	
</cfcomponent>