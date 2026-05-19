---
layout: post
title: mymcp server 的 2.x 进展
categories: 软件技术
tags: AI MCP Linux LLM OpenTelemetry Observability
toc: false
---

之前介绍过的 [mymcp server](/mymcp-server/) 最近 2.x 版本里有几个变化：**安装方式变了，可观测性补齐了，文件传输也从“文本工具”扩展到了大文件和二进制文件。**


## 从脚本安装变成 pipx 安装

之前 `mymcp` 更像一个可以部署到服务器上的源码项目：clone 代码，跑 `deploy/install.sh`，再由脚本创建 venv、写 systemd service、设置目录。

现在 2.x 之后，它已经更接近一个正常 Python 命令行工具了：

```bash
pipx install algony-mymcp
```

PyPI 上的发行包名字是 `algony-mymcp`，但安装以后命令仍然是 `mymcp`:

* 代码由 pipx 管理；
* 配置目录迁到 `/etc/mymcp`；
* 日志目录默认在 `/var/log/mymcp`；
* systemd service 可以通过 CLI 生成；
* 升级变成常规的 `pipx upgrade algony-mymcp`。

最小试用可以直接前台启动：

```bash
mymcp serve
```

生产环境则是：

```bash
sudo mymcp install-service --yes
sudo systemctl start mymcp
```

`install-service` 会生成 admin token、可选的 metrics token，写入 `/etc/mymcp/.env`，再安装 systemd unit。

## CLI 变成了运维入口

另一个变化是，很多原来散在脚本里的动作，现在被收进了 `mymcp` CLI：

| 命令 | 作用 |
|---|---|
| `mymcp serve` | 前台运行 MCP server |
| `mymcp install-service` | 安装 systemd 服务 |
| `mymcp uninstall-service` | 卸载 systemd 服务 |
| `mymcp token list/add/revoke` | 管理 ro/rw token |
| `mymcp token rotate-admin` | 轮换 admin token |
| `mymcp token rotate-metrics` | 轮换 metrics token |
| `mymcp doctor` | 诊断环境、依赖和可观测性状态 |
| `mymcp version` | 查看版本 |

这个变化背后的意义是：`mymcp` 不只是一个 HTTP server，而是开始有了自己的“生命周期管理界面”。

2.x 里环境变量前缀也统一成了 `MYMCP_*`。例如以前的 `MCP_TOKEN_FILE` 这类配置，现在对应到 `MYMCP_TOKEN_FILE`。

## 可观测性：从 audit log 到 OpenTelemetry

上一篇已经提过 audit log。那时的重点是：AI 调了什么 tool、参数是什么、成功还是失败、耗时多久，至少要能回看。

现在 2.x 的可观测性明显往前走了一步：`mymcp` 开始支持 OpenTelemetry 的三件套：

* metrics；
* traces；
* logs。

默认安装就支持 Prometheus pull：

```bash
curl -H "Authorization: Bearer $MYMCP_METRICS_TOKEN" \
  http://your-server:8765/metrics
```

如果从一开始就要启用 OTLP extra，可以这样安装：

```bash
pipx install 'algony-mymcp[otlp]'
```

如果你已经用 pipx 安装过 mymcp：

```bash
pipx install algony-mymcp
```

后来才发现还想给这个已安装的 mymcp 补装可选依赖，比如 OTLP 相关依赖，那么可以用：

```bash
pipx inject algony-mymcp 'algony-mymcp[otlp]'
```

pipx inject 的作用是：往某个 pipx 已创建的隔离虚拟环境里，再安装额外的 Python 包或 extra 依赖。

再配置标准 OTel 环境变量，就可以把指标、链路和日志推到 Grafana Cloud、OpenTelemetry Collector、Tempo、Loki、Mimir 等后端：

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT="https://your-otlp-endpoint/otlp"
export OTEL_EXPORTER_OTLP_HEADERS="Authorization=Basic ..."
export OTEL_SERVICE_NAME=mymcp

mymcp serve
```

这跟 audit log 是两层东西：

* audit log 解决“谁用哪个 token 调了哪个 tool”这种安全审计问题；
* OpenTelemetry 解决“服务是否健康、哪个 tool 慢、错误率多少、某个请求在哪一步出问题”这种运行观测问题。

还有 `/metrics` 不是直接裸奔的公开端点，而是需要 metrics token。

## Grafana 面板也准备好了

源码里已经带了 Grafana dashboard，例如：

* `deploy/observability/dashboard.json`
* `deploy/grafana/mymcp-dashboard.json`
* `deploy/grafana/mymcp-logs-dashboard.json`

指标面板主要看这些内容：

* tool call rate；
* tool latency percentiles；
* error rate；
* HTTP request rate；
* process RSS / CPU / open file descriptors。

日志和 trace 面板则重点围绕 `request_id`、`trace_id`、`span_id` 做关联。这样从一个慢请求跳到对应日志，再从日志跳到 trace，会比单纯翻 `journalctl` 清楚很多。

这也说明 `mymcp` 的定位在变：它不是只考虑“能不能连上 Claude / Cursor”，而是在考虑“长期跑在一台机器上，出了问题怎么定位”。

## 大文件和二进制传输

还有一个很实用的变化：MCP tools 从原来的文本文件读写，扩展出了两个文件传输工具：

| tool | 权限 | 作用 |
|---|---|---|
| `prepare_upload` | rw | 生成一次性上传 URL |
| `prepare_download` | ro | 生成一次性下载 URL |

这个设计不是把文件内容 base64 塞进 MCP 消息里，而是让 tool 返回一个短小的签名 URL，然后客户端用普通 HTTP 上传或下载。

好处很明显：

* 二进制文件不会进入 LLM context；
* 大文件不会把上下文撑爆；
* URL 是一次性的；
* ticket 有过期时间；
* 路径、字节数、权限都可以约束；
* 仍然复用 protected paths 和 audit log。

这让 `mymcp` 从“文本级文件操作”往“真实远程机器操作”又走了一步。比如上传一个安装包、下载一份日志归档、取回生成的报告，都不再需要绕道让大模型读写一大坨文本。
