<?php
session_start();
require '../php/connectDB.php';

$gebruikersnaam = $_SESSION['userID'];
$emailadres = $_POST['emailadres'];

$query = "SELECT Mailbox FROM Gebruiker WHERE Gebruikersnaam = :gebruikersnaam";
$sql = $dbh->prepare($query);
$sql->execute(['gebruikersnaam' => $gebruikersnaam]);
$mailbox = $sql->fetch(PDO::FETCH_ASSOC);
$mailbox = $mailbox['Mailbox'];

// Na het drukken op de knop zal de mail gestuurd worden naar de mail van de gebruiker. Dit wordt eerst uit de database gehaald met $mailbox

if (isset($_POST['geklikt']) &&  $emailadres == $mailbox) {
    $digits = 5;
    $controlegetal = mt_rand(pow(10, $digits-1), pow(10, $digits)-1);
    $subject = "Verificatiecode voor uw account";
    $txt = "
    <html>
    <head>
    <title>Verificatiecode</title>
    </head>
    <body style='text-algin: center;'>
    <h1>Uw Verificatiecode</h1>
    <p>Voer deze code in na het inloggen op EenmaalAndermaal</p>
    <h3>" . $controlegetal . "</h3>
    </body>
    </html>
    ";
    $headers = "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
    $headers .= "From: noreply@eenmaalandermaal.nl" . "\r\n";


    $success =  mail($emailadres, $subject, $txt, $headers);
    if (!$success) {
        header("Location: ../mailversturen.php?errc=1");
    }
    else
    {

    $query = "SELECT * FROM Verificatie WHERE Gebruikersnaam = '$gebruikersnaam'";
    $sql = $dbh->prepare($query);
    $sql->execute();
    $resultaat = $sql->fetch(PDO::FETCH_ASSOC);
    
    if($resultaat){
        $query = "UPDATE Verificatie 
        SET Verificatiecode = :controlegetal
        WHERE Gebruikersnaam = :gebruikersnaam";
        $sql = $dbh->prepare($query);
        $sql->bindValue(":gebruikersnaam", $gebruikersnaam);
        $sql->bindValue(":controlegetal", intval($controlegetal));
        $sql->execute();
    }else{
        $query = "INSERT INTO Verificatie (Gebruikersnaam, Verificatiecode) VALUES (:gebruikersnaam, :controlegetal)";
        $sql = $dbh->prepare($query);
        $sql->bindValue(":gebruikersnaam", $gebruikersnaam);
        $sql->bindValue(":controlegetal", intval($controlegetal));
        $sql->execute();
    }

    header("Location: ../mailverstuurd.php");
}
} else {
    header("Location: ../mailversturen.php?errc=1");
}
