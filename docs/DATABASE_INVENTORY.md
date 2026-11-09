# DATABASE_INVENTORY.md — MySQL Database Schema Inventory

> **Database Engine:** MySQL 8.0.45  
> **Database Name:** `placementdb`  
> **Character Set:** `utf8mb4`  
> **Collation:** `utf8mb4_unicode_ci`  
> **Total Tables:** 24  
> **Total Columns:** 185  
> **Verification Timestamp:** 2026-11-06  
> **Status:** Verified Source of Truth

---

## Table Summary & Column Count

| # | Table Name | Column Count | Primary Key | Description |
|---|---|:---:|---|---|
| 1 | `users` | 7 | `id` (BIGINT UNSIGNED) | Core user identities (Students, Mentors, TPOs) |
| 2 | `student_profiles` | 7 | `user_id` (BIGINT UNSIGNED) | Extended academic profile data linked 1:1 to users |
| 3 | `readiness_scores` | 7 | `id` (BIGINT UNSIGNED) | Readiness evaluation metrics (coding, aptitude, communication, overall) |
| 4 | `companies` | 7 | `id` (BIGINT UNSIGNED) | Corporate hiring partners catalog |
| 5 | `placement_drives` | 11 | `id` (BIGINT UNSIGNED) | Campus recruitment drive listings |
| 6 | `drive_eligible_departments` | 3 | `id` (BIGINT UNSIGNED) | Eligible department branches mapped to placement drives |
| 7 | `drive_applications` | 6 | `id` (BIGINT UNSIGNED) | Student applications to specific recruitment drives |
| 8 | `problems` | 11 | `id` (BIGINT UNSIGNED) | Coding sandbox problem catalog |
| 9 | `test_cases` | 6 | `id` (BIGINT UNSIGNED) | Unit test cases (sample & hidden) for coding problems |
| 10 | `submissions` | 10 | `id` (BIGINT UNSIGNED) | Student code submissions & automated judge evaluation |
| 11 | `company_tracks` | 7 | `id` (BIGINT UNSIGNED) | Company-specific preparation tracks |
| 12 | `company_track_rounds` | 6 | `id` (BIGINT UNSIGNED) | Hiring rounds within preparation tracks |
| 13 | `company_track_topics` | 5 | `id` (BIGINT UNSIGNED) | Syllabus topics mapped to interview rounds |
| 14 | `interview_questions` | 7 | `id` (BIGINT UNSIGNED) | Curated interview questions per track round |
| 15 | `quiz_questions` | 12 | `id` (BIGINT UNSIGNED) | MCQs for aptitude and core CS assessments |
| 16 | `quiz_attempts` | 8 | `id` (BIGINT UNSIGNED) | Timed quiz attempt sessions by students |
| 17 | `quiz_attempt_answers` | 7 | `id` (BIGINT UNSIGNED) | Individual question responses for quiz attempts |
| 18 | `mentorship_notes` | 8 | `id` (BIGINT UNSIGNED) | Faculty mentor 1:1 counseling notes for students |
| 19 | `resume_evaluations` | 9 | `id` (BIGINT UNSIGNED) | ATS & rubric resume assessment evaluations |
| 20 | `student_badges` | 6 | `id` (BIGINT UNSIGNED) | Verified achievement badges awarded to students |
| 21 | `audit_logs` | 8 | `id` (BIGINT UNSIGNED) | Immutable administrative activity audit trail |
| 22 | `mock_interview_sessions` | 12 | `id` (BIGINT UNSIGNED) | Multi-question mock interview session lifecycle |
| 23 | `mock_interview_answers` | 9 | `id` (BIGINT UNSIGNED) | Question snapshots, answers, and rubric evaluations |
| 24 | `password_reset_tokens` | 6 | `id` (BIGINT UNSIGNED) | Persistent password recovery tokens with SHA-256 hashes |
| **Total** | **24 Tables** | **185** | — | — |

---

## Detailed Table Inventories

