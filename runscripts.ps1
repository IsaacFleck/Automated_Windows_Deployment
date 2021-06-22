# -=-=-=-=-=-=-=-=- 
# Requirements  
# -=-=-=-=-=-=-=-=- 
# Powershell 7+ 
# Python 3 added to Path 
# -=-=-=-=-=-=-=-=- 

$StartTime = Get-Date
$tempfile = New-TemporaryFile
$CurrentDate = Get-Date -Format "yyyy-MM-dd"

$wd = Get-Location
Start-Transcript "$($wd)\logs\$($CurrentDate).txt" #Creates log file in the repo dir for debugging 
Function InstallRequirements {
    pip install -r .\requirements.txt
    Set-Location $PSScriptRoot    
}
Function UpdateRepo{
    Set-Location $wd
    git pull    
    Set-Location $PSScriptRoot
}

Function DigestMarkdown (){
    $scripts = @{}
    $md = ConvertFrom-Markdown -Path .\Readme.md 
    $md.Html | Out-File -Encoding utf8 $tempfile

    foreach ($line in Get-Content $tempfile){
        if ($line.StartsWith('<tr>')){
            $t = 1            
        }
        else{
            if ($line.StartsWith('<td>')){
                $n += 1
                if ($t -eq 1){
                    $clean = $line -replace '<[^>]+>',''
                }             
                if ($n -eq 1){
                    $kv = $clean
                }
                else {
                   $scripts.$kv = ($clean, 0) 
                }                
            }
        else {
            $t = 0
            $n = 0
            $kv = ''
        }
        }        
    }
    return $scripts    
}

UpdateRepo
InstallRequirements
$scriptstorun = DigestMarkdown

do{
    Foreach($s in $scriptstorun.GetEnumerator()){
        $CurrentTime = Get-Date -Format "HH:mm"
        if($s.Value[0] -eq "Daily"){
            if($s.Value[1] -eq 0){
                python .\scripts\$($s.Name)
                $s.Value[1] = "Completed at $CurrentTime"
                "The Script $($s.Name), configured to run *$($s.Value[0])* was ran at $Currenttime"  
            }
            else{
                continue
            }                        
        }  
        if($s.Value[1] -eq 0){
            python .\scripts\$($s.Name)
            $s.Value[1] = $CurrentTime            
        }
        if($s.Value[1] -notmatch "Completed at"){
            $scriptruninterval = $s.Value[0] 
            $scriptruntime = $s.Value[1]
            $difference = New-TimeSpan -Start $scriptruntime -End $CurrentTime
            $ts =  [timespan]::fromminutes($scriptruninterval)   
                if($difference -ge $ts){                    
                    python .\scripts\$($s.Name)
                    $s.Value[1] = $CurrentTime
                    "The script $($s.Name) was reran at $currenttime"
                }                
            }
        }
    Start-Sleep -Seconds 5    
} while ((get-date) -le ($StartTime.AddHours(8)))

Stop-Transcript