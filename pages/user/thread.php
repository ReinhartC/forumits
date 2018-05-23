<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Thread</title>
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
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

            <!-- Thread -->
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
                if(isset($_POST['deletet'])){
                    include "../database/connect.php";
                    $query3 = "CALL delete_thread($_POST[deletet])";
                    $sql3 = mysqli_query($db, $query3);
                    $row3 = mysqli_fetch_array($sql3);
                    echo '<meta http-equiv="refresh" content="0; URL=account.php">';
                }
                if(isset($_POST['edit'])){
                    $_SESSION['thread']=$_POST['edit'];
                    echo '<meta http-equiv="refresh" content="0; URL=editthread.php">';
                }
              ?>
              <!-- Main Thread -->
              <div class="box-header with-border">
                <div class="user-block">
                  <img class="img-circle" src="<?php echo"$row[user_photo]";?>" alt="User Image">
                  <span class="username"><?php echo"$row[thread_judul]";?>                    
                    <?php
                      if($_SESSION['userid'] == "admin" || $_SESSION['userid'] == $row['user_id']){
                        echo"
                          <button class ='btn btn-sm btn-flat btn-danger pull-right' data-toggle='modal' data-target='#Delete'><em class='fa fa-trash'></em></button>
                          <form action='#' method='post' class='pull-right' style='display:inline-block'>
                            <button class ='btn btn-sm btn-flat btn-default' type='submit' name='edit' value='$row[thread_id]'><em class='fa fa-pencil'></em></button>
                          </form>
                        ";
                      }
                      else{
                        echo"
                          <a class='text-muted pull-right' href='report.php'><small>Report this Thread &emsp;</small></a>
                        ";
                      }
                    ?>
                    <div class="modal fade" id="Delete" role="dialog">
                      <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                          <div class="modal-header"> 
                            <h4 class="modal-title">Warning</h4>
                          </div>
                          <div class="modal-body">
                            <p>Are you sure you want to delete this thread?</p> 
                          </div>
                          <div class="modal-footer">
                            <form action="#" method="post">
                              <?php
                                echo "<button class ='btn btn-md btn-flat btn-danger' type='submit' name='deletet' id='deletet' value='$row[thread_id]'>Delete</button>
                                ";
                              ?>
                              <button type="button" class="btn btn-flat btn-default" data-dismiss="modal">Cancel</button>
                            </form>
                          </div>
                        </div>
                      </div>
                    </div>
                
                  </span>
                  <span class="description">
                    <?php
                      if($row['thread_edit']==0){
                        echo "Created ";
                      }
                      else{
                        echo "Edited ";
                      }
                    ?>
                    by <?php echo"$row[user_name]";?> at <?php echo"$row[thread_time]";?></span>
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
              <?php
                include '../database/connect.php';
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
                  if($_POST['reply']==''){
                    echo "<br><p style='color:#D50000'>&emsp;&emsp;Reply is empty.</p>";
                  }
                  else{
                    $_POST['reply'] = str_replace("'", "’", $_POST['reply']);

                    include "../database/connect.php";
                    $query2 = "CALL reply_thread('$_POST[reply]','$_SESSION[thread]','$_SESSION[userid]')";
                    $sql2 = mysqli_query($db, $query2);
                    $row2 = mysqli_fetch_array($sql2);
                    echo '<meta http-equiv="refresh" content="0; URL=thread.php">';
                    mysqli_close($db);
                  }
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
  <?php include "../elements/footer.php"; ?>

  <!-- SCRIPTS -->
  <link rel="import" href="../elements/script.html">

</body>
</html>
