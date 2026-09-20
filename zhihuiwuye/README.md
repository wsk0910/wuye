# 智慧物业管理系统

基于 Spring Boot、Vue 3 和 Element Plus 的前后端分离智慧物业管理系统。

## 技术栈

- 后端：Spring Boot 2.7、MyBatis Plus、MySQL
- 前端：Vue 3、Vite、Element Plus、ECharts、Pinia
- 运行环境：JDK 11+、Maven 3.6+、Node.js 18+、MySQL 8+

## 项目结构

```text
.
├── server/                    # Spring Boot 后端
│   ├── src/
│   └── pom.xml
├── web/                       # Vue 3 前端
│   ├── src/
│   ├── package.json
│   └── package-lock.json
├── smart_property.sql         # 备用数据库脚本
└── .env.example               # 环境变量示例
```

## 本地启动

### 1. 初始化数据库

在 MySQL 中执行：

```text
server/src/main/resources/schema.sql
```

数据库脚本内包含用于本地演示的虚构测试数据。

### 2. 配置数据库连接

后端通过以下环境变量读取数据库配置：

| 变量 | 默认值 |
| --- | --- |
| `DB_URL` | 本机 `smart_property` 数据库 |
| `DB_USERNAME` | `root` |
| `DB_PASSWORD` | 空 |

PowerShell 示例：

```powershell
$env:DB_USERNAME="root"
$env:DB_PASSWORD="你的本地数据库密码"
```

### 3. 启动后端

```powershell
cd server
mvn spring-boot:run
```

后端默认运行在 <http://localhost:8080>。

### 4. 启动前端

打开另一个终端：

```powershell
cd web
npm ci
npm run dev
```

前端默认运行在 <http://localhost:5173>。

## 演示账号

| 角色 | 用户名 | 密码 |
| --- | --- | --- |
| 超级管理员 | `admin` | `123456` |
| 物业管理员 | `property` | `123456` |
| 维修工 | `worker1` | `123456` |

这些账号和密码仅用于本地演示，请勿直接用于生产环境。

## 功能模块

- 用户管理
- 业主管理
- 报修管理
- 费用管理
- 通知公告
- 投诉建议
- 访客预约
- 巡检管理

## 安全提示

当前版本定位为学习和演示项目。正式部署前至少应增加密码哈希、身份认证、接口权限校验，并替换所有演示账号和数据。

## 许可证

本项目使用 [MIT License](LICENSE)。
