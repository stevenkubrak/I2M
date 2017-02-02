<cfcomponent extends="investigations.cfc.utility" output="false">

	<cflock scope="application" throwontimeout="no" timeout="5" type="readonly">
	  <cfset this.I2MCon = application.starsdb />
	  <cfset this.dateFormat = application.dateFormat />
	</cflock>

	<!--- getBriefings() --->
	<cffunction name="getBriefings" returntype="any" access="public" output="false">
	   <cfargument name="user_id" type="numeric" required="yes" />
	   <cfargument name="bmenu" type="string" required="yes" />
		 
		 <cfset var qBriefings = "">
		 
		 <cfquery	name="qBriefings" datasource="#this.I2MCon#">
			SELECT 
			 B.ID,
			 B.BRIEFING_NUMBER,
             B.TITLE,
             B.BRIEF_DATE,
             B.OFFICE,
			 (
			 SELECT DISTINCT EMP.TEAM_NAME     
			 FROM IGDBAP.V_EMPLOYEES EMP
			 WHERE EMP.DIVISION_CODE = B.OFFICE) AS OFFICE_TITLE,			 
             B.PRESENTER_ID,
			 GET_NAME(B.PRESENTER_ID,'FL') AS PRESENTOR,
             B.FILENAME,
             B.COMMENTS,
             (
			 SELECT COUNT(BA1.ID) 
			 FROM #application.DB#.IV_BRIEFING_ATTENDEES BA1 
			 WHERE BA1.BRIEF_ID = B.ID
			 AND (BA1.REMOVED IS NULL OR BA1.REMOVED <> 'Y')) AS ATTENDEE_COUNT,
             B.CO_PRESENTERS,
             B.ORGANIZATION,
             B.ORG_ADDRESS,
             B.ORG_CITY,
             B.ORG_STATE,
             B.ORG_ZIP,
             B.CREATED_BY,
             B.CREATED_DATE,
             B.UPDATED_BY,
             B.UPDATED_DATE,
             B.REMOVED,
            TO_CHAR(B.CREATED_DATE,'YYYYMMDD') AS SUBDIR                           
      FROM #application.DB#.IV_BRIEFINGS B,
            #application.DB#.IV_BRIEFING_ATTENDEES BA,
            #application.DB#.IV_BRIEFING_STAFF BS
      WHERE (B.REMOVED IS NULL OR B.REMOVED <> 'Y')
          AND B.ID = BS.BRIEF_ID
          AND B.ID = BA.BRIEF_ID(+)
          AND (BA.REMOVED IS NULL OR BA.REMOVED <> 'Y')
          <cfif arguments.bmenu is "yours">
						AND (
									B.PRESENTER_ID = <cfqueryparam value="#UCase(arguments.user_id)#"/>			
									OR 	BS.EMP_ID = <cfqueryparam value="#UCase(arguments.user_id)#"/>	
						)
					</cfif>          
      GROUP BY B.ID,B.BRIEFING_NUMBER,B.TITLE,B.BRIEF_DATE,B.OFFICE, B.PRESENTER_ID,B.FILENAME, B.COMMENTS,B.CO_PRESENTERS,B.ORGANIZATION,
                   B.ORG_ADDRESS, B.ORG_CITY, B.ORG_STATE, B.ORG_ZIP, B.CREATED_BY,
                   B.CREATED_DATE,B.UPDATED_BY, B.UPDATED_DATE, B.REMOVED
      ORDER BY B.BRIEF_DATE DESC		
		</cfquery>
	   
	   <cfreturn qBriefings />
	</cffunction>
	
	<!--- getRecord() --->
	<cffunction name="getRecord" returntype="any" access="public" output="false">
	   <cfargument name="user_id" type="numeric" required="yes" />
	   <cfargument name="bmenu" type="string" required="yes" />
		 
		 <cfset var Record = "">
		 
		 <cfquery	name="Record" datasource="#this.I2MCon#">
			SELECT 
			 B.ID,
			 B.BRIEFING_NUMBER,
             B.TITLE,
             B.BRIEF_DATE,
             B.OFFICE,
             B.PRESENTOR,
             B.FILENAME,
             B.COMMENTS,
             (
			 SELECT COUNT(BA1.ID) 
			 FROM #application.DB#.IV_BRIEFING_ATTENDEES BA1 
			 WHERE BA1.BRIEF_ID = B.ID
			 AND (BA1.REMOVED IS NULL OR BA1.REMOVED <> 'Y')) AS ATTENDEE_COUNT,
             B.CO_PRESENTERS,
             B.ORGANIZATION,
             B.ORG_ADDRESS,
             B.ORG_CITY,
             B.ORG_STATE,
             B.ORG_ZIP,
             B.CREATED_BY,
             B.CREATED_DATE,
             B.UPDATED_BY,
             B.UPDATED_DATE,
             B.REMOVED,
             NVL(TO_CHAR(B.UPDATED_DATE,'YYYYMMDD'),TO_CHAR(B.CREATED_DATE,'YYYYMMDD')) AS SUBDIR                           
      FROM #application.DB#.IV_BRIEFINGS B,
            #application.DB#.IV_BRIEFING_ATTENDEES BA,
            #application.DB#.IV_BRIEFING_STAFF BS
      WHERE (B.REMOVED IS NULL OR B.REMOVED <> 'Y')
          AND B.ID = BS.BRIEF_ID
          AND B.ID = BA.BRIEF_ID(+)
          AND (BA.REMOVED IS NULL OR BA.REMOVED <> 'Y')
          <cfif arguments.bmenu is "yours">
						AND (
									B.PRESENTER_ID = <cfqueryparam value="#UCase(arguments.user_id)#"/>			
									OR 	BS.EMP_ID = <cfqueryparam value="#UCase(arguments.user_id)#"/>	
						)
					</cfif>          
      GROUP BY 
	  	B.ID,B.BRIEFING_NUMBER,B.TITLE,B.BRIEF_DATE,B.OFFICE, B.PRESENTOR,B.FILENAME, B.COMMENTS,B.CO_PRESENTERS,
		B.ORGANIZATION,B.ORG_ADDRESS, B.ORG_CITY, B.ORG_STATE, B.ORG_ZIP, B.CREATED_BY,
		B.CREATED_DATE,B.UPDATED_BY, B.UPDATED_DATE, B.REMOVED
      ORDER BY B.BRIEF_DATE DESC		
		</cfquery>
	   
	   <cfreturn Record />
	</cffunction>
	
	<!--- getBriefAddPermissions() --->
	<cffunction name="getBriefAddPermissions" returntype="any" access="public" output="false">
	   <cfargument name="emp_id" required="yes" />
	 	 
		 <cfset var qBriefAddPermissions = "">
		 
		 <cfquery name="qBriefAddPermissions"  datasource="#this.I2MCon#" >
				SELECT PR.BRIEFING_ACCESS
				FROM #application.DB#.IV_PARIS_ROLES PR
				WHERE PR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.emp_id#"/>
		</cfquery>
	   
	   <cfreturn qBriefAddPermissions />
	</cffunction>
	
	<!--- getEmailCampaignPermission() --->
	<cffunction name="getEmailCampaignPermission" returntype="any" access="public" output="false">
	   <cfargument name="emp_id" required="yes" />
	 	 
		 <cfset var qEmailCampaignPermission = "">
		 
		 <cfquery name="qEmailCampaignPermission"  datasource="#this.I2MCon#" >
				SELECT PR.EMAIL_CAMPAIGN_ACCESS
				FROM #application.DB#.IV_PARIS_ROLES PR
				WHERE PR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.emp_id#"/>
		</cfquery>
	   
	   <cfreturn qEmailCampaignPermission />
	</cffunction>
	
	<!--- getBriefingPermissions() --->
	<cffunction name="getBriefingPermissions" returntype="any" access="public" output="false">
	   <cfargument name="emp_id" required="yes" />
	 	 <cfargument name="location_code" required="yes" />
	 	 <cfargument name="role_code" required="yes" />
	 	 <cfargument name="briefing_id" required="yes" default="0" />
	 	 
		 <cfset var qBriefingPermissions = "">
		 
		 <cfquery name="qBriefingPermissions"  datasource="#this.I2MCon#" >
				SELECT 
					DISTINCT
					AP.ID AS PERMISSION_ID,
				    PR.ID AS ROLE_ID,
				    AP.RELATED_ID,
       				AP.RELATED_NAME,
					AP.LOCATION_CODE,
					AP.ASSIGNED_DATE,
					AP.RELEASED_DATE,
					AP.PERMISSION_CODE,
					PR.EMP_ID,
					PR.ROLE_CODE,
					PR.BRIEFING_ACCESS,
					PR.ROLE_TYPE  
				FROM
					#application.DB#.IV_ASSIGNED_PERMISSIONS AP,
					#application.DB#.IV_PARIS_ROLES PR
				WHERE 
					PR.EMP_ID = AP.EMPLOYEE_ID
				AND AP.REMOVED = PR.REMOVED
				AND PR.BRIEFING_ACCESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y"/>
				AND AP.SUSPENDED = <cfqueryparam cfsqltype="cf_sql_varchar" value="N"/>
				AND PR.REMOVED = <cfqueryparam cfsqltype="cf_sql_varchar" value="N"/>
				AND PR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.emp_id#"/>
				AND AP.LOCATION_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.location_code#"/>
				AND PR.ROLE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.role_code#"/>
				<cfif arguments.briefing_id GT 0>
					AND AP.RELATED_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.briefing_id#"/>
				</cfif>
		</cfquery>
	   
	   <cfreturn qBriefingPermissions />
	</cffunction>
	
	<!--- getBriefingPermissionsById() --->
	<cffunction name="getBriefingPermissionsById" returntype="any" access="remote" output="false">
	   <cfargument name="perm_id" required="yes" />
	 	 
		 <cfset var qBriefingPermissionsById = "">
		 
		 <cfquery name="qBriefingPermissionsById"  datasource="#this.I2MCon#" >
				SELECT 
					DISTINCT 
					AP.ID,
					PR.ID AS ROLE_ID,
					AP.RELATED_ID,
					AP.RELATED_NAME,
					AP.LOCATION_CODE,
					AP.ASSIGNED_DATE,
					AP.RELEASED_DATE,
					AP.PERMISSION_CODE, 
					RP.DESCRIPTION AS PERM_DESC,
					PR.EMP_ID,      
					PR.ROLE_CODE,
					PR.BRIEFING_ACCESS,
					PR.ROLE_TYPE,
					E.EMP_LAST_NAME || ', ' || E.EMP_FIRST_NAME AS FULL_NAME    
				FROM 
					#application.DB#.IV_ASSIGNED_PERMISSIONS AP,
					#application.DB#.IV_REF_PERMISSIONS RP,
					#application.DB#.IV_PARIS_ROLES PR,
					#application.DB#.V_EMPLOYEES E
				WHERE 
					PR.EMP_ID = AP.EMPLOYEE_ID
				AND E.USERID = AP.EMPLOYEE_ID
				AND RP.CODE = AP.PERMISSION_CODE
				AND AP.REMOVED = PR.REMOVED
				AND PR.BRIEFING_ACCESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y"/>
				AND AP.SUSPENDED = <cfqueryparam cfsqltype="cf_sql_varchar" value="N"/>
				AND PR.REMOVED = <cfqueryparam cfsqltype="cf_sql_varchar" value="N"/>
				AND AP.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.perm_id#"/>
		</cfquery>
	  
	   <cfreturn qBriefingPermissionsById />
	</cffunction>
	
	<!--- getAllBriefingPermissions() --->
	<cffunction name="getAllBriefingPermissions" returntype="any" access="public" output="false">
		 <cfset var qAllBriefingPermissions = "">
		 
		 <cfquery name="qAllBriefingPermissions"  datasource="#this.I2MCon#" >
				SELECT 
					L.CODE,
				    L.DESCRIPTION,
				    L.APPLICATION_PATH
				FROM 
					IV_REF_APPLICATION_LOCATIONS L
				WHERE 
					L.CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="BRIEF%"/>
				AND L.VALID_FLAG = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y"/>
				ORDER BY L.DESCRIPTION
		 </cfquery>
		 
	 	<cfreturn qAllBriefingPermissions />
	</cffunction>
	
	<!--- getBriefingPermissionsByLocation() --->
	<cffunction name="getBriefingPermissionsByLocation" returntype="any" access="remote" output="false">
		 <cfargument name="loc_code" required="yes" />
		 
		 <cfset var qBriefingPermissionsByLocation = "">
		 
		 <cfquery name="qBriefingPermissionsByLocation"  datasource="#this.I2MCon#" >
				SELECT L.CODE,
				       L.DESCRIPTION,
				       L.APPLICATION_PATH
				FROM IV_REF_APPLICATION_LOCATIONS L
				WHERE L.CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loc_code#"/>
					AND L.VALID_FLAG = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y"/>
				ORDER BY L.DESCRIPTION
		 </cfquery>
		 
	 	<cfreturn qBriefingPermissionsByLocation />
	</cffunction>
	
	<!--- getAllBriefingStaff() --->
	<cffunction name="getAllBriefingStaff" returntype="any" access="public" output="false">
	 	 <cfargument name="briefing_id" required="yes" default="0" />
		 <cfset var qAllBriefingStaff = "">
		 
		 <cfquery name="qAllBriefingStaff"  datasource="#this.I2MCon#" >
				SELECT 
					DISTINCT
					--S.ID,
					S.BRIEF_ID,
					S.EMP_ID,
					P.ID AS PERM_ID,
					B.TITLE,
					B.BRIEFING_NUMBER,
					E.EMP_LAST_NAME || ', ' || E.EMP_FIRST_NAME AS FULL_NAME,
					P.LOCATION_CODE,
					P.PERMISSION_CODE
				FROM 
					#application.DB#.IV_BRIEFING_STAFF S,
					#application.DB#.IV_BRIEFINGS B,
					#application.DB#.V_EMPLOYEES E,
					#application.DB#.IV_ASSIGNED_PERMISSIONS P
				WHERE 
					S.BRIEF_ID = B.ID
			    AND P.RELATED_ID = B.ID
			    AND E.USERID = S.EMP_ID
			    AND P.EMPLOYEE_ID = E.USERID
			    AND P.REMOVED_DATE IS NULL 
			    AND P.SUSPENDED = <cfqueryparam cfsqltype="cf_sql_varchar" value="N"/>
			    <cfif arguments.briefing_id GT 0>
					AND P.RELATED_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.briefing_id#"/>
				</cfif>
				ORDER BY 6
		</cfquery>
	   
	   <cfreturn qAllBriefingStaff />
	</cffunction>
	
	<!--- getBriefing() --->
	<cffunction name="getBriefing" returntype="any" access="public" output="false">
	   <cfargument name="id" required="yes" />
	 
		 <cfset var qBriefing = "">
		 
		 <CFQUERY name="qBriefing"  datasource="#this.I2MCon#" >
			SELECT 
				B.ID,
				B.TITLE,
				B.BRIEF_DATE,
				B.OFFICE,
				B.PRESENTOR,
				B.FILENAME,
				B.COMMENTS,
				B.CO_PRESENTERS,
				B.ORGANIZATION,
				B.ORG_ADDRESS,
				B.ORG_CITY,
				B.ORG_STATE,
				B.ORG_ZIP,
				B.BRIEFING_NUMBER,
				B.BUDGET_CODE,
				B.TOPIC
			FROM #application.DB#.IV_BRIEFINGS B
			WHERE 
				B.ID = <cfqueryparam value="#Arguments.id#"/>
		</CFQUERY>
	   
	   <cfreturn qBriefing />
	</cffunction>
		
	<!--- getAllBriefings() --->
	<cffunction name="getAllBriefings" returntype="any" access="public" output="false">
	 
		 <cfset var qAllBriefings = "">
		 
		 <CFQUERY name="qAllBriefings"  datasource="#this.I2MCon#" >
			SELECT B.ID,
						 B.TITLE,
						 B.BRIEF_DATE,
						 B.OFFICE,
						 B.PRESENTOR,
						 B.BRIEFING_NUMBER,
						 B.BUDGET_CODE,
						 B.TITLE || ' - ' || TO_CHAR(BRIEF_DATE,'MM-DD-YY') || ' (' || PRESENTOR || ')' AS DESCRIPTION
			FROM #application.DB#.IV_BRIEFINGS B
			WHERE EXISTS (SELECT ID FROM IV_BRIEFING_ATTENDEES WHERE BRIEF_ID = B.ID)
			ORDER BY B.TITLE
		</cfquery>
	   
	   <cfreturn qAllBriefings />
	</cffunction>
	
	<!--- getNextBriefingNumber() --->
	<cffunction name="getNextBriefingNumber" returntype="any" access="public" output="false">
	 
		 <cfset var qNextBriefingNumber = "">
		 
		 <cfquery name="qNextBriefingNumber"  datasource="#this.I2MCon#" >
				SELECT NVL(MAX(B.BRIEFING_NUMBER),0) AS MAX_NUMBER
				FROM #application.DB#.IV_BRIEFINGS B
				WHERE (B.REMOVED IS NULL OR B.REMOVED <> 'Y')
				ORDER BY B.BRIEFING_NUMBER
		</cfquery>
	   
	   <cfreturn qNextBriefingNumber />
	</cffunction>
	
	<!--- getBriefingTopic() --->
	<cffunction name="getBriefingTopic" returntype="any" access="public" output="false">
	   <cfargument name="id" required="yes" />
		 
		 <cfset var get_briefing_topic = "">
		 
		<CFQUERY name="get_briefing_topic"  datasource="#this.I2MCon#" >
			SELECT * 
			FROM #application.DB#.IV_BRIEFING_TOPICS
			WHERE BRIEFING_ID = <cfqueryparam value="#Arguments.id#"/>
			AND (REMOVED IS NULL OR REMOVED <> 'Y')
		</CFQUERY>
	   
	   <cfreturn get_briefing_topic />
	</cffunction>

	<!--- getBriefingAttend() --->
	<cffunction name="getBriefingAttend" returntype="any" access="public" output="false">
	   <cfargument name="id" required="yes" />
		 
		 <cfset var get_briefing_attend = "">
		 
			<cfquery name="get_briefing_attend" datasource="#this.I2MCon#" >
				SELECT BA.ID,
				       BA.BRIEF_ID,
				       BA.EMP_ID,
				       BA.ATTENDEE_TYPE,
				       BA.POSITION,
               BA.OFFICE,
               BA.CATEGORY,
				       CASE BA.ATTENDEE_TYPE
				         WHEN 'H' THEN 'EPA Headquarters'
				         WHEN 'A' THEN (SELECT LOCATION_NAME FROM IGDBA.EMP_LOCATION L,IGDBAP.V_PERSONNEL P WHERE L.LOCATION_ID = P.LOCATION_CODE AND P.USERID = BA.EMP_ID)
				         WHEN 'U' THEN 'AUSA - ' || (SELECT TITLE FROM IV_REF_ATTORNEY_LIST WHERE CODE = BA.ATTENDEE_AGENCY_CODE)
				         WHEN 'L' THEN 'LEO - ' || (SELECT DESCRIPTION FROM V_IV_JOINT_AGENCIES WHERE CODE = BA.ATTENDEE_AGENCY_CODE)
				         ELSE BA.ATTENDEE_AGENCY_CODE
				        END ATTENDEE_LOCATION,
				        LOWER(BA.ATTENDEE_EMAIL) AS ATTENDEE_EMAIL,
				        BA.ATTENDEE_PHONE,
				        BA.ATTENDEE_LNAME || ', ' || BA.ATTENDEE_FNAME AS FULL_NAME
	      FROM #application.DB#.IV_BRIEFING_ATTENDEES BA
	      WHERE BA.BRIEF_ID = <cfqueryparam value="#Arguments.id#" />
	      	AND (BA.REMOVED IS NULL OR BA.REMOVED <> 'Y')
			</cfquery>
	   
	   <cfreturn get_briefing_attend />
	</cffunction>

	<!--- getBriefingAttendee() --->
	<cffunction name="getBriefingAttendee" returntype="any" access="remote" output="false">
	   <cfargument name="ID" required="yes" hint="ID from IV_BRIEFING_ATTENDEES" />
		 
		 <cfset var qBriefingAttendee = "">
		 
			<cfquery name="qBriefingAttendee" datasource="#this.I2MCon#" >
				SELECT BA.ID,
                       BA.BRIEF_ID,
                       BA.EMP_ID,
                       BA.ATTENDEE_FNAME,
                       BA.ATTENDEE_LNAME,
                       BA.ATTENDEE_MID_INIT,
                       <!--- BA.TITLE, --->
                       BA.ATTENDEE_TYPE,
					   BA.ATTENDEE_AGENCY_CODE,
                       BA.POSITION,
                       BA.OFFICE,
                       BA.CATEGORY,
                       CASE BA.ATTENDEE_TYPE
                         WHEN 'H' THEN 'EPA Headquarters'
                         WHEN 'A' THEN (SELECT LOCATION_NAME 
                                        FROM IGDBA.EMP_LOCATION L,IGDBAP.V_PERSONNEL P 
                                        WHERE L.LOCATION_ID = P.LOCATION_CODE AND P.USERID = BA.EMP_ID)
                         WHEN 'U' THEN 'AUSA - ' || (SELECT TITLE FROM IV_REF_ATTORNEY_LIST WHERE CODE = BA.ATTENDEE_AGENCY_CODE)
                         WHEN 'L' THEN 'LEO - ' || (SELECT DESCRIPTION FROM V_IV_JOINT_AGENCIES WHERE CODE = BA.ATTENDEE_AGENCY_CODE)
                         ELSE BA.ATTENDEE_AGENCY_CODE
                         END ATTENDEE_LOCATION,
                       LOWER(BA.ATTENDEE_EMAIL) AS ATTENDEE_EMAIL,
                       BA.ATTENDEE_PHONE,
                       BA.ATTENDEE_LNAME || ', ' || BA.ATTENDEE_FNAME AS FULL_NAME
          FROM 
		  		#application.DB#.IV_BRIEFING_ATTENDEES BA
	      WHERE 
		  	BA.ID = <cfqueryparam value="#Arguments.ID#" />
			</cfquery>
	   
	   <cfreturn qBriefingAttendee />
	</cffunction>
	
	<!--- getAllBriefingAttend() --->
	<cffunction name="getAllBriefingAttend" returntype="any" access="public" output="false">		 
		 <cfset var qAllBriefingAttend = "">
		 
			<cfquery name="qAllBriefingAttend" datasource="#this.I2MCon#" >
				SELECT DISTINCT                        
               BA.EMP_ID,
               BA.BRIEF_ID,
               BA.ATTENDEE_TYPE,
               CASE BA.ATTENDEE_TYPE
                 WHEN 'H' THEN 'EPA Headquarters'
                 WHEN 'A' THEN (SELECT LOCATION_NAME FROM IGDBA.EMP_LOCATION L,IGDBAP.V_PERSONNEL P WHERE L.LOCATION_ID = P.LOCATION_CODE AND P.USERID = BA.EMP_ID)
                 WHEN 'U' THEN 'AUSA - ' || (SELECT TITLE FROM IV_REF_ATTORNEY_LIST WHERE CODE = BA.ATTENDEE_AGENCY_CODE)
                 WHEN 'L' THEN 'LEO - ' || (SELECT DESCRIPTION FROM V_IV_JOINT_AGENCIES WHERE CODE = BA.ATTENDEE_AGENCY_CODE)
                 ELSE BA.ATTENDEE_AGENCY_CODE
                END ATTENDEE_LOCATION,
                LOWER(BA.ATTENDEE_EMAIL) AS ATTENDEE_EMAIL,
                BA.ATTENDEE_PHONE,
                BA.ATTENDEE_LNAME || ', ' || BA.ATTENDEE_FNAME AS FULL_NAME
	      FROM #application.DB#.IV_BRIEFING_ATTENDEES BA
	      WHERE (BA.REMOVED IS NULL OR BA.REMOVED <> 'Y')
	      ORDER BY FULL_NAME	
			</cfquery>
	   
	   <cfreturn qAllBriefingAttend />
	</cffunction>
	
	<!--- getAllIndividuals() --->
	<cffunction name="getAllIndividuals" returntype="any" access="public" output="false">		 
		 <cfset var qAllIndividuals = "">
		 
			<cfquery name="qAllIndividuals" datasource="#this.I2MCon#" >
				SELECT DISTINCT                        
               MAX(BA.ID) AS ID,
               LOWER(BA.ATTENDEE_EMAIL) AS ATTENDEE_EMAIL,
               BA.ATTENDEE_LNAME || ', ' || BA.ATTENDEE_FNAME AS FULL_NAME
	      FROM #application.DB#.IV_BRIEFING_ATTENDEES BA
	      WHERE (BA.REMOVED IS NULL OR BA.REMOVED <> 'Y')
	      GROUP BY ATTENDEE_EMAIL,ATTENDEE_LNAME,ATTENDEE_FNAME
	      ORDER BY FULL_NAME	
			</cfquery>
	   
	   <cfreturn qAllIndividuals />
	</cffunction>
	
	<!--- getAllOrganizations() --->
	<cffunction name="getAllOrganizations" returntype="any" access="public" output="false">		 
		 <cfset var qAllOrganizations = "">
		 
			<cfquery name="qAllOrganizations" datasource="#this.I2MCon#" >
				SELECT DISTINCT BA.ATTENDEE_AGENCY_CODE AS CODE,
		       CASE BA.ATTENDEE_TYPE
		        WHEN 'H' THEN REPLACE(BA.ATTENDEE_AGENCY_CODE,'.',' ') || DECODE(BA.OFFICE,NULL,'',' (' || BA.OFFICE || ')')
		        WHEN 'A' THEN REPLACE(BA.ATTENDEE_AGENCY_CODE,'.',' ') || DECODE(BA.OFFICE,NULL,'',' (' || BA.OFFICE || ')')
		        WHEN 'L' THEN (SELECT DESCRIPTION FROM V_IV_JOINT_AGENCIES WHERE CODE = ATTENDEE_AGENCY_CODE)
		        WHEN 'U' THEN (SELECT TITLE FROM IV_REF_ATTORNEY_LIST WHERE CODE = ATTENDEE_AGENCY_CODE)
		        WHEN 'E' THEN 'EPA Non-OIG'
		        ELSE REPLACE(BA.ATTENDEE_AGENCY_CODE,'.',' ')
		       END AS AGENCY       
				FROM #application.DB#.IV_BRIEFINGS B,
						 #application.DB#.IV_BRIEFING_ATTENDEES BA
				WHERE (B.REMOVED IS NULL OR B.REMOVED <> 'Y')
				    AND BA.BRIEF_ID = B.ID
				ORDER BY AGENCY
			</cfquery>
	   
	   <cfreturn qAllOrganizations />
	</cffunction>
	
	<!--- getOrganizationByCode() --->
	<cffunction name="getOrganizationByCode" returntype="any" access="public" output="false">		 
		 <cfargument name="org" type="string" required="yes" />
		 <cfset var qOrganizationByCode = "">
		 
			<cfquery name="qOrganizationByCode" datasource="#this.I2MCon#" >
				SELECT DISTINCT BA.ATTENDEE_AGENCY_CODE AS CODE,
		       CASE BA.ATTENDEE_TYPE
		        WHEN 'H' THEN REPLACE(BA.ATTENDEE_AGENCY_CODE,'.',' ') || DECODE(BA.OFFICE,NULL,'',' (' || BA.OFFICE || ')')
		        WHEN 'A' THEN REPLACE(BA.ATTENDEE_AGENCY_CODE,'.',' ') || DECODE(BA.OFFICE,NULL,'',' (' || BA.OFFICE || ')')
		        WHEN 'L' THEN (SELECT DESCRIPTION FROM V_IV_JOINT_AGENCIES WHERE CODE = ATTENDEE_AGENCY_CODE)
		        WHEN 'U' THEN (SELECT TITLE FROM IV_REF_ATTORNEY_LIST WHERE CODE = ATTENDEE_AGENCY_CODE)
		        WHEN 'E' THEN 'EPA Non-OIG'
		        ELSE REPLACE(BA.ATTENDEE_AGENCY_CODE,'.',' ')
		       END AS AGENCY       
				FROM #application.DB#.IV_BRIEFINGS B,
						 #application.DB#.IV_BRIEFING_ATTENDEES BA
				WHERE (B.REMOVED IS NULL OR B.REMOVED <> 'Y')
				    AND BA.BRIEF_ID = B.ID
				    AND UPPER(BA.ATTENDEE_AGENCY_CODE) = <cfqueryparam value="#UCase(arguments.org)#" />	
				ORDER BY AGENCY
			</cfquery>
	   
	   <cfreturn qOrganizationByCode />
	</cffunction>

	<!--- getAIGs() --->
	<cffunction name="getAIGs" returntype="any" access="remote" output="false">
	 
		 <cfset var qAIG = "">
		 
		 <CFQUERY name="qAIG"  datasource="#this.I2MCon#" >
			SELECT DISTINCT
				E.AIG_ID,
				E.AIG_CODE,
				E.AIG_TITLE
			FROM
				IGDBAP.V_EMPLOYEES E
			ORDER BY E.AIG_TITLE
		 </CFQUERY>
	   
	   <cfreturn qAIG />
	</cffunction>

	<!--- getDivisions() --->
	<cffunction name="getDivisions" returntype="any" access="remote" output="false">
	   <cfargument name="AIG_ID" required="no" default="ALL"  />
	 
		 <cfset var qDivisions = "">
		 
		 <CFQUERY name="qDivisions" datasource="#this.I2MCon#" >
			SELECT DISTINCT
				E.DIVISION_CODE,
				E.TEAM_NAME
			FROM
				IGDBAP.V_EMPLOYEES E
			WHERE
				E.USERID IS NOT NULL
			<cfif Arguments.AIG_ID NEQ 'ALL'>
			AND E.AIG_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AIG_ID#" />
			</cfif>
			ORDER BY E.TEAM_NAME
		 </CFQUERY>
	   
	   <cfreturn qDivisions />
	</cffunction>	

	<!--- getEmployeesByDivisons() --->
	<cffunction name="getEmployeesByDivisons" returntype="any" access="remote" output="false">
	   <cfargument name="DIVISION_CODE" required="no" default="ALL"  />
	 
		 <cfset var qEmployeesByDivisons = "">
		 
		 <CFQUERY name="qEmployeesByDivisons" datasource="#this.I2MCon#" >
			SELECT
				E.USERID,
				E.EMP_FIRST_NAME,
				E.EMP_LAST_NAME,
				(E.EMP_LAST_NAME || ', ' || E.EMP_FIRST_NAME || ' (' || E.AIG_CODE || ')') AS FULL_NAME,
				E.TEAM_NAME,
				E.AIG_CODE
			FROM
				IGDBAP.V_EMPLOYEES E
			WHERE
				E.USERID IS NOT NULL
			<cfif Arguments.DIVISION_CODE NEQ 'ALL'>		
			AND	E.DIVISION_CODE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DIVISION_CODE#" /> 
			</cfif>
		 </CFQUERY>
	   
	   <cfreturn qEmployeesByDivisons />
	</cffunction>	
	
	<!--- getOrganizationParticipants() --->
	<cffunction name="getOrganizationParticipants" returntype="any" access="public" output="false">		 
		 <cfargument name="org" type="string" required="yes" />
		 <cfset var qOrganizationParticipants = "">
		 
			<cfquery name="qOrganizationParticipants" datasource="#this.I2MCon#" >
				SELECT DISTINCT 
				       MAX(BA.ID) AS ATTENDEE_ID,
				       BA.ATTENDEE_TYPE,
				       BA.TITLE,
				       REPLACE(BA.TITLE,'.',', ') AS FULL_NAME,
				       BA.ATTENDEE_EMAIL,
				       BA.ATTENDEE_AGENCY_CODE      
				FROM #application.DB#.IV_BRIEFING_ATTENDEES BA
				WHERE (BA.REMOVED IS NULL OR BA.REMOVED <> 'Y')
				    AND UPPER(BA.ATTENDEE_AGENCY_CODE) = <cfqueryparam value="#UCase(arguments.org)#" />	
				GROUP BY BA.ATTENDEE_TYPE,BA.TITLE,BA.ATTENDEE_EMAIL,BA.ATTENDEE_AGENCY_CODE
				ORDER BY BA.TITLE
			</cfquery>
	   
	   <cfreturn qOrganizationParticipants />
	</cffunction>

	<!--- getOffice() --->
	<cffunction name="getOffice" returntype="any" access="public" output="false">
		 <cfset var office = "">
		 
		 <cfquery name="office" datasource="#this.I2MCon#">
			 SELECT * 
			 FROM IGDBA.FIELD_OFFICES 
			 WHERE valid_flag = <cfqueryparam value="Y"/>
			 ORDER BY DESCRIPTION
		</cfquery>
	   
	   <cfreturn office />
	</cffunction>
	
	<!--- getStaff() --->
	<cffunction name="getStaff" returntype="any" access="public" output="false">
		 
		 <cfset var qStaff = "">
		 
		 <cfquery name="qStaff" datasource="#this.I2MCon#">
			SELECT	id, 
					logon_cd, 
					lst_name || ', ' || fst_name as name 
			FROM	igdba.person_instn 
			WHERE	valid_flg = <cfqueryparam value="Y"/> 
				AND sub_type = <cfqueryparam value="E" />
			ORDER BY name
		</cfquery>
	   <cfreturn qStaff />
	</cffunction>
	
	<!--- getTopics() --->
	<cffunction name="getTopics" returntype="any" access="public" output="false">
		 <cfset var topics = "">
		 
		 <cfquery name="topics" datasource="#this.I2MCon#">
			 SELECT * 
			 FROM #application.DB#.IV_TOPICS 
			 WHERE valid_flag = <cfqueryparam value="Y"/>
		</cfquery>
	   
	   <cfreturn topics />
	</cffunction>
	
	<!--- getHQList() --->
	<cffunction name="getHQList" returntype="any" access="public" output="false">
		 <cfargument name="location_code" required="yes" />
		 <cfset var qHQList = "">
		 
		 <cfquery name="qHQList" datasource="#this.I2MCon#">
			 SELECT 
			 	USERID AS EMP_ID,
			 'EPA.'|| aig_code || '|' || userid || '|H|' || emp_last_name || '.' || emp_first_name || '|' || jobposition || '|' || location_city || '|' || emp_email || '|' || NVL(TO_CHAR(WORK_PHONE),'N/A') || '|' || aig_code AS ID,
              initCap(emp_last_name) || ', ' || initCap(emp_first_name) || ' (' || aig_code || ')' as title    	   
			 FROM #application.DB#.V_PERSONNEL
			 WHERE LOCATION_CODE IN (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#arguments.location_code#"/>)
			 ORDER BY EMP_LAST_NAME 
		</cfquery>
	   
	   <cfreturn qHQList />
	</cffunction>
	
	<!--- getAreaList() --->
	<cffunction name="getAreaList" returntype="any" access="public" output="false">
		 <cfset var qAreaList = "">
		 
		 <cfquery name="qAreaList" datasource="#this.I2MCon#">
			 	SELECT location_id,
				   'EPA.OIG|' || location_id || '|A|' || REPLACE(LOCATION_NAME,'U.S. EPA OIG - ','') AS ID, 
				   initCap(LTRIM(LOCATION_NAME)) as TITLE 
				FROM IGDBA.EMP_LOCATION
				WHERE VALID_FLG= 'Y'
					AND EXISTS (SELECT P.USERID FROM #application.DB#.V_PERSONNEL P WHERE P.LOCATION_CODE = location_id)
					AND LOCATION_ID <> 1
			  ORDER BY LOCATION_NAME 
		</cfquery>
	   
	   <cfreturn qAreaList />
	</cffunction>
	
	<!--- getLocalList() --->
	<cffunction name="getLocalList" returntype="any" access="public" output="false">
		 <cfargument name="location_code" required="yes" />
		 <cfset var qLocalList = "">
		 
		 <cfquery name="qLocalList" datasource="#this.I2MCon#">
			 SELECT 'EPA.'|| aig_code || '|' || userid || '|A|' || emp_last_name || '.' || emp_first_name || '|'  || jobposition || '|'  || location_city || '|' || emp_email || '|' || NVL(TO_CHAR(WORK_PHONE),'N/A')  || '|' || aig_code AS ID, 
              initCap(emp_last_name) || ', ' || initCap(emp_first_name) || ' (' || aig_code || ')' as title    	   
			 FROM #application.DB#.V_PERSONNEL
			 WHERE LOCATION_CODE IN (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#arguments.location_code#"/>)
			 ORDER BY EMP_LAST_NAME 
		</cfquery>
	   
	   <cfreturn qLocalList />
	</cffunction>
	
	<!--- getAttorneyList() --->
	<cffunction name="getAttorneyList" returntype="any" access="public" output="false">
		 <cfset var qAttorneyList = "">
		 
		 <cfquery name="qAttorneyList" datasource="#this.I2MCon#">
			 	SELECT ID || '|U|' || TITLE AS ID, 
			 				 initCap(TITLE ) as TITLE,
			 				 CODE 
				FROM #application.DB#.IV_REF_ATTORNEY_LIST
				WHERE VALID_FLAG = 'Y'
				ORDER BY CODE
		</cfquery>
	   
	   <cfreturn qAttorneyList />
	</cffunction>
	
	<!--- getLEOList() --->
	<cffunction name="getLEOList" returntype="any" access="public" output="false">
		 <cfset var qLEOList = "">
		 
		 <cfquery name="qLEOList" datasource="#this.I2MCon#">
			 	SELECT code || '|L|' || description AS ID, 
			 				 initCap(description) AS title,
			 				 code
				FROM #application.DB#.V_IV_JOINT_AGENCIES
				WHERE valid_flag = 'Y'
				ORDER BY DESCRIPTION
		</cfquery>
	   
	   <cfreturn qLEOList />
	</cffunction>
	
	<!--- getOtherList() --->
	<cffunction name="getOtherList" returntype="any" access="public" output="false">
		 <cfargument name="location_code" required="yes" />
		 <cfset var qOtherList = "">
		 
		 <cfquery name="qOtherList" datasource="#this.I2MCon#">
			 	SELECT userid || '|O|' || emp_last_name || '.' || emp_first_name AS ID, 
				   initCap(emp_last_name) || ', ' || initCap(emp_first_name) as title				   
			  FROM #application.DB#.V_PERSONNEL
			  WHERE LOCATION_CODE IN (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#arguments.location_code#"/>)
			  ORDER BY EMP_LAST_NAME 
		</cfquery>
	   
	   <cfreturn qOtherList />
	</cffunction>
	
		<!--- getEmailCampaignTypes() --->
	<cffunction name="getEmailCampaignTypes" returntype="any" access="public" output="false">
		 <cfset var qEmailCampaignTypes = "">
		 
		 <cfquery name="qEmailCampaignTypes" datasource="#this.I2MCon#">
			 	SELECT *
				FROM #application.DB#.IV_REF_EMAIL_TYPES
				WHERE valid_flag = 'Y'
				ORDER BY DESCRIPTION
		</cfquery>
	   
	   <cfreturn qEmailCampaignTypes />
	</cffunction>
	
</cfcomponent>