### 1. `users`
Core user identity and role assignment for platform authentication.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `name` | `varchar(150)` | NO | *NULL* | | | Full name of the user |
| 3 | `email` | `varchar(255)` | NO | *NULL* | UNI | | Unique email address (login credential) |
| 4 | `password_hash` | `varchar(255)` | NO | *NULL* | | | Hashed password |
| 5 | `role` | `varchar(20)` | NO | *NULL* | | | Role (`STUDENT`, `MENTOR`, `TPO`) |
| 6 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |
| 7 | `updated_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | on update CURRENT_TIMESTAMP | Last record modification timestamp |

---

### 2. `student_profiles`
Academic credentials and student metadata. Primary key is shared 1:1 with `users(id)`.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `user_id` | `bigint unsigned` | NO | *NULL* | PRI | | Primary key & FK referencing `users(id)` |
| 2 | `roll_number` | `varchar(30)` | NO | *NULL* | UNI | | Institutional roll / registration number |
| 3 | `phone` | `varchar(15)` | YES | *NULL* | | | Primary contact number |
| 4 | `department` | `varchar(100)` | NO | *NULL* | | | Academic branch (e.g. `CSE`, `IT`, `ECE`) |
| 5 | `current_year` | `tinyint unsigned` | YES | *NULL* | | | Current academic year (1 to 4) |
| 6 | `graduation_year` | `year` | NO | *NULL* | | | Expected graduation year (e.g. 2026) |
| 7 | `cgpa` | `decimal(4,2)` | YES | *NULL* | | | Cumulative Grade Point Average (0.00 - 10.00) |

---

### 3. `readiness_scores`
Composite and category readiness metrics for students.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` |
| 3 | `coding_score` | `decimal(5,2)` | NO | *NULL* | | | Coding assessment score [0.00, 100.00] |
| 4 | `aptitude_score` | `decimal(5,2)` | NO | *NULL* | | | Aptitude assessment score [0.00, 100.00] |
| 5 | `communication_score`| `decimal(5,2)` | NO | *NULL* | | | Communication score [0.00, 100.00] |
| 6 | `overall_score` | `decimal(5,2)` | NO | *NULL* | | | Composite weighted score [0.00, 100.00] |
| 7 | `assessed_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Assessment date/time |

---

### 4. `companies`
Registered recruiting organizations.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `company_name` | `varchar(150)` | NO | *NULL* | UNI | | Unique company corporate name |
| 3 | `website` | `varchar(255)` | YES | *NULL* | | | Official website URL |
| 4 | `industry` | `varchar(100)` | YES | *NULL* | | | Industry sector (e.g. Product, IT Services) |
| 5 | `location` | `varchar(150)` | YES | *NULL* | | | Corporate headquarters / location |
| 6 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |
| 7 | `updated_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | on update CURRENT_TIMESTAMP | Last record modification timestamp |

---

### 5. `placement_drives`
Recruitment drives organized by the Training and Placement Cell.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `company_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `companies(id)` |
| 3 | `job_title` | `varchar(150)` | NO | *NULL* | | | Position title (e.g. `Software Engineer`) |
| 4 | `job_description` | `text` | YES | *NULL* | | | Detailed job role description |
| 5 | `job_location` | `varchar(150)` | YES | *NULL* | | | Job location / Work model |
| 6 | `employment_type` | `varchar(30)` | NO | *NULL* | | | `FULL_TIME`, `INTERNSHIP`, `CONTRACT` |
| 7 | `package_lpa` | `decimal(8,2)` | YES | *NULL* | | | Annual CTC compensation in Lakhs Per Annum |
| 8 | `application_deadline` | `datetime` | NO | *NULL* | | | Last date to submit applications |
| 9 | `drive_date` | `datetime` | YES | *NULL* | | | Date recruitment drive takes place |
| 10 | `status` | `varchar(20)` | NO | `'OPEN'` | | | Status (`OPEN`, `CLOSED`, `CANCELLED`) |
| 11 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |

---

### 6. `drive_eligible_departments`
Academic departments eligible to participate in specific recruitment drives.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `drive_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `placement_drives(id)` |
| 3 | `department` | `varchar(100)` | NO | *NULL* | | | Department name (e.g. `CSE`, `IT`, `ECE`) |

---

### 7. `drive_applications`
Student application tracking for campus drives.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` |
| 3 | `drive_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `placement_drives(id)` |
| 4 | `status` | `varchar(30)` | NO | `'APPLIED'` | | | Application status (see constraints) |
| 5 | `applied_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Initial application timestamp |
| 6 | `updated_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | on update CURRENT_TIMESTAMP | Last status transition timestamp |

---

