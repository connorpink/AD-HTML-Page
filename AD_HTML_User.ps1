import-module ActiveDirectory
Add-Type -AssemblyName PresentationCore, PresentationFramework

while ($null -eq $domain.name){
    if($cred = $host.ui.PromptForCredential('Need credentials', 'Please enter your user name and password.',
    'PRHC01\', "SYSTEM\Administrator")){}else{exit}
    $username = $cred.username
    try{$password = $cred.GetNetworkCredential().password} catch{}

    # Get current domain using logged-on user's credentials
    $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
    $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)
}

Function DarkMode{
    $grey = '#484848' 
    $black = '#2b2a2a' 
    $white = '#ffffff'
    $form1.BackColor = $black
    $Search.ForeColor = $white
    $SearchBox.BackColor = $grey
    $SearchBox.ForeColor = $white
    $SearchButton.ForeColor = $white
    $CompareSearch.ForeColor = $white
    $CompareBox.ForeColor = $white
    $CopyExistingUserBox.ForeColor = $white
    $CopyNetNewUserBox.ForeColor = $white
    $CopyOverwriteGroupsBox.ForeColor = $white
    $CopyOverwritePropertiesBox.ForeColor = $white
    $CopyDeleteFileBox.ForeColor = $white
    $CompareSearch.ForeColor = $white
    $CompareSearchBox.BackColor = $grey
    $CompareSearchBox.ForeColor = $white
    $CopyFirstName.ForeColor = $white
    $CopyFirstNameBox.BackColor = $grey
    $CopyFirstNameBox.ForeColor = $white
    $CopyLastName.ForeColor = $white
    $CopyLastNameBox.BackColor = $grey
    $CopyLastNameBox.ForeColor = $white
    $CopyUserName.ForeColor = $white
    $CopyUserNameBox.BackColor = $grey
    $CopyUserNameBox.ForeColor = $white
    $darkButtonBox.ForeColor = $white

    $GroupTree1.ForeColor = $white
    $GroupTree2.ForeColor = $white

}
Function LightMode{
    $black = '#202020' 
    $white = '#ffffff'
    $offWhite = '#f0f0f0'
    $form1.BackColor = $offWhite
    $Search.ForeColor = $black
    $SearchBox.BackColor = $white
    $SearchBox.ForeColor = $black
    $SearchButton.ForeColor = $black
    $CompareSearch.ForeColor = $black
    $CompareBox.ForeColor = $black
    $CopyExistingUserBox.ForeColor = $black
    $CopyNetNewUserBox.ForeColor = $black
    $CopyOverwriteGroupsBox.ForeColor = $black
    $CopyOverwritePropertiesBox.ForeColor = $black
    $CopyDeleteFileBox.ForeColor = $black
    $CompareSearch.ForeColor = $black
    $CompareSearchBox.BackColor = $white
    $CompareSearchBox.ForeColor = $black
    $CopyFirstName.ForeColor = $black
    $CopyFirstNameBox.BackColor = $white
    $CopyFirstNameBox.ForeColor = $black
    $CopyLastName.ForeColor = $black
    $CopyLastNameBox.BackColor = $white
    $CopyLastNameBox.ForeColor = $black
    $CopyUserName.ForeColor = $black
    $CopyUserNameBox.BackColor = $white
    $CopyUserNameBox.ForeColor = $black
    $darkButtonBox.ForeColor = $black

    $GroupTree1.ForeColor = $black
    $GroupTree2.ForeColor = $black
}
#function to take the information about the requested user and generate the html code to display the user
function GenerateFile {
    param(
        [Parameter(Mandatory = $true)]
        [String] $Accname
    )
    #CSS code for the HTML file
    $Header = @"
    <style>
        body {
            background-color: #27323B;
            font-family: 'Montserrat', sans-serif;
        }
        .inLineText{
            display: flex;
            flex-direction: row;
            margin: 0;
        }
        div{
            display: flex;
            flex-direction: row;
            margin: 10vh;
            margin-top: 2vh;
        }
        .table{
            margin: 0;
            top:0px;
            position: relative;
        }
        .allInfo{
            display: flex;
            flex-direction:  column;
            justify-content: center;
        }
        .info{
            margin: 0;
            margin-right: 1vh;
            display:flex;
            flex-direction: column;
        }
        .title{
            margin: 0;
            margin-top:10vh;
            margin-left: 10vh;
        }
        h1 {
    
            font-family: 'Montserrat', sans-serif;
            color: #4283b9;
            font-size: 32px;
    
        }
    
        h2 {
    
            font-family: 'Montserrat', sans-serif;
            color: #b1d3f0;
            font-size: 19px;
    
        }
    
        h3 {
            font-family: 'Montserrat', sans-serif;
            color: #b1d3f0;
            font-size: 17px;
            margin-right:5px;
            font-weight: light;
        }
        
        #CreationDate {
            color: #ff3300;
            font-size: 12px;
    
        }
        
        .styled-table {
            border-collapse: collapse;
            margin: 25px 0;
            font-size: 0.9em;
            min-width: 400px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
            border-radius: 3px;
        }

        .styled-table thead tr {
            background-color: #4283b9;
            color: #ffffff;
            text-align: left;
        }

        .styled-table th,
        .styled-table td {
            padding: 12px 15px;
        }

        .styled-table tbody tr {
            border-bottom: 1px solid #dddddd;
        }


        .styled-table tbody tr:nth-of-type(odd) {
            background-color: #ffffff;
        }
        .styled-table tbody tr:nth-of-type(even) {
            background-color: #f7f7f7;
            
        }

        .styled-table tbody tr:last-of-type {
            border-bottom: 2px solid;
        }

            
        .header {
            display: block;
            overflow: hidden;
            background-color: #f1f1f1;
            padding: 0px 0px;
            margin: 0;
            padding: 1vh;
            border-radius: 10px;
          }
          
          /* Style the logo link (notice that we set the same value of line-height and font-size to prevent the header to increase when the font gets bigger */
        .header a {
            padding 5vh;
           margin-top: auto;
           margin-bottom: auto;
            font-size: 40px;
            font-weight: bold;
            color: #4283b9;
            
        }
          
        .header-right {
            margin: auto;
            float: none;
            font-weight: bold;
            font-size: 30px;
            color: black;
            }

         .active {
            margin-top: auto;
            margin-bottom: auto;
            colour: black;
            float: center;
            }
        }
    </style>
    
