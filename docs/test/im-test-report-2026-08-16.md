# IM 模块功能测试报告（API 级）

## 1. 测试概述

| 项 | 内容 |
|---|---|
| 测试对象 | IM 即时通讯模块（`yudao-module-im`），小程序 inherit-app-uniapp 后台账号桥接场景 |
| 测试范围 | 登录、私聊（收发/历史/撤回/已读）、好友申请全流程、用户搜索、群组管理（建群/邀请/退群/解散）、群聊、文件上传、异常边界 |
| 测试方式 | API 级功能测试（curl + 源码比对），WebSocket/UI 项标注「需人工验证」 |
| 环境 | yudao-server @ http://127.0.0.1:48080（profile=local），统一前缀 `/admin-api`，`tenant-id: 1`；测试库 ruoyi-vue-pro-jdk8（MySQL） |
| 测试账号 | admin（id=1）+ 临时用户 B（imtestb/id=226）、C（imtestc/id=227，用于拒绝申请与邀请测试；测试后已删除） |
| 测试时间 | 2026-08-16 15:00–15:30 |
| 执行人 | QA 子 agent（专职测试工程师） |

## 2. 执行摘要

| 指标 | 数值 |
|---|---|
| 用例总数 | 55 |
| PASS（API 可验证通过） | 36 |
| FAIL | 0 |
| 需人工验证（WebSocket / UI / 弱网并发） | 19 |
| N/A | 0 |
| 通过率（可执行项） | 36/36 = 100% |

用例构成：L(登录)5、W(WebSocket)3、C(会话)5、P(私聊)10、G(群聊)6、T(通讯录)3、F(好友)10、M(群组)5、U(上传)3、E(异常)5。

## 3. 缺陷明细表

| 编号 | 对应用例 | 严重级别 | 描述 | 复现步骤 | 实际结果 vs 预期 | 证据 | 建议 |
|---|---|---|---|---|---|---|---|
| DEF-01 | U1/U2/P4 | P1（环境/配置） | 本机 master 文件存储配置为占位假配置，图片上传 100% 失败 | `POST /admin-api/infra/file/upload`（multipart file） | 预期返回文件 URL；实际返回 `{"code":500,"msg":"系统异常"}`，服务端日志 `S3Exception Status 405`。根因：`infra_file_config` id=35（master=1）为 `endpoint=http://www.baidu.com, bucket=1, 假密钥` 的占位配置 | 上传返回 code:500；日志 `S3Exception (Service: S3, Status Code: 405)`；`infra_file_config` 查询结果 id=35 master=1 | 本地/测试环境将 master 文件配置改为可用存储（MinIO、本地、DB 存储其一）；生产部署前务必校验文件存储配置。测试期间已临时切至 DB 存储(id=4)验证上传/图片消息通过，并已恢复原状 |
| DEF-02 | F5/F1（间接） | P2（配置/使用注意） | 无角色的新建用户无法通过 IM 搜索/好友申请接口看到其它用户 | 创建无角色用户 X → X 调 `GET /system/user/get-simple?id=1` / `POST /im/friend-request/apply` | 预期可搜索/可申请；实际 get-simple 返回 null、apply 返回 `{"code":1002003003,"msg":"用户不存在"}`。根因：无角色用户 data scope 被过滤（RBAC 数据权限），`validateUserList` 查不到对方 | `system/user/create` 建无角色用户 → get-simple?id=1 返回 null → 分配 roleId=2 后恢复正常 | 属 RBAC 预期行为非代码缺陷；测试/运营创建账号需分配角色。小程序桥接账号均有角色，不影响正常业务；建议在创建测试账号指引中注明 |
| DEF-03 | T1（设计契约） | P2（设计/前端契约） | 删除好友为单向软删除，删除方 friend/list 仍返回该好友（status=1） | admin 删除好友 C → `GET /im/friend/list` | 预期删除后不再出现；实际仍返回 C 记录，但 `status=1, deleteTime` 已赋值 | `DELETE /im/friend/delete?friendUserId=227&clear=true` 后 `friend/list` 返回 `{friendUserId:227,status:1,deleteTime:...}` | 设计如此（软删除），但前端必须按 `status==0` 过滤，否则已删好友仍显示。建议联调时与前端对齐过滤逻辑 |
| DEF-04 | M2 | P3（体验/校验） | 后端允许空 `memberUserIds` 创建群（仅群主入群），未拦截「至少选一名成员」 | `POST /im/group/create` body `{"name":"x"}` | 预期提示需选择成员；实际建群成功（code:0） | 空成员建群返回 `{"code":0,"data":{"id":2,...}}` | 属前端校验项，但建议后端 `ImGroupCreateReqVO.memberUserIds` 增加 `@NotEmpty`（若产品要求至少一名初始成员） |
| DEF-05 | 测试工具 | P3（环境） | git-bash curl 传中文存在 GBK 编码问题：POST body 中文→500 解析失败；URL query 中文→HTTP 400；PUT 中文参数→落库乱码 | `curl -d '{"nickname":"测试"}'` 等 | 中文被按 GBK 发送 | `Caused by: Invalid UTF-8 start byte 0xb2`（日志）；`handleContent` 落库为 `�ݲ�����Ӻ���` | 测试工具环境问题，非产品缺陷；已用 UTF-8 文件 payload / URL 编码规避。正式联调用小程序真实端无此问题 |

