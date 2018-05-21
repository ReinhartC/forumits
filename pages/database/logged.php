<?php
      session_start();
      if(isset($_SESSION['userid'])){
      	if($_SESSION['userid'] == "admin"){
        	header("Location:../admin/admin.php");
            die;
      	}
      	else{
            header("Location:../user/index.php");
            die;
        }
      }
?>