"@
    #take the requested username and reassign the variable
    $DesiredUser = $Accname
    
    
    #querry the users information from Active Directory

    try {
        $User_Desc = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties Description |
        Select-Object -ExpandProperty Description
    }
    catch {

    }
    try {
        $User_Name = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties Name |
        Select-Object -ExpandProperty Name
    }
    catch {

    }
    try {
        $User_Email = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties EmailAddress |
        Select-Object -ExpandProperty EmailAddress
    }
    catch {

    }
    try {
        $User_FullName = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties DisplayName |
        Select-Object -ExpandProperty DisplayName
    }
    catch {

    }
    try {
        $User_Department = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties Department |
        Select-Object -ExpandProperty Department
    }
    catch {

    }
    try {
        $User_Company = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties Company |
        Select-Object -ExpandProperty Company
    }
    catch {

    }
    try {
        $User_JobTitle = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties Title |
        Select-Object -ExpandProperty Title
    }
    catch {

    }  try {
        $User_Office = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties office |
        Select-Object -ExpandProperty office
    }
    catch {

    }  try {
        $User_Phone = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties telephoneNumber |
        Select-Object -ExpandProperty telephoneNumber
    }
    catch {
   
    }  try {
        $User_ManagerTemp = Get-ADUser -Credential $cred -Identity $DesiredUser -Properties Manager |
        Select-Object -ExpandProperty Manager
    }
    catch {

    }  try {
        $User_Manager = Get-ADUser -Credential $cred -Identity $User_ManagerTemp -Properties DisplayName |
        Select-Object -ExpandProperty DisplayName
    }
    catch {

    }
     
    $Groups = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $DesiredUser | Select-Object Name 

    $assignToPostContent += "<div class='allInfo'>"
    if ($User_Name) { $assignToPostContent += "<div class = 'info'><div class='inLineText'><h3>Username:  </h3> <h2>" + $User_Name + "</h2></div>" }
    if ($User_Email) { $assignToPostContent += "<div class='inLineText'><h3>Email:  </h3> <h2> " + $User_Email + "</h2></div>" }
    if ($User_Phone) { $assignToPostContent += "<div class='inLineText'><h3>Phone Number:  </h3> <h2> " + $User_Phone + "</h2></div>" }
    if ($User_FullName) { $assignToPostContent += "<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $User_FullName + "</h2></div>" }
    if ($User_Desc) { $assignToPostContent += "<div class='inLineText'><h3>Description:  </h3> <h2> " + $User_Desc + "</h2></div>" }
    if ($User_Department) { $assignToPostContent += "<div class='inLineText'><h3>Department:  </h3> <h2> " + $User_Department + "</h2></div>" }
    if ($User_JobTitle) { $assignToPostContent += "<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $User_JobTitle + "</h2></div>" }
    if ($User_Company) { $assignToPostContent += "<div class='inLineText'><h3>Company:  </h3> <h2> " + $User_Company + "</h2></div>" }
    if ($User_Office) { $assignToPostContent += "<div class='inLineText'><h3>Office:  </h3> <h2> " + $User_Office + "</h2></div>" }
    if ($User_Manager) { $assignToPostContent += "<div class='inLineText'><h3>Manager:  </h3> <h2> " + $User_Manager + "</h2></div></div>" }

    $assignToPostContent += "<div class='table'>
	<table class = 'styled-table'>
		<thead>
			<tr>
				<th>Security Groups on User</th>
			</tr>
		</thead>
    <tbody>
    "
    foreach ($g in $Groups.GetEnumerator() ) {
        #Write-Host $g.name
        $nameOfGroup = $g.name
        $assignToPostContent += "
                <tr>
                    <td>$nameOfGroup</td>
                </tr>
                
            "
    }

    $assignToPostContent += "
            </tbody>
        </table></div>
    "
    $assignToPostContent += "</div>"
    #Create the hashtable that will structure the html page
    $htmlParams = @{
        Head        = $Header + "<link rel='preconnect' href='https://fonts.googleapis.com'>
        <link rel='preconnect' href='https://fonts.gstatic.com' crossorigin>
        <link href='https://fonts.googleapis.com/css2?family=Montserrat&display=swap' rel='stylesheet'>"
        Title       = "This is Description" 
    
        
        Body        = "

        <div class='header'>
        <a class='logo'>PRHC</a>
        <div class='header-right'>
         <a class='active'>Generated by I.T.</a>
        </div>
        </div>"
        PostContent = $assignToPostContent
        
    }
    
    #convert code to html file
    ConvertTo-Html @htmlParams |
    Out-File $env:USERPROFILE/AppData\Local\Temp\Show-User-Description.html
    #open the html file
    Start-Process $env:USERPROFILE/AppData\Local\Temp\Show-User-Description.html

    #remove the file if box is checked 
    if ($CopyDeleteFileBox.Checked = $true)
    {
        Start-Sleep -s 5
        Remove-Item $env:USERPROFILE/AppData\Local\Temp\Show-User-Description.html -Force
    }
}

#functions to generate the file for the compare users functionality
function GenerateFileCompare {                                 
    param(
        [Parameter(Mandatory = $true)]
        [String] $FirstUser,
        [Parameter(Mandatory = $true)]
        [String] $SecondUser
    )
    #CSS code for the HTML file
    $Header = @"
    <style>
    body {
        background-color: #27323B;
        font-family: 'Montserrat', sans-serif;
    }
    .inLineText{
        display: flex;
        flex-direction: row;
        margin: 0;
    }
    div{
        
        flex-direction: row;
        
        flex-wrap: wrap;
    }
    .table1{
        margin: 0;
        position: relative;
        float: right;
        
    }
    .table2{
        margin: 0;
        position: relative;
        float: left;
        
    }
    .allTables {
        display: flex;
        flex-direction: row;
        justify-content: center;
        
    }
    .info{
        margin: 0;
        margin-right: 1vh;
        display:flex;
        flex-direction: column;
    }
    .allInfo{
        display: flex;
        justify-content: center;
    }
    .title{
        margin: 0;
        margin-top:10vh;
        margin-left: 10vh;
    }
    h1 {

        font-family: 'Montserrat', sans-serif;
        color: #4283b9;
        font-size: 32px;

    }

    h2 {

        font-family: 'Montserrat', sans-serif;
        color: #b1d3f0;
        font-size: 19px;

    }

    h3 {
        font-family: 'Montserrat', sans-serif;
        color: #b1d3f0;
        font-size: 17px;
        margin-right:5px;
        font-weight: light;
    }
    
    #CreationDate {
        color: #ff3300;
        font-size: 12px;

    }
    
    .styled-table {
        border-collapse: collapse;
        margin: 25px 0;
        font-size: 0.9em;
        min-width: 400px;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
        border-radius: 3px;
        table-layout:fixed
    }

    .styled-table thead tr {
        background-color: #4283b9;
        color: #ffffff;
        text-align: left;
    }

    .styled-table th,
    .styled-table td {
        padding: 12px 15px;
    }

    .styled-table tbody tr {
        border-bottom: 1px solid #dddddd;
    }

    .bad {
        background-color: #f7aaad;
    }
   .good {
        background-color: #a3f9c0;
        
    }
    
    .styled-table tbody tr:last-of-type {
        border-bottom: 2px solid;
    }

    .allInfo {
        display: flex;
        flex-direction: row
        flex-wrap: wrap;
    }
    .firstUser {
        
        display: flex;
        flex-direction: column;
        float: left;
        margin: 1vh;
        flex-grow; 1;
    } 
    .secondUser{
        
        display: flex;
        flex-direction: column;
        float right;
        margin: 1vh;
        flex-grow; 1;
    }
    .header {
        display: block;
        overflow: hidden;
        background-color: #f1f1f1;
        padding: 0px 0px;
        margin: 0;
        padding: 1vh;
        border-radius: 10px;
      }
      
      /* Style the logo link (notice that we set the same value of line-height and font-size to prevent the header to increase when the font gets bigger */
    .header a {
       margin-top: auto;
       margin-bottom: auto;
        font-size: 40px;
        font-weight: bold;
        color: #4283b9;
        
    }
      
    .header-right {
        margin: auto;
        float: none;
        font-weight: bold;
        font-size: 30px;
        color: black;
        }

     .active {
        margin-top: auto;
        margin-bottom: auto;
        font-size: 30px;
        float: center;
        }
    
</style>
    
"@
    
    
    #querry the users information from Active Directory for the First User
    try {
        $First_User_Desc = Get-ADUser -Credential $cred -Identity $FirstUser -Properties Description |
        Select-Object -ExpandProperty Description
    }
    catch {

    } try {
        $First_User_Name = Get-ADUser -Credential $cred -Identity $FirstUser -Properties Name |
        Select-Object -ExpandProperty Name
    }
    catch {

    } try {
        $First_User_Email = Get-ADUser -Credential $cred -Identity $FirstUser -Properties EmailAddress |
        Select-Object -ExpandProperty EmailAddress
    }
    catch {

    } try {
        $First_User_FullName = Get-ADUser -Credential $cred -Identity $FirstUser -Properties DisplayName |
        Select-Object -ExpandProperty DisplayName
    }
    catch {

    } try {
        $First_User_Department = Get-ADUser -Credential $cred -Identity $FirstUser -Properties Department |
        Select-Object -ExpandProperty Department
    }
    catch {

    } try {
        $First_User_Company = Get-ADUser -Credential $cred -Identity $FirstUser -Properties Company |
        Select-Object -ExpandProperty Company
    }
    catch {

    } try {
        $First_User_JobTitle = Get-ADUser -Credential $cred -Identity $FirstUser -Properties Title |
        Select-Object -ExpandProperty Title
    }
    catch {

    } try {
        $First_User_Office = Get-ADUser -Credential $cred -Identity $FirstUser -Properties office |
        Select-Object -ExpandProperty office
    }
    catch {

    } try {
        $First_User_Phone = Get-ADUser -Credential $cred -Identity $FirstUser -Properties telephoneNumber |
        Select-Object -ExpandProperty telephoneNumber
    }
    catch {

    } try {
        $First_User_ManagerTemp = Get-ADUser -Credential $cred -Identity $FirstUser -Properties Manager |
        Select-Object -ExpandProperty Manager
    }
    catch {

    } try {
        $First_User_Manager = Get-ADUser -Credential $cred -Identity $First_User_ManagerTemp -Properties DisplayName |
        Select-Object -ExpandProperty DisplayName
    }
    catch {

    }
    # $First_Groups = Get-ADPrincipalGroupMembership -Identity $FirstUser | Select-Object Name 

    #Second User CODE ------------------
    #querry the users information from Active Directory for the First User
    #$assignToPostContent += "<div class = 'secondUser'>"
    
    try {
        $Second_User_Desc = Get-ADUser -Credential $cred -Identity $SecondUser -Properties Description |
        Select-Object -ExpandProperty Description
    }
    catch {

    } try {

        $Second_User_Name = Get-ADUser -Credential $cred -Identity $SecondUser -Properties Name |
        Select-Object -ExpandProperty Name
    }
    catch {

    } try {

        $Second_User_Email = Get-ADUser -Credential $cred -Identity $SecondUser -Properties EmailAddress |
        Select-Object -ExpandProperty EmailAddress
    }
    catch {

    } try {

        $Second_User_FullName = Get-ADUser -Credential $cred -Identity $SecondUser -Properties DisplayName |
        Select-Object -ExpandProperty DisplayName
    }
    catch {

    } try {

        $Second_User_Department = Get-ADUser -Credential $cred -Identity $SecondUser -Properties Department |
        Select-Object -ExpandProperty Department
    }
    catch {

    } try {

        $Second_User_Company = Get-ADUser -Credential $cred -Identity $SecondUser -Properties Company |
        Select-Object -ExpandProperty Company
    }
    catch {

    } try {

        $Second_User_JobTitle = Get-ADUser -Credential $cred -Identity $SecondUser -Properties Title |
        Select-Object -ExpandProperty Title
    }
    catch {

    } try {

        $Second_User_Office = Get-ADUser -Credential $cred -Identity $SecondUser -Properties office |
        Select-Object -ExpandProperty office
    }
    catch {

    } try {

        $Second_User_Phone = Get-ADUser -Credential $cred -Identity $SecondUser -Properties telephoneNumber |
        Select-Object -ExpandProperty telephoneNumber
    }
    catch {

    } try {

        $Second_User_ManagerTemp = Get-ADUser -Credential $cred -Identity $SecondUser -Properties Manager |
        Select-Object -ExpandProperty Manager
    }
    catch {

    } try {

        $Second_User_Manager = Get-ADUser -Credential $cred -Identity $Second_User_ManagerTemp -Properties DisplayName |
        Select-Object -ExpandProperty DisplayName
    }
    catch {

    }
    
    # $Second_Groups = Get-ADPrincipalGroupMembership -Identity $SecondUser | Select-Object Name 
    
    $assignToPostContent += "<div class = 'allInfo'>"
    $assignToPostContent += "<div class = 'firstUser'>"

    $assignToPostContent += "<div class = 'info'>"
    if ($First_User_Name) { $assignToPostContent += "<div class='inLineText'><h3>Username:  </h3> <h2>" + $First_User_Name + "</h2></div>" }
    if ($First_User_Email) { $assignToPostContent += "<div class='inLineText'><h3>Email:  </h3> <h2> " + $First_User_Email + "</h2></div>" }
    if ($First_User_Phone) { $assignToPostContent += "<div class='inLineText'><h3>Phone Number:  </h3> <h2> " + $First_User_Phone + "</h2></div>" }
    if ($First_User_FullName) { $assignToPostContent += "<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $First_User_FullName + "</h2></div>" }
    if ($First_User_Desc) { $assignToPostContent += "<div class='inLineText'><h3>Description:  </h3> <h2> " + $First_User_Desc + "</h2></div>" }
    if ($First_User_Department) { $assignToPostContent += "<div class='inLineText'><h3>Department:  </h3> <h2> " + $First_User_Department + "</h2></div>" }
    if ($First_User_JobTitle) { $assignToPostContent += "<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $First_User_JobTitle + "</h2></div>" }
    if ($First_User_Company) { $assignToPostContent += "<div class='inLineText'><h3>Company:  </h3> <h2> " + $First_User_Company + "</h2></div>" }
    if ($First_User_Office) { $assignToPostContent += "<div class='inLineText'><h3>Office:  </h3> <h2> " + $First_User_Office + "</h2></div>" }
    if ($First_User_Manager) { $assignToPostContent += "<div class='inLineText'><h3>Manager:  </h3> <h2> " + $First_User_Manager + "</h2></div>" }
    $assignToPostContent += "</div>" #close info tag

    $assignToPostContent += "</div>"    # for first user close div
    $assignToPostContent += "<div class = 'secondUser'>"    # for first user close div

    $assignToPostContent += "<div class = 'info'>"
    if ($Second_User_Name) { $assignToPostContent += "<div class='inLineText'><h3>Username:  </h3> <h2>" + $Second_User_Name + "</h2></div>" }
    if ($Second_User_Email) { $assignToPostContent += "<div class='inLineText'><h3>Email:  </h3> <h2> " + $Second_User_Email + "</h2></div>" }
    if ($Second_User_Phone) { $assignToPostContent += "<div class='inLineText'><h3>Phone Number:  </h3> <h2> " + $Second_User_Phone + "</h2></div>" }
    if ($Second_User_FullName) { $assignToPostContent += "<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $Second_User_FullName + "</h2></div>" }
    if ($Second_User_Desc) { $assignToPostContent += "<div class='inLineText'><h3>Description:  </h3> <h2> " + $Second_User_Desc + "</h2></div>" }
    if ($Second_User_Department) { $assignToPostContent += "<div class='inLineText'><h3>Department:  </h3> <h2> " + $Second_User_Department + "</h2></div>" }
    if ($Second_User_JobTitle) { $assignToPostContent += "<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $Second_User_JobTitle + "</h2></div>" }
    if ($Second_User_Company) { $assignToPostContent += "<div class='inLineText'><h3>Company:  </h3> <h2> " + $Second_User_Company + "</h2></div>" }
    if ($Second_User_Office) { $assignToPostContent += "<div class='inLineText'><h3>Office:  </h3> <h2> " + $Second_User_Office + "</h2></div>" }
    if ($Second_User_Manager) { $assignToPostContent += "<div class='inLineText'><h3>Manager:  </h3> <h2> " + $Second_User_Manager + "</h2></div>" }
    $assignToPostContent += "</div>" #close info tag

    $assignToPostContent += "</div>" #for second user div
    $assignToPostContent += "</div>" #for All info div
    
    
    
    $assignToPostContent += "<div class ='allTables'>" #for all tables div
    $assignToPostContent += "<div class='table1'>
	<table class = 'styled-table'>
		<thead>
			<tr>
				<th>Member of for User</th>
			</tr>
		</thead>
    <tbody>
    "
    #FOR JAX DON'T TOUCH 
    $FirstUserList = @()
    $SecondUserList = @()
    
    $FirstUserNotEqual = @()
    
    $SecondUserNotEqual = @()
    
    
    $d = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $FirstUser | Select-Object Name
    Foreach ($y IN $d) {
        $FirstUserList += $y.name
    }

    $e = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $SecondUser | Select-Object Name
    Foreach ($y IN $e) {
        $SecondUserList += $y.name
    }
    $FirstUserList | ForEach-Object {
        if ($SecondUserList -notcontains $_) {
            $SecondUserNotEqual += $_
        }
    }
    
    
    $SecondUserList | ForEach-Object {
        if ($FirstUserList -notcontains $_) {
            $FirstUserNotEqual += $_
        }
    }

    $FirstUserList | Sort-Object
    $SecondUserList | Sort-Object

    $newFirstUserList = @()
    $newSecondUserList = @()

    foreach ($x in $FirstUserList) {
        foreach ($y in $SecondUserList) {
            if ($x -eq $y) {
                $newFirstUserList += $x
                $newSecondUserList += $x
                

            }
        }
    }
    
        
    $newFirstUserList = $newFirstUserList + $FirstUserNotEqual
    
    
    $newSecondUserList = $newSecondUserList + $SecondUserNotEqual  

    #foreach ($g in $Second_Groups.GetEnumerator() )
    foreach ($g in $newSecondUserList) {
        if ($SecondUserNotEqual -contains $g) {
            $nameOfGroup = $g
    
            
            $assignToPostContent += "
            <tr class = 'bad'>
                <td>$nameOfGroup</td>
            </tr>
        "
        }
        else {
            #Write-Host $g.name
            $nameOfGroup = $g
            $assignToPostContent += "
               <tr class = 'good'>
                   <td>$nameOfGroup</td>
               </tr>
               
           "
        }
    }

    $assignToPostContent += "
            </tbody>
        </table></div>
    "#close table div^
    


    $assignToPostContent += "<div class='table2'>
    <table class = 'styled-table'>
    <thead>
        <tr>
            <th>Member of for User</th>
        </tr>
    </thead>
    <tbody>
    "
    #foreach ($g in $First_Groups.GetEnumerator() )
    foreach ($g in $newFirstUserList) {
        #Write-Host $g.name
        if ($FirstUserNotEqual -contains $g) {
            $nameOfGroup = $g

            $assignToPostContent += "
                <tr class = 'bad'>
                    <td>$nameOfGroup</td>
                </tr>
            "
        }
        else {
            $nameOfGroup = $g
            $assignToPostContent += "
                <tr class = 'good'>
                    <td>$nameOfGroup</td>
                </tr>
            "
        }
    }

    $assignToPostContent += "
        </tbody>
    </table></div>
    "#close table div^
    
    


    
    #Create the hashtable that will structure the html page
    $htmlParams = @{
        Head        = $Header + "<link rel='preconnect' href='https://fonts.googleapis.com'>
        <link rel='preconnect' href='https://fonts.gstatic.com' crossorigin>
        <link href='https://fonts.googleapis.com/css2?family=Montserrat&display=swap' rel='stylesheet'>"
        Title       = "This is Description" 
    
        Body        = "
        <div class='header'>
        <a class='logo'>PRHC</a>
        <div class='header-right'>
        <a class='active'>Generated by I.T.</a>
        </div>
        </div>"

        PostContent = $assignToPostContent
    }
    
    #convert code to html file
    ConvertTo-Html @htmlParams |
    Out-File $env:USERPROFILE/AppData\Local\Temp\Show-User-Description.html
    #open the html file
    Start-Process $env:USERPROFILE/AppData\Local\Temp\Show-User-Description.html

    #remove file if box is checked
    if ($DeleteBox.Checked -eq $true)
    {
        Start-Sleep -s 10
        Remove-Item $env:USERPROFILE/AppData\Local\Temp\Show-User-Description.html -Force
    }
}


[void][system.reflection.assembly]::loadwithpartialname("System.Windows.Forms")
#function to see if the requested user exists in AD 
function Test-ADUser {
    param(
        [Parameter(Mandatory = $true)]
        [String] $sAMAccountName
    )

    try {
        Get-ADUser -Identity $sAMAccountName
        $UserExists = $true
    }
    catch {
        $UserExists = $false
    }
    return $UserExists
}


#function  to run the Test-ADUser and GenerateFile  functions. Throw an error if user does not exist.
Function Searching {
    #if group tree is selected
    if ($null -ne $selectedTree)
    {

        #if copying user 
        if ($CopyExistingUserBox.Checked -eq $true) {
            $oldUser = $SearchBox.Text
            $newUserUserName = $CopyUserNameBox.Text

            #net new user
            if ($CopyNetNewUserBox.Checked -eq $true) {
                if (Test-ADUser($oldUser)) {
                    if (Test-ADUser($newUserUserName)) {
                        [System.Windows.MessageBox]::Show('Attempted net new user already exists')
                    }
                    else{

                        $title    = 'Net New User'
                        $question = 'Are you sure you want to proceed with Net New User Creation?'

                        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
                        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
                        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

                        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
                        if ($decision -eq 0) { 
                            $newUserFirstName = $CopyFirstNameBox.Text
                            $newUserLastName = $CopyLastNameBox.Text
                            
                            #generate email
                            $newUserEmail = $newUserUserName + "@prhc.on.ca"
                            #generate displayName
                            $newUserDisplayName = $newUserLastName + ", " + $newUserFirstName
                            
                            #retrieve info from oldUser such as description, department, member of,  security... etc 
                            $user = Get-ADUser $oldUser -Credential $cred -Properties Department, Description, Manager, MemberOf, Office, Organization, ProfilePath, Title, Company
                            
                            #create new user with firstName, lastName, userName, email and everything else
                            
                            New-ADUser -Credential $cred -Name $newUserUserName -UserPrincipalName $newUserUserName -DisplayName $newUserDisplayName -AccountPassword (ConvertTo-SecureString -AsPlainText "password" -force) -ChangePasswordAtLogon $true -GivenName $newUserFirstName -Surname $newUserLastName -EmailAddress $newUserEmail -Instance $user

                            #change new user OU location

                            $UserDN = (Get-ADUser -Credential $cred -Identity $oldUser).distinguishedName

                            $TargetOU = $UserDN.Substring($UserDN.IndexOf('OU='))
                            $UserDN2 = (Get-ADUser -Credential $cred -Identity $newUserUserName).distinguishedName

                            Move-ADObject  -Credential $cred -Identity $UserDN2  -TargetPath $TargetOU 

                            #Copy Groups over
                            $d = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $oldUser | Select-Object Name
                            Foreach ($g IN $d) {
                                if ($g.name -ne 'Domain Users') {
                                    try {
                                        Add-ADGroupMember -Server $selectedTree -Credential $cred -Identity $g.name -Members $newUserUserName
                                    }
                                    catch {
                                        $counter += 1
                                    }
                                }
                            }

                            
                            #small method to ensure that the new AD account exists and is online before trying to generate the account 
                            

                            $CheckArray = @()

                            [System.Windows.MessageBox]::Show('Success')
                            while ($CheckArray.Length -ne ($d.Length - $counter)) { 
                                try{
                                $CheckArray = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $newUserUserName | Select-Object Name
                                }
                                catch{
                                    
                                }
                                Start-Sleep -Seconds 2
                            }
                            
                            #At the end generate a file of a comparison of new user compared to old user
                            #to show that new user is idenitical to old
                            GenerateFileCompare $oldUser $newUserUserName
                        }
                    }
                }
                else {
                    [System.Windows.MessageBox]::Show('User copying from does not exist')
                }
            }
            # Check if overwrite member of groups box is checked 
            Elseif ($CopyOverwriteGroupsBox.Checked -eq $true) {

                #Check if overwrite member of groups box is checked and if overwrite properties is checked
                if ($CopyOverwritePropertiesBox.Checked -eq $true) {
                    #if old user exists
                    if (Test-ADUser($oldUser)) {
                        #if new user exists
                        if (Test-ADUser($newUserUserName)) {
                            $title    = 'Overwrite Member of groups and properties'
                            $question = 'Are you sure you want to proceed?'

                            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
                            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
                            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

                            $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
                            if ($decision -eq 0) {
        
                                #add functionality here ---------------
                                $oldUser = $SearchBox.Text
                            
                                $existingUserUserName = $CopyUserNameBox.Text
                            
                                #remove old groups?
                                Get-AdPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $existingUserUserName | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $existingUserUserName -Confirm: $false
                            
                                #retrieve info from oldUser such as description, department, member of,  security... etc 
                                $user = Get-ADUser $oldUser -Credential $cred -Properties Department, Description, Manager, Title, office, organization, telephonenumber, Company
                            
                                #modify eisting user information using $existingUserUserName
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Description $user.Description} Catch{}
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Department $user.Department} Catch{}
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Manager $user.Manager} Catch{}
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Title $user.Title} Catch{}
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -office $user.office} Catch{}
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -organization $user.organization} Catch{}
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -telephonenumber $user.telephonenumber} Catch{}
                                try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Company $user.Company} Catch{}
                                

                                
            
                                #Copy Groups over
                                $d = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $oldUser | Select-Object Name
                                Foreach ($g IN $d) {
                                    if ($g.name -ne 'Domain Users') {
                                        try {
                                            Add-ADGroupMember -Server $selectedTree -Credential $cred -Identity $g.name -Members $existingUserUserName
                                        }
                                        catch {
                                            $counter += 1
                                        }
                                    }
                                }
            
                                #change new user OU location
            
                                $UserDN = (Get-ADUser -Credential $cred -Identity $oldUser).distinguishedName
            
                                $TargetOU = $UserDN.Substring($UserDN.IndexOf('OU='))
                                $UserDN2 = (Get-ADUser -Credential $cred -Identity $ExistingUserUserName).distinguishedName
            
                                Move-ADObject  -Credential $cred -Identity $UserDN2  -TargetPath $TargetOU 
            
                            
                                #At the end generate a file of a comparison of new user compared to old user
                                #to show that new user is idenitical to old
            
        
            
                                $CheckArray = @()
            
                                [System.Windows.MessageBox]::Show('Success')
                                while ($CheckArray.Length -ne ($d.Length - $counter)) { 

                                    try{$CheckArray = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $existingUserUserName | Select-Object Name} catch{}
                                    Start-Sleep -Seconds 2
                                }
            
            
                                #Start-Sleep -s 17
                                GenerateFileCompare $oldUser $newUserUserName
                            }
                        }
                        #new user  does not exist
                        else {
                            [System.Windows.MessageBox]::Show('User copying to does not exist')
                        }
                    }
                    #old user does not exist
                    else {
                        [System.Windows.MessageBox]::Show('User copying from does not exist')
                    }
                }
                #If only overwrite box is checked, overwrite groups and not properties or OU
                else {
                    #if old user exists
                    if (Test-ADUser($oldUser)) {
                        #if new user exists
                        if (Test-ADUser($newUserUserName)) {    
                            $title    = 'Overwrite Member of groups'
                            $question = 'Are you sure you want to proceed?'
                            
                            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
                            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
                            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
                            
                            $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
                            if ($decision -eq 0) {
                                
                                #add functionality here ---------------
                                $oldUser = $SearchBox.Text
                            
                                $existingUserUserName = $CopyUserNameBox.Text
            
                                #remove old groups
                                Get-AdPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $existingUserUserName | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $existingUserUserName -Confirm: $false

                                #Copy Groups over
                                $d = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $oldUser | Where-Object -Property Name -Ne -Value "Domain Users" | Select-Object Name
                                Foreach ($g IN $d) {
                                    try {
                                        Add-ADGroupMember -Server $selectedTree -Credential $cred -Identity $g.name -Members $newUserUserName
                                    }
                                    catch {
                                        $counter += 1
                                    }
                                }
            
                                #At the end generate a file of a comparison of new user compared to old user
                                #to show that new user is idenitical to old
            
            
                                $CheckArray = @()
            
                                [System.Windows.MessageBox]::Show('Success')
                                while (($CheckArray.Length - 1<#domain users#>) -ne ($d.Length - $counter<#inadequate access#>)) { 
                                    $CheckArray = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $newUserUserName | Select-Object Name
                                    Start-Sleep -Seconds 2
                                }
            
            
            
                                #Start-Sleep -s 17
                                GenerateFileCompare $oldUser $newUserUserName
                            }       
                        }
                        #if new user does not exist
                        else {
                            [System.Windows.MessageBox]::Show('User copying to does not exist')
                        }
                    }
                    #if old user does not exists
                    else {
                        [System.Windows.MessageBox]::Show('User copying from does not exist')
                    }
                }
        
            }
            # copy properties and append member of groups
            Elseif ($CopyOverwritePropertiesBox.Checked -eq $true) {
                #if old user exists
                if (Test-ADUser($oldUser)) {
                    #if new user exists
                    if (Test-ADUser($newUserUserName)) {
                        $title    = 'Copy Properties and append Member of groups'
                        $question = 'Are you sure you want to proceed?'

                        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
                        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
                        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

                        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
                        if ($decision -eq 0) {
                            
                            #add functionality here ---------------
                            $oldUser = $SearchBox.Text
                        
                            $existingUserUserName = $CopyUserNameBox.Text
                        
                            #retrieve info from oldUser such as description, department, member of,  security... etc 
                            $user = Get-ADUser $oldUser -Properties Department, Description, Manager, Title, office, organization, telephonenumber, Company
                        
                            #modify eisting user information using $existingUserUserName
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Description $user.Description} Catch{}
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Department $user.Department} Catch{}
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Manager $user.Manager} Catch{}
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Title $user.Title} Catch{}
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -office $user.office} Catch{}
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -organization $user.organization} Catch{}
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -telephonenumber $user.telephonenumber} Catch{}
                            try{Set-ADUser -Credential $cred -Identity $existingUserUserName -Company $user.Company} Catch{}

                            
        
                            #dont remove old groups
        
                            #Copy Groups over
                            $existingUserGroupList = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $existingUserUserName | Select-Object -ExpandProperty Name
                            $d = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $oldUser | Where-Object -Property Name -Ne -Value "Domain Users" | Select-Object Name
                            $alreadyThereCounter = 0
                            $counter = 0
                            Foreach ($g IN $d) {
                                if ($g.name -ne 'Domain Users') {
                                    if ($existingUserGroupList -contains $g.name){$alreadyThereCounter+=1}
                                    else{
                                        try {
                                            Add-ADGroupMember -Server $selectedTree -Credential $cred -Identity $g.name -Members $existingUserUserName
                                        }
                                        catch {
                                            $counter += 1
                                        }
                                    }
                                }
                            }
                            #change new user OU location
                            
                            $UserDN = (Get-ADUser -Credential $cred -Identity $oldUser).distinguishedName
                            
                            $TargetOU = $UserDN.Substring($UserDN.IndexOf('OU='))
                            $UserDN2 = (Get-ADUser -Credential $cred -Identity $ExistingUserUserName).distinguishedName

                            Move-ADObject  -Credential $cred -Identity $UserDN2  -TargetPath $TargetOU 
                            #At the end generate a file of a comparison of new user compared to old user
                            #to show that new user is idenitical to old
        
                            $CheckArray = @()
                            [System.Windows.MessageBox]::Show('Success')
                            while ((($CheckArray.Length)-($existingUserGroupList.Length-$alreadyThereCounter)) -ne ($d.Length - $counter)) {
                                try{$CheckArray = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $existingUserUserName | Select-Object Name} catch{}
                                Start-Sleep -Seconds 2
                            }
                            #Start-Sleep -s 17
                            GenerateFileCompare $oldUser $existingUserUserName
                        }
                    }
                    #else new user does not exist throw error
                    else {
                        [System.Windows.MessageBox]::Show('User copying from does not exist')
                    }
                }
                #else old  user does not exists throw error
                else {
                    [System.Windows.MessageBox]::Show('User copying from does not exist')
                }
        
            }
            #default append groups to existing user, do not copy properties.
            else {
                #if old user exists run code
                if (Test-ADUser($oldUser)) {
                    #if new user exists run code
                    if (Test-ADUser($newUserUserName)) {
                        $title    = 'Append Member of Groups to existing User'
                        $question = 'Are you sure you want to proceed?'

                        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
                        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
                        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

                        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
                        if ($decision -eq 0) {
                            #add functionality here ---------------
                            $oldUser = $SearchBox.Text
                                                
                            $existingUserUserName = $CopyUserNameBox.Text
                            
                            #Append Groups over

                            $existingUserGroupList = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $existingUserUserName | Where-Object -Property Name -Ne -Value 'Domain Users' | Select-Object -ExpandProperty Name
                            $d = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $oldUser | Where-Object -Property Name -Ne -Value 'Domain Users' | Select-Object Name
                            $alreadyThereCounter = 0
                            $counter = 0
                            Foreach ($g IN $d) {
                                if ($g.name -ne 'Domain Users') {
                                    if ($existingUserGroupList -contains $g.name){$alreadyThereCounter+=1}
                                    else{
                                        try {
                                            Add-ADGroupMember -Server $selectedTree -Credential $cred -Identity $g.name -Members $existingUserUserName
                                        }
                                        catch {
                                            $counter += 1
                                        }
                                    }
                                }
                            }

                            #At the end generate a file of a comparison of new user compared to old user
                            #to show that new user is idenitical to old

                            

                            $CheckArray = @()

                            [System.Windows.MessageBox]::Show('Success')
                            while ((($CheckArray.Length-1)-($existingUserGroupList.Length-$alreadyThereCounter)) -ne ($d.Length - $counter)) {
                                try{$CheckArray = Get-ADPrincipalGroupMembership -ResourceContextServer $selectedTree -Credential $cred -Identity $existingUserUserName | Select-Object Name} catch{}
                                Start-Sleep -Seconds 2
                            }

                            #Start-Sleep -s 17
                            GenerateFileCompare $oldUser $existingUserUserName
                        }
                    }
                #else new user does not exist throw error
                else {
                    [System.Windows.MessageBox]::Show('User copying from does not exist')
                }
            }
            #else old  user does not exists throw error
            else {
                [System.Windows.MessageBox]::Show('User copying from does not exist')
            }
            }
            
        }
        #basic compare person
        ElseIf ($CompareBox.Checked -eq $true) {
            $User_Input = $SearchBox.Text
            $Second_Input = $CompareSearchBox.Text
            if ((Test-ADUser($User_Input)) -and (Test-ADUser($Second_Input))) {
                GenerateFileCompare $User_Input $Second_Input
            }
            else {
                [System.Windows.MessageBox]::Show('1 or more Invalid User...            ')
            }
        }
        #basic absolute default just generate a file of the user's info
        else {
            $User_Input = $SearchBox.Text
            #Write-Host $User_Input
            if (Test-ADUser($User_Input)) {
                GenerateFile($User_Input)
            }
            else {
                [System.Windows.MessageBox]::Show('Invalid User...                   ')
            }
        }
     
    }
    else{
        [System.Windows.MessageBox]::Show('Select a group tree to search')
    }
}

