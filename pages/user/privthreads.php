<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Private Threads</title>
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
          <h1>Your Private Threads</h1>
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
          
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Latest Threads</h3>
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
                      $query = "CALL prvt_list($_SESSION[userid],-1)";
                      $sql = mysqli_query($db, $query) or die("Query fail : ".mysqli_error($db));
                      $ThreadArr = array();
                      while($row = mysqli_fetch_assoc($sql)){
                    ?>
                    <tr>
                      <td class="text-left"><b>
                        <form method="post">
                          <button style="border:none; background:none; padding:0; color:#0073b7;" type="submit" name="thread" id="thread" value="<?php echo "$row[thread_id]";?>"><?php echo"$row[thread_judul]"; if($row['thread_access']=='private'){echo" &nbsp;<i class='fa fa-lock'></i>";}?></button>
                        </form>
                      </b><small><?php echo"$row[creator]";?></small></td>
                      <td class="text-right"><small><?php echo"$row[thread_time]";?></small></td>
                    </tr>
                    <?php } ?>
                    
                  </tbody>
                </table>
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