### 8. `problems`
Algorithmic programming catalog for the online coding judge.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `title` | `varchar(200)` | NO | *NULL* | | | Problem headline title |
| 3 | `description` | `text` | NO | *NULL* | | | Full markdown/HTML problem description |
| 4 | `difficulty` | `varchar(20)` | NO | *NULL* | | | Difficulty tier (`EASY`, `MEDIUM`, `HARD`) |
| 5 | `topic` | `varchar(100)` | NO | *NULL* | | | Algorithmic topic (e.g. `Arrays`, `DP`) |
| 6 | `constraints` | `text` | YES | *NULL* | | | Time, memory, and input range constraints |
| 7 | `input_format` | `text` | YES | *NULL* | | | Input specification |
| 8 | `output_format` | `text` | YES | *NULL* | | | Expected output specification |
| 9 | `sample_input` | `text` | YES | *NULL* | | | Visible sample test input |
| 10 | `sample_output` | `text` | YES | *NULL* | | | Visible sample test output |
| 11 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |

---

### 9. `test_cases`
Test suite verification cases for automated judge evaluation.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `problem_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `problems(id)` |
| 3 | `input_data` | `text` | NO | *NULL* | | | Input string supplied via STDIN |
| 4 | `expected_output`| `text` | NO | *NULL* | | | Expected matching output |
| 5 | `is_hidden` | `tinyint(1)` | NO | `'1'` | | | Hidden test case flag (1: hidden, 0: sample) |
| 6 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |

---

### 10. `submissions`
Code submission attempts and execution judge metrics.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` |
| 3 | `problem_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `problems(id)` |
| 4 | `language` | `varchar(30)` | NO | *NULL* | | | Programming language (`java`, `python`, `cpp`) |
| 5 | `source_code` | `longtext` | NO | *NULL* | | | Full source code submitted |
| 6 | `status` | `varchar(30)` | NO | `'PENDING'` | | | Verdict status (e.g. `ACCEPTED`) |
| 7 | `score` | `decimal(5,2)` | NO | `'0.00'` | | | Scored points [0.00, 100.00] |
| 8 | `execution_time_ms`| `int unsigned` | YES | *NULL* | | | Runtime duration in milliseconds |
| 9 | `memory_used_kb` | `int unsigned` | YES | *NULL* | | | Peak RAM consumed in kilobytes |
| 10 | `submitted_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Submission timestamp |

---

### 11. `company_tracks`
Curated technical preparation tracks for target companies.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `company_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `companies(id)` |
| 3 | `track_name` | `varchar(150)` | NO | *NULL* | | | Preparation track name |
| 4 | `description` | `text` | YES | *NULL* | | | Detailed syllabus and track overview |
| 5 | `duration_days` | `int unsigned` | YES | *NULL* | | | Recommended completion timeframe |
| 6 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |
| 7 | `updated_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | on update CURRENT_TIMESTAMP | Last record modification timestamp |

---

### 12. `company_track_rounds`
Interview rounds defined within a preparation track.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `track_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `company_tracks(id)` |
| 3 | `round_number` | `int unsigned` | NO | *NULL* | | | Sequential round order index (1, 2, ...) |
| 4 | `round_name` | `varchar(150)` | NO | *NULL* | | | Round title (e.g. `Online Assessment`) |
| 5 | `description` | `text` | YES | *NULL* | | | Evaluation criteria and format overview |
| 6 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |

---

### 13. `company_track_topics`
Syllabus topics within an interview round.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `round_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `company_track_rounds(id)` |
| 3 | `topic_name` | `varchar(150)` | NO | *NULL* | | | Topic title (e.g. `Graph Algorithms`) |
| 4 | `description` | `text` | YES | *NULL* | | | Topic study guide details |
| 5 | `is_mandatory` | `tinyint(1)` | NO | `'1'` | | | Mandatory topic flag (1: yes, 0: optional) |

---

