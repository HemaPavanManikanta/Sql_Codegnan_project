-- =============================================================================
-- PLACEMENT PREPARATION PLATFORM — SAMPLE SEED DATA
-- Database: placementdb
-- Populates all 5 core domains with realistic testing and demonstration data
-- =============================================================================

USE `placementdb`;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. USERS (Password hashes are BCrypt strings for demo)
INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`) VALUES
(1, 'Admin TPO Head', 'tpo@mru.edu.in', '$2a$10$w85o3k9g1rTqZ3.gG9a2qu.80j.Ym7N4c1jW.b9sF1mO7K1fM2', 'TPO'),
(2, 'Dr. Ramesh Kumar (Mentor)', 'ramesh.cs@mru.edu.in', '$2a$10$w85o3k9g1rTqZ3.gG9a2qu.80j.Ym7N4c1jW.b9sF1mO7K1fM2', 'MENTOR'),
(3, 'Prof. Sunita Sharma (Mentor)', 'sunita.it@mru.edu.in', '$2a$10$w85o3k9g1rTqZ3.gG9a2qu.80j.Ym7N4c1jW.b9sF1mO7K1fM2', 'MENTOR'),
(4, 'Aarav Sharma', 'aarav.sharma@student.mru.edu.in', '$2a$10$w85o3k9g1rTqZ3.gG9a2qu.80j.Ym7N4c1jW.b9sF1mO7K1fM2', 'STUDENT'),
(5, 'Diya Patel', 'diya.patel@student.mru.edu.in', '$2a$10$w85o3k9g1rTqZ3.gG9a2qu.80j.Ym7N4c1jW.b9sF1mO7K1fM2', 'STUDENT'),
(6, 'Rohan Verma', 'rohan.verma@student.mru.edu.in', '$2a$10$w85o3k9g1rTqZ3.gG9a2qu.80j.Ym7N4c1jW.b9sF1mO7K1fM2', 'STUDENT'),
(7, 'Ananya Reddy', 'ananya.reddy@student.mru.edu.in', '$2a$10$w85o3k9g1rTqZ3.gG9a2qu.80j.Ym7N4c1jW.b9sF1mO7K1fM2', 'STUDENT');

-- 2. STUDENT PROFILES (1:1 with users 4, 5, 6, 7)
INSERT INTO `student_profiles` (`user_id`, `roll_number`, `phone`, `department`, `current_year`, `graduation_year`, `cgpa`) VALUES
(4, '22CS0101', '+919876543210', 'Computer Science and Engineering', 4, 2026, 8.85),
(5, '22IT0102', '+919876543211', 'Information Technology', 4, 2026, 9.15),
(6, '22EC0103', '+919876543212', 'Electronics and Communication', 4, 2026, 7.90),
(7, '22CS0104', '+919876543213', 'Computer Science and Engineering', 3, 2027, 8.50);

-- 3. READINESS SCORES
INSERT INTO `readiness_scores` (`id`, `student_id`, `coding_score`, `aptitude_score`, `communication_score`, `overall_score`) VALUES
(1, 4, 90.00, 85.50, 88.00, 88.25),
(2, 5, 95.00, 92.00, 90.00, 92.80),
(3, 6, 72.00, 78.00, 75.00, 74.70),
(4, 7, 80.00, 82.00, 85.00, 81.90);

-- 4. COMPANIES
INSERT INTO `companies` (`id`, `company_name`, `website`, `industry`, `tier`) VALUES
(1, 'Google LLC', 'https://careers.google.com', 'Technology & Cloud', 'TIER_1'),
(2, 'Amazon Web Services', 'https://amazon.jobs', 'E-Commerce & Cloud Computing', 'TIER_1'),
(3, 'Microsoft Corporation', 'https://careers.microsoft.com', 'Software & AI', 'TIER_1'),
(4, 'Tata Consultancy Services', 'https://www.tcs.com/careers', 'IT Services & Consulting', 'SERVICE'),
(5, 'Zomato', 'https://www.zomato.com/careers', 'Food Delivery & Tech', 'PRODUCT');

-- 5. PLACEMENT DRIVES
INSERT INTO `placement_drives` (`id`, `company_id`, `title`, `job_role`, `package_lpa`, `drive_type`, `location`, `min_cgpa_criteria`, `status`, `drive_date`) VALUES
(1, 1, 'Google Campus Recruitment 2026', 'Software Engineer (L3)', 32.50, 'ON_CAMPUS', 'Hyderabad / Bangalore', 8.50, 'ACTIVE', '2026-11-20 09:00:00'),
(2, 2, 'Amazon SDE-1 Hiring Drive', 'Software Development Engineer', 28.00, 'ON_CAMPUS', 'Bangalore', 8.00, 'UPCOMING', '2026-12-05 09:30:00'),
(3, 4, 'TCS Digital & Ninja Hiring Drive', 'Systems Engineer / Digital Trainee', 7.50, 'ON_CAMPUS', 'Pan-India', 7.00, 'COMPLETED', '2026-10-15 10:00:00');

-- 6. DRIVE ELIGIBLE DEPARTMENTS
INSERT INTO `drive_eligible_departments` (`id`, `drive_id`, `department`) VALUES
(1, 1, 'Computer Science and Engineering'),
(2, 1, 'Information Technology'),
(3, 2, 'Computer Science and Engineering'),
(4, 2, 'Information Technology'),
(5, 2, 'Electronics and Communication'),
(6, 3, 'Computer Science and Engineering'),
(7, 3, 'Information Technology'),
(8, 3, 'Electronics and Communication'),
(9, 3, 'Mechanical Engineering');

-- 7. DRIVE APPLICATIONS
INSERT INTO `drive_applications` (`id`, `student_id`, `drive_id`, `application_status`) VALUES
(1, 4, 1, 'SHORTLISTED'),
(2, 5, 1, 'SHORTLISTED'),
(3, 4, 2, 'APPLIED'),
(4, 5, 2, 'APPLIED'),
(5, 6, 2, 'APPLIED'),
(6, 6, 3, 'OFFERED');

-- 8. PROBLEMS (CODING SANDBOX)
INSERT INTO `problems` (`id`, `title`, `slug`, `description`, `difficulty`, `category`, `time_limit_ms`, `memory_limit_mb`, `acceptance_rate`) VALUES
(1, 'Two Sum', 'two-sum', 'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.', 'EASY', 'Arrays & Hash Tables', 1000, 256, 85.50),
(2, 'Valid Parentheses', 'valid-parentheses', 'Given a string s containing just the characters (, ), {, }, [ and ], determine if the input string is valid.', 'EASY', 'Stack & String', 1000, 256, 78.20),
(3, 'Longest Substring Without Repeating Characters', 'longest-substring-without-repeating', 'Given a string s, find the length of the longest substring without repeating characters.', 'MEDIUM', 'Sliding Window', 1500, 256, 62.40),
(4, 'Trapping Rain Water', 'trapping-rain-water', 'Given n non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.', 'HARD', 'Two Pointers & Dynamic Programming', 2000, 512, 45.10);

-- 9. TEST CASES
INSERT INTO `test_cases` (`id`, `problem_id`, `input_data`, `expected_output`, `is_sample`) VALUES
(1, 1, 'nums = [2,7,11,15], target = 9', '[0,1]', TRUE),
(2, 1, 'nums = [3,2,4], target = 6', '[1,2]', TRUE),
(3, 1, 'nums = [3,3], target = 6', '[0,1]', FALSE),
(4, 2, 's = "()"', 'true', TRUE),
(5, 2, 's = "()[]{}"', 'true', TRUE),
(6, 2, 's = "(]"', 'false', FALSE);

-- 10. SUBMISSIONS
INSERT INTO `submissions` (`id`, `student_id`, `problem_id`, `source_code`, `language`, `status`, `verdict`, `execution_time_ms`, `memory_used_kb`) VALUES
(1, 4, 1, 'class Solution { public int[] twoSum(int[] nums, int target) { ... } }', 'Java', 'COMPLETED', 'ACCEPTED', 35, 41200),
(2, 5, 1, 'def twoSum(nums, target): ...', 'Python', 'COMPLETED', 'ACCEPTED', 48, 16400),
(3, 6, 1, 'class Solution { public int[] twoSum(int[] nums, int target) { ... } }', 'Java', 'COMPLETED', 'TIME_LIMIT_EXCEEDED', 1050, 48000),
(4, 4, 2, 'class Solution { public boolean isValid(String s) { ... } }', 'Java', 'COMPLETED', 'ACCEPTED', 18, 39500);

-- 11. COMPANY TRACKS
INSERT INTO `company_tracks` (`id`, `company_id`, `track_name`, `description`) VALUES
(1, 1, 'Google SWE Preparation Track', 'Comprehensive curriculum targeting Google Online Assessment, Data Structures, and System Design rounds.'),
(2, 2, 'Amazon SDE-1 Hiring Track', 'Targeted practice for Amazon Leadership Principles, Graphs, Dynamic Programming, and Behavioral interviews.');

-- 12. TRACK ROUNDS
INSERT INTO `company_track_rounds` (`id`, `track_id`, `round_number`, `round_name`, `round_type`) VALUES
(1, 1, 1, 'Round 1: Online Coding Assessment (OA)', 'ONLINE_ASSESSMENT'),
(2, 1, 2, 'Round 2: Data Structures & Algorithms', 'TECHNICAL'),
(3, 1, 3, 'Round 3: Googleyness & Leadership', 'BEHAVIORAL'),
(4, 2, 1, 'Round 1: Amazon Online Assessment', 'ONLINE_ASSESSMENT'),
(5, 2, 2, 'Round 2: Technical Problem Solving', 'TECHNICAL');

-- 13. TRACK TOPICS
INSERT INTO `company_track_topics` (`id`, `round_id`, `topic_name`, `resource_url`) VALUES
(1, 1, 'Graph Algorithms & BFS/DFS', 'https://geeksforgeeks.org/graph-data-structure-and-algorithms/'),
(2, 1, 'Dynamic Programming on Trees', 'https://leetcode.com/discuss/study-guide/dynamic-programming/'),
(3, 2, 'Trie & Segment Trees', 'https://cp-algorithms.com/data_structures/segment_tree.html'),
(4, 4, 'Amazon Leadership Principles', 'https://www.amazon.jobs/content/en/our-workplace/leadership-principles');

-- 14. INTERVIEW QUESTIONS
INSERT INTO `interview_questions` (`id`, `round_id`, `question_text`, `question_type`, `difficulty`, `sample_answer`) VALUES
(1, 2, 'Explain the internal working of HashMap in Java and how hash collisions are handled.', 'CONCEPTUAL', 'MEDIUM', 'HashMap uses an array of buckets. Collisions are handled using linked lists, and since Java 8, converted to balanced red-black trees when bucket count exceeds TREEIFY_THRESHOLD (8).'),
(2, 2, 'Design a Least Recently Used (LRU) Cache with O(1) get and put operations.', 'CODING', 'HARD', 'Implemented using a combination of a Doubly Linked List and a Hash Map.'),
(3, 3, 'Tell me about a time you had a technical disagreement with a team member and how you resolved it.', 'BEHAVIORAL', 'MEDIUM', 'Focus on data-driven reasoning, active listening, respectful alignment, and business-first priority.');

-- 15. QUIZ QUESTIONS
INSERT INTO `quiz_questions` (`id`, `category`, `sub_category`, `question_text`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`, `difficulty`, `explanation`) VALUES
(1, 'Database Management', 'Normalization', 'Which normal form eliminates transitive functional dependencies for non-prime attributes?', '1NF', '2NF', '3NF', 'BCNF', 'C', 'MEDIUM', '3NF requires 2NF and that no non-prime attribute is transitively dependent on the primary key.'),
(2, 'Computer Networks', 'OSI Model', 'At which OSI layer does the TCP protocol operate?', 'Network Layer', 'Transport Layer', 'Data Link Layer', 'Session Layer', 'B', 'EASY', 'TCP is a connection-oriented protocol that operates at the Transport Layer (Layer 4).'),
(3, 'Operating Systems', 'Concurrency', 'Which condition is NOT a necessary condition for a deadlock to occur?', 'Mutual Exclusion', 'Hold and Wait', 'Preemption Allowed', 'Circular Wait', 'C', 'MEDIUM', 'No Preemption is a deadlock condition; allowing preemption actually prevents deadlocks.');

