Clear-Host;
Write-Host "This program will configure your ab-av1 parameters.";
Write-Host "This program will ask several questions regarding your setups.";
Write-Host "Type according to the instructions given.`n";

$encChoose = Read-Host -Prompt "Please type A or B or C or D to choose either to use encoder:`n`n[A] SVT-AV1`n[B] H265`n[C] H264`n[D] AOM-AV1`n`nType neither to exit program.";
if     ($encChoose -eq "A") { $encoder = "libsvtav1"; }
elseif ($encChoose -eq "B") { $encoder = "libx265"; }
elseif ($encChoose -eq "C") { $encoder = "libx264"; }
elseif ($encChoose -eq "D") { $encoder = "libaom-av1"; }
else                        { Exit-PSHostProcess; }

Clear-Host;
$inputpath = Read-Host -Prompt "Please input video path.`n`nTIP: Just drag the video file to this windows terminal.";

Clear-Host;
$inputkeyint = Read-Host -Prompt "Please input keyframe integer.`n(Higher the value, the more coarse the video seeking, therefore resulting in lower file size.) and vice-versa";

Clear-Host;
$inputminvmaf = Read-Host -Prompt "input minimum VMAF score that ab-av1 app will use.`n(Higher the VMAF value, the more details it preserve, therefore bigger in file size.) and vice-versa";

Clear-Host;
if ($encChoose -eq "A") { 
    $speed = Read-Host -Prompt "Please input one value, 0 - 12 inclusive.`n(The higher the value, compression efficiency become lower, therefore faster time taken to encode.) and vice-versa";
}
elseif ($encChoose -eq "D") {
    $speed = Read-Host -Prompt "Please input one value, 0 - 8 inclusive.`n(The higher the value, compression efficiency become lower, therefore faster time taken to encode.) and vice-versa";
}
else {
    $choosespeed = Read-Host -Prompt "Please input either:`n`n[A] Very Slow`n[B] Slower`n[C] Slow`n[D] Medium`n[E] Fast`n[F] Faster`n[G] Very Fast`n[H] Super Fast`n`nEntering neither will defaulted to Ultra Fast.";
    if     ($choosespeed -eq "A") { $speed = "veryslow";}
    elseif ($choosespeed -eq "B") { $speed = "slower";}
    elseif ($choosespeed -eq "C") { $speed = "slow";}
    elseif ($choosespeed -eq "D") { $speed = "medium";}
    elseif ($choosespeed -eq "E") { $speed = "fast";}
    elseif ($choosespeed -eq "F") { $speed = "faster";}
    elseif ($choosespeed -eq "G") { $speed = "veryfast";}
    elseif ($choosespeed -eq "H") { $speed = "superfast";}
    else                          { $speed = "ultrafast";}
}

Clear-Host;
$omitvfilter = Read-Host -Prompt "Do you want to skip video filter?`n(Useful if you want to keep consistency around your encoding.) [y/n]";
if ($omitvfilter -eq "y") { Write-Host "Skipping video filter parameter..."; }
else {
    $inputframerate = Read-Host -Prompt "Please input frame rate of this video.`nTIP: It is a best practice to input integer like 30 or 60. Floating point like 23.976 is not recommended.";
}

# DETERMINE THE FINALE COMMAND IF USERS CHOSE THE LIBAOM-AV1
if ($encChoose -eq "D") {
    $finalecommand = "ab-av1 crf-search -e $encoder -i $inputpath --keyint $inputkeyint --min-vmaf $inputminvmaf --preset $speed --enc row-mt=1";
}
else {$finalecommand = "ab-av1 crf-search -e $encoder -i $inputpath --keyint $inputkeyint --min-vmaf $inputminvmaf --preset $speed";}


Clear-Host;
Write-Host "Your final combined commands is:";
if ($encChoose -eq "D") {
    if ($omitvfilter -eq "y") {
        Write-Host "$finalecommand";
    }
    else {
        $finalecommandwithvfilter = "$finalecommand --vfilter 'fps=$inputframerate'"; 
        Write-Host $finalecommandwithvfilter;
    }
}
else {
    if ($omitvfilter -eq "y") {
        Write-Host "$finalecommand";
    }
    else {
        $finalecommandwithvfilter = "$finalecommand --vfilter 'fps=$inputframerate'"; 
        Write-Host $finalecommandwithvfilter;
}
}








$fPth=Read-Host -Prompt "Drag & drop video file here, and press ENTER";Start-Transcript -Path $fPth -Append;$cqArr=@(21,22,23,24,25);foreach($cqVal in $cqArr){ab-av1 sample-encode -e libsvtav1 -i $fPth --crf $cqVal --preset 8 --samples 3 --vfilter "fps=30"};Stop-Transcript;