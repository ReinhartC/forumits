<?php include "../database/adminCheck.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Users</title>
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
          <h1>Users List</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          <?php
            if(isset($_POST['report'])){
              $_SESSION['report']=$_POST['report'];
              echo '<meta http-equiv="refresh" content="0; URL=report.php">';
            }
          ?>
          
          <!-- Reports -->
          <div class="col-md-12">
            <div class="box box-primary">
              <div class="box-header with-border">
                <h3 class="box-title">Latest Active Users</h3>
              </div>
              <div class="box-body no-padding">
                <div class="table-responsive mailbox-messages">
                  <table class="table table-hover table-striped">
                    <tbody>
                    <!-- Report load loop -->
                    <?php
                      include '../database/connect.php';
                      $query = "CALL users_list(-1)";
                      $sql = mysqli_query($db, $query) or die("Query fail : ".mysqli_error($db));
                      $ReportArr = array();
                      while($row = mysqli_fetch_assoc($sql)){
                    ?>
                    <tr>
                      <td class="text-left"><b>
                        <div class="user-block">
                          <img class="img-circle" src="<?php echo"$row[user_photo]";?>" alt="User Image">
                          <span class="username">&nbsp;<?php echo"$row[user_name]";?>                 
                          </b>&emsp;<?php echo"$row[user_id]";?><br>
                          </b>&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo"$row[user_role]";?><br>
                    </span></div>
                      <td class="text-right"><small>Last login at<br><?php echo"$row[last_login]";?></small></td>
                    </tr>
                    <?php } ?>

                    </tbody>
                  </table>
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
