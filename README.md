## Cecil Hotel Data Mart

### Background
This project was completed as part of a data warehousing course I took in the fall of 2022. I created an OLTP database for the course using fictional data, then created a data mart into which the data from the OLTP was loaded. The ETL was created in Visual Studio, and all documents have been linked to the VS solution.

### Required Software
- SQL Server
- Visual Studio

### How to Use
The OLTP database is stored as a .bak file and should be restored to SQL Server. I also included the build script and generated data for the OLTP if you prefer that method. Once restored, open the VS file and navigate to the CecilDMETL SSIS package and open the .dtsx file. Run the ETL and the data mart should be successfully generated and populated with data. For more information on the project, open the development plan, object worksheet or star schema. Also included is a Power Pivot file with a cursory analysis, as well as a PowerBI report. Unfortunately, PowerBI files cannot be opened from a VS solution, and therefore it must be opened from the directory.

### Thanks for stopping by!
