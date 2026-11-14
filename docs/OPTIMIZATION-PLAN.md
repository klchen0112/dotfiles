# Dotfiles 优化计划

审查日期：2026-11-14。基于当前工作树，包括已有的暂存与未暂存改动。

结论：继续沿用 den / aspect / role 的现有结构。优先修复激活脚本和磁盘脚本的具体缺陷，闭环生成配置与验证流程，再做少量模块拆分。尚无性能基线，不把 input 数量、模块数量或重复 import 直接视为性能瓶颈。

本轮交付为计划；没有修改现有配置、更新 lock、执行部署或切换系统。下列任务均待实施。预计耗时是主动工作时间，不包含下载、大型构建与跨机器验证。

## 已完成的检查

| 检查 | 结果与边界 |
| --- | --- |
| Nix 语法 | 148 个 `.nix` 文件全部通过 `nix-instantiate --parse`；不代表完整模块求值或构建通过 |
| 命令入口 | `just --list` 成功 |
| 磁盘脚本静态检查 | `scripts/iso-burn.sh`、`scripts/create-subvolumes.sh` 均通过 `bash -n` 与 ShellCheck |
| flake 元数据 | 离线读取成功；50 个根 input，119 个 lock 节点（包含 root） |
| 现有检查项 | `checks.x86_64-linux` 已有 `check-flake-file`、`pre-commit`、`treefmt`；本轮只查询名称，没有运行这些 derivation |
| Mac 远程构建配置 | 两台 Linux builder 均被求值为 `aarch64-darwin`；`nix.distributedBuilds` 为 `false`，所以是启用前需要修复的配置缺陷 |
| Hermes dry-run | 使用临时目录与假环境文件复现：dry-run 仍追加内容；未读取真实凭证 |
| 未覆盖范围 | 全主机求值、完整 `nix flake check`、系统/ISO 构建、实际 SSH/远程部署、模型服务运行、性能测量 |

## 优先级与执行顺序

P1 为已确认的写入行为缺陷，应先处理；P2 为配置一致性、可恢复性和维护流程；P3 为有测量依据后再决定的优化。

| 顺序 | 优先级 | 工作包 | 预计投入 | 完成标准 |
| --- | --- | --- | --- | --- |
| 1 | P1 | Hermes 激活脚本遵守 dry-run | 1–3 小时 | dry-run 无写入；正常执行幂等；失败保留旧文件 |
| 2 | P1 | 磁盘脚本验证目标与失败条件 | 半天–1 天 | 卸载失败不刻盘；错误挂载不创建子卷；不覆盖既有测试文件 |
| 3 | P2 | 生成 flake、lock、安装工具保持一致 | 2–4 小时 | 已有 `check-flake-file` 通过；安装器来自锁定 input |
| 4 | P2 | 连接开发、求值与部署检查 | 半天–1 天 | 检查不修改文件；单机部署默认检查；工具由 devShell 提供 |
| 5 | P2 | 修正远程构建平台与 SSH 复用配置 | 1–3 小时 | Linux builder 平台正确；SSH 不同端口使用不同 socket |
| 6 | P2 | 拆开 init 的通用配置和磁盘配置 | 半天 | init 行为保持一致；ISO 不再继承后撤销真实磁盘配置 |
| 7 | P2 | 声明推理服务配置与恢复步骤 | 半天–1 天 | preset 可恢复；缺模型时错误明确；启动时机有记录 |
| 8 | P2/P3 | 更新使用文档，建立性能基线 | 半天起 | 文档命令可执行；后续性能改动有前后数据 |

建议分批提交：第一批完成 1–2；第二批完成 3–5；第三批完成 6–8。实施前记录现有工作树状态，仅暂存本轮相关文件或 hunk，保留已有改动。

## 1. Hermes 激活脚本：完整保护写入

**证据：**[modules/llm/hermes-agent.nix:53](/home/klchen/dotfiles/modules/llm/hermes-agent.nix:53) 只有 `install` 受 `$DRY_RUN_CMD` 控制，第 56–57 行的重定向与 `cat` 仍写入 `.env`。假数据复现中，文件由 1 行变为 3 行，原有 0644 权限未被修正，因为 `install -m 0600` 没有执行。

