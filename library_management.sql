-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 20, 2023 at 05:15 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library_management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_category` (`catname` VARCHAR(255), `status` VARCHAR(255))   BEGIN
	insert into category(catname,status)value(catname,status);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_category` (`id` INT(11))   BEGIN
	DELETE from category WHERE category.ID=id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_backup` (IN `id` INT, IN `name` VARCHAR(255), IN `category` INT, IN `author` INT, IN `publisher` INT, IN `content` VARCHAR(255), IN `pages` INT, IN `edition` INT)   begin
    start transaction;
	insert into book(id,name,category,author,publisher,content,pages,edition)VALUES(id,name,category,author,publisher,content,pages,edition);
    delete from book_backu where book_backu.id = id; 
    if (select check_exist(name) = 1)
    then
		commit;
	else
		rollback;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sortBookNameAsc` ()   begin
	select b.id,b.name,c.catname,a.name,p.publisher,b.content,b.pages,b.edition from book b JOIN category c On b.category = c.id JOIN author a On b.author = a.id JOIN publisher p On b.publisher = p.id order by b.name asc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sortBookNameDesc` ()   begin
	select b.id,b.name,c.catname,a.name,p.publisher,b.content,b.pages,b.edition from book b JOIN category c On b.category = c.id JOIN author a On b.author = a.id JOIN publisher p On b.publisher = p.id order by b.name desc;
end$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_exist` (`name` VARCHAR(255)) RETURNS INT(11)  begin
declare gt int;
if exists (select name from book where book.name = name)
	then set gt=1;
    else set gt=0;
end if;
return gt;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `question` varchar(255) NOT NULL,
  `answer` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`id`, `username`, `name`, `password`, `question`, `answer`) VALUES
(1, 'hung', 'hung', '123456', 'What is your school name?', 'ctu');

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `phone` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`id`, `name`, `address`, `phone`) VALUES
(1, 'Dale Carnegie', 'America', 132035324),
(2, 'Paulo Coelho', 'Brazil', 598387564),
(3, 'J.K.Rowling', 'England', 899092658),
(4, 'Dượng Tony', 'Việt Nam', 598387516),
(5, 'Robert Kiyosaki', 'America', 899093610),
(6, 'Trump', 'America', 899093679),
(7, 'J.D.Salinger', 'New York City, U.S', 899096639),
(8, 'Margaret Mitchell', 'America', 899094686),
(9, 'Tony Hsieh', 'America', 598384733);

-- --------------------------------------------------------

--
-- Table structure for table `book`
--

CREATE TABLE `book` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` int(11) NOT NULL,
  `author` int(11) NOT NULL,
  `publisher` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `pages` int(11) NOT NULL,
  `edition` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book`
--

INSERT INTO `book` (`id`, `name`, `category`, `author`, `publisher`, `content`, `pages`, `edition`) VALUES
(1, 'Đắc Nhân Tâm', 1, 1, 1, 'self-help', 320, 10),
(2, 'Nhà Giả Kim', 2, 2, 2, 'tiểu thuyết', 225, 30),
(3, 'Harry Potter', 3, 3, 3, 'Goblet of Fire', 636, 23),
(4, 'Cà phê cùng Tony', 4, 4, 4, 'Tony buổi sáng', 268, 6),
(5, 'Dạy con làm giàu', 5, 5, 5, 'Rich Dad Series', 336, 25),
(6, 'Tỷ phú bán giày', 8, 9, 7, 'văn hóa công ty', 368, 5),
(7, 'Đừng bao giờ bỏ cuộc', 6, 6, 5, 'Never Give Up', 207, 22),
(8, 'Bắt trẻ đồng xanh', 7, 7, 9, 'tiểu thuyết', 277, 2),
(9, 'Cuốn theo chiều gió', 9, 8, 8, 'lịch sử', 1037, 2),
(12, 'one piece', 4, 1, 1, 'vua hải tặc', 1058, 2);

--
-- Triggers `book`
--
DELIMITER $$
CREATE TRIGGER `backup_book` BEFORE DELETE ON `book` FOR EACH ROW begin
	insert into book_backu values (old.id,old.name,old.category,old.author,old.publisher,old.content,old.pages,old.edition);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `book_backu`
--

CREATE TABLE `book_backu` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` int(11) NOT NULL,
  `author` int(11) NOT NULL,
  `publisher` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `pages` int(11) NOT NULL,
  `edition` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `ID` int(11) NOT NULL,
  `catname` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`ID`, `catname`, `status`) VALUES
(1, 'Life skill', 'Active'),
(2, 'Fantasy mysticism', 'Active'),
(3, 'Fantasy novels', 'Active'),
(4, 'Short stories', 'Active'),
(5, 'Economics-Management', 'Active'),
(6, 'History', 'Default'),
(7, 'Romance', 'Default'),
(8, 'Essays', 'Default'),
(9, 'Thrillers&Horror', 'Default'),
(11, 'Children', 'Default');

-- --------------------------------------------------------

--
-- Table structure for table `lendbook`
--

CREATE TABLE `lendbook` (
  `id` int(11) NOT NULL,
  `memberid` int(11) NOT NULL,
  `bookid` int(11) NOT NULL,
  `issuedate` date NOT NULL,
  `returndate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lendbook`
--

INSERT INTO `lendbook` (`id`, `memberid`, `bookid`, `issuedate`, `returndate`) VALUES
(1, 1, 1, '2023-04-20', '2023-05-19'),
(2, 2, 2, '2023-03-20', '2023-04-10'),
(3, 3, 3, '2023-05-20', '2023-06-01');

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id`, `name`, `address`, `phone`) VALUES
(1, 'Hưng', 'An Giang', 917493415),
(2, 'Khoa', 'Sóc Trăng', 706778307),
(3, 'Phú', 'Cà Mau', 384264628);

-- --------------------------------------------------------

--
-- Table structure for table `publisher`
--

CREATE TABLE `publisher` (
  `id` int(11) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `phone` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `publisher`
--

INSERT INTO `publisher` (`id`, `publisher`, `address`, `phone`) VALUES
(1, 'First News', 'Việt Nam', 3827980),
(2, 'Nhã Nam', 'Việt Nam', 598117775),
(3, 'Bloomsbury', 'England', 598387516),
(4, 'NXB trẻ', 'Việt Nam', 839316289),
(5, 'ThomsonReuters', 'Canada', 899098772),
(6, 'NXB Kim Đồng', 'Việt Nam', 1900571595),
(7, 'NXB Giáo dục', 'Việt Nam', 439422010),
(8, 'Pearson', 'England', 326260702),
(9, 'Bertelsmann', 'Germany', 499956449);

-- --------------------------------------------------------

--
-- Table structure for table `returnbook`
--

CREATE TABLE `returnbook` (
  `id` int(11) NOT NULL,
  `mid` int(11) NOT NULL,
  `mname` varchar(255) NOT NULL,
  `bname` varchar(255) NOT NULL,
  `returndate` varchar(255) NOT NULL,
  `elap` int(11) NOT NULL,
  `fine` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_backu`
--
ALTER TABLE `book_backu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `lendbook`
--
ALTER TABLE `lendbook`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `publisher`
--
ALTER TABLE `publisher`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `returnbook`
--
ALTER TABLE `returnbook`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `author`
--
ALTER TABLE `author`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `book`
--
ALTER TABLE `book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `book_backu`
--
ALTER TABLE `book_backu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `lendbook`
--
ALTER TABLE `lendbook`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `publisher`
--
ALTER TABLE `publisher`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `returnbook`
--
ALTER TABLE `returnbook`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
