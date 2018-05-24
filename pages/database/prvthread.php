<?php
	if(isset($_SESSION['thread'])){
		include "../database/connect.php";
		$query = "CALL thread_status($_SESSION[thread])";
		$sql = mysqli_query($db, $query);
		$row = mysqli_fetch_array($sql);  
		if($row['thread_access']=='private'){
			include "../database/connect.php";
			$query1 = "CALL prvt_perm($_SESSION[thread])";
            $sql1 = mysqli_query($db, $query1) or die("Query fail : ".mysqli_error($db));
            $usrArr = array();
            $flag=0;
            while($row1 = mysqli_fetch_assoc($sql1)){
            	if($_SESSION['userid']==$row1['user_id']){
            		$flag=1;
            	}
			}
			if($flag!=1){
        		echo '<script language="javascript">';
	            echo 'alert("You have no access to this thread!")';  
	            echo '</script>';
        		echo '<meta http-equiv="refresh" content="0; URL=index.php">';
        	}
		}    
	}
?>