Function NewSearchBar {
    $CopyExistingUserBox.Visible = $false

    $CompareSearchBox.Visible = $true
    $CompareSearch.Visible = $true
    $form1.Refresh()

} 
Function RemoveSearchBar {
    $CompareSearchBox.Visible = $false
    $CompareSearch.Visible = $false

    #add back other checkbox for recovered functionality
    $CopyExistingUserBox.Visible = $true
    $form1.Refresh()

}

Function NewExistingSearchBarCopy { 
    #remove oppostite button 
    $CompareBox.Visible = $false
    $CopyNetNewUserBox.Visible = $true
    $CopyOverwriteGroupsBox.Visible = $true
    $CopyOverwritePropertiesBox.Visible = $true
    #make copy features visible
    
    $CopyUserName.Visible = $true
    $CopyUserNameBox.Visible = $true
    
    #change text of label and button
    $Search.Text = "Enter the username of the account to copy from:"
    $SearchButton.Text = "Copy"
    $form1.Refresh()

}
Function RemoveExistingSearchBarCopy {
    #make copy features invisible
    
    $CopyUserName.Visible = $false
    $CopyUserNameBox.Visible = $false
    $CopyOverwriteGroupsBox.Visible = $false
    $CopyOverwritePropertiesBox.Visible = $false

    #add back other checkbox for recovered functionality
    $CompareBox.Visible = $true

    $CopyNetNewUserBox.Checked = $false
    $CopyNetNewUserBox.Visible = $false
    #change text of label and button back to normal
    $Search.Text = "Enter an Accounts Username:"
    $SearchButton.Text = "Search"
    $form1.Refresh()
}
Function NewSearchBarCopy { 
    #make copy features visible
    $CopyFirstName.Visible = $true
    $CopyFirstNameBox.Visible = $true
    $CopyLastName.Visible = $true
    $CopyLastNameBox.Visible = $true

    $form1.Refresh()

}
Function RemoveSearchBarCopy {
    #make copy features invisible
    
    $CopyFirstNameBox.Visible = $false
    $CopyFirstName.Visible = $false
    $CopyLastNameBox.Visible = $false
    $CopyLastName.Visible = $false
    
    $form1.Refresh()
}
Function removeNetNewUser {
    
    $CopyNetNewUserBox.Visible = $false
    $CopyNetNewUserBox.Checked = $false    
    
}
Function addNetNewUserBack {
    if(($CopyOverwriteGroupsBox.Checked -eq $false) -and ($CopyOverwritePropertiesBox.Checked -eq $false)){
        $CopyNetNewUserBox.Visible = $true
    }
}

