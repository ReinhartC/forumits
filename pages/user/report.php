<?php include "../database/verify.php"; ?>

<!DOCTYPE html>
<html>
<head>
  <!-- Tabs Title -->
  <title>FITS | Report Thread</title>
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
          <h1>Report Thread</h1>
        </section>
        <!--====================================================/CONTENT=============================================================-->
        <!-- Main content -->
        <section class="content">

          <div class="box box-primary text-center">
            <div class="box-header with-border">
              <h3 class="box-title">Why do you report this thread?</h3>
            </div>
            <form role="form" method="post">
              <fieldset>
                  <div class="form-group col-sm-12">
                      <input class="form-control" autofocus id="title" type="text" name="title" placeholder="Explain why you want to report here" required=""/>
                  </div>
                  <div class="col-sm-12">
                    <input class="btn btn-md btn-primary btn-flat" type="submit" name="report" id="report" value="Report"/><br><br>
                  </div>
              </fieldset>
          </form>
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
