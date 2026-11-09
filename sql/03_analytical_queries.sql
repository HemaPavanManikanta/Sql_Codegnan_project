-- =============================================================================
-- PLACEMENT PREPARATION PLATFORM — ANALYTICAL & BUSINESS QUERIES
-- Database: placementdb
-- Contains real-world reporting queries for TPOs, Mentors, and Students
-- =============================================================================

USE `placementdb`;

-- -----------------------------------------------------------------------------
-- Query 1: Comprehensive Student Readiness Report
-- Joins users, student profiles, readiness scores, and awarded badge counts
-- -----------------------------------------------------------------------------
SELECT 
    u.id AS user_id,
    u.name AS student_name,
    u.email,
    sp.roll_number,
    sp.department,
    sp.cgpa,
    rs.coding_score,
    rs.aptitude_score,
    rs.communication_score,
    rs.overall_score,
    COUNT(DISTINCT sb.id) AS total_badges_earned
FROM users u
JOIN student_profiles sp ON u.id = sp.user_id
LEFT JOIN readiness_scores rs ON sp.user_id = rs.student_id
LEFT JOIN student_badges sb ON sp.user_id = sb.student_id
WHERE u.role = 'STUDENT'
GROUP BY u.id, u.name, u.email, sp.roll_number, sp.department, sp.cgpa, 
         rs.coding_score, rs.aptitude_score, rs.communication_score, rs.overall_score
ORDER BY rs.overall_score DESC;

-- -----------------------------------------------------------------------------
-- Query 2: Placement Drive Application & Shortlist Analytics
-- Calculates student applicants, shortlist counts, and eligibility benchmarks
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    c.tier AS company_tier,
    pd.title AS drive_title,
    pd.job_role,
    pd.package_lpa,
    pd.min_cgpa_criteria,
    pd.status AS drive_status,
    COUNT(da.id) AS total_applications,
    SUM(CASE WHEN da.application_status = 'SHORTLISTED' THEN 1 ELSE 0 END) AS shortlisted_count,
    SUM(CASE WHEN da.application_status = 'OFFERED' THEN 1 ELSE 0 END) AS offers_made
FROM placement_drives pd
JOIN companies c ON pd.company_id = c.id
LEFT JOIN drive_applications da ON pd.id = da.drive_id
GROUP BY c.company_name, c.tier, pd.title, pd.job_role, pd.package_lpa, 
         pd.min_cgpa_criteria, pd.status
ORDER BY pd.package_lpa DESC;

-- -----------------------------------------------------------------------------
-- Query 3: Student Coding Sandbox Performance & Verdict Breakdown
-- Groups accepted vs failing verdicts per student
-- -----------------------------------------------------------------------------
SELECT 
    u.name AS student_name,
    sp.roll_number,
    COUNT(s.id) AS total_submissions,
    COUNT(DISTINCT s.problem_id) AS unique_problems_attempted,
    SUM(CASE WHEN s.verdict = 'ACCEPTED' THEN 1 ELSE 0 END) AS accepted_submissions,
    SUM(CASE WHEN s.verdict = 'TIME_LIMIT_EXCEEDED' THEN 1 ELSE 0 END) AS tle_count,
    SUM(CASE WHEN s.verdict = 'WRONG_ANSWER' THEN 1 ELSE 0 END) AS wa_count,
    ROUND(
        (SUM(CASE WHEN s.verdict = 'ACCEPTED' THEN 1 ELSE 0 END) / COUNT(s.id)) * 100, 2
    ) AS student_acceptance_rate_percent
FROM submissions s
JOIN student_profiles sp ON s.student_id = sp.user_id
JOIN users u ON sp.user_id = u.id
GROUP BY u.name, sp.roll_number
ORDER BY accepted_submissions DESC;

-- -----------------------------------------------------------------------------
-- Query 4: Department-Wise Drive Eligibility & Student Pool
-- Shows which branches qualify for specific campus drives
-- -----------------------------------------------------------------------------
SELECT 
    pd.title AS drive_title,
    c.company_name,
    GROUP_CONCAT(DISTINCT ded.department ORDER BY ded.department SEPARATOR ', ') AS eligible_departments,
    pd.package_lpa,
    pd.drive_date
FROM placement_drives pd
JOIN companies c ON pd.company_id = c.id
JOIN drive_eligible_departments ded ON pd.id = ded.drive_id
GROUP BY pd.id, pd.title, c.company_name, pd.package_lpa, pd.drive_date
ORDER BY pd.drive_date ASC;

-- -----------------------------------------------------------------------------
-- Query 5: Company Track Syllabus & Curated Question Hierarchy
-- Unrolls track -> round -> topic -> interview questions
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    ct.track_name,
    ctr.round_number,
    ctr.round_name,
    ctr.round_type,
    iq.question_type,
    iq.difficulty,
    iq.question_text
FROM company_tracks ct
JOIN companies c ON ct.company_id = c.id
JOIN company_track_rounds ctr ON ct.id = ctr.track_id
JOIN interview_questions iq ON ctr.id = iq.round_id
ORDER BY c.company_name, ctr.round_number, iq.difficulty;

