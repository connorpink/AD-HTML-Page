import-module ActiveDirectory
Add-Type -AssemblyName PresentationCore,PresentationFramework

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
    $User_Desc = Get-ADUser -Identity $DesiredUser -Properties Description |
    Select-Object -ExpandProperty Description
    }
    catch {

    }
    try {
    $User_Name = Get-ADUser -Identity $DesiredUser -Properties Name|
    Select-Object -ExpandProperty Name
}
catch {

}
try {
    $User_Email = Get-ADUser -Identity $DesiredUser -Properties EmailAddress|
    Select-Object -ExpandProperty EmailAddress
}
catch {

}
try {
    $User_FullName = Get-ADUser -Identity $DesiredUser -Properties DisplayName|
    Select-Object -ExpandProperty DisplayName
}
catch {

}
try {
    $User_Department = Get-ADUser -Identity $DesiredUser -Properties Department|
    Select-Object -ExpandProperty Department
}
catch {

}
try {
    $User_Company = Get-ADUser -Identity $DesiredUser -Properties Company|
    Select-Object -ExpandProperty Company
}
catch {

}
try {
    $User_JobTitle = Get-ADUser -Identity $DesiredUser -Properties Title|
    Select-Object -ExpandProperty Title
}
catch {

}  try {
    $User_Office = Get-ADUser -Identity $DesiredUser -Properties office|
    Select-Object -ExpandProperty office
}
catch {

}  try {
    $User_Phone = Get-ADUser -Identity $DesiredUser -Properties telephoneNumber|
    Select-Object -ExpandProperty telephoneNumber
}
catch {
   
}  try {
    $User_ManagerTemp = Get-ADUser -Identity $DesiredUser -Properties Manager|
    Select-Object -ExpandProperty Manager
}
catch {

}  try {
    $User_Manager = Get-ADUser -Identity $User_ManagerTemp -Properties DisplayName|
    Select-Object -ExpandProperty DisplayName
}
catch {

}
     
     $Groups = Get-ADPrincipalGroupMembership -Identity $DesiredUser | Select-Object Name 

    $assignToPostContent += "<div class='allInfo'>"
    if ($User_Name){ $assignToPostContent += "<div class = 'info'><div class='inLineText'><h3>Username:  </h3> <h2>" + $User_Name + "</h2></div>"}
    if ($User_Email){ $assignToPostContent +="<div class='inLineText'><h3>Email:  </h3> <h2> " + $User_Email + "</h2></div>"}
    if ($User_Phone){ $assignToPostContent +="<div class='inLineText'><h3>Phone Number:  </h3> <h2> " + $User_Phone + "</h2></div>"}
    if ($User_FullName){ $assignToPostContent +="<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $User_FullName + "</h2></div>"}
    if ($User_Desc){ $assignToPostContent +="<div class='inLineText'><h3>Description:  </h3> <h2> " + $User_Desc + "</h2></div>"}
    if ($User_Department){ $assignToPostContent +="<div class='inLineText'><h3>Department:  </h3> <h2> " + $User_Department + "</h2></div>"}
    if ($User_JobTitle){ $assignToPostContent +="<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $User_JobTitle + "</h2></div>"}
    if ($User_Company){ $assignToPostContent +="<div class='inLineText'><h3>Company:  </h3> <h2> " + $User_Company+ "</h2></div>"}
    if ($User_Office){ $assignToPostContent +="<div class='inLineText'><h3>Office:  </h3> <h2> " + $User_Office+ "</h2></div>"}
    if ($User_Manager){ $assignToPostContent +="<div class='inLineText'><h3>Manager:  </h3> <h2> " + $User_Manager+ "</h2></div></div>"}

    $assignToPostContent += "<div class='table'>
	<table class = 'styled-table'>
		<thead>
			<tr>
				<th>Security Groups on User</th>
			</tr>
		</thead>
    <tbody>
    "
    foreach ($g in $Groups.GetEnumerator() )
        {
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
        Head = $Header +"<link rel='preconnect' href='https://fonts.googleapis.com'>
        <link rel='preconnect' href='https://fonts.gstatic.com' crossorigin>
        <link href='https://fonts.googleapis.com/css2?family=Montserrat&display=swap' rel='stylesheet'>"
        Title = "This is Description" 
    
        
        Body = "

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
    Out-File C:\Users\$env:USERNAME\AppData\Local\Temp\Show-User-Description.html
    #open the html file
    Start-Process C:\Users\$env:USERNAME\AppData\Local\Temp\Show-User-Description.html
    Start-Sleep -s 1.5
    Remove-Item C:\Users\$env:USERNAME\AppData\Local\Temp\Show-User-Description.html -Force

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
        display: flex;
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
    $First_User_Desc = Get-ADUser -Identity $FirstUser -Properties Description |
     Select-Object -ExpandProperty Description
    }
    catch {

    } try {
    $First_User_Name = Get-ADUser -Identity $FirstUser -Properties Name|
    Select-Object -ExpandProperty Name
}
catch {

} try {
    $First_User_Email = Get-ADUser -Identity $FirstUser -Properties EmailAddress|
    Select-Object -ExpandProperty EmailAddress
}
catch {

} try {
    $First_User_FullName = Get-ADUser -Identity $FirstUser -Properties DisplayName|
    Select-Object -ExpandProperty DisplayName
}
catch {

} try {
    $First_User_Department = Get-ADUser -Identity $FirstUser -Properties Department|
    Select-Object -ExpandProperty Department
}
catch {

} try {
    $First_User_Company = Get-ADUser -Identity $FirstUser -Properties Company|
    Select-Object -ExpandProperty Company
}
catch {

} try {
    $First_User_JobTitle = Get-ADUser -Identity $FirstUser -Properties Title|
    Select-Object -ExpandProperty Title
}
catch {

} try {
    $First_User_Office = Get-ADUser -Identity $FirstUser -Properties office|
    Select-Object -ExpandProperty office
}
catch {

} try {
    $First_User_Phone = Get-ADUser -Identity $FirstUser -Properties telephoneNumber|
    Select-Object -ExpandProperty telephoneNumber
}
catch {

} try {
    $First_User_ManagerTemp = Get-ADUser -Identity $FirstUser -Properties Manager|
    Select-Object -ExpandProperty Manager
}
catch {

} try {
    $First_User_Manager = Get-ADUser -Identity $First_User_ManagerTemp -Properties DisplayName|
    Select-Object -ExpandProperty DisplayName
}
catch {

}
    # $First_Groups = Get-ADPrincipalGroupMembership -Identity $FirstUser | Select-Object Name 

     #Second User CODE ------------------
    #querry the users information from Active Directory for the First User
    #$assignToPostContent += "<div class = 'secondUser'>"
    
    try {
    $Second_User_Desc = Get-ADUser -Identity $SecondUser -Properties Description |
    Select-Object -ExpandProperty Description
}
catch {

} try {

    $Second_User_Name = Get-ADUser -Identity $SecondUser -Properties Name|
    Select-Object -ExpandProperty Name
}
catch {

} try {

    $Second_User_Email = Get-ADUser -Identity $SecondUser -Properties EmailAddress|
    Select-Object -ExpandProperty EmailAddress
}
catch {

} try {

    $Second_User_FullName = Get-ADUser -Identity $SecondUser -Properties DisplayName|
    Select-Object -ExpandProperty DisplayName
}
catch {

} try {

    $Second_User_Department = Get-ADUser -Identity $SecondUser -Properties Department|
    Select-Object -ExpandProperty Department
}
catch {

} try {

    $Second_User_Company = Get-ADUser -Identity $SecondUser -Properties Company|
    Select-Object -ExpandProperty Company
}
catch {

} try {

    $Second_User_JobTitle = Get-ADUser -Identity $SecondUser -Properties Title|
    Select-Object -ExpandProperty Title
}
catch {

} try {

    $Second_User_Office = Get-ADUser -Identity $SecondUser -Properties office|
    Select-Object -ExpandProperty office
}
catch {

} try {

    $Second_User_Phone = Get-ADUser -Identity $SecondUser -Properties telephoneNumber|
    Select-Object -ExpandProperty telephoneNumber
}
catch {

} try {

    $Second_User_ManagerTemp = Get-ADUser -Identity $SecondUser -Properties Manager|
    Select-Object -ExpandProperty Manager
}
catch {

} try {

    $Second_User_Manager = Get-ADUser -Identity $Second_User_ManagerTemp -Properties DisplayName|
    Select-Object -ExpandProperty DisplayName
}
catch {

}
    
   # $Second_Groups = Get-ADPrincipalGroupMembership -Identity $SecondUser | Select-Object Name 
    
    $assignToPostContent += "<div class = 'allInfo'>"
    $assignToPostContent += "<div class = 'firstUser'>"

    $assignToPostContent += "<div class = 'info'>"
    if ($First_User_Name){ $assignToPostContent += "<div class='inLineText'><h3>Username:  </h3> <h2>" + $First_User_Name + "</h2></div>"}
    if ($First_User_Email){ $assignToPostContent +="<div class='inLineText'><h3>Email:  </h3> <h2> " + $First_User_Email + "</h2></div>"}
    if ($First_User_Phone){ $assignToPostContent +="<div class='inLineText'><h3>Phone Number:  </h3> <h2> " + $First_User_Phone + "</h2></div>"}
    if ($First_User_FullName){ $assignToPostContent +="<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $First_User_FullName + "</h2></div>"}
    if ($First_User_Desc){ $assignToPostContent +="<div class='inLineText'><h3>Description:  </h3> <h2> " + $First_User_Desc + "</h2></div>"}
    if ($First_User_Department){ $assignToPostContent +="<div class='inLineText'><h3>Department:  </h3> <h2> " + $First_User_Department + "</h2></div>"}
    if ($First_User_JobTitle){ $assignToPostContent +="<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $First_User_JobTitle + "</h2></div>"}
    if ($First_User_Company){ $assignToPostContent +="<div class='inLineText'><h3>Company:  </h3> <h2> " + $First_User_Company+ "</h2></div>"}
    if ($First_User_Office){ $assignToPostContent +="<div class='inLineText'><h3>Office:  </h3> <h2> " + $First_User_Office+ "</h2></div>"}
    if ($First_User_Manager){ $assignToPostContent +="<div class='inLineText'><h3>Manager:  </h3> <h2> " + $First_User_Manager+ "</h2></div>"}
    $assignToPostContent += "</div>" #close info tag

    $assignToPostContent += "</div>"    # for first user close div
    $assignToPostContent += "<div class = 'secondUser'>"    # for first user close div

    $assignToPostContent += "<div class = 'info'>"
    if ($Second_User_Name){ $assignToPostContent += "<div class='inLineText'><h3>Username:  </h3> <h2>" + $Second_User_Name + "</h2></div>"}
    if ($Second_User_Email){ $assignToPostContent +="<div class='inLineText'><h3>Email:  </h3> <h2> " + $Second_User_Email + "</h2></div>"}
    if ($Second_User_Phone){ $assignToPostContent +="<div class='inLineText'><h3>Phone Number:  </h3> <h2> " + $Second_User_Phone + "</h2></div>"}
    if ($Second_User_FullName){ $assignToPostContent +="<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $Second_User_FullName + "</h2></div>"}
    if ($Second_User_Desc){ $assignToPostContent +="<div class='inLineText'><h3>Description:  </h3> <h2> " + $Second_User_Desc + "</h2></div>"}
    if ($Second_User_Department){ $assignToPostContent +="<div class='inLineText'><h3>Department:  </h3> <h2> " + $Second_User_Department + "</h2></div>"}
    if ($Second_User_JobTitle){ $assignToPostContent +="<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $Second_User_JobTitle + "</h2></div>"}
    if ($Second_User_Company){ $assignToPostContent +="<div class='inLineText'><h3>Company:  </h3> <h2> " + $Second_User_Company+ "</h2></div>"}
    if ($Second_User_Office){ $assignToPostContent +="<div class='inLineText'><h3>Office:  </h3> <h2> " + $Second_User_Office+ "</h2></div>"}
    if ($Second_User_Manager){ $assignToPostContent +="<div class='inLineText'><h3>Manager:  </h3> <h2> " + $Second_User_Manager+ "</h2></div>"}
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
    $FirstUserList= @()
    $SecondUserList = @()
    
    $FirstUserNotEqual = @()
    
    $SecondUserNotEqual = @()
    
    
        $d = Get-ADPrincipalGroupMembership -Identity $FirstUser | Select-Object Name
        Foreach ($y IN $d) {
        $FirstUserList += $y.name
        }
    
        $e = Get-ADPrincipalGroupMembership -Identity $SecondUser | Select-Object Name
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



       #foreach ($g in $Second_Groups.GetEnumerator() )
       foreach ($g in $FirstUserList)
       {
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
               
           "}
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
    foreach ($g in $SecondUserList)
        {
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
            "}
        }

    $assignToPostContent += "
        </tbody>
    </table></div>
    "#close table div^
    
    


    
     #Create the hashtable that will structure the html page
    $htmlParams = @{
        Head = $Header +"<link rel='preconnect' href='https://fonts.googleapis.com'>
        <link rel='preconnect' href='https://fonts.gstatic.com' crossorigin>
        <link href='https://fonts.googleapis.com/css2?family=Montserrat&display=swap' rel='stylesheet'>"
        Title = "This is Description" 
    
        Body = "
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
    Out-File C:\Users\$env:USERNAME\AppData\Local\Temp\Show-User-Description.html
    #open the html file
    Start-Process C:\Users\$env:USERNAME\AppData\Local\Temp\Show-User-Description.html
    Start-Sleep -s 1.5
    Remove-Item C:\Users\$env:USERNAME\AppData\Local\Temp\Show-User-Description.html -Force

}


[void][system.reflection.assembly]::loadwithpartialname("System.Windows.Forms")
#function to see if the requested user exists in AD 
function Test-ADUser {
    param(
      [Parameter(Mandatory = $true)]
      [String] $sAMAccountName
    )
    $null -ne ([ADSISearcher] "(sAMAccountName=$sAMAccountName)").FindOne()
  }


#function  to run the Test-ADUser and GenerateFile  functions. Throw an error if user does not exist.
Function Searching
{
    
    if ($CopyNewUserBox.Checked -eq $true){
        if (Test-ADUser($oldUser)){
            if (Test-ADUser($newUserUserName)){
                #[System.Windows.MessageBox]::Show('selected username of new  User is already taken') 

                
                 #add functionality here ---------------
                 $oldUser = $SearchBox.Text
                 
                 $existingUserUserName = $CopyUserNameBox.Text
                 
                
                 #retrieve info from oldUser such as description, department, member of,  security... etc 
                $user = Get-ADUser $oldUser -Properties Department, Description, Manager, MemberOf, Office, Organization, ProfilePath, Title, Company
                
                #modify eisting user information using $existingUserUserName
                Set-ADUser -Identity $existingUserUserName -Instance $user 
                #change new user OU location

                $UserDN  = (Get-ADUser -Identity $oldUser).distinguishedName

                $TargetOU =  $UserDN.Substring($UserDN.IndexOf('OU='))
                $UserDN2 = (Get-ADUser -Identity $ExistingUserUserName).distinguishedName

                Move-ADObject  -Identity $UserDN2  -TargetPath $TargetOU 

                #remove old groups?

                #Copy Groups over
                $d = Get-ADPrincipalGroupMembership -Identity $oldUser | Select-Object Name
                Foreach ($g IN $d) {
                    if ($g.name -ne 'Domain Users') {
                        try {
                            Add-ADGroupMember -Identity $g.name -Members $newUserUserName
                        }
                        catch {
                            $counter +=1
                        }
                    }
                }

                #At the end generate a file of a comparison of new user compared to old user
                #to show that new user is idenitical to old

                $u = Get-ADPrincipalGroupMembership -Identity $oldUser | Select-Object Name

                $CheckArray = @()


                while ($CheckArray.Length -ne ($u.Length - $counter))
                { 
                $CheckArray = Get-ADPrincipalGroupMembership -Identity $newUserUserName | Select-Object Name
                Start-Sleep -Seconds 2
                }



                #Start-Sleep -s 17
                GenerateFileCompare $oldUser $newUserUserName
            }
            else {
                $oldUser = $SearchBox.Text
                $newUserFirstName = $CopyFirstNameBox.Text
                $newUserLastName = $CopyLastNameBox.Text
                $newUserUserName = $CopyUserNameBox.Text
                #generate email
                $newUserEmail = $newUserUserName+"@prhc.on.ca"
                #generate displayName
                $newUserDisplayName = $newUserLastName + ", " + $newUserFirstName
                
                 #retrieve info from oldUser such as description, department, member of,  security... etc 
                $user = Get-ADUser $oldUser -Properties Department, Description, Manager, MemberOf, Office, Organization, ProfilePath, Title, Company
                
                #create new user with firstName, lastName, userName, and email
                
                New-ADUser -Name $newUserUserName -UserPrincipalName $newUserUserName -DisplayName $newUserDisplayName -AccountPassword (ConvertTo-SecureString -AsPlainText "password" -force) -ChangePasswordAtLogon $true -GivenName $newUserFirstName -Surname $newUserLastName -EmailAddress $newUserEmail -Instance $user

                #change new user OU location

                $UserDN  = (Get-ADUser -Identity $oldUser).distinguishedName

                $TargetOU =  $UserDN.Substring($UserDN.IndexOf('OU='))
                $UserDN2 = (Get-ADUser -Identity $newUserUserName).distinguishedName

                Move-ADObject  -Identity $UserDN2  -TargetPath $TargetOU 

                #Copy Groups over
                $d = Get-ADPrincipalGroupMembership -Identity $oldUser | Select-Object Name
                Foreach ($g IN $d) {
                    if ($g.name -ne 'Domain Users') {
                        try {
                            Add-ADGroupMember -Identity $g.name -Members $newUserUserName
                        }
                        catch {
                            $counter +=1
                        }
                    }
                }

                #At the end generate a file of a comparison of new user compared to old user
                #to show that new user is idenitical to old

                $u = Get-ADPrincipalGroupMembership -Identity $oldUser | Select-Object Name

                $CheckArray = @()


                while ($CheckArray.Length -ne ($u.Length - $counter))
                { 
                $CheckArray = Get-ADPrincipalGroupMembership -Identity $newUserUserName | Select-Object Name
                Start-Sleep -Seconds 2
                }



                #Start-Sleep -s 17
                GenerateFileCompare $oldUser $newUserUserName
            }
        }
        else{
            [System.Windows.MessageBox]::Show('User copying from does not exist')
        }
    }

    ElseIf ($CompareBox.Checked -eq $true){
        $User_Input = $SearchBox.Text
        $Second_Input = $CompareSearchBox.Text
        if ((Test-ADUser($User_Input)) -and (Test-ADUser($Second_Input))){
            GenerateFileCompare $User_Input $Second_Input
        }
        else {
            [System.Windows.MessageBox]::Show('1 or more Invalid User...            ')
        }
    }
    else {
        $User_Input = $SearchBox.Text
        #Write-Host $User_Input
        if (Test-ADUser($User_Input)){
            GenerateFile($User_Input)
        }
        else {
            [System.Windows.MessageBox]::Show('Invalid User...                   ')
        }
    }
}

Function NewSearchBar
{
    $CopyNewUserBox.Visible = $false

    $CompareSearchBox.Visible = $true
    $CompareSearch.Visible = $true
    $form1.Refresh()

} 
Function RemoveSearchBar
{
    $CompareSearchBox.Visible = $false
    $CompareSearch.Visible = $false

    #add back other checkbox for recovered functionality
    $CopyNewUserBox.Visible = $true
    $form1.Refresh()

}

Function NewSearchBarCopy
{ 
    #remove oppostite button 
    $CompareBox.Visible = $false


    #make copy features visible
    $CopyFirstName.Visible = $true
    $CopyFirstNameBox.Visible = $true
    $CopyLastName.Visible = $true
    $CopyLastNameBox.Visible = $true
    $CopyUserName.Visible = $true
    $CopyUserNameBox.Visible = $true
    
    #change text of label and button
    $Search.Text = "Enter the username of the account you would like to copy from:"
    $SearchButton.Text = "Copy"
    $form1.Refresh()

}
Function RemoveSearchBarCopy
{
    #make copy features invisible
    $CopyFirstNameBox.Visible = $false
    $CopyFirstName.Visible = $false
    $CopyLastNameBox.Visible = $false
    $CopyLastName.Visible = $false
    $CopyUserName.Visible = $false
    $CopyUserNameBox.Visible = $false
    #add back other checkbox for recovered functionality
    $CompareBox.Visible = $true
    #change text of label and button back to normal
    $Search.Text = "Enter an Accounts Username:"
    $SearchButton.Text = "Search"
    $form1.Refresh()
}


#create a windows gui form data
#form container
$form1 = New-Object System.Windows.Forms.Form
$form1.ClientSize = "550,260"
$form1.StartPosition = "CenterScreen"
$form1.Text = "Searching For Users"

#label for search bar
$Search = New-Object System.Windows.Forms.Label
$Search.Size = New-Object System.Drawing.size(140,40)
$Search.Location = New-Object System.Drawing.size(20,20)
$Search.Text = "Enter an Accounts Username:"

#text box for user to type in user's name
$SearchBox = New-Object System.Windows.Forms.TextBox
$SearchBox.Location = New-Object System.Drawing.Size(170,20)
$SearchBox.Size = New-Object System.Drawing.Size(240,70)

#button to submit the form
$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Text = "Search"
$SearchButton.Size = New-Object System.Drawing.Size(100,40)
$SearchButton.Location = New-Object System.Drawing.Size(420,20)
#listener for if button is clicked, run the Searching function
$SearchButton.Add_Click({Searching})


#label for search second bar
$CompareSearch = New-Object System.Windows.Forms.Label
$CompareSearch.Size = New-Object System.Drawing.size(140,40)
$CompareSearch.Name = "CompareSearch"
$CompareSearch.Location = New-Object System.Drawing.size(20,70)
$CompareSearch.Text = "Enter a second Account's Username:"

#comparison check box 
$CompareBox = New-Object System.Windows.Forms.CheckBox
$CompareBox.location = New-Object System.Drawing.size(20, 200)
$CompareBox.size = New-Object System.Drawing.size(180, 20)
$CompareBox.Checked = $false
$CompareBox.text = "Compare to another User..."
$CompareBox.Name = "CompareBox"
$CompareBox.add_CheckedChanged({
    if ($CompareBox.Checked -eq $true){
        NewSearchBar
    }
    if ($CompareBox.Checked -eq $false){
        RemoveSearchBar
    }
}) 

#Copy check box 
$CopyNewUserBox = New-Object System.Windows.Forms.CheckBox
$CopyNewUserBox.location = New-Object System.Drawing.size(200, 200)
$CopyNewUserBox.size = New-Object System.Drawing.size(180, 20)
$CopyNewUserBox.Checked = $false
$CopyNewUserBox.text = "Copy to another User..."
$CopyNewUserBox.Name = "CopyNewUserBox"
$CopyNewUserBox.add_CheckedChanged({
    if ($CopyNewUserBox.Checked -eq $true){
        NewSearchBarCopy
    }
    if ($CopyNewUserBox.Checked -eq $false){
        RemoveSearchBarCopy
    }
})


#label for search second bar
$CompareSearch = New-Object System.Windows.Forms.Label
$CompareSearch.Size = New-Object System.Drawing.size(140,40)
$CompareSearch.Name = "CompareSearch"
$CompareSearch.Location = New-Object System.Drawing.size(20,70)
$CompareSearch.Text = "Enter a second Account's Username:"
$CompareSearch.Visible = $false

#text box for user to type in user's name
$CompareSearchBox = New-Object System.Windows.Forms.TextBox
$CompareSearchBox.Location = New-Object System.Drawing.Size(170,70)
$CompareSearchBox.Size = New-Object System.Drawing.Size(240,70)
$CompareSearchBox.Name = "CompareSearchBox"
$CompareSearchBox.Visible = $false





#Copy Functionality -----------------------------------
#label for search second bar
$CopyFirstName = New-Object System.Windows.Forms.Label
$CopyFirstName.Size = New-Object System.Drawing.size(140,40)
$CopyFirstName.Name = "CopySearch"
$CopyFirstName.Location = New-Object System.Drawing.size(20,60)
$CopyFirstName.Text = "Enter new account first name"
$CopyFirstName.Visible = $false

#text box for Name to type in Name's name
$CopyFirstNameBox = New-Object System.Windows.Forms.TextBox
$CopyFirstNameBox.Location = New-Object System.Drawing.Size(170,60)
$CopyFirstNameBox.Size = New-Object System.Drawing.Size(240,70)
$CopyFirstNameBox.Name = "CopyFirstNameBox"
$CopyFirstNameBox.Visible = $false


#label for search Last bar
$CopyLastName = New-Object System.Windows.Forms.Label
$CopyLastName.Size = New-Object System.Drawing.size(140,40)
$CopyLastName.Name = "CopySearch"
$CopyLastName.Location = New-Object System.Drawing.size(20,100)
$CopyLastName.Text = "Enter new account Last name"
$CopyLastName.Visible = $false

#text box for Name to type in Name's name
$CopyLastNameBox = New-Object System.Windows.Forms.TextBox
$CopyLastNameBox.Location = New-Object System.Drawing.Size(170,100)
$CopyLastNameBox.Size = New-Object System.Drawing.Size(240,70)
$CopyLastNameBox.Name = "CopyLastNameBox"
$CopyLastNameBox.Visible = $false

#label for search Last bar
$CopyUserName = New-Object System.Windows.Forms.Label
$CopyUserName.Size = New-Object System.Drawing.size(140,40)
$CopyUserName.Name = "CopySearch"
$CopyUserName.Location = New-Object System.Drawing.size(20,140)
$CopyUserName.Text = "Enter new account User name"
$CopyUserName.Visible = $false

#text box for Name to type in Name's name  
$CopyUserNameBox = New-Object System.Windows.Forms.TextBox
$CopyUserNameBox.Location = New-Object System.Drawing.Size(170,140)
$CopyUserNameBox.Size = New-Object System.Drawing.Size(240,70)
$CopyUserNameBox.Name = "CopyLastNameBox"
$CopyUserNameBox.Visible = $false


$form1.Controls.Add($Search)
$form1.Controls.Add($SearchBox)

$form1.Controls.Add($CompareSearchBox)
$form1.Controls.Add($CompareSearch)


$form1.Controls.Add($CopyFirstNameBox)
$form1.Controls.Add($CopyFirstName)
$form1.Controls.Add($CopyLastNameBox)
$form1.Controls.Add($CopyLastName)
$form1.Controls.Add($CopyUserNameBox)
$form1.Controls.Add($CopyUserName)

#add the form features
$form1.AcceptButton = $SearchButton

$form1.Controls.Add($CompareBox)
$form1.Controls.Add($CopyNewUserBox)
$form1.Controls.Add($SearchButton)
#display the form
$form1.ShowDialog() | out-null
[System.Windows.Forms.Application]::EnableVisualStyles()

