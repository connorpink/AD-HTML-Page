import-module ActiveDirectory
Add-Type -AssemblyName PresentationCore,PresentationFramework
function GenerateFile {
    param(
      [Parameter(Mandatory = $true)]
      [String] $Accname
    )
    $Header = @"
    <style>
        body {
            background-color: #1c1813
        }
        .inLineText{
            display: flex;
            flex-direction: row;
            margin: 0;
        }
        div{
            display: flex;
            flex-direction: column;
            margin: 10vh;
        }
        h1 {
    
            font-family: 'Montserrat', sans-serif;
            color: #1ed760;
            font-size: 32px;
    
        }
    
        h2 {
    
            font-family: 'Montserrat', sans-serif;
            color: #ffffff;
            font-size: 19px;
    
        }
    
        h3 {
            font-family: 'Montserrat', sans-serif;
            color: #ffffff;
            font-size: 17px;
            margin-right:5px;
            font-weight: light;
        }
    
       table {
            font-size: 12px;
            border: 0px; 
            font-family: Arial, Helvetica, sans-serif;
        } 
        
        td {
            padding: 4px;
            margin: 0px;
            border: 0;
        }
        
        th {
            background: #395870;
            background: linear-gradient(#49708f, #293f50);
            color: #fff;
            font-size: 11px;
            text-transform: uppercase;
            padding: 10px 15px;
            vertical-align: middle;
        }
    
        tbody tr:nth-child(even) {
            background: #f0f0f2;
        }
        
        #CreationDate {
    
            font-family: Arial, Helvetica, sans-serif;
            color: #ff3300;
            font-size: 12px;
    
        }
    
        .StopStatus {
    
            color: #ff0000;
        }
        
      
        .RunningStatus {
    
            color: #008000;
        }
    
    </style>
    
"@
    
    $DesiredUser = $Accname
    
    $User_Desc = Get-ADUser -Identity $DesiredUser -Properties Description |
     Select-Object -ExpandProperty Description
    
    $User_Name = Get-ADUser -Identity $DesiredUser -Properties Name|
     Select-Object -ExpandProperty Name
    
     $User_Email = Get-ADUser -Identity $DesiredUser -Properties EmailAddress|
     Select-Object -ExpandProperty EmailAddress
    
     $User_FullName = Get-ADUser -Identity $DesiredUser -Properties DisplayName|
     Select-Object -ExpandProperty DisplayName
    
     $User_Department = Get-ADUser -Identity $DesiredUser -Properties Department|
     Select-Object -ExpandProperty Department
    
     $User_Company = Get-ADUser -Identity $DesiredUser -Properties Company|
     Select-Object -ExpandProperty Company
    
     $User_JobTitle = Get-ADUser -Identity $DesiredUser -Properties Title|
     Select-Object -ExpandProperty Title
    
     $User_Office = Get-ADUser -Identity $DesiredUser -Properties office|
     Select-Object -ExpandProperty office
    $htmlParams = @{
        Head = $Header 
        Title = "This is Description"
        Body = "<link rel='preconnect' href='https://fonts.googleapis.com'>
        <link rel='preconnect' href='https://fonts.gstatic.com' crossorigin>
        <link href='https://fonts.googleapis.com/css2?family=Montserrat&display=swap' rel='stylesheet'>
    
        <div> <h1>Generated by Corporate IT</h1>"
        PostContent = "<div class='inLineText'><h3>Username:  </h3> <h2>" + $User_Name + "</h2></div>" + 
        "<div class='inLineText'><h3>Email:  </h3> <h2> " + $User_Email + "</h2></div>" +
        "<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $User_FullName + "</h2></div>" +
        "<div class='inLineText'><h3>Description:  </h3> <h2> " + $User_Desc + "</h2></div>" +
        "<div class='inLineText'><h3>Department:  </h3> <h2> " + $User_Department + "</h2></div>"+
        "<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $User_JobTitle + "</h2></div>"+
        "<div class='inLineText'><h3>Company:  </h3> <h2> " + $User_Company+ "</h2></div>" +
        "<div class='inLineText'><h3>Office:  </h3> <h2> " + $User_Office+ "</h2></div>" +
        "</div> "
      }
    ConvertTo-Html @htmlParams |
    Out-File Show-User-Description.html
     
    Start-Process .\Show-User-Description.html  
    

    
  }

[void][system.reflection.assembly]::loadwithpartialname("System.Windows.Forms")

function Test-ADUser {
    param(
      [Parameter(Mandatory = $true)]
      [String] $sAMAccountName
    )
    $null -ne ([ADSISearcher] "(sAMAccountName=$sAMAccountName)").FindOne()
  }

Function Searching

{
    $Input = $SearchBox.Text
    if (Test-ADUser($Input)){
        GenerateFile($Input)
    }
    else {
        $WarningMessege = [System.Windows.MessageBox]::Show('Invalid User...                   ')
    }
}



$form1 = New-Object System.Windows.Forms.Form
$form1.ClientSize = "550,150"
$form1.StartPosition = "CenterScreen"
$form1.Text = "Searching For Users"

$Search = New-Object System.Windows.Forms.Label
$Search.Size = New-Object System.Drawing.size(140,40)
$Search.Location = New-Object System.Drawing.size(20,20)
$Search.Text = "Enter an Accounts Username:"

$SearchBox = New-Object System.Windows.Forms.TextBox
$SearchBox.Location = New-Object System.Drawing.Size(170,20)
$SearchBox.Size = New-Object System.Drawing.Size(240,70)

$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Text = "Search"
$SearchButton.Size = New-Object System.Drawing.Size(100,40)
$SearchButton.Location = New-Object System.Drawing.Size(420,20)

$SearchButton.Add_Click({Searching})



$form1.Controls.Add($Search)
$form1.Controls.Add($SearchBox)
$form1.Controls.Add($SearchButton)

$Input = $form1.ShowDialog()


