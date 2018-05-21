<?php
    include "database/logged.php";
?>

<!DOCTYPE html>
<html>
<head>
  <title>FITS | Login</title>
  <!-- HEADER -->
  <link rel="import" href="elements/header.html">
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<body class="hold-transition login-page">
  <div class="login-box">
    <div class="login-logo">
      <a>Forum<b>ITS</b></a>
    </div>
    <div class="login-box-body">
      <?php
        if(isset($_POST['submit'])){
          include "database/connect.php";

          $query = "CALL login('$_POST[userid]','$_POST[password]')";
          $sql = mysqli_query($db, $query);

          $row = mysqli_fetch_array($sql);
              if($row[0] == 0){
                  $_SESSION['userid']=$_POST['userid'];
                  $_SESSION['password']=$row[2];
                  $_SESSION['loggedIn']=true;
                  echo $row[1];
                  if($_SESSION['userid'] == "admin"){
                    header("Location:admin/admin.php");
                  }
                  else{ header("Location:user/index.php"); }
              }
                  echo "<p style='color:maroon'>$row[1]</p>"; 
                  mysqli_close($db);

        }
      ?>
      <!--FORM-->
      <form role="form" action="#" method="post">
          <fieldset>
              <div class="form-group has-feedback">
                  <input class="form-control" autofocus id="userid" type="text" name="userid" placeholder="User ID" required=""/>
                  <span class="glyphicon glyphicon-user form-control-feedback"></span>
              </div>
              <div class="form-group has-feedback">
                  <input class="form-control" id="password" type="password"  name="password" placeholder="Password" required=""/>
                  <span class="glyphicon glyphicon-lock form-control-feedback"></span>
              </div>
              <input class="btn btn-md btn-primary btn-block btn-flat" type="submit" name="submit" id="submit" value="Login"/><br>
          </fieldset>
      </form>
      <!--/FORM-->      
    </div>
  </div>

  <!-- SCRIPT -->
  <link rel="import" href="elements/script.html">
</body>
</html>
