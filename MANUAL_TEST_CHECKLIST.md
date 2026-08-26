# 真机/人工验收清单

- 前置：Redis 已返回 `PONG`。
- 前置：后端 `48080` 处于 LISTENING。
- 前置：LAN API `http://192.168.3.23:48080/app-api/inherit/inheritor/page?pageNo=1&pageSize=10` 可访问。
- 微信开发者工具导入 `unpackage/dist/build/mp-weixin`，确认首页可打开。
- 进入传承人列表，确认列表加载、分页/空态和下拉刷新。
- 打开“本地联调传承人”详情，确认头像/简介/擅长/经历及作品、资质、项目区域。
- 未登录：打开联系入口应提示需要登录或按接口策略拒绝，不应泄露联系电话。
- 已登录：打开联系入口，确认显示已配置的联系电话；点击拨号 `00000000000`，随后取消拨号。
- 已登录：关注传承人，确认关注数/状态变化；取消关注后确认状态恢复。
- 重新进入详情，确认关注状态与页面一致。
- 不测试 IM、聊天或消息页；一期仅验证传承人浏览、联系、关注。
## Heritage ecosystem

- [ ] Public product-system list returns five enabled systems.
- [ ] Public service detail and schedule list load.
- [ ] Logged-in user creates and cancels a booking; verify DB and capacity read-back.
- [ ] Logged-in user creates a cooperation application; verify DB read-back.

## 一期生态 RC1 明日人工重点

- [ ] 分类页显示后端返回的五个体系，快速切换不串数据。
- [ ] 文创/美食卡片进入商品详情；手作/康养/演艺卡片进入服务详情。
- [ ] 服务详情展示封面、体系、简介、价格、地点、场次；无场次和关闭预约状态正确。
- [ ] 未登录点击预约进入现有登录链路；登录后可提交预约。
- [ ] 预约表单拦截空联系人、非法手机号、人数 0/21；提交按钮防连点。
- [ ] 我的服务预约展示场次、地点、人数、联系人和状态，只有待确认/已确认可取消。
- [ ] 合作申请显示四个中文合作类型，列表显示待处理/沟通中/已达成/已拒绝。
- [ ] Profile 入口可进入“服务预约”和“合作申请”。
- [ ] 真机网络使用 LAN API；微信开发者工具导入 `client_code/unpackage/dist/build/mp-weixin`。

以上项目属于视觉/真机交互，HTTP、数据库和构建已由自动验收覆盖。