Function NetNewRemoveCopy {
    $CopyOverwriteGroupsBox.Visible = $false
    $CopyOverwritePropertiesBox.Visible = $false
    $CopyOverwriteGroupsBox.Checked = $false
    $CopyOverwritePropertiesBox.Checked = $false
    
}

Function NetNewAddCopy {
    $CopyOverwriteGroupsBox.Visible = $true
    $CopyOverwritePropertiesBox.Visible = $true

    $CopyLastNameBox.Text = ''
    $CopyFirstNameBox.Text = ''
}

#create a windows gui form data
#form container
$form1 = New-Object System.Windows.Forms.Form
$form1.ClientSize = "720,290"
$form1.StartPosition = "CenterScreen"
$form1.Text = "Active Directory Extra Features"

#dark mode button
$darkButtonBox = New-Object System.Windows.Forms.CheckBox
$darkButtonBox.Location = New-Object System.Drawing.size(530, 15)
$darkButtonBox.size = New-Object System.Drawing.size(40, 20)
$darkButtonBox.Text = "Dark"
$darkButtonBox.Font = 'Microsoft Sans Serif,9'
$darkButtonBox.Appearance = 'button'
$darkButtonBox.add_CheckedChanged({
    if ($darkButtonBox.Checked -eq $true) {
        DarkMode
    }
    if ($darkButtonBox.Checked -eq $false) {
        LightMode
    }
})



