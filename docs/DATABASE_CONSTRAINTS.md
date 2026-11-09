# DATABASE_CONSTRAINTS.md — MySQL Database Constraints Reference

> **Database Engine:** MySQL 8.0.45  
> **Database Name:** `placementdb`  
> **Total Primary Keys:** 24  
> **Total Unique Constraints:** 12  
> **Total Check Constraints:** 28  
> **Verification Status:** Verified Source of Truth

---

## 1. Primary Keys

All 24 tables define an explicit primary key constraint:

| # | Table Name | Constraint Name | Key Column(s) | Key Strategy | Notes |
|:---:|---|---|---|---|---|
| 1 | `users` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 2 | `student_profiles` | `PRIMARY` | `user_id` | **Manual Assignment** | Shared 1:1 primary key with `users(id)` |
| 3 | `readiness_scores` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 4 | `companies` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 5 | `placement_drives` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 6 | `drive_eligible_departments` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 7 | `drive_applications` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 8 | `problems` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 9 | `test_cases` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 10 | `submissions` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 11 | `company_tracks` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 12 | `company_track_rounds` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 13 | `company_track_topics` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 14 | `interview_questions` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 15 | `quiz_questions` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 16 | `quiz_attempts` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 17 | `quiz_attempt_answers` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 18 | `mentorship_notes` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 19 | `resume_evaluations` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 20 | `student_badges` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 21 | `audit_logs` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 22 | `mock_interview_sessions` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 23 | `mock_interview_answers` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |
| 24 | `password_reset_tokens` | `PRIMARY` | `id` | `AUTO_INCREMENT` | Surrogate numeric key |

> **Critical JPA Implication:** In `StudentProfile`, the primary key is `user_id` and must be mapped with `@Id @Column(name = "user_id")` and `@OneToOne @MapsId`, NOT `@GeneratedValue(strategy = GenerationType.IDENTITY)`.

---

## 2. Unique Constraints

10 unique constraints enforce business rules across single and composite keys:

| # | Table Name | Constraint Name | Column(s) Covered | Purpose / Business Rule |
|:---:|---|---|---|---|
| 1 | `users` | `email` | `email` | Prevent duplicate accounts; email is the unique login identifier |
| 2 | `student_profiles` | `roll_number` | `roll_number` | Prevent duplicate roll numbers across the institution |
| 3 | `companies` | `company_name` | `company_name` | Corporate names must be distinct |
| 4 | `company_tracks` | `uq_company_track` | `company_id`, `track_name` | A company cannot have two tracks with the exact same name |
| 5 | `company_track_rounds`| `uq_track_round` | `track_id`, `round_number` | Round numbers within a company track must be unique |
| 6 | `company_track_topics`| `uq_round_topic` | `round_id`, `topic_name` | Topics within a track round must not duplicate |
| 7 | `drive_eligible_departments` | `uq_drive_department` | `drive_id`, `department` | A department cannot be attached more than once to a drive |
| 8 | `drive_applications` | `uq_student_drive` | `student_id`, `drive_id` | A student can only apply once to any given recruitment drive |
| 9 | `quiz_attempt_answers`| `uq_attempt_question` | `attempt_id`, `question_id` | An attempt can only contain one recorded answer per question |
| 10 | `student_badges` | `uq_student_badge` | `student_id`, `badge_name` | A student cannot be awarded the same achievement badge twice |
| 11 | `mock_interview_answers` | `uq_interview_session_question` | `session_id`, `question_id` | An interview session can only contain one recorded answer per question |
| 12 | `password_reset_tokens` | `uq_reset_token_hash` | `token_hash` | Cryptographic SHA-256 token hash must be globally unique |

---

## 3. Check Constraints

28 check constraints validate data ranges and accepted enumeration values at the database level:

