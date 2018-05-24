<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Account</title>
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
          <h1>Account</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          <?php
            if(isset($_POST['thread'])){
              $_SESSION['thread']=$_POST['thread'];
              echo '<meta http-equiv="refresh" content="0; URL=thread.php">';
            }
          ?>
          
          <!-- LEFTSIDE -->
          <div class="row">
            <div class="col-md-3">

              <!-- User Data Call -->
              <?php
                if(isset($_SESSION['userid'])){
                    include "../database/connect.php";
                    $query = "CALL user_data_acc('$_SESSION[userid]')";
                    $sql = mysqli_query($db, $query);
                    $row = mysqli_fetch_array($sql);
                    $_SESSION['user_threadcount']=$row['user_threadcount'];
                }
              ?>

              <!-- User Profile -->
              <div class="box box-primary">
                <div class="box-body box-profile">
                  <img class="profile-user-img img-responsive img-circle" src="<?php echo"$row[user_photo]";?>" alt="User profile picture">
                  <h3 class="profile-username text-center"><?php echo"$row[user_name]";?></h3>
                  <h4 class="profile-username text-center"><small><?php echo"$row[user_role]";?> - <?php echo"$row[user_id]";?></small></h4>
                  <div class="col-md-12 text-center"><a class="btn btn-primary btn-sm btn-flat" href="editaccount.php">Edit profile</a></div>
                </div>
              </div>

              <!-- About Me -->
              <div class="box box-primary">
                <div class="box-header with-border">
                  <h3 class="box-title">About</h3>
                </div>
                <div class="box-body">
                  <strong><i class="fa fa-at margin-r-5"></i> Email</strong><br>
                  <p class="col-sm-6 text-muted"><?php echo"$row[user_email]";?></p>
                  <hr>
                  <strong><i class="fa fa-phone margin-r-5"></i> Phone</strong><br>
                  <p class="col-sm-6 text-muted"><?php echo"$row[user_phone]";?></p>
                  <hr>
                  <strong><i class="fa fa-clone margin-r-5"></i> Threads</strong><br>
                  <p class="col-sm-6 text-muted"><?php echo"$row[user_threadcount]";?> Threads</p>
                  <hr>
                  <strong><i class="fa fa-sticky-note-o margin-r-5"></i> Note</strong><br>
                  <p class="col-sm-6 text-muted"><?php echo nl2br("$row[user_note]");?></p>
                </div>
              </div>
            </div>

            <!-- RIGHTSIDE -->
            <div class="col-md-9">
              <div class="box box-primary">
                <div class="box-header with-border">
                  <h3 class="box-title">Latest Threads</h3>
                  <a href="accthreads.php"><small class="pull-right">View All</small></a>
                </div>
                <div class="box-body no-padding">
                  <div class="table-responsive mailbox-messages">
                    <table class="table table-hover table-striped">
                      <tbody>
                        <!-- Thread load loop -->
                        <?php
                          if($_SESSION['user_threadcount']==0){
                            echo "
                              <tr>
                                <td class='text-left'>
                                  <form method='post'>
                                    User haven't created any thread yet.
                                  </form>
                                </td>
                              </tr>
                            ";
                          }                          
                          include '../database/connect.php';
                          $query = "CALL account_threadlist($_SESSION[userid],4)";
                          $sql = mysqli_query($db, $query) or die("Query fail : ".mysqli_error($db));
                          $ThreadArr = array();
                          $ctr=0;
                          while($row = mysqli_fetch_assoc($sql)){
                        ?>
                        <tr>
                          <td class="text-left"><b>
                            <form method="post">
                              <button style="border:none; background:none; padding:0; color:#0073b7;" type="submit" name="thread" id="thread" value="<?php echo "$row[thread_id]";?>"><?php echo"$row[thread_judul]";?></button>
                            </form>
                          </b><small><?php echo"$row[user_name]";?></small></td>
                          <td class="text-right"><small><?php echo"$row[thread_time]";?></small></td>
                        </tr>
                        <?php } ?>
                        
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-md-9">
              <div class="box box-primary">
                <div class="box-header with-border">
                  <h3 class="box-title">Private Threads</h3>
                  <a href="privthreads.php"><small class="pull-right">View All</small></a>
                </div>
                <div class="box-body no-padding">
                  <div class="table-responsive mailbox-messages">
                    <table class="table table-hover table-striped">
                      <tbody>
                        <!-- Thread load loop -->
                        <?php
                        include "../database/connect.php";
                        $query4 = "CALL prvt_count($_SESSION[userid])";
                        $sql4 = mysqli_query($db, $query4);
                        $row4 = mysqli_fetch_array($sql4);
                          if($row4['pc']==0){
                            echo "
                              <tr>
                                <td class='text-left'>
                                  <form method='post'>
                                    User is not in any private thread yet.
                                  </form>
                                </td>
                              </tr>
                            ";
                          }                          
                          include '../database/connect.php';
                          $query1 = "CALL prvt_list($_SESSION[userid],4)";
                          $sql1 = mysqli_query($db, $query1) or die("Query fail : ".mysqli_error($db));
                          $ThreadArr1 = array();
                          $ctr1=0;
                          while($row1 = mysqli_fetch_assoc($sql1)){
                        ?>
                        <tr>
                          <td class="text-left"><b>
                            <form method="post">
                              <button style="border:none; background:none; padding:0; color:#0073b7;" type="submit" name="thread" id="thread" value="<?php echo "$row1[thread_id]";?>"><?php echo"$row1[thread_judul]"; if($row1['thread_access']=='private'){echo" &nbsp;<i class='fa fa-lock'></i>";}?></button>
                            </form>
                          </b><small><?php echo"$row1[creator]";?></small></td>
                          <td class="text-right"><small><?php echo"$row1[thread_time]";?></small></td>
                        </tr>
                        <?php } ?>
                        
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
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

</body>
</html>