-- 16. QUIZ ATTEMPTS & ANSWERS
INSERT INTO `quiz_attempts` (`id`, `student_id`, `category`, `score`, `total_questions`, `is_passed`) VALUES
(1, 4, 'Core Computer Science', 100.00, 3, TRUE),
(2, 5, 'Core Computer Science', 66.67, 3, TRUE);

INSERT INTO `quiz_attempt_answers` (`id`, `attempt_id`, `question_id`, `selected_option`, `is_correct`) VALUES
(1, 1, 1, 'C', TRUE),
(2, 1, 2, 'B', TRUE),
(3, 1, 3, 'C', TRUE),
(4, 2, 1, 'C', TRUE),
(5, 2, 2, 'B', TRUE),
(6, 2, 3, 'A', FALSE);

-- 17. MENTORSHIP NOTES
INSERT INTO `mentorship_notes` (`id`, `mentor_id`, `student_id`, `notes`, `action_items`) VALUES
(1, 2, 4, 'Aarav exhibits stellar algorithmic problem-solving. Needs improvement in communication during System Design rounds.', 'Practice mock interview on YouTube/platform, read Designing Data-Intensive Applications Ch 1-3.'),
(2, 3, 5, 'Diya has an outstanding CGPA and aptitude score. Ready for Tier-1 corporate drives.', 'Participate in Google Kickstart style timed weekly mock contests.');

