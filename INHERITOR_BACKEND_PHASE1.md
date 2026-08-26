# Inheritor Backend Phase 1

## Scope

本收口仅覆盖 `yudao-module-inherit` 后端、非破坏性数据库增量、自动化测试、E2E 与运行文档；不修改 `client_code/**`、IM、TRTC、商城订单和前端页面。

## 数据库

`inherit_migration.sql` 在 `heritage_ruoyi` 上创建/补齐：

- `inherit_inheritor`、作品、资质、项目关系、关注（既有表）
- `inherit_inheritor_product_relation`：仅保存 `inheritor_id + spu_id`，逻辑关联真实 `product_spu`，唯一键 `(inheritor_id, spu_id)`。
- `inherit_inheritor_service_relation`：仅保存 `inheritor_id + service_id`，逻辑关联真实 `heritage_service`，唯一键 `(inheritor_id, service_id)`。

两个新表都包含租户/审计/逻辑删除字段，无物理外键。迁移使用 `CREATE TABLE IF NOT EXISTS` 与自然键权限种子，可重复执行。`inherit_demo.sql` 和 `inherit_demo_cleanup.sql` 独立于正式迁移，demo 只使用 `DEV_DEMO_` 标记和真实 active SPU/service。

## 公开条件与隐私

App 页面、详情、作品、资质、项目、商品、服务统一要求传承人满足：`deleted=0 AND status=0(ENABLE) AND audit_status=1(SUCCESS) AND display_status=1`。关系和商品/服务本身也必须未删除且启用；隐藏主数据不会通过关系接口泄露。公开 VO 不包含 phone、idCard、auditRemark、creator、updater、tenantId、deleted。`/app-api/inherit/inheritor/contact?id=` 不公开，要求登录且只返回 `{phone}`；隐藏传承人即使登录也被拒绝。

## App API

- `GET /app-api/inherit/inheritor/page`
- `GET /app-api/inherit/inheritor/get?id=`
- `GET /app-api/inherit/inheritor/works?id=`
- `GET /app-api/inherit/inheritor/qualifications?id=`
- `GET /app-api/inherit/inheritor/projects?id=`
- `GET /app-api/inherit/inheritor/products?id=`
- `GET /app-api/inherit/inheritor/services?id=`
- `GET /app-api/inherit/inheritor/contact?id=`（登录）
- `POST/DELETE/GET /app-api/inherit/inheritor-follow/{create,delete,get}`（登录）
- `GET /app-api/inherit/inheritor-follow/page`（当前登录用户）

服务预约不在 inherit 中复制：先从 `inheritor/services` 取得 `serviceId`，再复用 `/app-api/heritage/service/get`、`/app-api/heritage/service/schedule-list` 和 `/app-api/heritage/service-booking/create`。

## Admin API

商品关系：

- `GET /admin-api/inherit/inheritor-product-relation/page`
- `GET /admin-api/inherit/inheritor-product-relation/get?id=`
- `POST /admin-api/inherit/inheritor-product-relation/create`
- `PUT /admin-api/inherit/inheritor-product-relation/update`
- `DELETE /admin-api/inherit/inheritor-product-relation/delete?id=`

服务关系对应路径为 `/admin-api/inherit/inheritor-service-relation/...`。全部接口使用 `inherit:inheritor-{product,service}-relation:{query,create,update,delete}` 权限。

## 关系与事务语义

创建关系先校验父传承人及真实商品/SPU 或 heritage service；重复关系返回业务错误码；逻辑删除后重新创建走 revive，不把 MySQL 1062 暴露给客户端。删除传承人使用 `@Transactional(rollbackFor = Exception.class)`，同步逻辑删除作品、资质、项目/商品/服务关系和关注。作品、资质、项目关系更新都会校验父传承人存在；审核状态只接受 0/1/2，性别、展示、推荐、启停状态拒绝越界值。

关注创建先执行公开校验；取消/状态/我的关注使用登录用户 ID，客户端没有 userId 参数；我的关注保留数据库关系但过滤已下架/未审核对象。

## Project/category status

本轮搜索命令覆盖 `backend-clean` Java 与 SQL（`heritage_category`、`heritage_project`、`project_category`、`HeritageProject`、`HeritageCategory`）。`123.sql` 确实已有 `heritage_category` 与 `heritage_project` 表，但 backend-clean 没有对应 Java DO/Mapper/Service/Controller；因此没有凭空建立第二套 CMS，而是在 inherit Mapper 中以数据库子查询复用这两张真实表：App page 可选 `heritageCategoryId`，按 active category/project 与 active relation 在分页前过滤；项目关系创建/更新校验 active `heritage_project`。当前数据库这两张表无业务种子时，筛选结果为空是数据事实，不是前端假筛。
## Tests and E2E

单测位于 `backend-clean/yudao-module-inherit/src/test/java/.../Inheritor*Test.java`，覆盖公开/隐藏/未审核关注、重复与 revive、用户关注过滤、删除级联、状态校验、商品/服务关系创建/重复/删除/重绑/非法主数据，共 25 个测试方法。E2E 脚本为 `scripts/inherit-phase1-e2e.ps1`；账号密码只从 `INHERIT_USER_A_PASSWORD`、`INHERIT_USER_B_PASSWORD`、`INHERIT_ADMIN_PASSWORD` 环境变量读取，不写入 Git。

## Known limitations

- category/project 主数据缺失，无法在数据库层实现 heritage category filter。
- E2E 的认证写操作需要本机提供上述环境变量；缺少凭据时脚本只执行公开检查并明确标记 NOT RUN 分支。