#label for search bar
$Search = New-Object System.Windows.Forms.Label
$Search.Size = New-Object System.Drawing.size(140, 40)
$Search.Location = New-Object System.Drawing.size(20, 20)
$Search.Text = "Enter an Accounts Username:"
$Search.Font = 'Microsoft Sans Serif,9'

#text box for user to type in user's name
$SearchBox = New-Object System.Windows.Forms.TextBox
$SearchBox.Location = New-Object System.Drawing.Size(170, 20)
$SearchBox.Size = New-Object System.Drawing.Size(240, 70)

#button to submit the form
$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Text = "Search"
$SearchButton.Size = New-Object System.Drawing.Size(100, 40)
$SearchButton.Location = New-Object System.Drawing.Size(420, 20)
#listener for if button is clicked, run the Searching function
$SearchButton.Add_Click({ Searching })
$SearchButton.Font = 'Microsoft Sans Serif,10'



#label for search second bar
$CompareSearch = New-Object System.Windows.Forms.Label
$CompareSearch.Size = New-Object System.Drawing.size(140, 40)
$CompareSearch.Name = "CompareSearch"
$CompareSearch.Location = New-Object System.Drawing.size(20, 70)
$CompareSearch.Text = "Enter a second Account's Username:"
$CompareSearch.Font = 'Microsoft Sans Serif,9'

