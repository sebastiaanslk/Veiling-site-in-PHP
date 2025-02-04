<?php
require '../php/connectDB.php';
session_start();

$gebruikersnaam = $_POST['Gebruikersnaam'];
$wachtwoord = $_POST['Wachtwoord'];

$passwordreset = false;
if(isset($_POST['passwordreset'])){
    if($_POST['passwordreset'] == '1'){
        $passwordreset = true;
    }
}

$sql = $dbh->prepare("SELECT * FROM Gebruiker WHERE Gebruikersnaam=:gebruikersnaam");
$sql->execute(['gebruikersnaam' => $gebruikersnaam]);
$gebruiker = $sql->fetch(PDO::FETCH_ASSOC);

$sql = $dbh->prepare("SELECT * FROM Admin WHERE Gebruikersnaam=:gebruikersnaam");
$sql->execute(['gebruikersnaam' => $gebruikersnaam]);
$admin = $sql->fetch(PDO::FETCH_ASSOC);

if (password_verify($wachtwoord, $admin['Wachtwoord'])) {
    $_SESSION['adminID'] = $admin['Gebruikersnaam'];
    header('Location: ../admin/index.php');

} elseif (password_verify($wachtwoord, $gebruiker['Wachtwoord'])) {
    
    $sql = $dbh->prepare("SELECT * FROM geblokkeerd WHERE Gebruiker=:gebruikersnaam");
    $sql->execute(['gebruikersnaam' => $gebruikersnaam]);
    $geblokkeerd = $sql->fetch(PDO::FETCH_ASSOC);
    

    if ($geblokkeerd) {

        if ($geblokkeerd['Duur'] == null) {
            $banOphefDatum = $geblokkeerd['Datum'];
            header('Location: ../geblokkeerd.php?gebruiker=' . $gebruikersnaam);
        } else {
            $banOphefDatum = date("Y-m-d", strtotime($geblokkeerd['Datum']. ' + ' . $geblokkeerd['Duur'] . ' days'));
        }

        if ($banOphefDatum <= date("Y-m-d")) {
            $sql = $dbh->prepare("DELETE FROM geblokkeerd WHERE Gebruiker=:gebruiker");
            $sql->execute(['gebruiker' => $gebruikersnaam]);
            $_SESSION['userID'] = $gebruikersnaam;
            
            if ($gebruiker['Geactiveerd'] == 1) {
                header('Location: ../profiel.php');
            } else {
                header('Location: ../mailversturen.php');
            }
        } else {
            header('Location: ../geblokkeerd.php?gebruiker=' . $gebruikersnaam);
        }
    } else {
        $_SESSION['userID'] = $gebruiker['Gebruikersnaam'];
        if ($gebruiker['Geactiveerd'] == 1) {
            if($passwordreset){
                header('Location: ../profiel.php?warn=1');
            }else{
                header('Location: ../profiel.php');
            }
        } else {
            header('Location: ../mailversturen.php');
        }
    }
} else {
    header('Location: ../inloggen.php?errc=1');
}
