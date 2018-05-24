<header class="main-header">
  <nav class="navbar navbar-static-top">
    <div class="container">
      <div class="navbar-header">
        <a href="../../index.html" class="navbar-brand">FORUM<b>ITS</b></a>
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
          <i class="fa fa-bars"></i>
        </button>
      </div>

      <!-- NAVBAR-LEFTSIDE -->
      <div class="collapse navbar-collapse pull-left" id="navbar-collapse">
        <!-- Links -->
        <ul class="nav navbar-nav">
          <?php 
            if($_SESSION['userid']=="admin"){
              echo"
                <li><a href='admin.php'>Home</a></li>
                <li><a href='reports.php'>Reports</a></li>
                <li><a href='threads.php'>Threads</a></li>
                <li><a href='users.php'>Users</a></li>
              ";
            }
            else{
              echo "
                <li><a href='index.php'>Home</a></li>
                <li><a href='threads.php'>Threads</a></li>                
              ";
            }
          ?>
        </ul>


        <?php
          if(isset($_POST['check'])){
            $_SESSION['keyword']=$_POST['navbar-search-input'];
            $_SESSION['keyword'] = str_replace("'", "’", $_SESSION['keyword']);
            header("Location:search.php");
          }
        ?>

        <!-- Searchbar -->
        <?php 
            if($_SESSION['userid']!="admin"){
              echo"
                <form role='form' class='navbar-form navbar-left' method='post'>
                  <div class='form-group'>
                    <div class='col-sm-7'>
                      <input class='form-control' id='navbar-search-input' type='text' name='navbar-search-input' placeholder='Enter keyword here' required=''/>
                    </div>
                    <div class='col-sm-2 text-center'>
                      <input class='btn btn-info btn-md btn-flat' style='color:#0288D1; background-color:#FAFAFA' type='submit' name='check' id='check' value='Search'/>
                    </div>
                  </div>
                </form>
              ";
            }
        ?>
      </div>
      <!-- /NAVBAR-LEFTSIDE -->

      <!-- NAVBAR-RIGHTSIDE -->
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">

          <!-- New Thread -->
          <?php 
            if($_SESSION['userid']!="admin"){
              echo"
                <li><a href='newthread.php'><i class='fa fa-pencil'></i></a></li>
              ";
            }
            else{
              echo"
                <li><a href='announce.php'><i class='fa fa-pencil'></i>&nbsp;&nbsp;Announcement</a></li>
              ";
            } 
          

            //<!-- User data call -->          
            if(isset($_SESSION['userid'])){
                include "../database/connect.php";
                $query = "CALL user_data_nav('$_SESSION[userid]')";
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
                $_SESSION['username']=$row['user_name'];
            }
          
            //<!-- Notifications -->          
            if($_SESSION['userid']!="admin"){
              include '../database/connect.php';
              $query1 = "CALL notif_list('$_SESSION[userid]',20)";
              $sql1 = mysqli_query($db, $query1) or die("Query fail : ".mysqli_error($db));
              $NotifArr = array();
              echo"
                <li class='dropdown notifications-menu'>
                  <a href='#' class='dropdown-toggle' data-toggle='dropdown'>
                    <i class='fa fa-bell-o'></i>
                  </a>
                  <ul class='dropdown-menu'>
                    <li class='header'><strong>Notifications</strong></li>
                    <li>
                      <ul class='menu'>
                        <li>
                          
              ";
              if($row['user_notifcount']>0){
                while($row1 = mysqli_fetch_assoc($sql1)){
                  if (strpos($row1['notif_isi'], 'edited') !== false){
                    echo "<a><i class='fa fa-pencil-square-o'></i> $row1[notif_isi]</a>";
                  }
                  else if (strpos($row1['notif_isi'], 'deleted') !== false){
                    echo "<a><i class='fa fa-trash-o'></i> $row1[notif_isi]</a>";
                  }
                  else if (strpos($row1['notif_isi'], 'commented') !== false){ 
                    echo "<a><i class='fa fa-comment-o'></i> $row1[notif_isi]</a>";
                  }
                  else if (strpos($row1['notif_isi'], 'created') !== false){ 
                    echo "<a><i class='fa fa-plus'></i> $row1[notif_isi]</a>";
                  }
                }
              }
              else{
                echo "<a class='text-center'>No notification</a>";
              }
              echo"
                      
                        </li>
                      </ul>
                    </li>
                  </ul>
                </li>
              ";
            }
          ?>
          <!-- USER ACCOUNT MENU -->
          <?php 
            if(isset($_SESSION['userid'])){
                include "../database/connect.php";
                $query = "CALL user_data_nav('$_SESSION[userid]')";
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
                $_SESSION['username']=$row['user_name'];
            }
          ?>
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <img src="<?php echo"$row[user_photo]";?>" class="user-image" alt="User Image">
              <span class="hidden-xs"><?php echo"$row[user_name]";?></span>
            </a>
            <ul class="dropdown-menu">
              <!-- The user image in the menu -->
              <li class="user-header">
                <img src="<?php echo"$row[user_photo]";?>" class="img-circle" alt="User Image">
                <p><?php echo"$row[user_name]";?><br><small><?php echo"$row[user_role]";?> - <?php echo"$row[user_id]";?></small></p>
              </li>
              <!-- Menu Footer-->
              <li class="user-footer">
                
                <?php 
                  if($_SESSION['userid']!="admin"){
                    echo"
                      <div class='pull-left'>
                        <a href='account.php' class='btn btn-default btn-flat'>Account</a>
                      </div>
                      <div class='pull-right'>
                        <a href='../database/logout.php' class='btn btn-default btn-flat'>Logout</a>
                      </div>
                    ";
                  }
                  else{
                    echo"
                      <div class='text-center'>
                        <a href='../database/logout.php' class='btn btn-default btn-flat'>Logout</a>
                      </div>
                    ";
                  }
                ?>
                

              </li>
            </ul>
          </li>
        </ul>
      </div>
      <!-- /NAVBAR-RIGHTSIDE -->
    </div>
  </nav>
</header>