-- 18. RESUME EVALUATIONS
INSERT INTO `resume_evaluations` (`id`, `student_id`, `evaluated_by`, `resume_file_url`, `ats_score`, `feedback`, `suggestions`) VALUES
(1, 4, 1, 'https://s3.amazonaws.com/placement-resumes/aarav_resume_v2.pdf', 89.50, 'Strong ATS formatting. Action verbs well used. Metrics included in projects.', 'Add live demo links and GitHub repository badges to the project section.'),
(2, 5, 2, 'https://s3.amazonaws.com/placement-resumes/diya_resume_v1.pdf', 94.00, 'Exceptional profile. Clear impact metrics and concise tech stack tags.', 'Highlight cloud certifications (AWS Solutions Architect) in top header.');

-- 19. STUDENT BADGES
INSERT INTO `student_badges` (`id`, `student_id`, `badge_name`, `badge_description`, `badge_icon_url`) VALUES
(1, 4, '100-Days-Of-Code', 'Completed 100 consecutive days of coding problem submissions', 'https://cdn.platform.com/badges/100_days.png'),
(2, 4, 'Quiz Master', 'Achieved 100% score on 5 consecutive core CS quizzes', 'https://cdn.platform.com/badges/quiz_master.png'),
(3, 5, 'Tier-1 Ready', 'Scored above 90% across coding, aptitude, and communication assessments', 'https://cdn.platform.com/badges/tier1_ready.png');

