# Heritage ecosystem phase 1

Implemented in the dev baseline:

- `yudao-module-heritage` provides the five product systems, product-SPU relations, public services/schedules, authenticated bookings, and cooperation applications.
- `heritage_ecosystem_migration.sql` is idempotent and creates only the new `heritage_*` tables; it does not modify `123.sql`, inherit, mall, IM, or TRTC tables.
- `heritage_ecosystem_demo.sql` adds deterministic `DEV_DEMO_` services/schedules and maps existing `product_spu` rows without creating product tables.
- App endpoints are under `/app-api/heritage/**`; frontend integration is in `client_code/common/request/heritage-ecosystem.js` and the service/cooperation pages.

Validation commands and evidence are recorded in the task completion report.

## RC1 冻结业务映射

- `CULTURAL_CREATIVE` → `PRODUCT` → `product_spu`
- `HERITAGE_FOOD` → `PRODUCT` → `product_spu`
- `HANDCRAFT_EXPERIENCE` → `SERVICE` → `heritage_service`
- `WELLNESS_COMPANION` → `SERVICE` → `heritage_service`
- `FOLK_PERFORMANCE` → `SERVICE` → `heritage_service`

预约状态机：

- `PENDING -> CONFIRMED -> COMPLETED`
- `PENDING -> CANCELLED`
- `PENDING -> REJECTED`
- `CONFIRMED -> CANCELLED`

创建预约增加 `booked_count`；确认和完成保持容量；取消、驳回释放容量。有效重复预约只包含 `PENDING`、`CONFIRMED`。

合作状态：`0 待处理`、`1 沟通中`、`2 已达成`、`3 已拒绝`。新建申请始终为 `PENDING`，后台处理会记录处理人和处理时间。

## RC1 本地联调

```powershell
$env:HERITAGE_USER_A_PASSWORD='<local secret>'
$env:HERITAGE_USER_B_PASSWORD='<local secret>'
$env:HERITAGE_ADMIN_PASSWORD='<local secret>'
.\scripts\heritage-phase1-e2e.ps1
```

脚本使用 `DEV_E2E_<timestamp>` run id 标记预约与合作申请；它只会取消本次专用账号的活动预约，不会按用户全量删除数据。需要清理 Demo 服务图时，仅在本地执行 `heritage_ecosystem_demo_cleanup.sql`。SPU relation 没有 Demo marker，不自动删除。
## RC1 Final Closure Admin API

管理接口仅暴露在 `/admin-api/heritage`，并使用现有 `@ss.hasPermission` 权限模型：

- `GET /product-system-spu/page`
- `POST /product-system-spu/create`
- `PUT /product-system-spu/update`
- `DELETE /product-system-spu/delete?id=`
- `GET /service-schedule/list?serviceId=`
- `POST /service-schedule/create`
- `PUT /service-schedule/update`
- `DELETE /service-schedule/delete?id=`
- `PUT /service/status?id=&status=`
- `DELETE /service/delete?id=`

商品体系关系只允许 `CULTURAL_CREATIVE` 与 `HERITAGE_FOOD`，并验证商品存在、体系启用、重复关系和逻辑删除。服务体系不能创建商品关系。

预约状态机固定为：`PENDING -> CONFIRMED/CANCELLED/REJECTED`，`CONFIRMED -> CANCELLED/COMPLETED`；完成不释放容量，取消/拒绝释放容量。

合作申请状态机固定为：`PENDING -> COMMUNICATING/REJECTED`，`COMMUNICATING -> REACHED/REJECTED`；`REACHED` 与 `REJECTED` 为终态。

场次更新必须满足 `startTime < endTime`、`capacity >= 0`，且有限容量不能小于已预约人数；存在 PENDING/CONFIRMED 预约时禁止删除场次。服务存在未删除场次或有效预约时禁止删除。