### 14. `interview_questions`
Curated interview question bank mapped to track rounds.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `round_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `company_track_rounds(id)` |
| 3 | `question` | `text` | NO | *NULL* | | | Question text |
| 4 | `answer` | `text` | YES | *NULL* | | | Model answer / reference solution |
| 5 | `difficulty` | `varchar(20)` | NO | `'MEDIUM'` | | | Difficulty (`EASY`, `MEDIUM`, `HARD`) |
| 6 | `question_type` | `varchar(30)` | NO | `'TECHNICAL'` | | | `TECHNICAL`, `CODING`, `HR`, `BEHAVIORAL` |
| 7 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |

---

### 15. `quiz_questions`
Multiple-choice questions for Aptitude and Core Computer Science quizzes.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `question` | `text` | NO | *NULL* | | | Question statement |
| 3 | `option_a` | `text` | NO | *NULL* | | | Multiple choice option A |
| 4 | `option_b` | `text` | NO | *NULL* | | | Multiple choice option B |
| 5 | `option_c` | `text` | NO | *NULL* | | | Multiple choice option C |
| 6 | `option_d` | `text` | NO | *NULL* | | | Multiple choice option D |
| 7 | `correct_answer` | `char(1)` | NO | *NULL* | | | Single letter key: `'A'`, `'B'`, `'C'`, or `'D'` |
| 8 | `explanation` | `text` | YES | *NULL* | | | Detailed explanatory solution |
| 9 | `category` | `varchar(100)` | NO | *NULL* | | | Assessment category (e.g. `OS`, `DBMS`) |
| 10 | `difficulty` | `varchar(20)` | NO | `'MEDIUM'` | | | Difficulty (`EASY`, `MEDIUM`, `HARD`) |
| 11 | `marks` | `decimal(5,2)` | NO | `'1.00'` | | | Positive score awarded for correct answer |
| 12 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |

---

### 16. `quiz_attempts`
Timed quiz attempt sessions initiated by students.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` |
| 3 | `total_questions`| `int unsigned` | NO | *NULL* | | | Total number of questions in quiz |
| 4 | `attempted_questions`| `int unsigned`| NO | `'0'` | | | Questions attempted by candidate |
| 5 | `score` | `decimal(8,2)` | NO | `'0.00'` | | | Total marks achieved in attempt |
| 6 | `status` | `varchar(20)` | NO | `'IN_PROGRESS'`| | | `IN_PROGRESS`, `COMPLETED`, `ABANDONED` |
| 7 | `started_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Attempt initiation timestamp |
| 8 | `completed_at` | `datetime` | YES | *NULL* | | | Completion or submission timestamp |

---

### 17. `quiz_attempt_answers`
Individual question responses recorded during a quiz attempt.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `attempt_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `quiz_attempts(id)` |
| 3 | `question_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `quiz_questions(id)` |
| 4 | `selected_answer`| `char(1)` | YES | *NULL* | | | Candidate choice (`A`, `B`, `C`, `D`, or NULL) |
| 5 | `is_correct` | `tinyint(1)` | NO | `'0'` | | | Evaluation flag (1: correct, 0: wrong) |
| 6 | `marks_awarded` | `decimal(5,2)` | NO | `'0.00'` | | | Marks awarded for this question |
| 7 | `answered_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Answer submission timestamp |

---

