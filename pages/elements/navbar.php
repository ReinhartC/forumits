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
          <li><a href="index.php">Home</a></li>
          <li><a href="threads.php">Threads</a></li>
        </ul>


        <?php
          if(isset($_POST['check'])){
            $_SESSION['keyword']=$_POST['navbar-search-input'];
            $_SESSION['keyword'] = str_replace("'", "’", $_SESSION['keyword']);
            header("Location:search.php");
          }
        ?>

        <!-- Searchbar -->
        <form role="form" class="navbar-form navbar-left" method="post">
          <div class="form-group">
            <div class="col-sm-7">
              <input class="form-control" id="navbar-search-input" type="text" name="navbar-search-input" placeholder="Enter keyword here" required=""/>
            </div>
            <div class="col-sm-2 text-center">
              <input class="btn btn-info btn-md btn-flat" style="color:#0288D1; background-color:#FAFAFA" type="submit" name="check" id="check" value="Search"/>
            </div>
          </div>
        </form>
      </div>
      <!-- /NAVBAR-LEFTSIDE -->

      <!-- NAVBAR-RIGHTSIDE -->
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">

          <!-- New Thread -->
          <li><a href="newthread.php"><i class="fa fa-pencil"></i></a></li>

          <!-- User data call -->
          <?php
            if(isset($_SESSION['userid'])){
                include "../database/connect.php";
                $query = "CALL user_data_nav('$_SESSION[userid]')";
                $sql = mysqli_query($db, $query);
                $row = mysqli_fetch_array($sql);
            }
          ?>
          <!-- Notifications -->
          <li class="dropdown notifications-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-bell-o"></i>
              <span class="label label-warning"><?php echo"$row[user_notifcount]";?></span>
            </a>
            <ul class="dropdown-menu">
              <li class="header">You have <?php echo"$row[user_notifcount]";?> notifications</li>
              <li>
                <ul class="menu">
                  <li>
                    <a href="#">
                      <i class="fa fa-comment"></i>Notification feature will be coming soon...
                    </a>
                  </li>
                </ul>
              </li>
              <li class="footer"><a href="#">Viewed</a></li>
            </ul>
          </li>

          <!-- USER ACCOUNT MENU -->
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
                <div class="pull-left">
                  <a href="account.php" class="btn btn-default btn-flat">Account</a>
                </div>
                <div class="pull-right">
                  <a href="../database/logout.php" class="btn btn-default btn-flat">Logout</a>
                </div>
              </li>
            </ul>
          </li>
        </ul>
      </div>
      <!-- /NAVBAR-RIGHTSIDE -->
    </div>
  </nav>
</header>