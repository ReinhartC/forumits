<?php 
  include "../database/verify.php"; 
  if(!isset($_SESSION['priv'])){
    echo '<meta http-equiv="refresh" content="0; URL=newthread.php">';
  }
?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Manage Access</title>
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
          <h1>Add Access to your thread</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          <?php
          include "../database/connect.php";
          $query1 = "CALL check_latest_thread($_SESSION[userid])";
          $sql1 = mysqli_query($db, $query1);
          $row1 = mysqli_fetch_array($sql1);

          if(isset($_POST['add'])){
            if(!empty($_POST['mahasiswa'])){
              foreach($_POST['mahasiswa'] as $mhs){
                include "../database/connect.php";
                $query = "CALL new_private('$row1[tid]',$mhs)";
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
              }   
            }
            if(!empty($_POST['dosen'])){
              foreach($_POST['dosen'] as $dsn){
                include "../database/connect.php";
                $query = "CALL new_private('$row1[tid]',$dsn)";
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
              }
            }
            include "../database/connect.php";
            $query = "CALL new_private('$row1[tid]','$_SESSION[userid]')";
            $sql = mysqli_query($db, $query);
            $row = mysqli_fetch_array($sql);
            unset($_SESSION['priv']);
            $_SESSION['thread']=$row1['tid'];
            echo '<meta http-equiv="refresh" content="0; URL=thread.php">';   
          }
          ?> 
          <!-- Tabs -->
          <div class="nav-tabs-custom">
            <ul class="nav nav-tabs nav-justified">
              <li class="active"><a href="#dsn" data-toggle="tab">Dosen</a></li>
              <li><a href="#mhs" data-toggle="tab">Mahasiswa</a></li>
            </ul>

            <!-- user Dosen  -->
            <form role="form" method="post" enctype="multipart/form-data">
            <div class="tab-content">
              <div class="tab-pane fade in active" id="dsn">
                <div class="box box-primary">
                  <div class="box-header with-border">
                    <h3 class="box-title">Member</h3>
                  </div>
                  <fieldset>
                  <div class="box-body no-padding">
                    <div class="table-responsive mailbox-messages">
                        <div class="form-group"><br>
                          <!-- user load loop -->
                          <?php
                          include '../database/connect.php';
                          $query = "CALL user_load('Dosen',50)";
                          $sql = mysqli_query($db, $query) or die("Query fail : ".mysqli_error($db));
                          $ThreadArr = array();
                          while($row = mysqli_fetch_assoc($sql)){
                            if($row["user_id"] != $_SESSION["userid"]){
                              echo "
                                <div class='col-md-4'>
                                  <label>
                                    <input type='checkbox' name='dosen[]' value='$row[user_id]'>
                                    $row[user_name]
                                  </label>
                                </div>
                              "; 
                            }
                          }?>
                        </div>
                      </div>
                    </div>
                    </fieldset>
                </div>
              </div>

                <!-- user Mahasiswa -->
              <div class="tab-pane fade" id="mhs">
                <div class="box box-primary">
                  <div class="box-header">
                    <h3 class="box-title">Member</h3>
                  </div>
                  <fieldset>
                  <div class="box-body no-padding">
                    <div class="table-responsive mailbox-messages">
                        <div class="form-group"><br>
                          <!-- user load loop -->
                          <?php
                          include '../database/connect.php';
                          $query_2 = "CALL user_load('Mahasiswa',50)";
                          $sql = mysqli_query($db, $query_2) or die("Query fail : ".mysqli_error($db));
                          $ThreadArr = array();
                          while($row = mysqli_fetch_assoc($sql)){
                            if($row["user_id"] != $_SESSION["userid"]){
                              echo "
                                <div class='col-md-4'>
                                  <label>
                                    <input type='checkbox' name='mahasiswa[]' value='$row[user_id]'>
                                    $row[user_name]
                                  </label>
                                </div>
                              "; 
                            }
                          } 

                          ?>
                        </div>
                      </div>
                    </div>
                    </fieldset>
                    </form>
                </div>
                <?php
                  
                ?>
              </div>
                  
                <div class="col-sm-12">
                  <br><input class="btn btn-md btn-primary btn-flat" type="submit" name="add" id="add" value="Add"/><br><br>
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