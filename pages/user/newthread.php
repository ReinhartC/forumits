<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | New Thread</title>
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
          <h1>New Thread</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          
          <?php
            if(isset($_POST['add'])){
              if($_POST['body']==''){
                echo "<h4 style='color:#D50000'>Thread body is still empty.</h4>";
              }
              else{
                $tdir = "../../uploads/attachment/";
                $tfile = $tdir . basename($_FILES['attachment']['name']);

                include "../database/connect.php";
                $_POST['body'] = str_replace("'", "’", $_POST['body']);
                $_POST['title'] = str_replace("'", "’", $_POST['title']);

                if($_FILES["attachment"]["size"] == 0){
                  $query = "CALL new_thread('$_POST[title]','$_POST[body]','','$_SESSION[userid]')";
                }
                else if(move_uploaded_file($_FILES["attachment"]["tmp_name"], $tfile)){
                  $query = "CALL new_thread('$_POST[title]','$_POST[body]','$tfile','$_SESSION[userid]')";
                }
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
                $adds=$row[1];   
                echo '<meta http-equiv="refresh" content="0; URL=account.php">';
                mysqli_close($db);   
              }
            }      

          ?> 

          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Create a new thread</h3>
            </div>
            <form role="form" method="post" enctype="multipart/form-data">
              <fieldset>
                  <div class="form-group col-sm-12">
                      <input class="form-control" autofocus id="title" type="text" name="title" placeholder="Thread title" required=""/>
                  </div>
                  <div class="form-group col-sm-12">
                      <textarea class="form-control" name="body" id="body" rows="5" cols="40" placeholder="Thread body" required=""></textarea>
                  </div>
                  <div class="col-sm-12">
                    <div class="btn btn-default btn-file btn-flat">
                      <i class="fa fa-paperclip"></i>&nbsp; Attachment
                      <input type="file" name="attachment" id="attachment">
                    </div>
                    <p class="help-block"><small>(Hover at the button to see the attachment)</small> <br>
                    Max. file size is 2MB<br>
                    If there is no attachments, you can leave it empty.</p>
                  </div>
                  <div class="col-sm-12">
                      <br><input class="btn btn-md btn-primary btn-flat" type="submit" name="add" id="add" value="Add"/><br><br>
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
    var uploadField = document.getElementById("attachment");

    uploadField.onchange = function() {
        if(this.files[0].size > 2097152){
           alert("Attachment file is too large!");
           this.value = "";
        };
    };
  </script>
</body>
</html>
