-- MySQL dump 10.13  Distrib 5.1.61, for debian-linux-gnu (x86_64)
--
-- Host: db.pghmentoringstories.org    Database: pghmentoring_cl
-- ------------------------------------------------------
-- Server version	5.1.39-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'Numbers Entry 1',1,'Paul','Bridgett',0,0,25,0,0,NULL,NULL,'',1,1,1,'2012-10-23 13:13:19','2012-10-23 13:13:19'),(2,'AYD 1',2,'','',0,0,0,0,0,NULL,NULL,'',1,0,1,'2012-11-28 16:11:15','2012-11-28 16:11:15'),(3,'Event 1',3,'','',0,0,0,0,0,NULL,NULL,'',1,0,1,'2012-12-03 17:18:52','2012-12-03 17:18:52');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `funders`
--

LOCK TABLES `funders` WRITE;
/*!40000 ALTER TABLE `funders` DISABLE KEYS */;
INSERT INTO `funders` VALUES (1,'Art','','2012-10-23 13:08:45','2012-10-23 13:08:45'),(2,'Education','','2012-10-23 13:08:53','2012-10-23 13:08:53'),(3,'Sports','','2012-10-23 13:09:01','2012-10-23 13:09:01');
/*!40000 ALTER TABLE `funders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Pittsburgh, PA, USA',40.4406,-79.9959,'2012-10-23 13:13:21','2012-10-23 13:13:21'),(2,'2700 Shadeland Avenue, Pittsburgh, PA 15212',40.4692,-80.03,'2012-11-28 16:11:17','2012-11-28 16:11:17'),(3,'Landmarks Building, 100 W. Station Square Drive, Suite 621 Pittsburgh, PA 15219',40.4334,-80.0036,'2012-12-03 17:18:54','2012-12-03 17:18:54');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `page_images`
--

LOCK TABLES `page_images` WRITE;
/*!40000 ALTER TABLE `page_images` DISABLE KEYS */;
INSERT INTO `page_images` VALUES (1,1,'girls-stretching-at-bos-jis-400x300.jpg','image/jpeg',65320,'2012-10-23 13:10:22','2012-10-23 13:10:22');
/*!40000 ALTER TABLE `page_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `page_web_links`
--

LOCK TABLES `page_web_links` WRITE;
/*!40000 ALTER TABLE `page_web_links` DISABLE KEYS */;
INSERT INTO `page_web_links` VALUES (1,1,'Strong Women Strong Girls Site','http://swsg.org/','2012-10-23 13:10:22','2012-10-23 13:10:22');
/*!40000 ALTER TABLE `page_web_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES (1,'Story 1 SWSG',2,'Description for Story 1 SWSG',0,1,1,'2012-10-23 13:10:22','2012-11-19 20:57:14',1,'',NULL,0),(2,'Dominick and Warren',4,'23 year olds, Dominick Jones-Moriarty and Warren Butler have served as mentors and role models to two dozen at-risk boys at Allegheny Youth Development, after having been mentored through AYD themselves. Now, they help ensure that the nonprofit program continues to effectively reach North Side teenage boys.  Because of the beneficial impact Dominick and Warren got from their mentors at AYD, they seek to affect others in the same positive way.',0,1,0,'2012-11-19 20:57:06','2012-11-19 20:57:06',1,'',NULL,0),(3,'Rev. Paige and Raiqual',6,'Rev. Paige joined Amachi Pittsburgh as a mentor in 2004, when the program first started. He was matched with his mentee, Raiqual, and the two began to meet weekly, incorporating activities that were fun, but encourage learning as well. Through this match, Raiqual has improved his reading skills, as well as formed a close relationship with a leader in his community.',0,1,0,'2012-11-19 20:57:49','2012-11-19 20:57:49',1,'',NULL,0),(4,'Karen and Benjamin',10,'Michael Benjamin entered the Beginning with Books program when he was just 4 years old. He was matched with his mentor, Karen Perry, a school teacher who Benjamin credits for the many successes in his life. Karen Perry would read with Benjamin and help him with his homework. Now, Benjamin is a senior in high school, looking to attend Tulane University, where he received an academic scholarship. He hopes to give back as a mentor and be as positive an influence for a child as Karen was for him.',0,1,0,'2012-11-19 20:59:06','2012-11-19 20:59:06',1,'',NULL,0),(5,'Vanessa and Earlene',7,'Vanessa and Earlene are a great example of the powerful relationships that can result from mentoring. While Gwen’s Girls asks mentors to make a one year commitment, they have already spent more than two year’s matched.  Bonding over music, and spending a minimum of 12 hours per month together, Vanessa and Earlene participate in Gwen’s Girls activities, do homework, and discuss what’s going on in each other’s lives.  Their relationship is clearly strong, and they are enriching each others’ lives.',0,1,0,'2012-11-19 20:59:25','2012-11-19 20:59:25',1,'',NULL,0),(6,'Heidi and Damon',9,'Heidi Semmer decided to become a Big Sister in 2001, when she was introduced to her little brother, Damon. They began spending time together, going to the park and movies, and playing basketball. Just a few years later, when Damon was only 10, he lost his mother, and Heidi was by his side through the grief and difficulty of that time. Still matched, Heidi and Damon continue to read, learn, and have fun. Damon now has a second family.',0,1,0,'2012-11-19 20:59:48','2012-11-19 20:59:48',1,'',NULL,0);
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pages_funders`
--

LOCK TABLES `pages_funders` WRITE;
/*!40000 ALTER TABLE `pages_funders` DISABLE KEYS */;
INSERT INTO `pages_funders` VALUES (1,1),(1,2);
/*!40000 ALTER TABLE `pages_funders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `project_images`
--

LOCK TABLES `project_images` WRITE;
/*!40000 ALTER TABLE `project_images` DISABLE KEYS */;
INSERT INTO `project_images` VALUES (1,2,'Strong Women Strong Girls.jpg','image/jpeg',799796,'2012-10-23 13:07:15','2012-11-02 18:38:54'),(2,3,'Family Tyes.jpg','image/jpeg',1248913,'2012-11-02 18:43:04','2012-11-02 18:43:04'),(3,9,'BBBSPicture.jpg','image/jpeg',266341,'2012-11-02 19:21:30','2012-12-03 16:53:54'),(4,11,'100 Black Men.jpg','image/jpeg',813739,'2012-11-02 19:25:43','2012-11-02 19:25:43'),(5,12,'Reading is Fundamental - Everyone Wins!.jpg','image/jpeg',721781,'2012-11-02 19:28:31','2012-11-02 19:28:31'),(6,4,'Allegheny Youth Development.jpg','image/jpeg',137425,'2012-11-07 18:37:39','2012-11-07 18:37:39'),(7,6,'Amachi woman and girl.JPG','image/jpeg',2585320,'2012-11-07 18:38:37','2012-11-07 18:38:37'),(8,10,'Books.jpg','image/jpeg',223940,'2012-11-07 18:41:12','2012-11-07 18:52:10'),(9,7,'Gwen.jpg','image/jpeg',324250,'2012-11-07 18:41:49','2012-11-07 18:51:04'),(10,5,'MGR Murals.jpg','image/jpeg',91762,'2012-11-07 18:42:37','2012-11-07 18:42:37'),(11,8,'Pittsburgh Harlequins Rugby.jpg','image/jpeg',188596,'2012-11-07 18:43:54','2012-11-07 18:43:54'),(12,13,'Rosensteel_BBBS.jpg','image/jpeg',1027176,'2012-12-03 17:01:52','2012-12-03 17:01:52');
/*!40000 ALTER TABLE `project_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `project_web_links`
--

LOCK TABLES `project_web_links` WRITE;
/*!40000 ALTER TABLE `project_web_links` DISABLE KEYS */;
INSERT INTO `project_web_links` VALUES (1,1,'MGC','http://mcg.org','2012-10-19 15:35:52','2012-10-19 15:35:52'),(2,2,'Strong Women Strong Girls Site','http://swsg.org/','2012-10-23 13:07:15','2012-10-23 13:07:15'),(3,2,'Mentoring Partnership Program','http://mentoringpittsburgh.org/program_details.aspx?prgId=6977','2012-11-02 18:38:54','2012-11-02 18:38:54'),(4,3,'Family Tyes Site','http://www.familytyes.com/','2012-11-02 18:43:04','2012-11-02 18:43:04'),(5,3,'Mentoring Partnership Program','http://mentoringpittsburgh.org/program_details.aspx?prgId=6940','2012-11-02 18:43:04','2012-11-02 18:43:04'),(6,4,'Allegheny Youth Development','http://www.ayd.org/','2012-11-02 19:13:14','2012-11-02 19:13:14'),(7,5,'MGR Foundation Website','http://www.mgrf.org/','2012-11-02 19:16:03','2012-11-02 19:16:03'),(8,5,'Mentoring Partnership Program','http://mentoringpittsburgh.org/program_details.aspx?prgId=6953','2012-11-02 19:16:03','2012-11-02 19:16:03'),(9,6,'Amachi Mentoring Site','http://www.amachimentoring.org/','2012-11-02 19:17:34','2012-11-02 19:17:34'),(10,6,'Mentoring Partnership Program','http://mentoringpittsburgh.org/program_details.aspx?prgId=5040','2012-11-02 19:17:34','2012-11-02 19:17:34'),(11,7,'Gwen\'s Girls Site','http://www.gwensgirls.org/','2012-11-02 19:18:27','2012-11-02 19:18:27'),(12,7,'Mentoring Partnership Program','http://mentoringpittsburgh.org/program_details.aspx?prgId=5100','2012-11-02 19:18:27','2012-11-02 19:18:27'),(13,8,'Pittsburgh Harlequins Site','http://www.pittsburghharlequins.org/news/2011/03/20/2011-harlequin-youth-rugby-begins','2012-11-02 19:19:33','2012-11-02 19:19:33'),(14,8,'Mentoring Partnership Program','http://mentoringpittsburgh.org/program_details.aspx?prgId=6964','2012-11-02 19:19:33','2012-11-02 19:19:33'),(15,9,'Big Brothers Big Sisters of Greater Pittsburgh','http://www.bbbspgh.org/site/c.ahKLIYMIImI2E/b.8123819/k.F03D/Home_Page.htm','2012-11-02 19:21:30','2012-11-02 19:21:30'),(16,10,'Beginning With Books Site','http://www.beginningwithbooks.org','2012-11-02 19:23:06','2012-11-02 19:23:06'),(17,11,'100 Black Men Site','http://www.100blackmenofwesternpa.org','2012-11-02 19:25:43','2012-11-02 19:25:43'),(18,11,'Mentoring Partnership Program','http://mentoringpittsburgh.org/program_details.aspx?prgId=6917','2012-11-02 19:25:43','2012-11-02 19:25:43'),(19,12,'Reading is Fundamental Site','http://www.rifpittsburgh.org/Everybody-Wins-','2012-11-02 19:28:31','2012-11-02 19:28:31'),(20,13,'Big Brothers Big Sisters of Beaver County','http://bgbigs.org','2012-12-03 17:01:52','2012-12-03 17:01:52');
/*!40000 ALTER TABLE `project_web_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'Manchester Craftsman Guild FAKE','test description for MCG',1,'',1,1,'2012-10-19 15:35:52','2012-10-23 14:52:42','bweaver@pittsburghcares.org'),(2,'Strong Women Strong Girls','Professional women mentor college students in one-on-one relationships. College women from Carlow, Point Park, Carnegie Mellon, Duquesne and Pitt are needed to mentor elementary school girls in a group mentoring setting in after school program.  The mission of SWSG is to build upon the lessons learned from strong women throughout history to help girls and young women become strong women themselves. ',1,'',1,0,'2012-10-23 13:07:15','2012-11-06 19:29:22','aparker@swsg.org'),(3,'Family Tyes','Family Tyes is a 501 C-3 Non-Profit organization that is committed to youth development, family values and environmental conservation. Fly-fishing activities are organized to promote educational experiences and to connect youth, schools, families, businesses and communities.',1,'',1,0,'2012-10-23 15:12:29','2012-11-02 18:43:04','mkaleta@familytyes.org'),(4,'Allegheny Youth Development','On Monday and Wednesday evenings tutoring and judo classes for middle and high school boys. On Tuesday and Thursday evenings we will have high school tutoring followed by a fitness class. Giving young men a spiritual edge to success defines our work at Allegheny Youth Development. We focus on developing the practical traits of a Christian philosophy ... a serious, goal-oriented attitude toward education. Great self-control. A more generous nature and hope for the future.',1,'',1,0,'2012-11-02 19:13:14','2012-11-02 19:13:14','brfoltz@ayd.org'),(5,'MGR Foundation Murals Program','Murals is a program that uses music, art, drama, and dance to help students to deal with the issue of violence in their lives. As a component to our program, the MGR Foundation uses college \"artistic mentors\" to help guide the students through the artistic process, build relationships, and offer their insight and experience relating to violence.',1,'',1,0,'2012-11-02 19:16:03','2012-11-02 19:16:03','dkinsel@mgrf.org'),(6,'Amachi Pittsburgh','Amachi Pittsburgh\'s mission is to help break the cycle of incarceration through faith-based mentoring for children of prisoners and their families at 17 Pittsburgh area locations.',1,'',1,0,'2012-11-02 19:17:34','2012-11-02 19:17:34','ahollis@amachipgh.org'),(7,'Gwen\'s Girls','Gwen\'s Girls provides adolescent girls with a continuum of services and activities and opportunities. Our comprehensive, asset-based approach will empower girls to be goal-directed, self-sufficient and to imagine and fulfill a new destiny. Programming empowers girls through a gender specific education and experience.',1,'',1,0,'2012-11-02 19:18:27','2012-11-02 19:18:27','aboyle@gwensgirls.org'),(8,'Pittsburgh Harlequins Rugby Football Association','Pittsburgh Harlequins utilizes the sport of Rugby Football as a mentoring tool with disadvantaged youth in the Pittsburgh region. To this end, the Pittsburgh Harlequins Rugby Football Association organizes and staff programs throughout the region involving over 300 youth,mentors, parents and community stakeholders.',1,'',1,0,'2012-11-02 19:19:33','2012-11-02 19:19:33','matt@pittsburghharlequins.org'),(9,'Big Brothers Big Sisters of Greater Pittsburgh','The mission of Big Brothers Big Sisters of Greater Pittsburgh is to make positive differences in the lives of children by providing one-to-one mentoring programs and related services that help local youth discover their highest potential and grow to become responsible adults leading productive and rewarding lives.',1,'',1,0,'2012-11-02 19:21:30','2012-11-02 19:21:30','asable@bbbspgh.org'),(10,'Beginning with Books','The \"Read Together\" program matches children with volunteers who read to them one-on-one during weekly sessions at a library site. Children ages 3-8 whose parent(s) or grandparent(s) are enrolled in an adult literacy program or Head Start, are eligible for the program. Library sites include several locations throughout Pittsburgh.',1,'',1,0,'2012-11-02 19:23:06','2012-11-06 19:29:43','blacks@mybwb.org'),(11,'100 Black Men of Western, PA','The organization\'s mission is to combine our talents and resources to help solve some of the problems that affect the African American community in the Greater Pittsburgh Area. The 100 Black Men of Western PA Inc is a local charter of a national organization. Youth are involved in the group mentoring program which has four components: education, health, cultural and economic development. Focus is on African-American males and females who are middle or high school students. ',1,'',1,0,'2012-11-02 19:25:43','2012-11-06 19:30:02','mikecar78@aol.com'),(12,'Reading is Fundamental Everybody Wins!','Everybody Wins! is a lunchtime literacy and mentoring program that pairs elementary school students with community volunteers to share fun, conversation and good books. Everybody Wins! increases a child\'s opportunity for success, both academically and in life',1,'',1,0,'2012-11-02 19:28:31','2012-11-02 19:28:31','kporigow@rifpittsburgh.org'),(13,'Big Brothers Big Sisters of Beaver County','BBBS of Beaver County assists children in reaching their potential through professionally supported dynamic, one-to-one mentoring relationships with caring and committed Big Brothers, Sisters, and couples.',1,'',1,0,'2012-12-03 17:01:52','2012-12-03 17:01:52','csofranko@bcbigs.org');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','2012-10-18 16:18:38','2012-10-18 16:18:38'),(2,'user','2012-10-18 16:18:38','2012-10-18 16:18:38');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20110726183138'),('20110726183226'),('20110726183257'),('20110726183335'),('20110726183344'),('20110729152001'),('20111003222229'),('20111005214505'),('20111007210313'),('20111008210313'),('20111008210314'),('20111008210315'),('20111013162942'),('20120208175509'),('20120304005834'),('20120417182047'),('20120417182510'),('20120417182640'),('20120417195002'),('20120419183436'),('20120420054717'),('20120423222630'),('20120909230020');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (1,1,1,NULL,NULL,'Event','location','2012-10-23 13:13:20'),(2,2,2,NULL,NULL,'Event','location','2012-11-28 16:11:16'),(3,3,3,NULL,NULL,'Event','location','2012-12-03 17:18:53');
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'Pittsburgh, PA, USA'),(2,'2700 Shadeland Avenue, Pittsburgh, PA 15212'),(3,'Landmarks Building, 100 W. Station Square Drive, Suite 621 Pittsburgh, PA 15219');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Benjamin','Weaver','bweaver@pittsburghcares.org','bweaver','6180afc978ca3022d2a6e01f7ec8a0f50af6f57c','39ea3d20e2c307dff69725ff35fb79af04774b5b',NULL,NULL,'8d28ec1ffbf41cc43484c6da8a28000fb3fdc4a5',NULL,'2012-10-23 14:39:29',0,'2012-10-19 15:04:57','2012-10-23 15:16:42'),(2,'Paul','Dille','pdille@andrew.cmu.edu','pdille','57ca7ff4bef2d1356a55d95972ef365ef48a5e71','83155e9f44e195da2c38b93e6e2ebdce20faad6e',NULL,NULL,NULL,NULL,'2012-12-03 18:47:25',0,'2012-12-03 18:46:30','2012-12-03 18:47:25'),(3,'Randy','Tobias','randyftobias@gmail.com','randytobias','a25e6b10e998606809c8532bd5d9471e786bd7ab','125390f2f286c5b47e001a5c91aea4caa9dacfb4','ac5c5c747f4c379f4b8dccfeff38562614f53dc7','2013-01-30 19:41:08',NULL,NULL,'2013-01-16 19:40:51',0,'2013-01-16 19:39:56','2013-01-16 19:41:08');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users_events`
--

LOCK TABLES `users_events` WRITE;
/*!40000 ALTER TABLE `users_events` DISABLE KEYS */;
INSERT INTO `users_events` VALUES (1,1,'2012-10-23 13:13:19','2012-10-23 13:13:19'),(1,2,'2012-10-19 15:04:57','2012-10-23 15:16:42'),(1,3,'2012-10-19 15:04:57','2012-10-23 15:16:42');
/*!40000 ALTER TABLE `users_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users_projects`
--

LOCK TABLES `users_projects` WRITE;
/*!40000 ALTER TABLE `users_projects` DISABLE KEYS */;
INSERT INTO `users_projects` VALUES (1,1),(1,2);
/*!40000 ALTER TABLE `users_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users_roles`
--

LOCK TABLES `users_roles` WRITE;
/*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;
INSERT INTO `users_roles` VALUES (1,1),(2,1),(3,1);
/*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-01-16 12:57:48