- [ ] 把整个环境文件合并操作置于 Home Manager 的 `run` / `DRY_RUN` 控制下；不能只在带 `>>` 的命令前添加 `run`，重定向本身也必须受保护。
- [ ] 先验证输入可读，在目标目录生成权限 0600 的临时文件，完成后原子替换；失败时保留旧 `.env`。
- [ ] 保留现有的 `sops-nix` 后置依赖，防止首次激活时密钥尚未解密。
- [ ] 用假数据覆盖：已有目标 dry-run、目标不存在 dry-run、连续两次正常执行、输入缺失。检查内容、mtime、权限和失败后的文件状态。

Home Manager 官方要求 activation 幂等并遵守 dry-run；`DRY_RUN_CMD` 自 24.05 起已弃用，推荐 `run`。参见 [activation 选项](https://nix-community.github.io/home-manager/options/home-manager/home.html#home.activation) 和 [24.05 说明](https://nix-community.github.io/home-manager/release-notes/rl-2405.html)。

## 2. 磁盘脚本：失败即停止，校验真实对象

**证据 A：**[scripts/iso-burn.sh:47](/home/klchen/dotfiles/scripts/iso-burn.sh:47) 用 `|| true` 忽略卸载失败后继续 `dd`。第 33 行只检查块设备，分区路径也能通过；输入 `/dev/sdb1` 时，`/dev/sdb1?*` 不会匹配该分区本身。

- [ ] 规范化设备路径，使用 `lsblk` / `findmnt` 校验整盘及其子设备；确认信息包含路径、型号、容量和序列号（如可用）。
- [ ] 拒绝当前系统关键挂载所在设备；卸载失败或仍有挂载时退出，不执行 `dd`。
- [ ] 用模拟命令测试忙碌分区、分区路径、系统盘、正常目标，断言前三种不调用 `dd`；不使用真实磁盘做自动测试。

**证据 B：**[scripts/create-subvolumes.sh:55](/home/klchen/dotfiles/scripts/create-subvolumes.sh:55) 只判断 `TOP` 是否为挂载点；新挂载没有指定注释要求的 `subvolid=5`。第 116 行以固定 `.subvol-compression-test` 文件名写入再删除，可能覆盖既有同名文件。

- [ ] 检查 `TOP` 的设备、文件系统与顶层子卷；新挂载明确使用 `subvolid=5`。
- [ ] 已挂载的目标也核对来源与子卷，不能仅凭“已挂载”跳过。
- [ ] 测量文件改用 `mktemp` 与 `trap`，压缩测量改为可选操作。
- [ ] 验收：错误设备/子卷立即退出；重复执行幂等；dry-run 无写入；既有文件不变，失败后无测试文件残留。

## 3. 生成配置与依赖版本：闭环已有机制

**证据：**[modules/llm/default.nix:21](/home/klchen/dotfiles/modules/llm/default.nix:21) 的 ROCm input 为 `ROCmFPX/ROCmFPX`，而 [flake.nix:140](/home/klchen/dotfiles/flake.nix:140) 仍为 `freriadoc/Avalon`；[modules/nix/caches.nix:13](/home/klchen/dotfiles/modules/nix/caches.nix:13) 与生成的缓存列表也不一致。这是当前编辑状态中的待同步项，不推断历史提交一直存在该问题。

- [ ] 以模块声明作为来源，确定本轮上游切换的最终值后运行 `just write`；不手改生成的 `flake.nix`。
- [ ] 检查生成 diff，按需要更新受影响的 lock 节点；避免把全量依赖升级混入结构调整。
- [ ] 执行已有 `check-flake-file`，不重复创建另一套生成检查；验收第二次生成无变化。
- [ ] 对重复的 cache URL / key 去重，同时保留已需要的签名 key；缓存取舍以实际可用性和命中情况为依据。
- [ ] [Justfile:46](/home/klchen/dotfiles/Justfile:46) 的 `disko/latest` 改为调用仓库 `inputs.disko` 暴露的安装 wrapper。相同 lock 和平台应得到相同安装工具 derivation。

## 4. 开发与部署：把已有检查接到常用入口

**证据：**[Justfile:12](/home/klchen/dotfiles/Justfile:12) 的 `lint` 实际执行会改文件的 `nix fmt`；[modules/fmt.nix:23](/home/klchen/dotfiles/modules/fmt.nix:23) 的 pre-commit 只配置 nixfmt，而 treefmt 覆盖多种语言；[modules/devshell.nix:23](/home/klchen/dotfiles/modules/devshell.nix:23) 的自定义 shell 没有显式连接 pre-commit 安装 hook，deploy 工具也未启用。[Justfile:72](/home/klchen/dotfiles/Justfile:72) 默认部署跳过检查。

- [ ] 区分 `fmt`（允许修改）与 `check-format`（只校验），复用 treefmt 作为格式规则来源。
- [ ] 检查最终 devShell 的 hook 与工具输出，补齐 deploy-rs 和需要的 hook 集成；不因源文件的空 `checks = {}` 就误删或重建现有自动 checks。
- [ ] 增加快速定点求值检查：role 合并/去重、host-only role 不自动进入用户、Linux/Darwin 平台隔离、builder 元数据。覆盖近期 role 调整的行为，而非测试实现细节。
- [ ] 接入 deploy-rs 的部署配置校验；默认 `deploy HOST` 执行检查，批量部署使用独立入口，明确区分检查与真正激活。
- [ ] 验证分层：语法/格式 → 关键选项求值 → 受影响主机完整求值 → 对应平台构建。NixOS、Darwin、WSL 与 ISO 各保留代表目标；完整构建使用对应平台 runner。
- [ ] 若增加 CI，调用相同本地入口，先运行便宜检查，再运行匹配平台的构建。无需一开始为所有主机做全量构建矩阵。

验收：检查结束后工作树不变；干净 devShell 能找到所需工具；故意注入错误配置时预检失败；单机部署只选择指定节点。

## 5. 远程构建与 SSH：修正客户端/服务端边界

**证据 A：**[a99r50/default.nix:172](/home/klchen/dotfiles/modules/hosts/a99r50/default.nix:172) 与 [i12400/default.nix:47](/home/klchen/dotfiles/modules/hosts/i12400/default.nix:47) 用调用端的 `pkgs.stdenv.hostPlatform.system` 声明远端能力；Mac 引入这两个 aspect 后均得到 `aarch64-darwin`。服务端均属于 `x86_64-linux`。当前 Mac 的 `distributedBuilds = false`，本轮未观察到实际错误调度。

- [ ] 两个 builder 的平台明确设置为 `x86_64-linux`，或读取服务端元数据；两处修正即可，无需新建复杂的主机注册框架。
- [ ] 记录 Mac 是否需要启用远程 Linux 构建；需要时才开启，并验证连接与一个小型 Linux derivation 的调度。
- [ ] 对 Mac 和 Linux 客户端求值，确认同一远端平台一致。当前 `maxJobs = 1` 仅作为调优候选，先测量内存和并发压力再提高。

Nix 使用远端声明的系统类型决定任务分配，参见 [官方分布式构建说明](https://nix.dev/tutorials/nixos/distributed-builds-setup.html)。

**证据 B：**[modules/ssh/default.nix:28](/home/klchen/dotfiles/modules/ssh/default.nix:28) 的 `ControlPath` 为 `%r@%h`，不包含端口；`ssh -G` 验证 22 与 2222 得到相同路径。仓库也没有创建 `.ssh/cm` 的声明。

- [ ] 使用包含连接身份的 `%C`，并声明创建权限 0700 的目录，或直接使用现有 `.ssh` 下的哈希路径。
- [ ] 验收同主机/用户不同端口路径不同；新 HOME 激活后无需手动创建目录即可使用连接复用。

## 6. init 与 initIso：按实际用途组合

**证据：**[modules/hosts/init/disko.nix:12](/home/klchen/dotfiles/modules/hosts/init/disko.nix:12) 把磁盘、持久化和回滚合入 `init-base`；[modules/hosts/init/default.nix:99](/home/klchen/dotfiles/modules/hosts/init/default.nix:99) 的 ISO 再用多处 `mkForce` 撤销，并保留 `/persist` 占位条目。此处是维护成本，不宣称当前 ISO 不能启动。

- [ ] `init-base` 保留通用工具和基础设置；将磁盘、持久化和回滚迁入独立 `init-storage` aspect，仅由 `init` 引入。
- [ ] `initIso` 直接组合基础与 ISO 配置，移除因继承磁盘设置而产生的覆盖及占位条目；保留确有用途的 ISO 覆盖。
- [ ] 改前/改后比较 `init` 的 `disko.devices`、`fileSystems`、持久化目录和回滚 unit，保证行为一致。
- [ ] 确认 `initIso` 不再带真实磁盘配置；准备发布 ISO 时构建并做 VM 启动验证。

## 7. 推理服务：让重建后的恢复过程可重复

**证据：**[modules/llm/default.nix:139](/home/klchen/dotfiles/modules/llm/default.nix:139) 的 ROCm 服务依赖仓库外的模型 preset；该 role 在 [i12400/default.nix:17](/home/klchen/dotfiles/modules/hosts/i12400/default.nix:17) 对用户启用。服务设置每 5 秒重试，尚未声明缺文件检查；配置依赖已确认，实际新机恢复失败尚未验证。

- [ ] 将非机密 preset 纳入声明配置，模型权重继续保留在外部目录，记录下载/校验/恢复步骤。
- [ ] 将用户名、模型目录、模型名和后端参数集中到少量选项或局部参数，减少改模型时编辑长命令的成本。
- [ ] 添加适当的路径条件或启动前检查，缺 preset / 权重时给出明确原因。
- [ ] 明确“用户登录后可用”还是“开机即用”；只有后者才配置对应的用户常驻运行机制。
- [ ] 验收一次新 HOME 恢复、一次缺文件启动；若要求开机即用，再验证未登录状态的服务接口。

暂不处理当前注释禁用的 Strata / vLLM 部署逻辑，不把 host-only Vulkan role 误判成已启用的用户服务。

## 8. 文档与有依据的性能优化

**文档证据：**[Justfile:66](/home/klchen/dotfiles/Justfile:66) 的生成目标仍是不存在的 `configurations/nixos/init/`；[README.org:159](/home/klchen/dotfiles/README.org:159) 要求修改生成的 `flake.nix`，第 162 行使用仓库没有对应 Makefile 的 `make up`。

- [ ] 修复 `gen HOST` 的目标路径，明确硬件配置输出位置与覆盖行为。
- [ ] README 改为“主机/role 定义 → `just write` → 检查 → 构建 → 激活”的实际流程；添加失败回滚和新机恢复步骤。
- [ ] 目录树缩减为关键目录职责与主机表，清理旧名称和失效命令。
- [ ] 添加按 input 更新的入口，并记录每次更新的受影响主机和验证结果。

**性能候选（P3，先测量）：**[modules/pkgs.nix:30](/home/klchen/dotfiles/modules/pkgs.nix:30) 为 perSystem 包集合开启 CUDA，并提供 stable/unstable 集合。它的作用范围不能直接推断为所有主机包；先检查最终 derivation 和缓存命中，再决定是否收窄到相关包/role。

- [ ] 对一个固定的 Linux 配置和 Mac 配置记录求值耗时、构建闭包大小、待构建/待下载数量；冷/热缓存条件分别记录。
- [ ] 盘点 50 个根 input 的实际消费者；仅移除确认不用的依赖。检查 `follows` 兼容性，避免为减少节点强行统一有版本要求的依赖。
- [ ] 核实 CUDA 配置是否扩大实际重建范围，再决定局部 override；以相同 lock 和测试目标比较改前/改后。
- [ ] 未使用包另列清理项，例如 [SF-Pro/package.nix:14](/home/klchen/dotfiles/pkgs/by-name/SF-Pro/package.nix:14) 的 `rev = "master"` 配固定 hash：若保留，应 pin 对应提交；未证明被使用前不作为紧急问题。

不承诺未测量的提速比例，不以减少文件数作为验收标准。只有耗时、下载/构建量或维护步骤得到可复现改善，才保留相应性能调整。
