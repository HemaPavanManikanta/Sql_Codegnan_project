-- =============================================================================
-- PLACEMENT PREPARATION PLATFORM — COMPLETE DATABASE SCHEMA DDL
-- Database Engine: MySQL 8.0.45 (InnoDB)
-- Database Name: placementdb
-- Charset: utf8mb4 | Collation: utf8mb4_unicode_ci
-- Total Tables: 24 | Total Foreign Keys: 26 | Check Constraints: 28
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `placementdb`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `placementdb`;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `audit_logs`;
DROP TABLE IF EXISTS `mock_interview_answers`;
DROP TABLE IF EXISTS `mock_interview_sessions`;
DROP TABLE IF EXISTS `student_badges`;
DROP TABLE IF EXISTS `resume_evaluations`;
DROP TABLE IF EXISTS `mentorship_notes`;
DROP TABLE IF EXISTS `quiz_attempt_answers`;
DROP TABLE IF EXISTS `quiz_attempts`;
DROP TABLE IF EXISTS `quiz_questions`;
DROP TABLE IF EXISTS `interview_questions`;
DROP TABLE IF EXISTS `company_track_topics`;
DROP TABLE IF EXISTS `company_track_rounds`;
DROP TABLE IF EXISTS `company_tracks`;
DROP TABLE IF EXISTS `submissions`;
DROP TABLE IF EXISTS `test_cases`;
DROP TABLE IF EXISTS `problems`;
DROP TABLE IF EXISTS `drive_applications`;
DROP TABLE IF EXISTS `drive_eligible_departments`;
DROP TABLE IF EXISTS `placement_drives`;
DROP TABLE IF EXISTS `companies`;
DROP TABLE IF EXISTS `readiness_scores`;
DROP TABLE IF EXISTS `password_reset_tokens`;
DROP TABLE IF EXISTS `student_profiles`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- 1. DOMAIN: IDENTITY & CORE USERS
-- =============================================================================

