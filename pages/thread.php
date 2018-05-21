<?php include "database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Thread</title>
  <!-- HEADER -->
  <link rel="import" href="elements/header.html">
</head>

<body class="hold-transition skin-blue layout-top-nav">
  <div class="wrapper">

    <!-- NAVBAR -->
    <?php include "elements/navbar.php"; ?>
    <div class="content-wrapper">
      <div class="container">
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

            <!-- Thread -->
            <div class="box box-widget">
              <?php
                if(isset($_SESSION['thread'])){
                    include "database/connect.php";
                    $query = "CALL thread_load($_SESSION[thread])";
                    $sql = mysqli_query($db, $query);
                    $row = mysqli_fetch_array($sql);
                }
              ?>
              <!-- Main Thread -->
              <div class="box-header with-border">
                <div class="user-block">
                  <img class="img-circle" src="<?php echo"$row[user_photo]";?>" alt="User Image">
                  <span class="username"><?php echo"$row[thread_judul]";?>
                    <a class="text-muted pull-right" href="report.php"><small>Report this Thread &emsp;</small></a>
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
                      <a class='btn btn-default btn-md btn-flat' href='$row[thread_attachment]'>$row[thread_attachment]</a>
                    ";  
                  }
                ?>
              </div>
              <?php
                include 'database/connect.php';
                $query1 = "CALL reply_load($_SESSION[thread])";
                $sql1 = mysqli_query($db, $query1) or die("Query fail : ".mysqli_error($db));
                $ThreadArr = array();
                while($row1 = mysqli_fetch_assoc($sql1)){
              ?>
                <div class="box-footer box-comments">
                  <div class="box-comment">
                    <img class="img-circle img-sm" src="<?php echo "$row1[user_photo]";?>" alt="User Image">
                    <div class="comment-text">
                      <span class="username"> <?php echo "$row1[user_name]";?>
                        <span class="text-muted pull-right"><?php echo "$row1[reply_time]";?>&emsp;</span>
                      </span>
                      <?php echo nl2br($row1['reply_isi']);?>
                    </div>
                  </div>
                </div>
              <?php } ?>

              <?php
                if(isset($_POST['enter'])){
                  $_POST['reply'] = str_replace("'", "’", $_POST['reply']);
                  include "database/connect.php";
                  $_POST['body'] = str_replace("'", "’", $_POST['body']);
                  $query2 = "CALL reply_thread('$_POST[reply]','$_SESSION[thread]','$_SESSION[userid]')";
                  $sql2 = mysqli_query($db, $query2);
                  $row2 = mysqli_fetch_array($sql2);
                  echo '<meta http-equiv="refresh" content="0; URL=thread.php">';
                  mysqli_close($db);
                }            
              ?> 
              <!-- Create replies -->
              <div class="box-footer">
                <form role="form" method="post">
                  <div class="col-sm-11">
                    <textarea class="form-control" name="reply" id="reply" placeholder="Enter your reply here"></textarea>
                  </div>
                  <div>
                    <input class="btn btn-success btn-md btn-flat" type="submit" name="enter" id="enter" value="Reply"/>
                  </div>
                </form>
              </div>

              <!-- /.box-footer -->
            </div>
            <!-- /.box -->

        </section>
        <!--====================================================/CONTENT=============================================================-->
      </div>
    </div>
  </div>

  <!-- FOOTER -->
  <?php include "elements/footer.php"; ?>

  <!-- SCRIPTS -->
  <link rel="import" href="elements/script.html">

</body>
</html>