| # | Table Name | Constraint Name | Check Clause Expression | Purpose |
|:---:|---|---|---|---|
| 1 | `users` | `users_chk_1` | ``(`role` in ('STUDENT','MENTOR','TPO'))`` | Enforces valid system user roles |
| 2 | `student_profiles` | `student_profiles_chk_1` | ``(`current_year` between 1 and 4)`` | Restricts academic year to 1st–4th year |
| 3 | `student_profiles` | `student_profiles_chk_2` | ``(`cgpa` between 0 and 10)`` | Enforces standard 10-point CGPA scale |
| 4 | `readiness_scores` | `readiness_scores_chk_1` | ``(`coding_score` between 0 and 100)`` | Percentage boundary [0.00, 100.00] |
| 5 | `readiness_scores` | `readiness_scores_chk_2` | ``(`aptitude_score` between 0 and 100)`` | Percentage boundary [0.00, 100.00] |
| 6 | `readiness_scores` | `readiness_scores_chk_3` | ``(`communication_score` between 0 and 100)`` | Percentage boundary [0.00, 100.00] |
| 7 | `readiness_scores` | `readiness_scores_chk_4` | ``(`overall_score` between 0 and 100)`` | Percentage boundary [0.00, 100.00] |
| 8 | `placement_drives` | `placement_drives_chk_1` | ``((`package_lpa` is null) or (`package_lpa` >= 0))`` | Salary package cannot be negative |
| 9 | `placement_drives` | `placement_drives_chk_2` | ``(`employment_type` in ('FULL_TIME','INTERNSHIP','CONTRACT'))`` | Valid employment classifications |
| 10 | `placement_drives` | `placement_drives_chk_3` | ``(`status` in ('OPEN','CLOSED','CANCELLED'))`` | Recruitment drive status lifecycle |
| 11 | `drive_applications`| `drive_applications_chk_1`| ``(`status` in ('APPLIED','UNDER_REVIEW','SHORTLISTED','REJECTED','SELECTED','WITHDRAWN'))`` | Application state machine values |
| 12 | `problems` | `problems_chk_1` | ``(`difficulty` in ('EASY','MEDIUM','HARD'))`` | Algorithmic difficulty classifications |
| 13 | `submissions` | `submissions_chk_1` | ``(`status` in ('PENDING','RUNNING','ACCEPTED','WRONG_ANSWER','COMPILATION_ERROR','RUNTIME_ERROR','TIME_LIMIT_EXCEEDED'))`` | Online judge verdict states |
| 14 | `submissions` | `submissions_chk_2` | ``(`score` between 0 and 100)`` | Problem score boundary [0.00, 100.00] |
| 15 | `interview_questions`| `interview_questions_chk_1`| ``(`difficulty` in ('EASY','MEDIUM','HARD'))`` | Interview difficulty classifications |
| 16 | `interview_questions`| `interview_questions_chk_2`| ``(`question_type` in ('TECHNICAL','CODING','HR','BEHAVIORAL'))`` | Interview question categories |
| 17 | `quiz_questions` | `quiz_questions_chk_1` | ``(`correct_answer` in ('A','B','C','D'))`` | MCQ answer key options |
| 18 | `quiz_questions` | `quiz_questions_chk_2` | ``(`difficulty` in ('EASY','MEDIUM','HARD'))`` | Quiz difficulty classifications |
| 19 | `quiz_questions` | `quiz_questions_chk_3` | ``(`marks` > 0)`` | Question weight must be positive |
| 20 | `quiz_attempts` | `quiz_attempts_chk_1` | ``(`status` in ('IN_PROGRESS','COMPLETED','ABANDONED'))`` | Attempt lifecycle states |
| 21 | `quiz_attempts` | `quiz_attempts_chk_2` | ``(`attempted_questions` <= `total_questions`)`` | Attempted count cannot exceed total |
| 22 | `quiz_attempts` | `quiz_attempts_chk_3` | ``(`score` >= 0)`` | Quiz score cannot be negative |
| 23 | `quiz_attempt_answers`| `quiz_attempt_answers_chk_1`| ``((`selected_answer` is null) or (`selected_answer` in ('A','B','C','D')))`` | Selected option key or skipped |
| 24 | `quiz_attempt_answers`| `quiz_attempt_answers_chk_2`| ``(`marks_awarded` >= 0)`` | Marks awarded cannot be negative |
| 25 | `mentorship_notes` | `mentorship_notes_chk_1` | ``(`note_type` in ('GENERAL','DSA','APTITUDE','RESUME','INTERVIEW','CAREER'))`` | Mentorship note categories |
| 26 | `resume_evaluations`| `resume_evaluations_chk_1`| ``((`overall_score` is null) or (`overall_score` between 0 and 100))`` | ATS score boundary [0.00, 100.00] |
| 27 | `mock_interview_sessions`| `mock_interview_sessions_chk_1`| ``(`status` in ('IN_PROGRESS','COMPLETED','ABANDONED'))`` | Mock interview session lifecycle |
| 28 | `mock_interview_sessions`| `mock_interview_sessions_chk_2`| ``(`percentage` between 0 and 100)`` | Percentage boundary [0.00, 100.00] |

