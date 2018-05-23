<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Report Thread</title>
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
          <h1>Report Thread</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          <div class="box box-primary text-center">
            <div class="box-header with-border">
              <h3 class="box-title">Why do you report this thread?</h3>
            </div>
            <?php
              if(isset($_POST['report'])){
                if($_POST['rpbody']==''){
                  echo "<br><p style='color:#D50000'>&emsp;&emsp;Report field is empty.</p>";
                }
                else{
                  $_POST['rpbody'] = str_replace("'", "’", $_POST['rpbody']);

                  include "../database/connect.php";
                  $query2 = "CALL report_thread('$_POST[rpbody]','$_SESSION[thread]','$_SESSION[userid]')";
                  $sql2 = mysqli_query($db, $query2);
                  $row2 = mysqli_fetch_array($sql2);
                  echo '<meta http-equiv="refresh" content="0; URL=thread.php">';
                  mysqli_close($db);
                }
              }            
            ?> 
            <form role="form" method="post">
              <fieldset>
                  <div class="form-group col-sm-12">
                      <textarea class="form-control" name="rpbody" id="rpbody" placeholder="Enter your reply here" required=""></textarea>
                  </div>
                  <div class="col-sm-12">
                    <input class="btn btn-md btn-primary btn-flat" type="submit" name="report" id="report" value="Report"/><br><br>
                  </div>
              </fieldset>
          </form>
        </div>

        <div class="box box-widget">
          <?php
            if(isset($_SESSION['thread'])){
                include "../database/connect.php";
                $query = "CALL thread_view($_SESSION[thread])";
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
                $attach=$row['thread_attachment'];
                $attach = str_replace("../../uploads/attachment/", "", $attach);
            }
          ?>
          <!-- Main Thread -->
          <div class="box-header with-border">
            <div class="user-block">
              <img class="img-circle" src="<?php echo"$row[user_photo]";?>" alt="User Image">
              <span class="username"><?php echo"$row[thread_judul]";?>                    
              </span>
              <span class="description">by <?php echo"$row[user_name]";?> at <?php echo"$row[thread_time]";?></span>
            </div>
          </div>
          <div class="box-body">
            <p>&nbsp;<?php echo nl2br("$row[thread_isi]");?></p>
             <!-- Attachment -->
            <?php 
              if($row['thread_attachment']!= NULL){
                echo"
                  <br><p class='text-muted'>Attachment</p>
                  <a class='btn btn-default btn-md btn-flat' href='$row[thread_attachment]'>$attach</a>
                ";  
              }
            ?>
          </div>
       <!--====================================================/CONTENT=============================================================-->
      </div>
    </div>
  </div>

  <!-- FOOTER -->
  <?php include "../elements/footer.php"; ?>

  <!-- SCRIPTS -->
  <link rel="import" href="../elements/script.html">

</body>
</html>
