<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Edit Thread</title>
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
          <h1>Edit Thread</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          
          <?php
            if(isset($_SESSION['thread'])){
                include "../database/connect.php";
                $query1 = "CALL thread_view($_SESSION[thread])";
                $sql1 = mysqli_query($db, $query1);
                $row1 = mysqli_fetch_array($sql1);
                $attach=$row1['thread_attachment'];
                $attach = str_replace("../../uploads/attachment/", "", $attach);
            }
            if(isset($_POST['edit'])){
              if($_POST['body']==''){
                echo "<h4 style='color:#D50000'>Thread body is still empty.</h4>";
              }
              else{
                $tdir = "../../uploads/attachment/";
                $tfile = $tdir . basename($_FILES['attachment']['name']);

                include "../database/connect.php";
                $_POST['body'] = str_replace("'", "’", $_POST['body']);

                if($_FILES["attachment"]["size"] == 0){
                  $query = "CALL edit_thread($row1[thread_id],'$_POST[body]','$row1[thread_attachment]')";
                }
                else if(move_uploaded_file($_FILES["attachment"]["tmp_name"], $tfile)){
                  $query = "CALL edit_thread($row1[thread_id],'$_POST[body]','$tfile')";
                }
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
                $adds=$row[1];

                include "../database/connect.php";
                $notiff="You have successfully edited your `$_POST[title]` thread";
                $queryn = "CALL notif_add('$_SESSION[userid]','$notiff')";
                $sqln = mysqli_query($db, $queryn);
                $rown = mysqli_fetch_array($sqln);

                echo '<meta http-equiv="refresh" content="0; URL=thread.php">';
                mysqli_close($db);
              }
            }      

          ?> 

          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Edit this thread</h3>
            </div>
            <form role="form" method="post" enctype="multipart/form-data">
              <fieldset>
                  <div class="form-group col-sm-12">
                    <?php
                      echo"
                      <input class='form-control' autofocus id='title' type='text' name='title' placeholder='Thread title' value='$row1[thread_judul]' required='' readonly/>
                      ";
                    ?>
                  </div>
                  <div class="form-group col-sm-12">
                    <?php
                      echo"
                        <textarea class='form-control' name='body' id='body' rows='5' cols='40' placeholder='Thread body' required=''>$row1[thread_isi]</textarea>
                      ";
                    ?>
                  </div>
                  <div class="col-sm-12">
                    <?php 
                      if($row1['thread_attachment']!= NULL){
                        echo"
                          <br><p class='text-muted'>Attachment</p>
                          <a class='btn btn-default btn-md btn-flat' href='$row1[thread_attachment]'>$attach</a>

                          <div class='btn btn-default btn-file btn-flat'>
                            <i class='fa fa-paperclip'></i>&nbsp; Reupload
                            <input type='file' name='attachment' id='attachment'>
                          </div>
                          <p class='help-block'><small>(Hover at the button to see the attachment)</small> <br>
                          Max. file size is 2MB<br>
                          If there is no attachments, you can leave it empty.</p>
                        ";
                      }
                      else{
                        echo"
                        <div class='btn btn-default btn-file btn-flat'>
                          <i class='fa fa-paperclip'></i>&nbsp; Attachment
                          <input type='file' name='attachment' id='attachment'>
                        </div>
                        <p class='help-block'><small>(Hover at the button to see the attachment)</small> <br>
                        Max. file size is 2MB<br>
                        If there is no attachments, you can leave it empty.</p>
                        ";
                      }
                    ?>
                  </div>
                  <div class="col-sm-12">
                      <br><input class="btn btn-md btn-primary btn-flat" type="submit" name="edit" id="edit" value="Edit"/><br><br>
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
