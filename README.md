# Automated Windows Deployment

This repo hosts the framework of a custom script deployment solution for the Windows enviroment. `runscripts.ps1` is designed to digest this MD file and extract the table below. Once extracted it runs the coorisponding script in the `.\scripts` folder at their defined frequency. Another function of the `runscripts.ps1` is to update the repository every day at the first run. 

This repo, paird with the windows 'Task Scheduler', allows developers to update the repoository `readme.md` file with the script name and the run frequency, add their script to the `.\scripts` folder and have their solution run every `x` minutes every day for 8 hours (defined in the `runscripts.ps1`)

## Active Scripts

Please populate the table below with scrips and the frequency they should run. the runscripts.ps1 will automatically pick up on the updated table and run the scripts on an automated job daily. The Powershell script will then run for 8 hours running each script listed below at the desired interval. 

|    File Name      | Run Frequency |
| ----------------- | ------------- |
|   HelloWorld.py   |       5       |

*Current supported frequency's: Daily, Every X Minutes (Represented wtih just a number)*

Please save these files in the .\scripts folder.

------