-- 20. AUDIT LOGS
INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `entity_name`, `entity_id`, `details`, `ip_address`) VALUES
(1, 1, 'CREATE', 'placement_drives', 1, 'Created Google Campus Recruitment Drive 2026', '192.168.1.10'),
(2, 1, 'CREATE', 'placement_drives', 2, 'Created Amazon SDE-1 Hiring Drive', '192.168.1.10'),
(3, 4, 'SUBMIT', 'drive_applications', 1, 'Student Aarav Sharma applied for Google drive', '192.168.1.45');

-- 21. MOCK INTERVIEW SESSIONS & ANSWERS
INSERT INTO `mock_interview_sessions` (`id`, `student_id`, `interview_type`, `status`, `scheduled_at`, `overall_score`, `strengths`, `areas_to_improve`) VALUES
(1, 4, 'AI_MOCK', 'COMPLETED', '2026-11-05 14:00:00', 88.00, 'Excellent structured approach to problem breakdown and corner case coverage.', 'Speak out loud more consistently while drafting code.');

INSERT INTO `mock_interview_answers` (`id`, `session_id`, `question_id`, `recorded_answer`, `score`, `feedback`) VALUES
(1, 1, 1, 'HashMap internally operates on an array of Node objects. When a hash collision happens, nodes form a linked list. Once the bucket size reaches 8, it transforms into a Red-Black tree for O(log n) worst-case performance.', 92.00, 'Accurate explanation citing Java 8 treeify mechanics.');

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- END OF SEED DATA
-- =============================================================================