## 4. WebSocket / UI 项待人工验证清单

以下用例无法用 API 完整覆盖，需在小程序 UI + WebSocket 联调阶段人工验证：

| 编号 | 用例 | 验证要点 |
|---|---|---|
| L5 | 断网登录 | 断网点登录有「网络失败」提示、不崩溃 |
| W1 | 连接成功 | 登录后消息页顶部绿点亮起 |
| W2 | 断线重连 | 停 Redis/断网恢复后绿点先灭后自动重连 |
| W3 | 多端同账号 | 两个窗口登同一账号，两端均收到消息 |
| C1 | 会话展示 | 与 B 互发消息后头像/昵称/最后一条内容渲染 |
| C2 | 会话排序 | 新消息使会话置顶 |
| C3 | 未读角标 | 未读计数显示，超 99 显示 99+ |
| C4 | 时间格式 | 今天显时分、昨天/更早显月-日 |
| C5 | 会话空态 | 无会话显示「暂无会话」引导 |
| P10 | 未读清零 | 进会话→返回后角标消失 |
| G2 | 群聊成员标识 | 群消息带发送者昵称/头像 |
| T3 | 通讯录空态 | 无好友显示「暂无好友」 |
| F3 | 空关键词搜索 | 空关键词不发起请求 |
| F4 | 搜索到自己 | 结果显示「自己」按钮态 |
| F10 | 申请角标 | 新的朋友顶部显示待处理数 |
| M2 | 建群前端校验 | 不勾选成员提示「需选择成员」 |
| U3 | 上传失败提示 | 断网选图提示失败可重试、无残留 |
| E2 | 弱网收发 | 有加载/失败提示、不卡死 |
| E5 | 双端并发 50 条 | 顺序不乱、无丢失、无串号 |

## 5. 残留测试数据说明

**已清理（均为本次测试自造数据）：**
- 临时用户 B（imtestb/id=226）、C（imtestc/id=227）已通过 `POST /system/user/delete` 删除（ruoyi 逻辑删除，`system_users.deleted=1`，不可再登录；其 user_role/user_post 关联亦已随删除置 deleted=1）
- `im_friend`：0 行（admin 与 B、admin 与 C 的好友关系已删）
- `im_friend_request`：本次创建的 id=2/3/4 已删
- `im_group` / `im_group_member`：测试群「IM测试群」(id=1)、「空群测试」(id=2) 已解散并删除
- `im_private_message`：42 条、`im_group_message`：11 条、`im_conversation_read`：2 条已删
- 测试上传文件 2 个（test_img.png、big_test.bin）的 `infra_file`/`infra_file_content` 记录已删

**保留（非本次测试数据，未改动）：**
- `im_friend_request` id=1：admin → 用户 225「im01」的既有待处理申请（测试前已存在）
- `infra_file_config`：已恢复原状，master=id=35（占位配置，见 DEF-01）

**测试产物目录**：`F:\01workspace\fyxcx\fyxcx0810\.claude-build\im-test\`（含请求体、token、部分响应证据；token 已随退出登录/删除用户失效）

## 6. 风险评估与测试结论

### 风险
- **P1**：master 文件存储为占位配置，当前本地环境下小程序「发图片」链路端到端跑不通（API 侧图片消息/上传本身验证通过，需配置可用存储）。
- **P2**：好友删除为单向软删除，前端若未按 `status==0` 过滤会出现「已删好友仍显示」。
- 其余为 P3 级或使用注意事项，不影响主流程。

### 结论
- IM 模块核心 API 链路全部按预期工作：登录鉴权、私聊收发/历史分页/撤回（含超时与越权拦截）/已读回执、好友申请全流程（申请/幂等/对方可见/同意/拒绝）、用户搜索、建群/群信息/邀请/退群/解散、群聊收发/群主治理、文件上传、幂等去重、token 校验等 36 个可执行用例 **全部 PASS**，未发现功能性 FAIL。
- **可以进入小程序 UI 联调阶段**。建议：
  1. 先修复/配置 master 文件存储（DEF-01），否则图片功能无法端到端联调；
  2. 联调时重点覆盖 WebSocket 实时/断线重连（W1-W3）、会话角标/排序（C2/C3）、群聊成员标识（G2）等 UI 项；
  3. 与前端确认好友删除的 status 过滤逻辑（DEF-03）。

---

*本报告由 QA 子 agent 基于 API 级测试生成；WebSocket/UI 项待人工验证清单详见第 4 节。*
