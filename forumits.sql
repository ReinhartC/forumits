-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 24, 2018 at 01:24 PM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `forumits`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `account_edit` (`p_id` VARCHAR(16), `p_email` VARCHAR(64), `p_phone` VARCHAR(16), `p_photo` VARCHAR(255), `p_note` TEXT)  BEGIN
	IF EXISTS(SELECT 1 FROM fits_user WHERE user_id = p_id) THEN
		UPDATE fits_user SET user_email=p_email WHERE user_id=p_id;
		UPDATE fits_user SET user_phone=p_phone WHERE user_id=p_id;
		UPDATE fits_user SET user_photo=p_photo WHERE user_id=p_id;
		UPDATE fits_user SET user_note=p_note WHERE user_id=p_id;
		SELECT 0, 'User Account Updated';
		
	ELSE
		SELECT -1, 'User Account Update Error';
	END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `account_threadlist` (`p_id` VARCHAR(16), `lmt` INT)  BEGIN
	SELECT fits_thread.*, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_user.`user_id` = p_id
	ORDER BY thread_time DESC 
	LIMIT lmt;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `announcement` ()  BEGIN
	SELECT *
	FROM fits_thread
	WHERE fits_thread.`thread_id`=0;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_latest_thread` (`p_id` VARCHAR(32))  BEGIN
	SELECT MAX(`thread_id`) as tid
	FROM fits_thread
	WHERE fits_thread.`user_id`=p_id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_thread` (`p_id` BIGINT)  BEGIN
	IF EXISTS(SELECT 1 FROM fits_thread WHERE thread_id = p_id) THEN
		UPDATE fits_user SET user_threadcount=user_threadcount-1
			where fits_user.`user_id` = (select fits_thread.`user_id` from fits_thread where fits_thread.`thread_id`=p_id);
		DELETE FROM fits_thread WHERE thread_id = p_id;
		SELECT 0, 'Thread Deleted';
	ELSE
		SELECT -1, 'Thread Delete Failed';
	END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_thread` (`tid` INT, `isi` TEXT, `attachments` VARCHAR(128))  BEGIN
	UPDATE fits_thread 
	SET  thread_isi=isi, thread_attachment=attachments, thread_time=NOW(), thread_edit=thread_edit+1
	WHERE thread_id=tid;
	SELECT 1, 'Thread Edited';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (`p_id` VARCHAR(16), `p_pass` VARCHAR(64))  BEGIN
	IF EXISTS(SELECT 1 FROM fits_user WHERE user_id = p_id) THEN
		IF EXISTS(SELECT 2 FROM fits_user WHERE MD5(p_pass) = user_pass AND user_id = p_id) THEN			
			SELECT 0,'Login Successfull';
			UPDATE fits_user SET last_login = CURRENT_TIMESTAMP WHERE user_id = p_id;
		ELSE
			SELECT -2,'Wrong Password';
		END IF;
	ELSE
		SELECT -1,'User ID is not registered';
	END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `make_announce` (`judul` VARCHAR(32), `isi` TEXT, `active` INT)  BEGIN
	UPDATE fits_thread 
	SET  thread_judul=judul, thread_isi=isi, thread_time=NOW(), thread_edit=active
	WHERE thread_id=0;
	SELECT 1, 'Announcement Changed';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_private` (`thread_ids` INT, `user_ids` VARCHAR(32))  BEGIN
	
	INSERT INTO fits_private SET
	user_id = user_ids,
	thread_id = thread_ids;
	SELECT 1, 'Private Added';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_thread` (`judul` VARCHAR(32), `isi` TEXT, `attachments` VARCHAR(128), `access` VARCHAR(16), `input_user_id` VARCHAR(16))  BEGIN
	INSERT INTO fits_thread (thread_judul, thread_isi, thread_attachment, thread_access, user_id, thread_time) VALUES(judul, isi, attachments, access, input_user_id,NOW());
	UPDATE fits_user SET user_threadcount=user_threadcount+1 WHERE user_id=input_user_id;
	SELECT 1, 'Thread Added';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `notif_add` (`u_id` VARCHAR(16), `isi` TEXT)  BEGIN
	INSERT INTO fits_notification (user_id, notif_isi, notif_time) VALUES(u_id, isi,NOW());
	UPDATE fits_user SET user_notifcount=user_notifcount+1 WHERE user_id=u_id;
	SELECT 1, 'Notification Added';
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `notif_list` (`p_id` VARCHAR(16), `lim` INT)  BEGIN
	SELECT *
	FROM fits_notification
	where fits_notification.`user_id` = p_id
	ORDER BY notif_time DESC 
	LIMIT lim;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prvt_count` (`p_id` VARCHAR(32))  BEGIN
	SELECT count(`thread_id`) AS pc
	FROM fits_private
	WHERE fits_private.`user_id`=p_id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prvt_list` (`uid` VARCHAR(32), `lmt` INT)  BEGIN
	SELECT fits_thread.*, fits_user.`user_name` as creator, fits_user.`user_role` as crole, fits_private.*
	FROM fits_thread, fits_private, fits_user
	where fits_private.`thread_id`=fits_thread.`thread_id`
	and fits_thread.`user_id`=fits_user.`user_id`
	and fits_private.`user_id`=uid
	ORDER BY thread_time DESC 
	LIMIT lmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prvt_perm` (`tid` INT)  BEGIN
	SELECT fits_private.*, fits_user.`user_name`
	FROM fits_private, fits_user
	where fits_user.`user_id`=fits_private.`user_id`
	and fits_private.`thread_id`=tid;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reply_load` (`p_id` VARCHAR(16))  BEGIN
	SELECT distinct fits_reply.*, fits_user.`user_name`, fits_user.`user_photo`
	FROM fits_reply, fits_user
	where fits_reply.`user_id` = fits_user.`user_id`
	and fits_reply.`thread_id` = p_id
	ORDER BY reply_time asc;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reply_thread` (`isi` TEXT, `reply_thread_id` VARCHAR(16), `reply_user_id` VARCHAR(16))  BEGIN
	INSERT INTO fits_reply (reply_isi, thread_id, user_id, reply_time) VALUES(isi, reply_thread_id, reply_user_id,NOW());
	SELECT 1, 'Reply Added';
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `report_ignore` (`p_id` BIGINT)  BEGIN
	IF EXISTS(SELECT 1 FROM fits_report WHERE report_id = p_id) THEN
		DELETE FROM fits_report WHERE report_id = p_id;
		SELECT 0, 'Report Deleted';
	ELSE
		SELECT -1, 'Report Delete Failed';
	END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `report_list` (`lmt` INT)  BEGIN
	SELECT fits_report.*, fits_user.`user_name` as reporter, fits_thread.`thread_judul`
	FROM fits_report, fits_user, fits_thread
	WHERE fits_report.`reporter`=fits_user.`user_id`
	and fits_report.`thread_id`=fits_thread.`thread_id`
	ORDER BY report_time DESC 
	LIMIT lmt;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `report_thread` (`isi` TEXT, `report_thread_id` VARCHAR(16), `report_user_id` VARCHAR(16))  BEGIN
	INSERT INTO fits_report (report_isi, thread_id, reporter, report_time) VALUES(isi, report_thread_id, report_user_id,NOW());
	SELECT 1, 'Report Added';
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `report_view` (`p_id` INT)  BEGIN
	SELECT fits_report.*, fits_user.`user_name`, fits_thread.*
	FROM fits_report, fits_user, fits_thread
	WHERE fits_report.`reporter`=fits_user.`user_id`
	and fits_report.`thread_id`=fits_thread.`thread_id`
	AND fits_report.`report_id`=p_id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_thread` (`keyword` VARCHAR(64))  BEGIN
	SELECT fits_thread.*, fits_user.`user_id`, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND (fits_thread.`thread_judul` LIKE CONCAT('%',keyword,'%')
	or fits_user.`user_name` LIKE CONCAT('%',keyword,'%')
	or fits_thread.`thread_isi` LIKE CONCAT('%',keyword,'%'));
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `thread_list` (`lmt` INT)  BEGIN
	SELECT fits_thread.*, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	ORDER BY thread_time DESC 
	LIMIT lmt;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `thread_load` (`const` VARCHAR(64), `lmt` INT)  BEGIN
	SELECT fits_thread.*, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_user.`user_role` = const
	ORDER BY thread_time DESC 
	LIMIT lmt;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `thread_loadp` (`const` VARCHAR(64), `lmt` INT)  BEGIN
	SELECT fits_thread.*, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_user.`user_role` = const
	and fits_thread.`thread_access`='public'
	ORDER BY thread_time DESC 
	LIMIT lmt;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `thread_status` (`tid` INT)  BEGIN
	SELECT fits_thread.`thread_access`
	FROM fits_thread
	Where fits_thread.`thread_id`=tid;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `thread_view` (`p_id` INT)  BEGIN
	SELECT fits_thread.*, fits_user.*
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_thread.`thread_id`=p_id;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `users_list` (`lmt` INT)  BEGIN
	SELECT * FROM fits_user
	where user_id != "admin"
	ORDER BY last_login DESC 
	LIMIT lmt;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_data_acc` (`p_id` VARCHAR(16))  BEGIN
	IF EXISTS (SELECT 1 FROM fits_user WHERE `user_id`=p_id) THEN 
		SELECT
		    `user_id`
		    ,`user_name`
		    ,`user_role`
		    ,`user_photo`
		    ,`user_email`
		    ,`user_phone`
		    ,`user_notifcount`
		    ,`user_threadcount`
		    ,`user_note`
		FROM
		    `forumits`.`fits_user`
		WHERE `user_id`=p_id;
	ELSE
		SELECT "User ID Tidak ada" AS Hasil;
	END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_data_nav` (`p_id` VARCHAR(16))  BEGIN
	IF EXISTS (SELECT 1 FROM fits_user WHERE `user_id`=p_id) THEN 
		SELECT
		    `user_id`
		    ,`user_name`
		    ,`user_role`
		    ,`user_photo`
		    ,`user_notifcount`
		FROM
		    `forumits`.`fits_user`
		WHERE `user_id`=p_id;
	ELSE
		SELECT "User ID Tidak ada" AS Hasil;
	END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_load` (`const` VARCHAR(64), `lmt` INT)  BEGIN
	SELECT user_name, user_id, user_role
	FROM fits_user
	WHERE user_role = const
	ORDER BY user_name ASC
	LIMIT lmt;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `fits_announcenment`
