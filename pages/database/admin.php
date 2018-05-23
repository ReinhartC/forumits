<?php
      session_start();
      if($_SESSION['userid'] != "admin"){
    		header("Location:../login.php");
            die;
  	  }
?>