-- Table 1: users (Root user identity for Student, Mentor, TPO)
CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `role` VARCHAR(20) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_email` (`email`),
  CONSTRAINT `chk_users_role` CHECK (`role` IN ('STUDENT', 'MENTOR', 'TPO'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 2: student_profiles (Academic profile with 1:1 shared PK to users)
CREATE TABLE `student_profiles` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `roll_number` VARCHAR(30) NOT NULL,
  `phone` VARCHAR(15) DEFAULT NULL,
  `department` VARCHAR(100) NOT NULL,
  `current_year` TINYINT UNSIGNED DEFAULT NULL,
  `graduation_year` YEAR NOT NULL,
  `cgpa` DECIMAL(4,2) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_student_roll_number` (`roll_number`),
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `chk_student_current_year` CHECK (`current_year` BETWEEN 1 AND 4),
  CONSTRAINT `chk_student_cgpa` CHECK (`cgpa` BETWEEN 0.00 AND 10.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 3: password_reset_tokens (Secure recovery tokens)
CREATE TABLE `password_reset_tokens` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `token_hash` VARCHAR(255) NOT NULL,
  `expires_at` DATETIME NOT NULL,
  `is_used` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_reset_token_hash` (`token_hash`),
  KEY `idx_reset_token_user` (`user_id`),
  CONSTRAINT `fk_reset_token_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 4: readiness_scores (Composite 4-tier student readiness score)
CREATE TABLE `readiness_scores` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `coding_score` DECIMAL(5,2) NOT NULL,
  `aptitude_score` DECIMAL(5,2) NOT NULL,
  `communication_score` DECIMAL(5,2) NOT NULL,
  `overall_score` DECIMAL(5,2) NOT NULL,
  `assessed_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_readiness_student` (`student_id`),
  CONSTRAINT `fk_readiness_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `chk_readiness_coding` CHECK (`coding_score` BETWEEN 0.00 AND 100.00),
  CONSTRAINT `chk_readiness_aptitude` CHECK (`aptitude_score` BETWEEN 0.00 AND 100.00),
  CONSTRAINT `chk_readiness_comm` CHECK (`communication_score` BETWEEN 0.00 AND 100.00),
  CONSTRAINT `chk_readiness_overall` CHECK (`overall_score` BETWEEN 0.00 AND 100.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 2. DOMAIN: CORPORATE & CAMPUS RECRUITMENT LIFECYCLE
-- =============================================================================

-- Table 5: companies (Corporate partners directory)
CREATE TABLE `companies` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(150) NOT NULL,
  `website` VARCHAR(255) DEFAULT NULL,
  `industry` VARCHAR(100) DEFAULT NULL,
  `tier` VARCHAR(20) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_company_name` (`company_name`),
  CONSTRAINT `chk_company_tier` CHECK (`tier` IN ('TIER_1', 'TIER_2', 'TIER_3', 'STARTUP', 'PRODUCT', 'SERVICE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 6: placement_drives (Campus recruitment drives)
CREATE TABLE `placement_drives` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` BIGINT UNSIGNED NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `job_role` VARCHAR(150) NOT NULL,
  `package_lpa` DECIMAL(6,2) DEFAULT NULL,
  `drive_type` VARCHAR(30) NOT NULL,
  `location` VARCHAR(150) DEFAULT NULL,
  `min_cgpa_criteria` DECIMAL(4,2) NOT NULL DEFAULT 0.00,
  `status` VARCHAR(30) NOT NULL DEFAULT 'UPCOMING',
  `drive_date` DATETIME NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_drive_company` (`company_id`),
  CONSTRAINT `fk_drive_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `chk_drive_type` CHECK (`drive_type` IN ('ON_CAMPUS', 'OFF_CAMPUS', 'POOL_CAMPUS', 'VIRTUAL')),
  CONSTRAINT `chk_drive_status` CHECK (`status` IN ('UPCOMING', 'ACTIVE', 'COMPLETED', 'CANCELLED')),
  CONSTRAINT `chk_drive_min_cgpa` CHECK (`min_cgpa_criteria` BETWEEN 0.00 AND 10.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 7: drive_eligible_departments (Branch eligibility per drive)
CREATE TABLE `drive_eligible_departments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drive_id` BIGINT UNSIGNED NOT NULL,
  `department` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_drive_department` (`drive_id`, `department`),
  CONSTRAINT `fk_eligible_drive` FOREIGN KEY (`drive_id`) REFERENCES `placement_drives` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 8: drive_applications (Student job applications with composite uniqueness)
CREATE TABLE `drive_applications` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `drive_id` BIGINT UNSIGNED NOT NULL,
  `application_status` VARCHAR(30) NOT NULL DEFAULT 'APPLIED',
  `applied_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_student_drive` (`student_id`, `drive_id`),
  KEY `idx_application_drive` (`drive_id`),
  CONSTRAINT `fk_application_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_application_drive` FOREIGN KEY (`drive_id`) REFERENCES `placement_drives` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `chk_application_status` CHECK (`application_status` IN ('APPLIED', 'SHORTLISTED', 'ASSESSMENT_PENDING', 'INTERVIEW_SCHEDULED', 'OFFERED', 'REJECTED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 3. DOMAIN: CODING JUDGE SANDBOX ENGINE
-- =============================================================================

-- Table 9: problems (Coding problem repository)
CREATE TABLE `problems` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `slug` VARCHAR(200) NOT NULL,
  `description` LONGTEXT NOT NULL,
  `difficulty` VARCHAR(20) NOT NULL,
  `category` VARCHAR(100) NOT NULL,
  `time_limit_ms` INT UNSIGNED NOT NULL DEFAULT 1000,
  `memory_limit_mb` INT UNSIGNED NOT NULL DEFAULT 256,
  `acceptance_rate` DECIMAL(5,2) DEFAULT 0.00,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_problem_slug` (`slug`),
  CONSTRAINT `chk_problem_difficulty` CHECK (`difficulty` IN ('EASY', 'MEDIUM', 'HARD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 10: test_cases (Sample and hidden test suites)
CREATE TABLE `test_cases` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `problem_id` BIGINT UNSIGNED NOT NULL,
  `input_data` LONGTEXT NOT NULL,
  `expected_output` LONGTEXT NOT NULL,
  `is_sample` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_testcase_problem` (`problem_id`),
  CONSTRAINT `fk_testcase_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 11: submissions (Student automated execution submissions)
CREATE TABLE `submissions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `problem_id` BIGINT UNSIGNED NOT NULL,
  `source_code` LONGTEXT NOT NULL,
  `language` VARCHAR(30) NOT NULL,
  `status` VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  `verdict` VARCHAR(40) DEFAULT NULL,
  `execution_time_ms` INT UNSIGNED DEFAULT NULL,
  `memory_used_kb` INT UNSIGNED DEFAULT NULL,
  `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_submission_student` (`student_id`),
  KEY `idx_submission_problem` (`problem_id`),
  CONSTRAINT `fk_submission_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_submission_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `chk_submission_status` CHECK (`status` IN ('PENDING', 'RUNNING', 'COMPLETED')),
  CONSTRAINT `chk_submission_verdict` CHECK (`verdict` IN ('ACCEPTED', 'WRONG_ANSWER', 'TIME_LIMIT_EXCEEDED', 'MEMORY_LIMIT_EXCEEDED', 'RUNTIME_ERROR', 'COMPILATION_ERROR'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 4. DOMAIN: COMPANY PREPARATION TRACKS & QUESTION BANK
-- =============================================================================

-- Table 12: company_tracks (Company-specific curricula e.g., Amazon, Google, TCS)
CREATE TABLE `company_tracks` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_id` BIGINT UNSIGNED NOT NULL,
  `track_name` VARCHAR(150) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_company_track` (`company_id`, `track_name`),
  CONSTRAINT `fk_track_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 13: company_track_rounds (Hiring rounds within track: OA, Technical, HR)
CREATE TABLE `company_track_rounds` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `track_id` BIGINT UNSIGNED NOT NULL,
  `round_number` INT UNSIGNED NOT NULL,
  `round_name` VARCHAR(100) NOT NULL,
  `round_type` VARCHAR(50) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_track_round` (`track_id`, `round_number`),
  CONSTRAINT `fk_round_track` FOREIGN KEY (`track_id`) REFERENCES `company_tracks` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 14: company_track_topics (Syllabus topics per round)
CREATE TABLE `company_track_topics` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `round_id` BIGINT UNSIGNED NOT NULL,
  `topic_name` VARCHAR(150) NOT NULL,
  `resource_url` VARCHAR(255) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_round_topic` (`round_id`, `topic_name`),
  CONSTRAINT `fk_topic_round` FOREIGN KEY (`round_id`) REFERENCES `company_track_rounds` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 15: interview_questions (Curated interview question repository)
CREATE TABLE `interview_questions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `round_id` BIGINT UNSIGNED NOT NULL,
  `question_text` TEXT NOT NULL,
  `question_type` VARCHAR(50) NOT NULL,
  `difficulty` VARCHAR(20) NOT NULL,
  `sample_answer` LONGTEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_question_round` (`round_id`),
  CONSTRAINT `fk_question_round` FOREIGN KEY (`round_id`) REFERENCES `company_track_rounds` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `chk_question_difficulty` CHECK (`difficulty` IN ('EASY', 'MEDIUM', 'HARD')),
  CONSTRAINT `chk_question_type` CHECK (`question_type` IN ('CODING', 'CONCEPTUAL', 'BEHAVIORAL', 'SYSTEM_DESIGN', 'HR'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 5. DOMAIN: QUIZ ENGINE, MOCK INTERVIEWS & FACULTY GOVERNANCE
-- =============================================================================

-- Table 16: quiz_questions (MCQ item bank for Aptitude & Core CS)
CREATE TABLE `quiz_questions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category` VARCHAR(100) NOT NULL,
  `sub_category` VARCHAR(100) DEFAULT NULL,
  `question_text` TEXT NOT NULL,
  `option_a` VARCHAR(255) NOT NULL,
  `option_b` VARCHAR(255) NOT NULL,
  `option_c` VARCHAR(255) NOT NULL,
  `option_d` VARCHAR(255) NOT NULL,
  `correct_option` CHAR(1) NOT NULL,
  `difficulty` VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
  `explanation` TEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `chk_quiz_correct_option` CHECK (`correct_option` IN ('A', 'B', 'C', 'D')),
  CONSTRAINT `chk_quiz_difficulty` CHECK (`difficulty` IN ('EASY', 'MEDIUM', 'HARD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 17: quiz_attempts (Timed quiz assessment session)
CREATE TABLE `quiz_attempts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `category` VARCHAR(100) NOT NULL,
  `score` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  `total_questions` INT UNSIGNED NOT NULL,
  `is_passed` BOOLEAN NOT NULL DEFAULT FALSE,
  `started_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_quiz_attempt_student` (`student_id`),
  CONSTRAINT `fk_quiz_attempt_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 18: quiz_attempt_answers (Single response per question in an attempt)
CREATE TABLE `quiz_attempt_answers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_id` BIGINT UNSIGNED NOT NULL,
  `question_id` BIGINT UNSIGNED NOT NULL,
  `selected_option` CHAR(1) NOT NULL,
  `is_correct` BOOLEAN NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_attempt_question` (`attempt_id`, `question_id`),
  KEY `idx_answer_question` (`question_id`),
  CONSTRAINT `fk_answer_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `quiz_attempts` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_answer_question` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `chk_answer_selected_option` CHECK (`selected_option` IN ('A', 'B', 'C', 'D'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 19: mentorship_notes (Faculty mentor 1:1 counseling records)
CREATE TABLE `mentorship_notes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `mentor_id` BIGINT UNSIGNED NOT NULL,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `notes` TEXT NOT NULL,
  `action_items` TEXT DEFAULT NULL,
  `meeting_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_note_mentor` (`mentor_id`),
  KEY `idx_note_student` (`student_id`),
  CONSTRAINT `fk_note_mentor` FOREIGN KEY (`mentor_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_note_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 20: resume_evaluations (ATS and rubric resume scoring)
CREATE TABLE `resume_evaluations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `evaluated_by` BIGINT UNSIGNED DEFAULT NULL,
  `resume_file_url` VARCHAR(255) DEFAULT NULL,
  `ats_score` DECIMAL(5,2) NOT NULL,
  `feedback` TEXT NOT NULL,
  `suggestions` TEXT DEFAULT NULL,
  `evaluated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_resume_student` (`student_id`),
  KEY `idx_resume_evaluator` (`evaluated_by`),
  CONSTRAINT `fk_resume_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_resume_evaluator` FOREIGN KEY (`evaluated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `chk_resume_ats_score` CHECK (`ats_score` BETWEEN 0.00 AND 100.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 21: student_badges (Achievement gamification awards)
CREATE TABLE `student_badges` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `badge_name` VARCHAR(100) NOT NULL,
  `badge_description` VARCHAR(255) DEFAULT NULL,
  `badge_icon_url` VARCHAR(255) DEFAULT NULL,
  `awarded_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_student_badge` (`student_id`, `badge_name`),
  CONSTRAINT `fk_badge_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 22: audit_logs (Immutable activity trail with SET NULL protection)
CREATE TABLE `audit_logs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED DEFAULT NULL,
  `action` VARCHAR(100) NOT NULL,
  `entity_name` VARCHAR(100) NOT NULL,
  `entity_id` BIGINT UNSIGNED DEFAULT NULL,
  `details` TEXT DEFAULT NULL,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_user` (`user_id`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 23: mock_interview_sessions (Session lifecycle for AI / Peer / Faculty mocks)
CREATE TABLE `mock_interview_sessions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` BIGINT UNSIGNED NOT NULL,
  `interview_type` VARCHAR(50) NOT NULL,
  `status` VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED',
  `scheduled_at` DATETIME NOT NULL,
  `started_at` DATETIME DEFAULT NULL,
  `completed_at` DATETIME DEFAULT NULL,
  `overall_score` DECIMAL(5,2) DEFAULT NULL,
  `strengths` TEXT DEFAULT NULL,
  `areas_to_improve` TEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_interview_session_student` (`student_id`),
  CONSTRAINT `fk_interview_session_student` FOREIGN KEY (`student_id`) REFERENCES `student_profiles` (`user_id`) ON DELETE RESTRICT ON UPDATE NO ACTION,
  CONSTRAINT `chk_mock_type` CHECK (`interview_type` IN ('AI_MOCK', 'PEER_MOCK', 'FACULTY_MOCK')),
  CONSTRAINT `chk_mock_status` CHECK (`status` IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
  CONSTRAINT `chk_mock_score` CHECK (`overall_score` IS NULL OR `overall_score` BETWEEN 0.00 AND 100.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table 24: mock_interview_answers (Responses and rubric evaluations per question)
CREATE TABLE `mock_interview_answers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_id` BIGINT UNSIGNED NOT NULL,
  `question_id` BIGINT UNSIGNED NOT NULL,
  `recorded_answer` LONGTEXT NOT NULL,
  `score` DECIMAL(5,2) DEFAULT NULL,
  `feedback` TEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_interview_session_question` (`session_id`, `question_id`),
  KEY `idx_interview_answer_question` (`question_id`),
  CONSTRAINT `fk_interview_answer_session` FOREIGN KEY (`session_id`) REFERENCES `mock_interview_sessions` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_interview_answer_question` FOREIGN KEY (`question_id`) REFERENCES `interview_questions` (`id`) ON DELETE RESTRICT ON UPDATE NO ACTION,
  CONSTRAINT `chk_mock_answer_score` CHECK (`score` IS NULL OR `score` BETWEEN 0.00 AND 100.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- END OF SCHEMA DDL
-- =============================================================================

