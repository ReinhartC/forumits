<?php include "../database/adminCheck.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Announcement</title>
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
          <h1>Announcement</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          
          <?php
            include "../database/connect.php";
            $query1 = "CALL thread_view(0)";
            $sql1 = mysqli_query($db, $query1);
            $row1 = mysqli_fetch_array($sql1);
            if(isset($_POST['edit'])){
              if($_POST['body']==''){
                echo "<h4 style='color:#D50000'>Thread body is still empty.</h4>";
              }
              else{
                include "../database/connect.php";
                $_POST['title'] = str_replace("'", "’", $_POST['title']);
                $_POST['body'] = str_replace("'", "’", $_POST['body']);
                $query = "CALL make_announce('$_POST[title]','$_POST[body]',$_POST[active])";
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
                $adds=$row[1];
                echo '<script language="javascript">';
                echo 'alert("Announcement updated!")';  
                echo '</script>';
                echo '<meta http-equiv="refresh" content="0; URL=announce.php">';
                mysqli_close($db);
              }
            }      

          ?> 

          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Edit/Manage Announcement</h3>
            </div>
            <form role="form" method="post" enctype="multipart/form-data">
              <fieldset>
                  <div class="form-group col-sm-12">
                    <br>
                    <strong>Title</strong>
                    <?php
                      echo"
                      <input class='form-control' autofocus id='title' type='text' name='title' placeholder='Thread title' value='$row1[thread_judul]' required=''/>
                      ";
                    ?>
                  </div>
                  <div class="form-group col-sm-12">
                    <strong>Body</strong>
                    <?php
                      echo"
                        <textarea class='form-control' name='body' id='body' rows='5' cols='40' placeholder='Thread body' required=''>$row1[thread_isi]</textarea>
                      ";
                    ?>
                  </div>
                  <div class="col-sm-12">
                    <div class="form-group">
                      <strong>Status</strong><br>
                      <?php 
                        if($row1['thread_edit']==0){
                          echo"
                            <div class='radio'>
                              <label><input type='radio' name='active' id='active' value=1>Active</label>
                            </div>
                            <div class='radio'>
                              <label><input type='radio' name='active' id='active' value=0 checked>Inactive</label>
                            </div>
                          ";
                        }
                        else{
                          echo"
                            <div class='radio'>
                              <label><input type='radio' name='active' id='active' value=1 checked>Active</label>
                            </div>
                            <div class='radio'>
                              <label><input type='radio' name='active' id='active' value=0>Inactive</label>
                            </div>
                          ";
                        }
                      ?>
                  </div>
                  </div>
                  <div class="col-sm-12">
                      <input class="btn btn-md btn-primary btn-flat" type="submit" name="edit" id="edit" value="Submit"/><br><br>
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