### 18. `mentorship_notes`
Faculty mentorship notes recorded during 1:1 student guidance sessions.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `mentor_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `users(id)` |
| 3 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` |
| 4 | `note_title` | `varchar(150)` | NO | *NULL* | | | Note summary heading |
| 5 | `note_content` | `text` | NO | *NULL* | | | Guidance comments & advice body |
| 6 | `note_type` | `varchar(30)` | NO | `'GENERAL'` | | | Category (e.g. `DSA`, `RESUME`, `CAREER`) |
| 7 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Record creation timestamp |
| 8 | `updated_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | on update CURRENT_TIMESTAMP | Last record modification timestamp |

---

### 19. `resume_evaluations`
ATS and faculty rubrics evaluations for student resumes.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` |
| 3 | `evaluated_by` | `bigint unsigned` | YES | *NULL* | MUL | | FK referencing `users(id)` (NULL if ATS) |
| 4 | `resume_file_url`| `varchar(500)` | NO | *NULL* | | | Path or URL to uploaded PDF/DOCX resume |
| 5 | `overall_score` | `decimal(5,2)` | YES | *NULL* | | | Evaluation score [0.00, 100.00] |
| 6 | `strengths` | `text` | YES | *NULL* | | | Identified resume strengths |
| 7 | `weaknesses` | `text` | YES | *NULL* | | | Identified resume gaps & missing skills |
| 8 | `suggestions` | `text` | YES | *NULL* | | | Actionable improvement recommendations |
| 9 | `evaluated_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Evaluation timestamp |

---

### 20. `student_badges`
Gamification achievement badges earned by students.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` |
| 3 | `badge_name` | `varchar(150)` | NO | *NULL* | | | Title (e.g. `100 Problems Solved`) |
| 4 | `badge_description`| `text` | YES | *NULL* | | | Criterion required to earn the badge |
| 5 | `badge_category` | `varchar(50)` | NO | *NULL* | | | Category (e.g. `CODING`, `STREAK`) |
| 6 | `earned_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Award timestamp |

---

### 21. `audit_logs`
Immutable administrative audit log for critical system events.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `user_id` | `bigint unsigned` | YES | *NULL* | MUL | | FK referencing `users(id)` (SET NULL on delete) |
| 3 | `action` | `varchar(100)` | NO | *NULL* | | | Action verb (e.g. `DRIVE_CREATED`, `EXPORT_CSV`) |
| 4 | `entity_name` | `varchar(100)` | NO | *NULL* | | | Target entity (e.g. `PlacementDrive`, `User`) |
| 5 | `entity_id` | `bigint unsigned` | YES | *NULL* | | | ID of target entity record |
| 6 | `details` | `json` | YES | *NULL* | | | Contextual audit payload in JSON format |
| 7 | `ip_address` | `varchar(45)` | YES | *NULL* | | | Request client IPv4 / IPv6 address |
| 8 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Event timestamp |

---

### 22. `mock_interview_sessions`
Structured multi-question mock interview attempt sessions by students.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `student_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `student_profiles(user_id)` (RESTRICT on delete) |
| 3 | `interview_type` | `varchar(50)` | NO | `'TECHNICAL'` | | | Session category (`TECHNICAL`, `HR`, `BEHAVIORAL`, `ALL`) |
| 4 | `total_questions` | `int unsigned` | NO | `0` | | | Total assigned questions in session |
| 5 | `answered_questions` | `int unsigned` | NO | `0` | | | Total answered questions submitted |
| 6 | `total_score` | `decimal(6,2)` | NO | `0.00` | | | Sum of individual question scores |
| 7 | `max_score` | `decimal(6,2)` | NO | `100.00` | | | Maximum possible score (`total_questions * 100`) |
| 8 | `percentage` | `decimal(5,2)` | NO | `0.00` | | | Session percentage score (`(total_score / max_score) * 100`) |
| 9 | `status` | `varchar(20)` | NO | `'IN_PROGRESS'` | | | Session status (`IN_PROGRESS`, `COMPLETED`, `ABANDONED`) |
| 10 | `evaluation_summary` | `text` | YES | *NULL* | | | Comprehensive evaluation summary text |
| 11 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Session creation timestamp |
| 12 | `completed_at` | `datetime` | YES | *NULL* | | | Session completion timestamp |

---

### 23. `mock_interview_answers`
Frozen question snapshots, student responses, and rubric evaluations for mock interview sessions.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `session_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `mock_interview_sessions(id)` (CASCADE on delete) |
| 3 | `question_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `interview_questions(id)` (RESTRICT on delete) |
| 4 | `question_snapshot` | `text` | NO | *NULL* | | | Immutable frozen snapshot of question text at session start |
| 5 | `student_answer` | `text` | NO | *NULL* | | | Submitted student typed response |
| 6 | `score` | `decimal(5,2)` | NO | `0.00` | | | Rubric score out of 100 (STAR + depth + self-rating) |
| 7 | `max_score` | `decimal(5,2)` | NO | `100.00` | | | Maximum marks per question (100.00) |
| 8 | `evaluation_feedback` | `text` | YES | *NULL* | | | Specific actionable feedback generated by rubric |
| 9 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Answer creation timestamp |

---

### 24. `password_reset_tokens`
Persistent storage of high-entropy password recovery tokens with SHA-256 hashes, expiration, and single-use tracking.

| Ordinal | Column Name | Data Type | Nullable | Default | Key | Extra | Description |
|:---:|---|---|:---:|---|:---:|---|---|
| 1 | `id` | `bigint unsigned` | NO | *NULL* | PRI | auto_increment | Primary key |
| 2 | `user_id` | `bigint unsigned` | NO | *NULL* | MUL | | FK referencing `users(id)` (CASCADE on delete) |
| 3 | `token_hash` | `varchar(64)` | NO | *NULL* | UNI | | SHA-256 digest of 256-bit cryptographically secure raw token |
| 4 | `expiry_time` | `datetime` | NO | *NULL* | MUL | | Token expiration timestamp (15-minute validity window) |
| 5 | `used` | `tinyint(1)` | NO | `0` | | | Single-use flag (`0` = active, `1` = consumed) |
| 6 | `created_at` | `datetime` | NO | `CURRENT_TIMESTAMP` | | | Token generation timestamp |




