<?php include "../database/adminCheck.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Reports</title>
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
          <h1>Reports</h1>
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
                <h3 class="box-title">Latest Reports</h3>
              </div>
              <div class="box-body no-padding">
                <div class="table-responsive mailbox-messages">
                  <table class="table table-hover table-striped">
                    <tbody>
                    <!-- Report load loop -->
                    <?php
                      include '../database/connect.php';
                      $query = "CALL report_list(50)";
                      $sql = mysqli_query($db, $query) or die("Query fail : ".mysqli_error($db));
                      $ReportArr = array();
                      while($row = mysqli_fetch_assoc($sql)){
                    ?>
                    <tr>
                      <td class="text-left"><b>
                        <form method="post">
                          <button style="border:none; background:none; padding:0; color:#0073b7;" type="submit" name="report" id="report" value="<?php echo "$row[report_id]";?>">Report by <?php echo"$row[reporter]";?></button>
                        </form>
                      </b>On "<b><?php echo"$row[thread_judul]";?></b>" thread.<br>
                      <td class="text-right"><small><?php echo"$row[report_time]";?></small></td>
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
