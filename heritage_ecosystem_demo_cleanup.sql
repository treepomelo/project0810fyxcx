-- LOCAL DEVELOPMENT ONLY. Never run against production data.
-- Only removes DEV_DEMO_ service graph rows. Product SPU relations are intentionally not removed:
-- they have no demo marker and therefore are not safe to identify automatically.
SET NAMES utf8mb4;

DELETE b FROM heritage_service_booking b
JOIN heritage_service_schedule sch ON sch.id = b.schedule_id
JOIN heritage_service s ON s.id = sch.service_id
WHERE s.title LIKE 'DEV_DEMO_%';

DELETE sch FROM heritage_service_schedule sch
JOIN heritage_service s ON s.id = sch.service_id
WHERE s.title LIKE 'DEV_DEMO_%';

DELETE FROM heritage_service WHERE title LIKE 'DEV_DEMO_%';