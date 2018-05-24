<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Threads</title>
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
          <h1>Threads</h1>
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
          
          <!-- Tabs -->
          <div class="nav-tabs-custom">
            <ul class="nav nav-tabs nav-justified">
              <li class="active"><a href="#dsn" data-toggle="tab">Dosen & Karyawan</a></li>
              <li><a href="#mhs" data-toggle="tab">Mahasiswa</a></li>
            </ul>

            <!-- Thread Dosen & Karyawan -->
            <div class="tab-content">
              <div class="tab-pane fade in active" id="dsn">
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
                            include '../database/connect.php';
                            $query = "CALL thread_loadp('Dosen',50)";
                            $sql = mysqli_query($db, $query) or die("Query fail : ".mysqli_error($db));
                            $ThreadArr = array();
                            while($row = mysqli_fetch_assoc($sql)){
                              if($row['thread_access']=='public'){
                          ?>
                          <tr>
                            <td class="text-left"><b>
                              <form method="post">
                                <button style="border:none; background:none; padding:0; color:#0073b7;" type="submit" name="thread" id="thread" value="<?php echo "$row[thread_id]";?>"><?php echo"$row[thread_judul]"; if($row['thread_access']=='private'){echo" &nbsp;<i class='fa fa-lock'></i>";}?></button>
                              </form>
                            </b><small><?php echo"$row[user_name]";?></small></td>
                            <td class="text-right"><small><?php echo"$row[thread_time]";?></small></td>
                          </tr>
                          <?php }} ?>                            
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Thread Mahasiswa -->
              <div class="tab-pane fade" id="mhs">
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
                            include '../database/connect.php';
                            $query1 = "CALL thread_loadp('Mahasiswa',50)";
                            $sql1 = mysqli_query($db, $query1) or die("Query fail : ".mysqli_error($db));
                            $ThreadArr1 = array();
                            while($row1 = mysqli_fetch_assoc($sql1)){
                              if($row1['thread_access']=='public'){
                          ?>
                          <tr>
                            <td class="text-left"><b>
                              <form method="post">
                                <button style="border:none; background:none; padding:0; color:#0073b7;" type="submit" name="thread" id="thread" value="<?php echo "$row1[thread_id]";?>"><?php echo"$row1[thread_judul]"; if($row1['thread_access']=='private'){echo" &nbsp;<i class='fa fa-lock'></i>";}?></button>
                              </form>
                            </b><small><?php echo"$row1[user_name]";?></small></td>
                            <td class="text-right"><small><?php echo"$row1[thread_time]";?></small></td>
                          </tr>
                          <?php }} ?>
                            
                        </tbody>
                      </table>
                    </div>
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