--

CREATE TABLE `fits_announcenment` (
  `announcement_id` int(11) NOT NULL,
  `announcement_judul` varchar(32) NOT NULL,
  `announcement_isi` text NOT NULL,
  `announcement_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `announcement_status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `fits_notification`
--

CREATE TABLE `fits_notification` (
  `notif_id` int(11) NOT NULL,
  `user_id` varchar(16) NOT NULL,
  `notif_isi` text NOT NULL,
  `notif_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fits_notification`
--

INSERT INTO `fits_notification` (`notif_id`, `user_id`, `notif_isi`, `notif_time`) VALUES
(39, '5115100132', 'You have successfully created the â€™Ansonoiwenâ€™ thread', '2018-05-24 04:27:26'),
(40, '5115100132', 'You have successfully created the â€™fjfnonwfenâ€™ thread', '2018-05-24 04:27:37'),
(41, '5115100132', 'You have successfully created the â€™nionwoâ€™ thread', '2018-05-24 04:27:43'),
(42, '5115100132', 'You have successfully deleted your â€™nionwoâ€™ thread', '2018-05-24 04:28:10'),
(43, '5115100132', 'You have successfully edited your â€™Ansonoiwenâ€™ thread', '2018-05-24 04:28:51'),
(44, '5115100132', 'You have successfully created the â€™reportâ€™ thread', '2018-05-24 04:29:08'),
(45, '5115100132', 'MarkZ have commented on your â€™Ansonoiwenâ€™ thread', '2018-05-24 04:29:49'),
(46, '5115100132', 'IvanA have commented on your â€™Ansonoiwenâ€™ thread', '2018-05-24 04:30:15'),
(47, '5115100132', 'You have successfully edited your â€™reportâ€™ thread', '2018-05-24 07:31:42'),
(48, '5115100132', 'You have successfully deleted your â€™reportâ€™ thread', '2018-05-24 07:31:50'),
(49, '1002420091', 'ReinhartC have commented on your â€™vdsvsvdsâ€™ thread', '2018-05-24 07:32:30'),
(50, '1002420091', 'Admin have deleted your â€™vdsvsvdsâ€™ thread', '2018-05-24 07:34:52'),
(51, '1002420091', 'You have successfully created the â€™aâ€™ thread', '2018-05-24 07:37:17'),
(52, '1002420091', 'You have successfully created the â€™sâ€™ thread', '2018-05-24 07:37:25'),
(53, '1002420091', 'You have successfully created the â€™sâ€™ thread', '2018-05-24 07:37:30'),
(54, '1002420091', 'You have successfully created the â€™dâ€™ thread', '2018-05-24 07:37:36'),
(55, '1002420091', 'You have successfully created the â€™gqdâ€™ thread', '2018-05-24 07:37:42'),
(56, '1002420091', 'You have successfully created the â€™csâ€™ thread', '2018-05-24 07:37:48'),
(57, '1002420091', 'You have successfully deleted your â€™gqdâ€™ thread', '2018-05-24 08:28:28'),
(58, '1002420091', 'You have successfully deleted your â€™sâ€™ thread', '2018-05-24 08:28:34'),
(59, '1002420091', 'You have successfully deleted your â€™csâ€™ thread', '2018-05-24 08:28:38'),
(60, '1002420091', 'You have successfully deleted your â€™sâ€™ thread', '2018-05-24 08:28:44'),
(61, '1002420091', 'You have successfully created the â€™csâ€™ thread', '2018-05-24 08:29:25'),
(62, '1002420091', 'You have successfully created the â€™dsfâ€™ thread', '2018-05-24 08:30:42'),
(63, '1002420091', 'You have successfully created the â€™scsâ€™ thread', '2018-05-24 08:34:48'),
(64, '1002420091', 'You have successfully created the â€™casacâ€™ thread', '2018-05-24 08:34:59'),
(65, '1002420091', 'You have successfully created the â€™dsaâ€™ thread', '2018-05-24 08:39:17'),
(66, '1002420091', 'You have successfully created the â€™asfaâ€™ thread', '2018-05-24 09:15:01'),
(67, '1002420091', 'You have successfully created the â€™fewkpâ€™ thread', '2018-05-24 09:23:24'),
(68, '5115100166', 'You have successfully created the â€™canioâ€™ thread', '2018-05-24 09:32:52'),
(69, '5115100166', 'You have successfully created the â€™fenioâ€™ thread', '2018-05-24 09:33:00'),
(70, '5115100166', 'You have successfully created the â€™aionâ€™ thread', '2018-05-24 10:11:03'),
(71, '5115100132', 'You have successfully created the â€™scecâ€™ thread', '2018-05-24 10:13:00'),
(72, '5115100132', 'You have successfully created the â€™nwvkâ€™ thread', '2018-05-24 10:14:07'),
(73, '5115100132', 'You have successfully created the â€™csasackpâ€™ thread', '2018-05-24 10:15:55'),
(74, '5115100132', 'You have successfully created the â€™1â€™ thread', '2018-05-24 10:16:22'),
(75, '5115100132', 'You have successfully created the â€™2â€™ thread', '2018-05-24 10:16:38'),
(76, '5115100132', 'You have successfully created the â€™wenfioâ€™ thread', '2018-05-24 10:16:52'),
(77, '5115100132', 'You have successfully created the â€™cwhioâ€™ thread', '2018-05-24 10:19:29'),
(78, '5115100132', 'You have successfully created the â€™wnefioâ€™ thread', '2018-05-24 10:19:37'),
(79, '5115100132', 'You have successfully created the â€™wemopâ€™ thread', '2018-05-24 10:19:48'),
(80, '5115100132', 'You have successfully created the â€™ewnioeâ€™ thread', '2018-05-24 10:20:00'),
(81, '5115100132', 'You have successfully created the â€™ewniâ€™ thread', '2018-05-24 10:20:13'),
(82, '5115100166', 'Admin have deleted your â€™fsdsdfâ€™ thread', '2018-05-24 10:31:08');

-- --------------------------------------------------------

--
-- Table structure for table `fits_private`
--

CREATE TABLE `fits_private` (
  `private_id` int(11) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `user_id` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fits_private`
--

INSERT INTO `fits_private` (`private_id`, `thread_id`, `user_id`) VALUES
(1, 107, '5115100132'),
(2, 107, '1002420013'),
(3, 107, '1002420091'),
(4, 110, '5115100132'),
(5, 110, '5115100166'),
(6, 111, '1002420013'),
(7, 111, '5115100132'),
(8, 112, '5115100172'),
(9, 112, '5115100132'),
(10, 113, '5115100166'),
(11, 113, '1002420013'),
(12, 113, '5115100132'),
(13, 114, '1002420013'),
(14, 114, '5115100132'),
(15, 115, '5115100172'),
(16, 115, '5115100132'),
(17, 116, '5115100172'),
(18, 116, '1002420013'),
(19, 116, '5115100132'),
(20, 117, '1002420013'),
(21, 117, '5115100132'),
(22, 118, '5115100172'),
(23, 118, '5115100132'),
(24, 120, '1002420091'),
(25, 120, '5115100132'),
(26, 121, '5115100172'),
(27, 121, '1002420013'),
(28, 121, '5115100132');

-- --------------------------------------------------------

--
-- Table structure for table `fits_reply`
--

CREATE TABLE `fits_reply` (
  `reply_id` int(11) NOT NULL,
  `reply_isi` text NOT NULL,
  `thread_id` int(11) NOT NULL,
  `user_id` varchar(16) NOT NULL,
  `reply_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fits_reply`
--

INSERT INTO `fits_reply` (`reply_id`, `reply_isi`, `thread_id`, `user_id`, `reply_time`) VALUES
(19, 'dsvsdv', 31, '1002420091', '2018-05-23 17:17:03'),
(50, 'fenwowfnew\r\n', 90, '1002420013', '2018-05-24 04:29:49'),
(51, 'fewiewnfownf\r\n', 90, '5115100166', '2018-05-24 04:30:15');

-- --------------------------------------------------------

--
-- Table structure for table `fits_report`
--

CREATE TABLE `fits_report` (
  `report_id` int(11) NOT NULL,
  `report_isi` text NOT NULL,
  `reporter` varchar(16) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `report_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fits_report`
--

INSERT INTO `fits_report` (`report_id`, `report_isi`, `reporter`, `thread_id`, `report_time`) VALUES
(6, 'dsvsvsdv', '1002420091', 73, '2018-05-23 17:16:49'),
(7, 'vsmdl;vs', '1002420091', 31, '2018-05-23 17:17:06'),
(9, 'mdvaa', '1002420013', 77, '2018-05-23 17:17:50'),
(10, 'sacascas', '5115100132', 76, '2018-05-23 17:18:17');

-- --------------------------------------------------------

--
-- Table structure for table `fits_thread`
--

CREATE TABLE `fits_thread` (
  `thread_id` int(11) NOT NULL,
  `thread_judul` varchar(32) NOT NULL,
  `thread_isi` text NOT NULL,
  `thread_attachment` varchar(128) DEFAULT NULL,
  `thread_access` varchar(16) NOT NULL DEFAULT 'public',
  `user_id` varchar(16) NOT NULL,
  `thread_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `thread_edit` smallint(6) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fits_thread`
--

INSERT INTO `fits_thread` (`thread_id`, `thread_judul`, `thread_isi`, `thread_attachment`, `thread_access`, `user_id`, `thread_time`, `thread_edit`) VALUES
(0, 'Maintenance', 'Akan diadakan maintenance hari ini selama 1 jam dimulai dari jam 16:30 WIB', NULL, 'public', 'admin', '2018-05-24 08:34:01', 0),
(14, '1914 translation by H. Rackham', '\"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?\"', '', 'public', '5115100172', '2018-05-24 08:34:01', 0),
(31, 'What is Lorem ipsum?', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industryâ€™s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '', 'public', '1002420013', '2018-05-24 08:34:01', 0),
(70, 'fafs', 'dsgsdgsdg', '', 'public', '5115100166', '2018-05-24 08:34:01', 0),
(71, 'dgssdg', 'sdgdsgd', '', 'public', '5115100166', '2018-05-24 08:34:01', 0),
(72, 'dvsdvsd', 'dvsdv', '../../uploads/attachment/surf - Copy.jpg', 'public', '5115100172', '2018-05-24 08:34:01', 0),
(73, 'fsfsfs`wkwen`', 'â€™ewâ€™wefâ€™wâ€™fwâ€™e', '', 'public', '5115100172', '2018-05-24 08:34:01', 0),
(74, 'svsdv', 'vdvsdsdv', '', 'public', '5115100172', '2018-05-24 08:34:01', 0),
(75, 'vdsvsdvdsn', 'nsdvnsdvns', '../../uploads/attachment/surf - Copy.jpg', 'public', '1002420013', '2018-05-24 08:34:01', 0),
(76, 'vsvsd', 'dsfes', '', 'public', '1002420013', '2018-05-24 08:34:01', 0),
(77, 'sdvewv', 'vsdvsdvds', '../../uploads/attachment/surf - Copy.jpg', 'public', '1002420091', '2018-05-24 08:34:01', 0),
(90, 'Ansonoiwen', 'nwionwe', '../../uploads/attachment/surf - Copy.jpg', 'public', '5115100132', '2018-05-24 08:34:01', 1),
(91, 'fjfnonwfen', 'nweofnownfe', '', 'public', '5115100132', '2018-05-24 08:34:01', 0),
(97, 'a', 'a', '', 'public', '1002420091', '2018-05-24 08:34:01', 0),
(100, 'd', 'd', '', 'public', '1002420091', '2018-05-24 08:34:01', 0),
(103, 'scs', 'csacsa', '', 'public', '1002420091', '2018-05-24 08:34:48', 0),
(104, 'casac', 'csaca', '', 'public', '1002420091', '2018-05-24 08:34:59', 0),
(107, 'fewkp', 'dsp', '', 'private', '1002420091', '2018-05-24 09:23:24', 0),
(108, 'canio', 'naio', '', 'public', '5115100166', '2018-05-24 09:32:52', 0),
(109, 'fenio', 'nfweio', '', 'public', '5115100166', '2018-05-24 09:32:59', 0),
(110, 'aion', 'nion', '', 'private', '5115100166', '2018-05-24 10:11:03', 0),
(111, 'scec', 'cdsks', '', 'private', '5115100132', '2018-05-24 10:13:00', 0),
(112, 'nwvk', 'mope', '', 'private', '5115100132', '2018-05-24 10:14:07', 0),
(113, 'csasackp', 'cnapacm', '', 'private', '5115100132', '2018-05-24 10:15:55', 0),
(114, '1', 'w', '', 'private', '5115100132', '2018-05-24 10:16:22', 0),
(115, '2', 'mp', '', 'private', '5115100132', '2018-05-24 10:16:38', 0),
(116, 'wenfio', 'nfopew', '', 'private', '5115100132', '2018-05-24 10:16:52', 0),
(117, 'cwhio', 'nico', '', 'private', '5115100132', '2018-05-24 10:19:29', 0),
(118, 'wnefio', 'noiw', '', 'private', '5115100132', '2018-05-24 10:19:37', 0),
(119, 'wemop', 'e', '', 'public', '5115100132', '2018-05-24 10:19:48', 0),
(120, 'ewnioe', 'nwio', '', 'private', '5115100132', '2018-05-24 10:20:00', 0),
(121, 'ewni', 'fejw', '', 'private', '5115100132', '2018-05-24 10:20:13', 0);

-- --------------------------------------------------------

--
-- Table structure for table `fits_user`
--

CREATE TABLE `fits_user` (
  `user_id` varchar(16) NOT NULL,
  `user_pass` varchar(64) NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `user_role` varchar(32) NOT NULL,
  `user_photo` varchar(255) NOT NULL DEFAULT '../../dist/img/avatar.png',
  `user_email` varchar(64) DEFAULT '-',
  `user_phone` varchar(16) DEFAULT '-',
  `user_notifcount` int(11) DEFAULT '0',
  `user_threadcount` int(11) DEFAULT '0',
  `last_login` timestamp NULL DEFAULT NULL,
  `user_note` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fits_user`
--

INSERT INTO `fits_user` (`user_id`, `user_pass`, `user_name`, `user_role`, `user_photo`, `user_email`, `user_phone`, `user_notifcount`, `user_threadcount`, `last_login`, `user_note`) VALUES
('1002420013', '827ccb0eea8a706c4c34a16891f84e7b', 'MarkZ', 'Dosen', '../../uploads/profpic/user8-128x128.jpg', 'markzuqerberk@gmail.com', '08192837465', 0, 3, '2018-05-24 04:29:22', 'Hi. Iâ€™m Mark :)'),
('1002420091', '1e01ba3e07ac48cbdab2d3284d1dd0fa', 'ElizabethH', 'Dosen', '../../uploads/profpic/user3-128x128.jpg', 'elizabethhiggins@gmail.com', '08273746519', 19, 6, '2018-05-24 10:11:26', 'Yiellowncac\r\nnascna\r\nscnajcn\r\nanc\r\n'),
('5115100132', 'ab56b4d92b40713acc5af89985d4b786', 'ReinhartC', 'Mahasiswa', '../../uploads/profpic/user1-128x128.jpg', 'sgs3.rc@hotmail.com', '08111287200', 21, 13, '2018-05-24 11:23:02', 'Hi.\r\nHello.'),
('5115100166', '57c48dcd266eadf089325affe125151f', 'IvanA', 'Mahasiswa', '../../uploads/profpic/user2-160x160.jpg', 'ivanagung@gmail.com', '081112345678', 4, 5, '2018-05-24 10:09:49', 'Halo semuanya'),
('5115100172', 'ac9ec49afb308497ff99a4e9ab88bd3f', 'JoshuaP', 'Mahasiswa', '../../uploads/profpic/user6-128x128.jpg', 'joshuapardosi@gmail.com', '081187654321', 0, 4, '2018-05-23 17:20:22', 'Namaku ojosh hehehe'),
('admin', '21232f297a57a5a743894a0e4a801fc3', 'Admin', 'Administrator', '../../dist/img/admin.png', 'adminfits@gmail.com', '-', 0, 0, '2018-05-24 11:23:15', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fits_announcenment`
--
ALTER TABLE `fits_announcenment`
  ADD PRIMARY KEY (`announcement_id`);

--
-- Indexes for table `fits_notification`
--
ALTER TABLE `fits_notification`
  ADD PRIMARY KEY (`notif_id`),
  ADD KEY `notif_user_id` (`user_id`);

--
-- Indexes for table `fits_private`
--
ALTER TABLE `fits_private`
  ADD PRIMARY KEY (`private_id`),
  ADD KEY `fk_tid` (`thread_id`),
  ADD KEY `fk_uid` (`user_id`);

--
-- Indexes for table `fits_reply`
--
ALTER TABLE `fits_reply`
  ADD PRIMARY KEY (`reply_id`),
  ADD KEY `reply_user_id` (`user_id`),
  ADD KEY `reply_thread_id` (`thread_id`);

--
-- Indexes for table `fits_report`
--
ALTER TABLE `fits_report`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `fk_user_reporter` (`reporter`),
  ADD KEY `fk_thread_id` (`thread_id`);

--
-- Indexes for table `fits_thread`
--
ALTER TABLE `fits_thread`
  ADD PRIMARY KEY (`thread_id`),
  ADD KEY `thread_user_id` (`user_id`);

--
-- Indexes for table `fits_user`
--
ALTER TABLE `fits_user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `fits_notification`
--
ALTER TABLE `fits_notification`
  MODIFY `notif_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `fits_private`
--
ALTER TABLE `fits_private`
  MODIFY `private_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `fits_reply`
--
ALTER TABLE `fits_reply`
  MODIFY `reply_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `fits_report`
--
ALTER TABLE `fits_report`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `fits_thread`
--
ALTER TABLE `fits_thread`
  MODIFY `thread_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fits_notification`
--
ALTER TABLE `fits_notification`
  ADD CONSTRAINT `notif_user_id` FOREIGN KEY (`user_id`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fits_private`
--
ALTER TABLE `fits_private`
  ADD CONSTRAINT `fk_tid` FOREIGN KEY (`thread_id`) REFERENCES `fits_thread` (`thread_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_uid` FOREIGN KEY (`user_id`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fits_reply`
--
ALTER TABLE `fits_reply`
  ADD CONSTRAINT `reply_thread_id` FOREIGN KEY (`thread_id`) REFERENCES `fits_thread` (`thread_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reply_user_id` FOREIGN KEY (`user_id`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fits_report`
--
ALTER TABLE `fits_report`
  ADD CONSTRAINT `fk_thread_id` FOREIGN KEY (`thread_id`) REFERENCES `fits_thread` (`thread_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_reporter` FOREIGN KEY (`reporter`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fits_thread`
--
ALTER TABLE `fits_thread`
  ADD CONSTRAINT `thread_user_id` FOREIGN KEY (`user_id`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
