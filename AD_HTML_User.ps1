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
            background-color: #1c1813;
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
            flex-wrap: wrap;
        }
        .table{
            margin: 0;
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
            color: white;
            font-size: 19px;
    
        }
    
        h3 {
            font-family: 'Montserrat', sans-serif;
            color: white;
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
            background-color: #a5d3f5;
        }
        .styled-table tbody tr:nth-of-type(even) {
            background-color: #4283b9;
            
        }

        .styled-table tbody tr:last-of-type {
            border-bottom: 2px solid;
        }

            
        .header {
            overflow: hidden;
            background-color: #f1f1f1;
            padding: 20px 10px;
          }
          
          /* Style the header links */
          .header a {
            float: left;
            color: black;
            text-align: center;
            padding: 12px;
            text-decoration: none;
            font-size: 18px;
            line-height: 25px;
            border-radius: 4px;
          }
          
          /* Style the logo link (notice that we set the same value of line-height and font-size to prevent the header to increase when the font gets bigger */
          .header a.logo {
            font-size: 25px;
            font-weight: bold;
          }
          
          /* Change the background color on mouse-over */
          .header a:hover {
            background-color: #ddd;
            color: black;
          }
          
          /* Style the active/current link*/
          .header a.active {
            background-color: dodgerblue;
            color: white;
          }
          
          /* Float the link section to the right */
          .header-right {
            float: right;
          }
          
          /* Add media queries for responsiveness - when the screen is 500px wide or less, stack the links on top of each other */
          @media screen and (max-width: 500px) {
            .header a {
              float: none;
              display: block;
              text-align: left;
            }
            .header-right {
              float: none;
            }
          }
    </style>
    
"@
    #take the requested username and reassign the variable
    $DesiredUser = $Accname
    
    #querry the users information from Active Directory
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

     $User_Phone = Get-ADUser -Identity $DesiredUser -Properties telephoneNumber|
     Select-Object -ExpandProperty telephoneNumber

     $User_ManagerTemp = Get-ADUser -Identity $DesiredUser -Properties Manager|
     Select-Object -ExpandProperty Manager

     $User_Manager = Get-ADUser -Identity $User_ManagerTemp -Properties DisplayName|
     Select-Object -ExpandProperty DisplayName

     $Groups = Get-ADPrincipalGroupMembership -Identity $DesiredUser | Select-Object Name 


     $assignToPostContent =

     "<div class = 'info'><div class='inLineText'><h3>Username:  </h3> <h2>" + $User_Name + "</h2></div>" + 
     "<div class='inLineText'><h3>Email:  </h3> <h2> " + $User_Email + "</h2></div>" +
     "<div class='inLineText'><h3>Phone Number:  </h3> <h2> " + $User_Phone + "</h2></div>" +
     "<div class='inLineText'><h3>Full Name:  </h3> <h2> " + $User_FullName + "</h2></div>" +
     "<div class='inLineText'><h3>Description:  </h3> <h2> " + $User_Desc + "</h2></div>" +
     "<div class='inLineText'><h3>Department:  </h3> <h2> " + $User_Department + "</h2></div>"+
     "<div class='inLineText'><h3>Job Title:  </h3> <h2> " + $User_JobTitle + "</h2></div>"+
     "<div class='inLineText'><h3>Company:  </h3> <h2> " + $User_Company+ "</h2></div>" +
     "<div class='inLineText'><h3>Office:  </h3> <h2> " + $User_Office+ "</h2></div>" +
     "<div class='inLineText'><h3>Manager:  </h3> <h2> " + $User_Manager+ "</h2></div></div>"

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
    <a href='#default' class='logo'>CompanyLogo</a>
    <div class='header-right'>
     <a class='active' href='#home'>Home</a>
     <a href='#contact'>Contact</a>
     <a href='#about'>About</a>
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
        
    }

    if ($CompareBox.Checked -eq $false){
        
    }
    
    $User_Input = $SearchBox.Text
    if (Test-ADUser($User_Input)){
        GenerateFile($User_Input)
    }
    else {
        [System.Windows.MessageBox]::Show('Invalid User...                   ')
    }
}

Function NewSearchBar
{
    #remove copy user box
    $form1.Controls.RemoveByKey("CopyNewUserBox")
    #label for search second bar
    $CompareSearch = New-Object System.Windows.Forms.Label
    $CompareSearch.Size = New-Object System.Drawing.size(140,40)
    $CompareSearch.Name = "CompareSearch"
    $CompareSearch.Location = New-Object System.Drawing.size(20,70)
    $CompareSearch.Text = "Enter a second Account's Username:"

    #text box for user to type in user's name
    $CompareSearchBox = New-Object System.Windows.Forms.TextBox
    $CompareSearchBox.Location = New-Object System.Drawing.Size(170,70)
    $CompareSearchBox.Size = New-Object System.Drawing.Size(240,70)
    $CompareSearchBox.Name = "CompareSearchBox"

    $form1.Controls.Add($CompareSearchBox)
    $form1.Controls.Add($CompareSearch)
}
Function RemoveSearchBar
{
    $form1.Controls.RemoveByKey("CompareSearchBox")
    $form1.Controls.RemoveByKey("CompareSearch")
    #add back other checkbox for recovered functionality
    $form1.Controls.Add($CopyNewUserBox)
    $form1.Refresh()
}

Function NewSearchBarCopy
{
    #remove oppostite button 
    $form1.Controls.RemoveByKey("CompareBox")
    #label for search second bar
    $CopySearch = New-Object System.Windows.Forms.Label
    $CopySearch.Size = New-Object System.Drawing.size(140,40)
    $CopySearch.Name = "CopySearch"
    $CopySearch.Location = New-Object System.Drawing.size(20,70)
    $CopySearch.Text = "Enter a second Account's Username to copy all data to:"

    #text box for user to type in user's name
    $CopySearchBox = New-Object System.Windows.Forms.TextBox
    $CopySearchBox.Location = New-Object System.Drawing.Size(170,70)
    $CopySearchBox.Size = New-Object System.Drawing.Size(240,70)
    $CopySearchBox.Name = "CopySearchBox"

    $form1.Controls.Add($CopySearchBox)
    $form1.Controls.Add($CopySearch)
}
Function RemoveSearchBarCopy
{
    $form1.Controls.RemoveByKey("CopySearchBox")
    $form1.Controls.RemoveByKey("CopySearch")
    #add back other checkbox for recovered functionality
    $form1.Controls.Add($CompareBox)

    $form1.Refresh()
}


#create a windows gui form data
#form container
$form1 = New-Object System.Windows.Forms.Form
$form1.ClientSize = "550,250"
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

#comparison check box 
$CompareBox = New-Object System.Windows.Forms.CheckBox
$CompareBox.location = New-Object System.Drawing.size(20, 120)
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
$CopyNewUserBox.location = New-Object System.Drawing.size(200, 120)
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



#add the form features
$form1.AcceptButton = $SearchButton
$form1.Controls.Add($Search)
$form1.Controls.Add($SearchBox)
$form1.Controls.Add($SearchButton)
$form1.Controls.Add($CompareBox)
$form1.Controls.Add($CopyNewUserBox)
#display the form
$User_Input = $form1.ShowDialog()
[System.Windows.Forms.Application]::EnableVisualStyles()

