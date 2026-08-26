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