#comparison check box 
$CompareBox = New-Object System.Windows.Forms.CheckBox
$CompareBox.location = New-Object System.Drawing.size(20, 200)
$CompareBox.size = New-Object System.Drawing.size(180, 20)
$CompareBox.Checked = $false
$CompareBox.text = "Compare to another User..."
$CompareBox.Font = 'Microsoft Sans Serif,10'

$CompareBox.Name = "CompareBox"
$CompareBox.add_CheckedChanged({
        if ($CompareBox.Checked -eq $true) {
            NewSearchBar
        }
        if ($CompareBox.Checked -eq $false) {
            RemoveSearchBar
        }
    }) 

#copy to existing user checkbox
#Copy check box 
$CopyExistingUserBox = New-Object System.Windows.Forms.CheckBox
$CopyExistingUserBox.location = New-Object System.Drawing.size(200, 200)
$CopyExistingUserBox.size = New-Object System.Drawing.size(180, 20)
$CopyExistingUserBox.Checked = $false
$CopyExistingUserBox.text = "Copy to another User..."
$CopyExistingUserBox.Font = 'Microsoft Sans Serif,10'
$CopyExistingUserBox.Name = "CopyNewUserBox"

$CopyExistingUserBox.add_CheckedChanged({
        if ($CopyExistingUserBox.Checked -eq $true) {
            NewExistingSearchBarCopy
        }
        if ($CopyExistingUserBox.Checked -eq $false) {
            RemoveExistingSearchBarCopy
        }
    })
