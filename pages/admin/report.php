<?php include "../database/adminCheck.php"; 
      $row1['thread_id']=60;
?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Thread Report</title>
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
          <h1>Thread Report</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          <div class="box box-primary">
            <?php
              if(isset($_SESSION['report'])){
                include "../database/connect.php";
                $query1 = "CALL report_view($_SESSION[report])";
                $sql1 = mysqli_query($db, $query1);
                $row1 = mysqli_fetch_array($sql1);
              }
              if(isset($_POST['ignore'])){
                  include "../database/connect.php";
                  $query2 = "CALL report_ignore($_POST[ignore])";
                  $sql2 = mysqli_query($db, $query2);
                  $row2 = mysqli_fetch_array($sql2);
                  echo '<meta http-equiv="refresh" content="0; URL=reports.php">';
              }
              if(isset($_POST['delete'])){
                  include "../database/connect.php";
                  $query3 = "CALL delete_thread($_POST[delete])";
                  $sql3 = mysqli_query($db, $query3);
                  $row3 = mysqli_fetch_array($sql3);
                  
                  include "../database/connect.php";
                  $notiff="Admin have deleted your `$row1[thread_judul]` thread";
                  $queryn = "CALL notif_add('$row1[user_id]','$notiff')";
                  $sqln = mysqli_query($db, $queryn);
                  $rown = mysqli_fetch_array($sqln);
                
                  echo '<meta http-equiv="refresh" content="0; URL=reports.php">';
              }
            ?> 
            <div class="box-header with-border">
              <h3 class="box-title">Respond to report from <?php echo $row1['user_name'];?></h3>
            </div>
            <div class="box-body">
              <p>&nbsp;<?php echo nl2br("$row1[report_isi]");?></p>
              <div class="col-sm-12">
                <button class ="btn btn-md btn-flat btn-danger" data-toggle="modal" data-target="#Deleter">Delete Thread</button>&nbsp;
                <button class ="btn btn-md btn-flat btn-warning" data-toggle="modal" data-target="#Ignorer">Ignore Report</button>
              </div>
            </div>

            <div class="modal fade" id="Deleter" role="dialog">
              <div class="modal-dialog modal-sm">
                <div class="modal-content">
                  <div class="modal-header"> 
                    <h4 class="modal-title">Warning</h4>
                  </div>
                  <div class="modal-body">
                    <p>Are you sure you want to delete the thread?</p> 
                  </div>
                  <div class="modal-footer">
                    <form action="#" method="post">
                      <?php
                        echo "<button class ='btn btn-md btn-flat btn-danger' type='submit' name='delete' id='delete' value='$row1[thread_id]'>Delete</button>
                        ";
                      ?>
                      <button type="button" class="btn btn-flat btn-default" data-dismiss="modal">Cancel</button>
                    </form>
                  </div>
                </div>
              </div>
            </div>

            <div class="modal fade" id="Ignorer" role="dialog">
              <div class="modal-dialog modal-sm">
                <div class="modal-content">
                  <div class="modal-header"> 
                    <h4 class="modal-title">Warning</h4>
                  </div>
                  <div class="modal-body">
                    <p>Are you sure you want to ignore the report?</p> 
                  </div>
                  <div class="modal-footer">
                    <form action="#" method="post">
                      <?php
                        echo "<button class ='btn btn-md btn-flat btn-warning' type='submit' name='ignore' id='ignore' value='$row1[report_id]'>Ignore</button>
                        ";
                      ?>
                      <button type="button" class="btn btn-flat btn-default" data-dismiss="modal">Cancel</button>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>

        <div class="box box-widget">
          <?php
            if(isset($row1['thread_id'])){
                include "../database/connect.php";
                $query = "CALL thread_view($row1[thread_id])";
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
