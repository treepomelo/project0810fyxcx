-- LOCAL DEVELOPMENT ONLY. Uses natural keys and existing active product/service rows.
SET NAMES utf8mb4;

INSERT INTO inherit_inheritor (name,pinyin,avatar,cover,gender,phone,level,introduction,profile,specialty,audit_status,display_status,is_recommend,recommend_sort,sort,status,tenant_id)
SELECT 'DEV_DEMO_传承人','dev_demo_chengren','/static/heritage/demo-inheritor.jpg','/static/heritage/demo-inheritor.jpg',0,'19900000001','省级代表性传承人','用于传承人后端联调的公开演示数据','仅供本地 E2E 使用。','传统手工艺',1,1,0,0,1,0,0
WHERE NOT EXISTS (SELECT 1 FROM inherit_inheritor WHERE name='DEV_DEMO_传承人' AND deleted=0);

INSERT INTO inherit_inheritor_work (inheritor_id,name,cover,description,year,material,technique,sort,status,tenant_id)
SELECT i.id,'DEV_DEMO_作品一','/static/heritage/demo-work-1.jpg','本地 E2E 作品一','2024','铜','錾刻',1,0,0 FROM inherit_inheritor i WHERE i.name='DEV_DEMO_传承人' AND i.deleted=0 AND NOT EXISTS (SELECT 1 FROM inherit_inheritor_work w WHERE w.inheritor_id=i.id AND w.name='DEV_DEMO_作品一' AND w.deleted=0);
INSERT INTO inherit_inheritor_work (inheritor_id,name,cover,description,year,material,technique,sort,status,tenant_id)
SELECT i.id,'DEV_DEMO_作品二','/static/heritage/demo-work-2.jpg','本地 E2E 作品二','2023','丝','织造',2,0,0 FROM inherit_inheritor i WHERE i.name='DEV_DEMO_传承人' AND i.deleted=0 AND NOT EXISTS (SELECT 1 FROM inherit_inheritor_work w WHERE w.inheritor_id=i.id AND w.name='DEV_DEMO_作品二' AND w.deleted=0);

INSERT INTO inherit_inheritor_qualification (inheritor_id,type,name,level,issuer,description,sort,status,tenant_id)
SELECT i.id,'资质','DEV_DEMO_资质一','省级','本地文化馆','本地 E2E 资质一',1,0,0 FROM inherit_inheritor i WHERE i.name='DEV_DEMO_传承人' AND i.deleted=0 AND NOT EXISTS (SELECT 1 FROM inherit_inheritor_qualification q WHERE q.inheritor_id=i.id AND q.name='DEV_DEMO_资质一' AND q.deleted=0);
INSERT INTO inherit_inheritor_qualification (inheritor_id,type,name,level,issuer,description,sort,status,tenant_id)
SELECT i.id,'荣誉','DEV_DEMO_荣誉一','市级','本地文化馆','本地 E2E 荣誉一',2,0,0 FROM inherit_inheritor i WHERE i.name='DEV_DEMO_传承人' AND i.deleted=0 AND NOT EXISTS (SELECT 1 FROM inherit_inheritor_qualification q WHERE q.inheritor_id=i.id AND q.name='DEV_DEMO_荣誉一' AND q.deleted=0);

INSERT INTO inherit_inheritor_product_relation (inheritor_id,spu_id,is_representative,sort,status,tenant_id)
SELECT i.id,p.id,1,1,1,0 FROM inherit_inheritor i JOIN product_spu p ON p.deleted=0 AND p.status=1 WHERE i.name='DEV_DEMO_传承人' AND i.deleted=0 AND NOT EXISTS (SELECT 1 FROM inherit_inheritor_product_relation r WHERE r.inheritor_id=i.id AND r.spu_id=p.id);

INSERT INTO inherit_inheritor_service_relation (inheritor_id,service_id,is_representative,sort,status,tenant_id)
SELECT i.id,s.id,1,1,1,0 FROM inherit_inheritor i JOIN heritage_service s ON s.deleted=0 AND s.status=1 WHERE i.name='DEV_DEMO_传承人' AND i.deleted=0 AND NOT EXISTS (SELECT 1 FROM inherit_inheritor_service_relation r WHERE r.inheritor_id=i.id AND r.service_id=s.id);