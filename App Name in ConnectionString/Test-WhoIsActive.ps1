﻿Invoke-Sqlcmd -ServerInstance .\sql2016 -query "exec sp_whoisactive" | Select-Object -Property program_name,start_time,session_id,status;