# 本地运行说明

- Java：17；Maven：3.9.14；Node/pnpm 使用仓库现有本机运行时。
- MySQL：`127.0.0.1:3306`，数据库名 `heritage_ruoyi`。先执行 `123.sql`，再执行 `inherit_migration.sql`，最后执行 `heritage_ecosystem_migration.sql`；密码只通过本机环境变量提供，不写入文档。
- Redis：使用已验证的本机 Redis，不需要 Docker。启动：`$redis='F:\01workspace\fyxcx\fyxcx0810\.claude-build\redis\redis-server.exe'; $conf='F:\01workspace\fyxcx\fyxcx0810\.claude-build\redis\redis.local.conf'; Start-Process -FilePath $redis -ArgumentList $conf -WorkingDirectory (Split-Path $redis) -WindowStyle Hidden`。验证：`& 'F:\01workspace\fyxcx\fyxcx0810\.claude-build\redis\redis-cli.exe' -h 127.0.0.1 -p 6379 ping`，应返回 `PONG`。
- 打包：在 `backend-clean` 执行 `mvn -pl yudao-server -am -DskipTests package`。
- 启动：在 `dev` 根目录执行 `$env:RUOYI_DB_PASSWORD='(本机密码)'; java -jar .\backend-clean\yudao-server\target\yudao-server.jar --spring.profiles.active=local`。本机验证端口为 `48080`，API 根路径为 `/app-api`。
- 启动顺序：启动 Redis → 验证 `PONG` → 启动后端 → 确认 `48080 LISTENING` → 调用 localhost/LAN API。
- 冒烟接口：`/app-api/inherit/inheritor/page?pageNo=1&pageSize=10`、`/get?id=<id>`、`/works?id=<id>`、`/qualifications?id=<id>`、`/projects?id=<id>`；contact/follow 按登录态验证。
- 当前局域网地址：`192.168.3.23`。设备访问前，将 `VITE_RUOYI_APP_API_BASE_URL` 设置为 `http://192.168.3.23:48080/app-api`；地址变化时同步更新。
- 前端：在 `client_code` 执行 `pnpm run build:mp-weixin` 或 `pnpm run dev:mp-weixin`；微信开发者工具导入 `unpackage/dist/build/mp-weixin`。
- 停止：后端终端按 `Ctrl+C`；前端 watch 终端按 `Ctrl+C` 并确认终止。


# 简洁版
redis:
    cd F:\01workspace\fys2\dev
.\tools\redis\redis-server.exe

server:
    cd F:\01workspace\fys2\dev
    $env:RUOYI_DB_PASSWORD="1234"(如果数据库密码没有设置成环境变量，先执行：)
java -jar .\backend-clean\yudao-server\target\yudao-server.jar --spring.profiles.active=local

前端：
cd F:\01workspace\fys2\dev\client_code

$env:VITE_RUOYI_APP_API_BASE_URL="http://192.168.3.23:48080/app-api"

pnpm run dev:mp-weixin

项目里这个命令已经明确配置成微信小程序开发模式，输出到：

F:\01workspace\fys2\dev\client_code\unpackage\dist\dev\mp-weixin

## Heritage RC1

```powershell
$env:HERITAGE_USER_A_PASSWORD='<local secret>'
$env:HERITAGE_USER_B_PASSWORD='<local secret>'
$env:HERITAGE_ADMIN_PASSWORD='<local secret>'
.\scripts\heritage-phase1-e2e.ps1
```

Demo 幂等性验证可连续执行三次 `heritage_ecosystem_demo.sql`；本地清理按 booking → schedule → service 顺序执行 `heritage_ecosystem_demo_cleanup.sql`。该 cleanup 不删除没有 Demo marker 的 SPU relation。