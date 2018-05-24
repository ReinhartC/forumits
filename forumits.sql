-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 24, 2018 at 02:45 PM
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
(114, '5115100132', 'You have successfully created the â€™What is Lorem Ipsum?â€™ thread', '2018-05-24 12:07:27'),
(115, '5115100132', 'You have successfully created the â€™Where does it come from?â€™ thread', '2018-05-24 12:08:24'),
(116, '5115100132', 'You have successfully created the â€™Surat Kerja Praktekâ€™ thread', '2018-05-24 12:09:29'),
(117, '5115100166', 'You have successfully created the â€™Why do we use it?â€™ thread', '2018-05-24 12:11:23'),
(118, '5115100166', 'You have successfully created the â€™EasyWorship 6 Licenseâ€™ thread', '2018-05-24 12:13:11'),
(119, '5115100166', 'You have successfully created the â€™Secret Messageâ€™ thread', '2018-05-24 12:13:33'),
(120, '5115100172', 'You have successfully created the â€™The standard Lorem Ipsum passage, used since the 1500sâ€™ thread', '2018-05-24 12:14:11'),
(121, '5115100172', 'You have successfully created the â€™Section 1.10.32 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BCâ€™ thread', '2018-05-24 12:14:38'),
(122, '5115100172', 'You have successfully created the â€™1914 translation by H. Rackhamâ€™ thread', '2018-05-24 12:15:38'),
(123, '1002420013', 'You have successfully created the â€™Section 1.10.33 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BCâ€™ thread', '2018-05-24 12:16:55'),
(124, '1002420013', 'You have successfully created the â€™1914 translation by H. Rackham of 1.10.33â€™ thread', '2018-05-24 12:17:52'),
(125, '1002420013', 'You have successfully created the â€™Tugas Kelas RKâ€™ thread', '2018-05-24 12:18:43'),
(126, '1002420091', 'You have successfully created the â€™Some Lorem Ipsumâ€™ thread', '2018-05-24 12:19:40'),
(127, '1002420091', 'You have successfully created the â€™Quisque et quam blanditâ€™ thread', '2018-05-24 12:20:37'),
(128, '1002420091', 'You have successfully created the â€™A Secret Placeâ€™ thread', '2018-05-24 12:21:03'),
(129, '1002420013', 'JoshuaP have commented on your â€™1914 translation by H. Rackham oâ€™ thread', '2018-05-24 12:22:10'),
(130, '5115100166', 'JoshuaP have commented on your â€™EasyWorship 6 Licenseâ€™ thread', '2018-05-24 12:22:27'),
(131, '1002420091', 'JoshuaP have commented on your â€™Some Lorem Ipsumâ€™ thread', '2018-05-24 12:22:53'),
(132, '5115100132', 'JoshuaP have commented on your â€™What is Lorem Ipsum?â€™ thread', '2018-05-24 12:23:17'),
(133, '5115100172', 'IvanA have commented on your â€™The standard Lorem Ipsum passageâ€™ thread', '2018-05-24 12:23:36'),
(134, '1002420013', 'IvanA have commented on your â€™Section 1.10.33 of \"de Finibus Bâ€™ thread', '2018-05-24 12:23:54'),
(135, '1002420091', 'IvanA have commented on your â€™Some Lorem Ipsumâ€™ thread', '2018-05-24 12:24:17'),
(136, '5115100132', 'IvanA have commented on your â€™Where does it come from?â€™ thread', '2018-05-24 12:24:28'),
(137, '1002420091', 'ReinhartC have commented on your â€™Quisque et quam blanditâ€™ thread', '2018-05-24 12:24:47'),
(138, '5115100166', 'ReinhartC have commented on your â€™EasyWorship 6 Licenseâ€™ thread', '2018-05-24 12:25:20'),
(139, '5115100132', 'You have successfully edited your â€™What is Lorem Ipsum?â€™ thread', '2018-05-24 12:25:59'),
(140, '5115100172', 'ReinhartC have commented on your â€™Section 1.10.32 of \"de Finibus Bâ€™ thread', '2018-05-24 12:26:17'),
(141, '1002420013', 'ReinhartC have commented on your â€™Tugas Kelas RKâ€™ thread', '2018-05-24 12:26:29'),
(142, '5115100166', 'ReinhartC have commented on your â€™Secret Messageâ€™ thread', '2018-05-24 12:26:38'),
(143, '5115100132', 'ElizabethH have commented on your â€™Surat Kerja Praktekâ€™ thread', '2018-05-24 12:26:59'),
(144, '1002420013', 'Admin have deleted your â€™1914 translation by H. Rackham oâ€™ thread', '2018-05-24 12:27:48'),
(145, '5115100132', 'You have successfully created the â€™Loremâ€™ thread', '2018-05-24 12:33:15'),
(146, '5115100132', 'You have successfully deleted your â€™Loremâ€™ thread', '2018-05-24 12:34:07'),
(147, '5115100132', 'You have successfully edited your â€™What is Lorem Ipsum?â€™ thread', '2018-05-24 12:34:53');

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
(29, 124, '1002420091'),
(30, 124, '5115100132'),
(31, 127, '5115100172'),
(32, 127, '5115100132'),
(33, 127, '5115100166'),
(34, 129, '5115100132'),
(35, 129, '1002420013'),
(36, 129, '5115100172'),
(37, 133, '5115100166'),
(38, 133, '5115100172'),
(39, 133, '5115100132'),
(40, 133, '1002420013'),
(41, 136, '5115100172'),
(42, 136, '1002420013'),
(43, 136, '1002420091');

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
(54, 'Thanks a lot!', 126, '5115100172', '2018-05-24 12:22:27'),
(55, 'Itâ€™s quite inaccurate', 134, '5115100172', '2018-05-24 12:22:53'),
(56, 'Is it really true?', 122, '5115100172', '2018-05-24 12:23:16'),
(57, 'Great post dude!', 128, '5115100166', '2018-05-24 12:23:36'),
(58, 'Awesome literature sir.', 131, '5115100166', '2018-05-24 12:23:54'),
(59, 'What is this?', 134, '5115100166', '2018-05-24 12:24:16'),
(60, 'Cool image!', 123, '5115100166', '2018-05-24 12:24:27'),
(61, 'Awesome post!', 135, '5115100132', '2018-05-24 12:24:47'),
(62, 'Sure bruh', 126, '5115100132', '2018-05-24 12:25:20'),
(63, 'Yes', 122, '5115100132', '2018-05-24 12:25:51'),
(64, 'Sorry I fixed it :)', 122, '5115100132', '2018-05-24 12:26:08'),
(65, 'Cool', 129, '5115100132', '2018-05-24 12:26:17'),
(66, 'Terima kasih pak', 133, '5115100132', '2018-05-24 12:26:29'),
(67, 'W O W', 127, '5115100132', '2018-05-24 12:26:38'),
(68, 'Okay', 124, '1002420091', '2018-05-24 12:26:59'),
(69, 'Hehehe', 136, '1002420091', '2018-05-24 12:27:05');

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
(21, 'Not accurate content', '5115100172', 134, '2018-05-24 12:22:43'),
(22, 'Information is fake..', '5115100172', 122, '2018-05-24 12:23:10'),
(25, 'Cracking software', '5115100132', 126, '2018-05-24 12:25:35');

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
(122, 'What is Lorem Ipsum?', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industryâ€™s standard dummy text ever since the 1600s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '', 'public', '5115100132', '2018-05-24 12:34:53', 2),
(123, 'Where does it come from?', 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32.', '../../uploads/attachment/Surfing.jpg', 'public', '5115100132', '2018-05-24 12:08:24', 0),
(124, 'Surat Kerja Praktek', 'Berikut kelengkapan KP saya', '../../uploads/attachment/Proposal_Kerja Praktik_Reinhart_Caesar.docx', 'private', '5115100132', '2018-05-24 12:09:28', 0),
(125, 'Why do we use it?', 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using â€™Content here, content hereâ€™, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for â€™lorem ipsumâ€™ will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).', '', 'public', '5115100166', '2018-05-24 12:11:23', 0),
(126, 'EasyWorship 6 License', 'Here is some EasyWorship 6 License\r\nEmail: stepanova@rdinn.com\r\nPass: zxczxc', '../../uploads/attachment/EasyWorshipLicense.ewl', 'public', '5115100166', '2018-05-24 12:13:10', 0),
(127, 'Secret Message', 'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.', '', 'private', '5115100166', '2018-05-24 12:13:32', 0),
(128, 'The standard Lorem Ipsum passage', '\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"', '', 'public', '5115100172', '2018-05-24 12:14:11', 0),
(129, 'Section 1.10.32 of \"de Finibus B', '\"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\"', '', 'private', '5115100172', '2018-05-24 12:14:38', 0),
(130, '1914 translation by H. Rackham', '\"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?\"', '../../uploads/attachment/Cross_on_the_mountain.jpg', 'public', '5115100172', '2018-05-24 12:15:38', 0),
(131, 'Section 1.10.33 of \"de Finibus B', '\"At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.\"', '', 'public', '1002420013', '2018-05-24 12:16:54', 0),
(133, 'Tugas Kelas RK', 'Berikut adalah tugas RK untuk minggu depan.', '../../uploads/attachment/SRS.docx', 'private', '1002420013', '2018-05-24 12:18:43', 0),
(134, 'Some Lorem Ipsum', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eget felis ut arcu laoreet vehicula at et magna. In nulla enim, imperdiet a lacus tincidunt, tincidunt dignissim ex. In eget orci elit. Ut id ante velit. Nulla sit amet mollis risus. Vivamus non volutpat lorem, et finibus ligula. Proin pharetra nunc tellus, et auctor dolor porttitor et. Praesent gravida, magna in volutpat tincidunt, risus est aliquam massa, quis euismod nibh turpis eu lorem. Sed pulvinar imperdiet metus, quis volutpat dolor scelerisque eget. Vivamus eu ligula non libero tincidunt ultricies et quis metus. Sed sagittis arcu ut augue suscipit commodo. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis fermentum massa vitae consectetur pellentesque. Sed efficitur suscipit condimentum.', '', 'public', '1002420091', '2018-05-24 12:19:40', 0),
(135, 'Quisque et quam blandit', 'Ut venenatis eu velit a feugiat. Aenean vitae faucibus nunc. Cras ornare quam a libero cursus, sit amet molestie risus pellentesque. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ex ligula, cursus at auctor eget, suscipit non turpis. Mauris at ultricies leo. Etiam viverra ante diam, tristique bibendum tortor ultrices eget. Nullam in elit vel purus tristique interdum. Morbi gravida velit purus, a tempus lorem cursus fringilla. Suspendisse potenti. Morbi tristique consectetur nibh, quis bibendum urna. Maecenas ut orci eu tellus volutpat aliquam quis viverra tortor. In nec orci finibus, dignissim purus ut, dapibus mi. Nunc non egestas elit.', '../../uploads/attachment/photo1.png', 'public', '1002420091', '2018-05-24 12:20:37', 0),
(136, 'A Secret Place', 'Guess the secret place!', '../../uploads/attachment/photo2.png', 'private', '1002420091', '2018-05-24 12:21:03', 0);

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
('1002420013', '827ccb0eea8a706c4c34a16891f84e7b', 'MarkZ', 'Dosen', '../../uploads/profpic/user8-128x128.jpg', 'markzuqerberk@gmail.com', '08192837465', 10, 2, '2018-05-24 12:16:15', 'Hi. Iâ€™m Mark :)'),
('1002420091', '1e01ba3e07ac48cbdab2d3284d1dd0fa', 'ElizabethH', 'Dosen', '../../uploads/profpic/user3-128x128.jpg', 'elizabethhiggins@gmail.com', '08273746519', 31, 3, '2018-05-24 12:26:48', 'Yiellowncac\r\nnascna\r\nscnajcn\r\nanc\r\n'),
('5115100132', 'ab56b4d92b40713acc5af89985d4b786', 'ReinhartC', 'Mahasiswa', '../../uploads/profpic/user1-128x128.jpg', 'sgs3.rc@hotmail.com', '08111287200', 44, 3, '2018-05-24 12:41:06', 'Hi.\r\nHello.'),
('5115100166', '57c48dcd266eadf089325affe125151f', 'IvanA', 'Mahasiswa', '../../uploads/profpic/user2-160x160.jpg', 'ivanagung@gmail.com', '081112345678', 15, 3, '2018-05-24 12:23:26', 'Halo semuanya'),
('5115100172', 'ac9ec49afb308497ff99a4e9ab88bd3f', 'JoshuaP', 'Mahasiswa', '../../uploads/profpic/user6-128x128.jpg', 'joshuapardosi@gmail.com', '081187654321', 9, 3, '2018-05-24 12:21:56', 'Namaku ojosh hehehe'),
('admin', '21232f297a57a5a743894a0e4a801fc3', 'Admin', 'Administrator', '../../dist/img/admin.png', 'adminfits@gmail.com', '-', 0, 0, '2018-05-24 12:05:16', NULL);

--
-- Indexes for dumped tables
--

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
  MODIFY `notif_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT for table `fits_private`
--
ALTER TABLE `fits_private`
  MODIFY `private_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `fits_reply`
--
ALTER TABLE `fits_reply`
  MODIFY `reply_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `fits_report`
--
ALTER TABLE `fits_report`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `fits_thread`
--
ALTER TABLE `fits_thread`
  MODIFY `thread_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

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