---

## 4. Default Column Values & Non-Null Constraints

| Table Name | Column Name | Not Null | Default Value | Notes |
|---|---|:---:|---|---|
| `users` | `created_at` | YES | `CURRENT_TIMESTAMP` | Automatic record creation timestamp |
| `users` | `updated_at` | YES | `CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` | Automatic update timestamp |
| `companies` | `created_at` | YES | `CURRENT_TIMESTAMP` | Automatic record creation timestamp |
| `companies` | `updated_at` | YES | `CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` | Automatic update timestamp |
| `placement_drives` | `status` | YES | `'OPEN'` | New drives default to open |
| `placement_drives` | `created_at` | YES | `CURRENT_TIMESTAMP` | Automatic record creation timestamp |
| `drive_applications`| `status` | YES | `'APPLIED'` | New applications default to applied |
| `drive_applications`| `applied_at` | YES | `CURRENT_TIMESTAMP` | Automatic record creation timestamp |
| `drive_applications`| `updated_at` | YES | `CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` | Automatic update timestamp |
| `test_cases` | `is_hidden` | YES | `'1'` | Test cases are hidden by default |
| `submissions` | `status` | YES | `'PENDING'` | New submissions default to pending evaluation |
| `submissions` | `score` | YES | `'0.00'` | Initial score defaults to zero |
| `company_tracks` | `created_at` | YES | `CURRENT_TIMESTAMP` | Automatic record creation timestamp |
| `company_tracks` | `updated_at` | YES | `CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` | Automatic update timestamp |
| `company_track_topics`| `is_mandatory` | YES | `'1'` | Topics default to mandatory |
| `interview_questions`| `difficulty` | YES | `'MEDIUM'` | Default difficulty tier |
| `interview_questions`| `question_type`| YES | `'TECHNICAL'` | Default question classification |
| `quiz_questions` | `difficulty` | YES | `'MEDIUM'` | Default difficulty tier |
| `quiz_questions` | `marks` | YES | `'1.00'` | Default positive question weight |
| `quiz_attempts` | `attempted_questions`| YES | `'0'` | Initial counter defaults to 0 |
| `quiz_attempts` | `score` | YES | `'0.00'` | Initial attempt score defaults to 0.00 |
| `quiz_attempts` | `status` | YES | `'IN_PROGRESS'` | New quiz sessions default to in progress |
| `quiz_attempt_answers`| `is_correct` | YES | `'0'` | Default answer evaluation flag is false |
| `quiz_attempt_answers`| `marks_awarded`| YES | `'0.00'` | Default awarded score is 0.00 |
| `mentorship_notes` | `note_type` | YES | `'GENERAL'` | Default mentorship category |
| `student_badges` | `earned_at` | YES | `CURRENT_TIMESTAMP` | Automatic award timestamp |
| `audit_logs` | `created_at` | YES | `CURRENT_TIMESTAMP` | Automatic event audit timestamp |
| `password_reset_tokens` | `used` | YES | `'0'` | Default state is unconsumed |
| `password_reset_tokens` | `created_at` | YES | `CURRENT_TIMESTAMP` | Automatic token creation timestamp |


