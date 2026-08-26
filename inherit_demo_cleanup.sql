-- LOCAL DEVELOPMENT ONLY. Removes only DEV_DEMO_ inheritor graph rows.
SET NAMES utf8mb4;
DELETE r FROM inherit_inheritor_product_relation r JOIN inherit_inheritor i ON i.id=r.inheritor_id WHERE i.name LIKE 'DEV_DEMO_%';
DELETE r FROM inherit_inheritor_service_relation r JOIN inherit_inheritor i ON i.id=r.inheritor_id WHERE i.name LIKE 'DEV_DEMO_%';
DELETE f FROM inherit_inheritor_follow f JOIN inherit_inheritor i ON i.id=f.inheritor_id WHERE i.name LIKE 'DEV_DEMO_%';
DELETE w FROM inherit_inheritor_work w JOIN inherit_inheritor i ON i.id=w.inheritor_id WHERE i.name LIKE 'DEV_DEMO_%';
DELETE q FROM inherit_inheritor_qualification q JOIN inherit_inheritor i ON i.id=q.inheritor_id WHERE i.name LIKE 'DEV_DEMO_%';
DELETE p FROM inherit_inheritor_project_relation p JOIN inherit_inheritor i ON i.id=p.inheritor_id WHERE i.name LIKE 'DEV_DEMO_%';
DELETE FROM inherit_inheritor WHERE name LIKE 'DEV_DEMO_%';