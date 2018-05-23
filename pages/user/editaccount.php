<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Edit Account</title>
  <!-- HEADER -->
  <link rel="import" href="../elements/header.html">
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>

<body class="hold-transition skin-blue layout-top-nav">
  <div class="wrapper">

    <!-- NAVBAR -->
    <?php include "../elements/navbar.php"; ?>
    <div class="content-wrapper">
      <div class="container">
        <!-- CONTENT TITLE -->
        <section class="content-header">
          <h1>Edit Account</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          <!-- User data edit -->
          <?php
            if(isset($_POST['edit'])){
              $tdir = "../../uploads/profpic/";
              $tfile = $tdir . basename($_FILES['photo']['name']);

                       
                include "../database/connect.php";
              
                $_POST['email'] = str_replace("'", "’", $_POST['email']);
                $_POST['phone'] = str_replace("'", "’", $_POST['phone']);
                $_POST['note'] = str_replace("'", "’", $_POST['note']);
                
                if($_FILES["photo"]["size"] == 0){
                  $query = "CALL account_edit('$_SESSION[userid]','$_POST[email]','$_POST[phone]','$_SESSION[usrpt]','$_POST[note]')";
                }
                else{
                  $query = "CALL account_edit('$_SESSION[userid]','$_POST[email]','$_POST[phone]','$tfile','$_POST[note]')";
                }
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
                $edits=$row[1];
                unset($_SESSION['usrpt']);
                echo '<meta http-equiv="refresh" content="0; URL=account.php">';
                mysqli_close($db);
              
            }
          ?>

          <!-- User data call -->
          <?php
            if(isset($_SESSION['userid'])){
              include "../database/connect.php";
              $query = "CALL user_data_acc('$_SESSION[userid]')";
              $sql = mysqli_query($db, $query);
              $row = mysqli_fetch_array($sql);
              $_SESSION['usrpt']=$row['user_photo'];
            }
          ?>

          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Edit your account</h3>
            </div>
            <form role="form" method="post" enctype="multipart/form-data">
              <fieldset>
                  <div class="form-group col-sm-6">
                      <strong>Name</strong>
                      <input class="form-control" autofocus id="name" type="text" name="name" placeholder="Username" required="" value="<?php echo "$row[user_name]";?>" readonly/>
                  </div>
                  <div class="form-group col-sm-6">
                      <strong>Role</strong>
                      <input class="form-control" autofocus id="role" type="text" name="role" placeholder="User Role" required="" value="<?php echo "$row[user_role]";?>" readonly/>
                  </div>
                  <div class="form-group col-sm-6">
                      <strong>ID</strong>  
                      <input class="form-control" autofocus id="iduser" type="text" name="iduser" placeholder="User ID" required="" value="<?php echo "$row[user_id]";?>" readonly/>
                  </div>
                  <div class="form-group col-sm-6">
                      <strong>Email</strong>  
                      <input class="form-control" autofocus id="email" type="text" name="email" placeholder="User Email" required="" value="<?php echo "$row[user_email]";?>"/>
                  </div>
                  <div class="form-group col-sm-6">
                      <strong>Phone</strong>  
                      <input class="form-control" autofocus id="phone" type="text" name="phone" placeholder="User Phone" required="" value="<?php echo "$row[user_phone]";?>"/>
                  </div>
                  <div class="col-sm-6">
                    <strong>Photo</strong><br>
                    <div class="btn btn-default btn-file btn-flat">
                      Change
                      <input type="file" id="photo" name="photo" accept="image/*"/>
                    </div>
                    <p class="help-block"><small>(Hover at the button to see the photo)</small> <br>
                    Max. file size is 2MB
                  </div>
                  <div class="form-group col-sm-6">
                      <strong>Note</strong>  
                      <textarea class="form-control" name="note" id="note" rows="5" cols="40" placeholder="User Note"><?php echo "$row[user_note]";?></textarea>
                  </div>  
                  
                  <div class="col-sm-12">
                      <br><input class="btn btn-md btn-primary btn-flat" type="submit" name="edit" id="edit" value="Confirm"/><br><br>
                  </div>
              </fieldset>
          </form>
        </div>


        </section>
        <!--====================================================/CONTENT=============================================================-->
      </div>
    </div>
  </div>

  <!-- FOOTER -->
  <?php include "../elements/footer.php"; ?>

  <!-- SCRIPTS -->
  <link rel="import" href="../elements/script.html">
  <script type="text/javascript">
    var uploadField = document.getElementById("photo");

    uploadField.onchange = function() {
        if(this.files[0].size > 2097152){
           alert("Photo file is too large!");
           this.value = "";
        };
    };
  </script>

</body>
</html>