#copy to net new user checkbox
#Copy check box 
$CopyNetNewUserBox = New-Object System.Windows.Forms.CheckBox
$CopyNetNewUserBox.location = New-Object System.Drawing.size(380, 165)
$CopyNetNewUserBox.size = New-Object System.Drawing.size(180, 35)
$CopyNetNewUserBox.Checked = $false
$CopyNetNewUserBox.Visible = $false
$CopyNetNewUserBox.text = "Net New User.... "
$CopyNetNewUserBox.Font = 'Microsoft Sans Serif,10'

$CopyNetNewUserBox.Name = "CopyNewUserBox"
$CopyNetNewUserBox.add_CheckedChanged({
        if ($CopyNetNewUserBox.Checked -eq $true) {
            NetNewRemoveCopy
            NewSearchBarCopy
        }
        if ($CopyNetNewUserBox.Checked -eq $false) {
            NetNewAddCopy
            RemoveSearchBarCopy
        }
    })

#overwrite member of groups
$CopyOverwriteGroupsBox = New-Object System.Windows.Forms.CheckBox
$CopyOverwriteGroupsBox.location = New-Object System.Drawing.size(380, 200)
$CopyOverwriteGroupsBox.size = New-Object System.Drawing.size(200, 35)
$CopyOverwriteGroupsBox.Checked = $false
$CopyOverwriteGroupsBox.Visible = $false
$CopyOverwriteGroupsBox.text = "Overwrite current users 'member of' security groups "
$CopyOverwriteGroupsBox.Font = 'Microsoft Sans Serif,10'

$CopyOverwriteGroupsBox.Name = "CopyNewUserBox"
$CopyOverwriteGroupsBox.add_CheckedChanged({
        if ($CopyOverwriteGroupsBox.Checked -eq $true) {
            removeNetNewUser
        }
        if ($CopyOverwriteGroupsBox.Checked -eq $false) {
            addNetNewUserBack
        }
    })

#overwrite member of groups
$CopyOverwritePropertiesBox = New-Object System.Windows.Forms.CheckBox
$CopyOverwritePropertiesBox.location = New-Object System.Drawing.size(380, 235)
$CopyOverwritePropertiesBox.size = New-Object System.Drawing.size(190, 35)
$CopyOverwritePropertiesBox.Checked = $false
$CopyOverwritePropertiesBox.Visible = $false
$CopyOverwritePropertiesBox.text = "Overwrite user's properties and OU"
$CopyOverwritePropertiesBox.Font = 'Microsoft Sans Serif,10'

$CopyOverwritePropertiesBox.Name = "CopyNewUserBox"
$CopyOverwritePropertiesBox.add_CheckedChanged({
        if ($CopyOverwritePropertiesBox.Checked -eq $true) {
            removeNetNewUser
        }
        if ($CopyOverwritePropertiesBox.Checked -eq $false) {
            addNetNewUserBack
        }
    })

#delete file after doing process
$CopyDeleteFileBox = New-Object System.Windows.Forms.CheckBox
$CopyDeleteFileBox.location = New-Object System.Drawing.size(420, 60)
$CopyDeleteFileBox.size = New-Object System.Drawing.size(190, 30)
$CopyDeleteFileBox.Checked = $false
$CopyDeleteFileBox.text = "delete temp file after..."
$CopyDeleteFileBox.Font = 'Microsoft Sans Serif,9'
$CopyDeleteFileBox.Name = "CopyDeleteFileBox"
$CopyDeleteFileBox.add_CheckedChanged({
    if ($CopyDeleteFileBox.Checked -eq $true) {
        $DeleteBoxChecked = $true
    }
    if ($CopyDeleteFileBox.Checked -eq $false) {
        $DeleteBoxChecked = $false
    }
})

#choose tree
$GroupTree1 = New-Object System.Windows.Forms.CheckBox
$GroupTree1.location = New-Object System.Drawing.size(580, 15)
$GroupTree1.size = New-Object System.Drawing.size(190, 30)
$GroupTree1.Checked = $false
$GroupTree1.text = "DC01.prhc.on.ca"
$GroupTree1.Font = 'Microsoft Sans Serif,9'
$GroupTree1.Name = "CopyDeleteFileBox"
$GroupTree1.add_CheckedChanged({
    if ($GroupTree1.Checked -eq $true) {
        Group1Checked
    }
    if ($GroupTree1.Checked -eq $false) {
        Group1unChecked
    }
})


