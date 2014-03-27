###
#Script Groupe 1 Création de Groupes et utilisateurs
###
Write-Host "Création de groupes"
Write-Host "Entrez le nom du groupe à créer"
## Saisie par l'utilisateur du nom de Groupe a créer

$groupe = Read-Host "Nom du groupe"
## On stocke le nom du groupe dans la variable $groupe
if ( Get-ADGroup -Filter {SamAccountName -eq $groupe} ) {
## On filtre la sortie de GET-ADGroup pour savoir si notre groupe existe, si oui on continue
    foreach ($ligne in Get-Content "C:\Users\Administrateur\Documents\userList.txt")
## On parse le fichier d'entrée ligne par ligne
    {
        $str = $ligne.split(":")
## On continue le parsage de la ligne grâce aux séparateurs
        try {
            New-ADUser -Name $str[2] -GivenName $str[0] -SurName $str[1]
            Write-Host "Utilisateur créé" }
## Le bloc try va tester si l'utilisateur existe. Si non il le crée
		catch {
            Write-Warning "Les utilisateurs existent déjà" }
## Catch affiche un message d'erreur si l'utilisateur n'existe pas
		try {
            Add-ADGroupMember -Identity $groupe -Member $str[2]
            write-host "membre ajouté dans le groupe" }
## Le bloc try va tester si l'on peut ajouter l'utilisateur au groupe 
		catch {
            Write-Warning "L'utilisateur est déjà dans le groupe" }
## Catch affiche un message d'erreurs si l'utilisateur est déjà dans le groupe 
    }
} else {
## Si le groupe n'existe PAS on le crée et on répète l'opération
    New-ADGroup $groupe -GroupScope "universal"
    foreach ($ligne in Get-Content "C:\Users\Administrateur\Documents\userList.txt")
    {
        $str = $ligne.split(":")
        try {
            New-ADUser -Name $str[2] -GivenName $str[0] -SurName $str[1] }
        catch {
            Write-Warning "Les utilisateurs existent déjà"
            Write-Host "Utilisateur créé" }
        try {
            Add-ADGroupMember -Identity $groupe -Member $str[2]
            write-host "membre ajouté dans le groupe" }
        catch {
            Write-Warning "L'utilisateur est déjà dans le groupe" }
    }
}

