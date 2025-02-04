<!-- <style>
    .dash-nav-dropdown {
        width: 300px;
    }

    .dash-nav-dropdown,
    .show {
        width: 300px;
    }

    .dash-toolbar {
        margin-left: 61px;

    }
</style> -->

<?php session_start();
require_once '../php/connectDB.php';
if(!isset($_SESSION['adminID'])){
    header('Location: ../inloggen.php');
}else{
    $adminID = $_SESSION['adminID'];
    $query = 'SELECT * FROM Admin WHERE Gebruikersnaam = :gebruikersnaam';
    $sql = $dbh->prepare($query);
    $sql->execute(['gebruikersnaam' => $adminID]);
    $admin = $sql->fetch(PDO::FETCH_ASSOC);
    $voornaam = $admin['Voornaam'];
    $achternaam = $admin['Achternaam'];
}
?>
<div class="dash">
    <div class="dash-nav dash-nav-dark" style="background-color: #FF814F">
        <header>
            <a href="#!" class="menu-toggle">
                <i class="fas fa-bars"></i>
            </a>
            <img src="../images/LogoWit.png" style="width: 120px" alt="">        </header>
        <nav class="dash-nav-list">
            <a href="index.php" class="dash-nav-item">
                <i class="fas fa-home"></i> Dashboard </a>
            <div class="dash-nav-dropdown">
                <a href="#!" class="dash-nav-item dash-nav-dropdown-toggle">
                    <i class="fas fa-user-tie"></i> Gebruikers </a>
                <div class="dash-nav-dropdown-menu">
                    <a href="verkoper-blokkeren.php" class="dash-nav-dropdown-item"><i class="fas fa-flag"></i> &nbsp Gerapporteerd </a>
                    <a href="verkoper-deblokkeren.php" class="dash-nav-dropdown-item"><i class="fas fa-ban"></i> &nbsp Geblokkeerd</a>
                    <a href="verkoper-activeren.php" class="dash-nav-dropdown-item"><i class="fas fa-hourglass-half"></i> &nbsp In afwachting</a>
                </div>
            </div>
            <div class="dash-nav-dropdown">
                <a href="#!" class="dash-nav-item dash-nav-dropdown-toggle">
                <i class="fas fa-gavel"></i> Veilingen </a>
                <div class="dash-nav-dropdown-menu">
                    <a href="veiling-blokkeren.php" class="dash-nav-dropdown-item"><i class="fas fa-flag"></i> &nbsp Gerapporteerd</a>
                    <a href="veiling-deblokkeren.php" class="dash-nav-dropdown-item"><i class="fas fa-ban"></i> &nbsp Geblokkeerd</a>
                </div>
                <a href="CategorieUpdate.php" class="dash-nav-item">
                <i class="fas fa-table"></i> Rubrieken </a>
            </div>
        </nav>
    </div>
    <div class="dash-app">
        <header class="dash-toolbar">
            <a href="#!" class="menu-toggle">
                <i class="fas fa-bars"></i>
            </a>
            <div class="tools">
                <div class="dropdown tools-item">
                    <a href="#" class="" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true"
                        aria-expanded="false">
                        <i class="fas fa-user"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenu1">
                        <span class="dropdown-item"><?=$voornaam?> <?=$achternaam?></span>
                        <a class="dropdown-item" href="../php/logout.php">Logout</a>
                    </div>
                </div>
            </div>
        </header>