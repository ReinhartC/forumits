-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 26, 2018 at 09:07 AM
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
		UPDATE fits_user SET user_photo=CONCAT('../dist/img/',p_photo) WHERE user_id=p_id;
		UPDATE fits_user SET user_note=p_note WHERE user_id=p_id;
		SELECT 0, 'User Account Updated';
		
	ELSE
		SELECT -1, 'User Account Update Error';
	END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `account_threadlist` (`p_id` VARCHAR(16))  BEGIN
	SELECT fits_thread.*, fits_user.`user_id`, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_user.`user_id` = p_id
	ORDER BY thread_time DESC 
	LIMIT 10;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dos_threadlist` (`lmt` INT)  BEGIN
	SELECT fits_thread.*, fits_user.`user_id`, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_user.`user_role` = "Dosen"
	ORDER BY thread_time DESC 
	LIMIT lmt;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `mhs_threadlist` (`lmt` INT)  BEGIN
	SELECT fits_thread.*, fits_user.`user_id`, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_user.`user_role` = "Mahasiswa"
	ORDER BY thread_time DESC 
	LIMIT lmt;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_thread` (`judul` VARCHAR(32), `isi` TEXT, `attachments` VARCHAR(128), `input_user_id` VARCHAR(16))  BEGIN
	INSERT INTO fits_thread (thread_judul, thread_isi, thread_attachment, user_id, thread_time) VALUES(judul, isi, attachments, input_user_id,NOW());
	UPDATE fits_user SET user_threadcount=user_threadcount+1 WHERE user_id=input_user_id;
	SELECT 1, 'Thread Added';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reply_load` (`p_id` VARCHAR(16))  BEGIN
	SELECT distinct fits_reply.*, fits_user.`user_id`, fits_user.`user_name`, fits_user.`user_photo`
	FROM fits_reply, fits_user
	where fits_reply.`user_id` = fits_user.`user_id`
	and fits_reply.`thread_id` = p_id
	ORDER BY reply_time DESC;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reply_thread` (`isi` TEXT, `reply_thread_id` VARCHAR(16), `reply_user_id` VARCHAR(16))  BEGIN
	INSERT INTO fits_reply (reply_isi, thread_id, user_id, reply_time) VALUES(isi, reply_thread_id, reply_user_id,NOW());
	SELECT 1, 'Reply Added';
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_thread` (`keyword` VARCHAR(64))  BEGIN
	SELECT fits_thread.*, fits_user.`user_id`, fits_user.`user_name`, fits_user.`user_role`
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND (fits_thread.`thread_judul` LIKE CONCAT('%',keyword,'%')
	or fits_user.`user_name` LIKE CONCAT('%',keyword,'%')
	or fits_thread.`thread_isi` LIKE CONCAT('%',keyword,'%'));
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `thread_load` (`p_id` INT)  BEGIN
	SELECT fits_thread.*, fits_user.*
	FROM fits_thread, fits_user
	WHERE fits_thread.`user_id`=fits_user.`user_id`
	AND fits_thread.`thread_id`=p_id;
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `fits_notification`
--

CREATE TABLE `fits_notification` (
  `notif_id` varchar(16) NOT NULL,
  `user_id` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(10, 'Mantab infonya gan...', 31, '1002420091', '2018-04-26 06:42:53'),
(11, 'Apa itu?', 16, '1002420091', '2018-04-26 06:51:29'),
(12, 'Hi Iâ€™m Ivan :)', 31, '5115100166', '2018-04-26 06:52:06'),
(13, 'Mantabb', 18, '5115100132', '2018-04-26 06:54:07'),
(14, 'opopo\r\n', 31, '5115100132', '2018-04-26 07:04:28'),
(15, 'kmm', 32, '5115100132', '2018-04-26 07:05:44');

-- --------------------------------------------------------

--
-- Table structure for table `fits_thread`
--

CREATE TABLE `fits_thread` (
  `thread_id` int(11) NOT NULL,
  `thread_judul` varchar(32) NOT NULL,
  `thread_isi` text NOT NULL,
  `thread_attachment` varchar(128) DEFAULT NULL,
  `user_id` varchar(16) NOT NULL,
  `thread_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fits_thread`
--

INSERT INTO `fits_thread` (`thread_id`, `thread_judul`, `thread_isi`, `thread_attachment`, `user_id`, `thread_time`) VALUES
(2, 'Thread 1', '---- Thread pertamaaaaa ----', '', '5115100132', '2018-04-25 17:27:53'),
(3, 'Thread create 2', 'Thread buatan pertamaa', '', '5115100132', '2018-04-25 17:32:32'),
(4, 'Thread create 3', 'Coba-coba bikin thread di website ah. Kedua nehhh', 'boxed-bg.jpg', '5115100166', '2018-04-25 17:34:44'),
(5, 'Thread create 4', 'Coba bikin juga nih. Skalian stability test wkkwwk :)', '', '5115100172', '2018-04-25 17:36:28'),
(6, 'Thread create 5 (Dosen)', 'Thread dosen pertama neh wkwkwk. Nyoba attachment dulu dah.\r\nLancar jaya aminn', 'photo4.jpg', '1002420013', '2018-04-25 17:37:45'),
(7, 'Thread Create 6 (Dosen)', 'Thread pertama ane nih hehe.', '', '1002420091', '2018-04-25 17:38:23'),
(8, 'Thread create 7 ', 'Thread kedua saya hehe. Coba attachment deh skalian. Nih ruang makan', 'photo2.png', '1002420091', '2018-04-25 17:38:55'),
(9, 'Thread create 8', 'Balik lagi neh bikin thread ane. Kali ini pake attachment dah :)))))', 'photo1.png', '5115100132', '2018-04-25 17:40:08'),
(10, 'Thread Create 9', 'Mulai spam nih saya. Maaf hehe', '', '5115100132', '2018-04-25 17:40:34'),
(11, 'Thread Create 10', '-------=============--------\r\nThread ke SEPULUHHHHHH.\r\nMuantap...\r\nGG FORUMITS.\r\nNih gambar orang wkwkwkwwk :))\r\n-------=============--------', 'avatar.png', '5115100172', '2018-04-25 17:41:47'),
(12, 'The standard Lorem Ipsum passage', '\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"', '', '5115100166', '2018-04-25 17:42:59'),
(13, 'Section 1.10.32 of \"de Finibus B', '\"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\"', 'photo1.png', '5115100132', '2018-04-25 17:43:43'),
(14, '1914 translation by H. Rackham', '\"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?\"', '', '5115100172', '2018-04-25 17:44:28'),
(15, 'Bingung :|', 'Ini kenapa pada lorem ipsum deh hahahaha', '', '1002420013', '2018-04-25 17:45:03'),
(16, 'Section 1.10.33 of \"de Finibus B', '\"At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.\"', 'user8-128x128.jpg', '1002420013', '2018-04-25 17:45:42'),
(17, 'Pertanyaan', 'Kenapa semua jadi lorem ipsummmm', '', '1002420091', '2018-04-25 17:46:31'),
(18, 'Coba lagi :)', 'Wah masih lancar hehehe', 'photo2.png', '1002420091', '2018-04-25 19:33:19'),
(31, 'What is Lorem ipsum?', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industryâ€™s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '', '1002420013', '2018-04-26 05:50:28'),
(32, 'njnjnjn', 'mmkmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmâ€™', '', '5115100132', '2018-04-26 07:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `fits_user`
--

CREATE TABLE `fits_user` (
  `user_id` varchar(16) NOT NULL,
  `user_pass` varchar(64) NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `user_role` varchar(12) NOT NULL,
  `user_photo` varchar(255) NOT NULL DEFAULT '../dist/img/avatar.png',
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
('1002420013', '827ccb0eea8a706c4c34a16891f84e7b', 'MarkZ', 'Dosen', '../dist/img/user8-128x128.jpg', 'markzuqerberk@gmail.com', '08192837465', 0, 7, '2018-04-26 05:40:19', 'Hi. Iâ€™m Mark :)'),
('1002420091', '1e01ba3e07ac48cbdab2d3284d1dd0fa', 'ElizabethH', 'Dosen', '../dist/img/user4-128x128.jpg', 'elizabethhiggins@gmail.com', '08273746519', 0, 4, '2018-04-26 06:42:33', 'Yiellow'),
('5115100132', 'ab56b4d92b40713acc5af89985d4b786', 'ReinhartC', 'Mahasiswa', '../dist/img/user1-128x128.jpg', 'sgs3.rc@hotmail.com', '08111287200', 0, 15, '2018-04-26 06:53:59', 'Hi.\r\nHello.'),
('5115100166', '57c48dcd266eadf089325affe125151f', 'IvanA', 'Mahasiswa', '../dist/img/user2-160x160.jpg', 'ivanagung@gmail.com', '081112345678', 0, 2, '2018-04-26 06:51:52', 'Halo semuanya'),
('5115100172', 'ac9ec49afb308497ff99a4e9ab88bd3f', 'JoshuaP', 'Mahasiswa', '../dist/img/user6-128x128.jpg', 'joshuapardosi@gmail.com', '081187654321', 0, 3, '2018-04-25 17:44:09', 'Namaku ojosh hehehe');

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
-- Indexes for table `fits_reply`
--
ALTER TABLE `fits_reply`
  ADD PRIMARY KEY (`reply_id`),
  ADD KEY `reply_user_id` (`user_id`),
  ADD KEY `reply_thread_id` (`thread_id`);

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
-- AUTO_INCREMENT for table `fits_reply`
--
ALTER TABLE `fits_reply`
  MODIFY `reply_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `fits_thread`
--
ALTER TABLE `fits_thread`
  MODIFY `thread_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fits_notification`
--
ALTER TABLE `fits_notification`
  ADD CONSTRAINT `notif_user_id` FOREIGN KEY (`user_id`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fits_reply`
--
ALTER TABLE `fits_reply`
  ADD CONSTRAINT `reply_thread_id` FOREIGN KEY (`thread_id`) REFERENCES `fits_thread` (`thread_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reply_user_id` FOREIGN KEY (`user_id`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fits_thread`
--
ALTER TABLE `fits_thread`
  ADD CONSTRAINT `thread_user_id` FOREIGN KEY (`user_id`) REFERENCES `fits_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
