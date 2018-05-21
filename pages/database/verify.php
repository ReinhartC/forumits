<?php
      session_start();
      if($_SESSION['userid'] == "admin"){
    		header("Location:../admin/admin.php");
        	die;
  	  }
      if(!isset($_SESSION['userid'])){
            header("Location:../login.php");
            die;
      }
?>