#Choose tree
$GroupTree2 = New-Object System.Windows.Forms.CheckBox
$GroupTree2.location = New-Object System.Drawing.size(580, 45)
$GroupTree2.size = New-Object System.Drawing.size(190, 30)
$GroupTree2.Checked = $false
$GroupTree2.text = "DC02.prhc.on.ca"
$GroupTree2.Font = 'Microsoft Sans Serif,9'
$GroupTree2.Name = "CopyDeleteFileBox"
$GroupTree2.add_CheckedChanged({
    if ($GroupTree2.Checked -eq $true) {
        Group2Checked
    }
    if ($GroupTree2.Checked -eq $false) {
        Group2unChecked
    }
})
function Group1Checked{
    $GroupTree2.Visible = $false
    Set-Variable -Name "selectedTree" -Value "DC01.prhc.on.ca" -scope Global
}
function Group2Checked{
    $GroupTree1.Visible = $false
    Set-Variable -Name "selectedTree" -Value "DC02.prhc.on.ca" -scope Global
}
function Group1unChecked{
    $GroupTree2.Visible = $true
    Set-Variable -Name "selectedTree" -Value $null -scope Global
}
function Group2unChecked{
    $GroupTree1.Visible = $true
    Set-Variable -name "selectedTree" -value $null -scope Global
}

#label for search second bar
$CompareSearch = New-Object System.Windows.Forms.Label
$CompareSearch.Size = New-Object System.Drawing.size(140, 40)
$CompareSearch.Name = "CompareSearch"
$CompareSearch.Location = New-Object System.Drawing.size(20, 70)
$CompareSearch.Text = "Enter a second Account's Username:"

$CompareSearch.Font = 'Microsoft Sans Serif,9'
$CompareSearch.Visible = $false

#text box for user to type in user's name
$CompareSearchBox = New-Object System.Windows.Forms.TextBox
$CompareSearchBox.Location = New-Object System.Drawing.Size(170, 70)
$CompareSearchBox.Size = New-Object System.Drawing.Size(240, 70)
$CompareSearchBox.Name = "CompareSearchBox"
$CompareSearchBox.Visible = $false





#Copy Functionality -----------------------------------
#label for search second bar
$CopyFirstName = New-Object System.Windows.Forms.Label
$CopyFirstName.Size = New-Object System.Drawing.size(140, 40)
$CopyFirstName.Name = "CopySearch"
$CopyFirstName.Location = New-Object System.Drawing.size(20, 100)
$CopyFirstName.Text = "Enter new acc ount first name"
$CopyFirstName.Font = 'Microsoft Sans Serif,9'

$CopyFirstName.Visible = $false

#text box for Name to type in Name's name
$CopyFirstNameBox = New-Object System.Windows.Forms.TextBox
$CopyFirstNameBox.Location = New-Object System.Drawing.Size(170, 100)
$CopyFirstNameBox.Size = New-Object System.Drawing.Size(240, 70)
$CopyFirstNameBox.Name = "CopyFirstNameBox"
$CopyFirstNameBox.Visible = $false


#label for search Last bar
$CopyLastName = New-Object System.Windows.Forms.Label
$CopyLastName.Size = New-Object System.Drawing.size(140, 40)
$CopyLastName.Name = "CopySearch"
$CopyLastName.Location = New-Object System.Drawing.size(20, 140)
$CopyLastName.Text = "Enter new account Last name"
$CopyLastName.Font = 'Microsoft Sans Serif,9'

$CopyLastName.Visible = $false

#text box for Name to type in Name's name
$CopyLastNameBox = New-Object System.Windows.Forms.TextBox
$CopyLastNameBox.Location = New-Object System.Drawing.Size(170, 140)
$CopyLastNameBox.Size = New-Object System.Drawing.Size(240, 70)
$CopyLastNameBox.Name = "CopyLastNameBox"
$CopyLastNameBox.Visible = $false


#label for search Last bar
$CopyUserName = New-Object System.Windows.Forms.Label
$CopyUserName.Size = New-Object System.Drawing.size(140, 40)
$CopyUserName.Name = "CopySearch"
$CopyUserName.Location = New-Object System.Drawing.size(20, 60)
$CopyUserName.Text = "Enter account User name to copy to"
$CopyUserName.Font = 'Microsoft Sans Serif,9'

$CopyUserName.Visible = $false

#text box for Name to type in Name's name  
$CopyUserNameBox = New-Object System.Windows.Forms.TextBox
$CopyUserNameBox.Location = New-Object System.Drawing.Size(170, 60)
$CopyUserNameBox.Size = New-Object System.Drawing.Size(240, 70)
$CopyUserNameBox.Name = "CopyLastNameBox"
$CopyUserNameBox.Visible = $false



#custom tooltips for form
$toolTip1 = New-Object System.Windows.Forms.ToolTip
$toolTip1.InitialDelay = 500
$toolTip1.ShowAlways = $true
$toolTip1.SetToolTip($CopyExistingUserBox, "This box will by default take the member-of groups from the old user and append them onto the existing user.")
$toolTip1.SetToolTip($CopyNetNewUserBox, "Check this box to generate a new user that does not yet exist. User will have the 
same Department, Description, Manager, MemberOf, Office, Organization, ProfilePath, Title, and
Company as the old user, as well as the same Member of Groups and OU location. 
The new user will need a unique username and name enterred by you so the email can be generated.")
$toolTip1.SetToolTip($CopyOverwriteGroupsBox, "This will change the program function to overwrite the existing member-of groups of the user you are copying to as appossed to
the default which is to append the groups")
$toolTip1.SetToolTip($CopyOverwritePropertiesBox, "This will the change the program function to take the properties such as 
Department, Description, Manager, Office, Organization, Title, and Company and put them onto the 
user that is being copied to, overwriting the exiting properties on that account.
This also moves the user to the OU location of the old user. 
This is different from the default which does not do anything with the properties.")
$toolTip1.SetToolTip($CompareBox, "Checking this box will compare the 2 users entered and generate a html file that draws the comparisons between them.")
$toolTip1.SetToolTip($SearchButton, "If no checkboxes are checked this form will search a single user and open their info in a html file.")
$toolTip1.SetToolTip($SearchBox, "Enter only the username here.")
$toolTip1.SetToolTip($CompareSearchBox, "Enter only the username of the user you would like to compare to here.")
$toolTip1.SetToolTip($CopyUserNameBox, "Enter only the username of the user you would like to copy to here.")
$toolTip1.SetToolTip($CopyDeleteFileBox, "If checked, program will delete temp HTML file that is stored in users temp folder 10 seconds after it opens it.
If not checked the file will not be deleted, but the next time the program is run it will overwrite the old file.")
$toolTip1.SetToolTip($GroupTree1,"Group trees affect how the member of groups work and having the wrong one selected will the brick the program. Program is only successful if the HTML file is opened.")
$toolTip1.SetToolTip($GroupTree2,"Group trees affect how the member of groups work and having the wrong one selected will the brick the program. Program is only successful if the HTML file is opened.")


$form1.Controls.Add($Search)
$form1.Controls.Add($SearchBox)


$form1.Controls.Add($CompareSearchBox)
$form1.Controls.Add($CompareSearch)

$form1.Controls.Add($CopyUserNameBox)
$form1.Controls.Add($CopyUserName)
$form1.Controls.Add($CopyFirstNameBox)
$form1.Controls.Add($CopyFirstName)
$form1.Controls.Add($CopyLastNameBox)
$form1.Controls.Add($CopyLastName)
$form1.Controls.Add($GroupTree1)
$form1.Controls.Add($GroupTree2)


#add the form features
$form1.AcceptButton = $SearchButton

$form1.Controls.Add($CompareBox)
$form1.Controls.Add($CopyExistingUserBox)
$form1.Controls.Add($CopyNetNewUserBox)
$form1.Controls.Add($CopyOverwriteGroupsBox)
$form1.Controls.Add($CopyOverwritePropertiesBox)
$form1.Controls.Add($CopyDeleteFileBox)
$form1.Controls.Add($darkButtonBox)
$form1.Controls.Add($SearchButton)
#display the form
$form1.ShowDialog() | out-null
[System.Windows.Forms.Application]::EnableVisualStyles()

