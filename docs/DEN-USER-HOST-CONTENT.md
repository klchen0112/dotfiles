# den 的 #694 警告：a99r50 只通过 transition default 收到 nixos 内容

审查日期：2026-11-20。对象：`nixos-rebuild switch --flake .#a99r50` 求值期出现的 `evaluation warning`。
den 版本以本机 store 中的锁定源码为准：`/nix/store/k3fgjcckicwml7lda49f38nnrxbwlb0a-source`（下文简写 `$DEN`），对应 `flake.lock` 的 `den.rev = 2527e4d234cc4b0a85cdf8de1d60a28a00c44d5e`。

当前实现跟随 den 默认分支。第 7 节记录了移除 0.19 回退的方法和验证命令。

## 初次审查结论

警告不是配置错误，是 den v0.20.0 引入的 #694 迁移窗口在提示：a99r50 有 4 处 nixos 类配置由**用户作用域（user scope）**里的 aspect 写入，目前能到 host 上，靠的是 den 的过渡默认策略（`user-aspects` / `mutual-provider` 的 transition-default 形式）。这个默认在 den 计划于 2027-01-01 发布的那一版里被删除（`$DEN/nix/lib/migrations.nix:6`），删掉后这 4 处内容会留在用户侧，a99r50 会少掉 SSH 白名单里的 `remotebuild`、root 的 ssh key、`trusted-users`、以及 `home-manager.extraSpecialArgs.inputs`。

三条建议对应三种不同处理：把 `den.batteries.user-aspects` 显式挂在 host 上（保持今天行为，永久化），用 `den.batteries.mutual-provider`（只负责 `provides.to-hosts` / `provides.<host>`，本仓库这四条都不是这一类），或 `den.migrations.user-host-content.acknowledged = true`（立刻切到终态：既静默警告，也立刻改变行为）。

对本仓库的建议：**不要先 acknowledge**。先把 `den.aspects.klchen` / `den.aspects.root` / `den.aspects.skill` 里的 host 类内容搬到 host 侧（`den.aspects.a99r50.nixos` 或 `den.default.nixos`），把账号级字段挪到 `user` 类，然后才设 acknowledged；如果只想先止血，就在 `modules/den.nix` 加一行 `den.schema.host.includes = [ den.batteries.user-aspects ];`。

## 警告原文

```
evaluation warning: den: a99r50 receives nixos content only through den's transition default, which ends 2027-01-01:
                      - from klchen (klchen)
                      - from klchen (os@klchen)
                      - from klchen (os@skill)
                      - from root (root)
                    If the host should have it, include the aspect on the host or add the battery explicitly: `den.schema.host.includes = [ den.batteries.user-aspects ];` for a user's own content, `den.schema.host.includes = [ den.batteries.mutual-provider ];` for `provides.to-hosts`. If it's meant to stay with the user, set `den.migrations.user-host-content.acknowledged = true;` to adopt the new behaviour now. See https://github.com/denful/den/issues/694.
```

## 1. #694 改了什么

### 1.1 语义

内容属于写入它的 entity。用户 aspect 写在 `nixos` / `darwin` / `os` 类里的东西，不再因为「这个用户在某个 host 上」就自动成为那个 host 的配置；它只能通过**点名接收者的投递**（`provides`、`receiver = host` 的 policy、显式的 `user-aspects` 接受）到达 host。官方发布说明的表述：“a user's aspects stop leaking into the hosts it's on … From 2027-01-01, that content stays with the user”（<https://github.com/denful/den/releases/tag/v0.20.0>）。

### 1.2 代码上的三条通道

1. **接受键**。`user-aspects` 电池把 host 的接受写成上下文键：显式形式 `den-user-aspects/<host.id_hash>/…`，过渡默认形式 `den-user-aspects/default/<host.id_hash>`（`$DEN/nix/lib/acceptance.nix:8`、`:11`）。判定函数 `accepts` 只要看到 default 键就返回 true（`$DEN/nix/lib/acceptance.nix:66-68`），而 `acceptsExplicitly` 只认显式键（`$DEN/nix/lib/acceptance.nix:35-40`）。
2. **两种边界**。合并 host 子树时，`acceptedUserScope` 用 `acceptance.accepts` 判断某个 user scope 是否被接受（`$DEN/nix/lib/aspects/fx/edges/materialize-unified.nix:138-147`）；`entityBoundary` 由它导出（`:148-150`），而终态用的 `explicitBoundary` 要求 `acceptsExplicitly`（`:153-163`）。也就是说：**今天** user scope 不是边界（内容照旧并入 host 的 class bucket），**终态** user scope 是边界（内容留在 user）。
3. **过渡默认**。两个电池各有一个「默认形式」policy，名字带 `transition-default`、写自己的键（`$DEN/modules/aspects/batteries/user-aspects.nix:84-86`；`$DEN/modules/aspects/batteries/mutual-provider.nix:30-34`），并在 `transitionActive` 为真时挂到 `den.default.includes`（`$DEN/modules/aspects/batteries/user-aspects.nix:98`；`$DEN/modules/aspects/batteries/mutual-provider.nix:48-51`）。`transitionActive` = `den.internal.transitionDefaults && !den.migrations.user-host-content.acknowledged`（`$DEN/nix/lib/migrations.nix:12-14`），移除日期常量 `removalDate = "2027-01-01"`（`$DEN/nix/lib/migrations.nix:6`）。非 host/user/home 的 entity kind（例如自带 class 的 guest）由 `resolve-entity.nix` 直接注入同样两个 policy（`$DEN/nix/lib/resolve-entity.nix:66-86`），并进入该 entity 的 includes（`$DEN/nix/lib/resolve-entity.nix:125`）。

### 1.3 警告是谁发的、为什么能列出「来源」

- 发射点：`checkLost`（`$DEN/nix/lib/aspects/fx/resolve.nix:49-74`）。字符串本身在 `:63`，逐条格式 `"  - from ${e.entity} (${e.aspect})"` 在 `:66-68`，条件是 `!den.lib.migrations.transitionActive || lost == []` 就直接放行（`:58`）。
- 调用点：每个 host 组装模块时 `checkLost (spec.name or hostScopeId) hostClass (materialized.__lostAt hostClass) (…)`（`$DEN/nix/lib/aspects/fx/resolve.nix:436-441`）。因为 host 输出是惰性实例化的（同文件 `mkInstantiateArgs` 的注释与 `spec.instantiate`），**只有被求值的 host 才会 warn**——所以 `.#a99r50` 只报 a99r50。
- 条目来源：`lostAt`（`$DEN/nix/lib/aspects/fx/edges/materialize-unified.nix:450` 起）。定义是「在嵌套 entity 的 bucket 里、但终态（defaults 关掉）不会到达 root 的内容」（同文件 `:441-449` 注释与实现），逐条给出 `{ scope; entity; aspect; }`；来源是未被投递覆盖的 nested scope 模块 + `defaultDelivered`（同文件 `:591-640` 一带的 `defaultDelivered` 与最终列表）。
- 另外，同一批数据被塞进 `_module.args.denTransitionDefaultLost`（`$DEN/nix/lib/aspects/fx/resolve.nix:71-74`），可以在 host config 里读出来做断言，测试比读 warning 文本更稳。

### 1.4 条目里的 `os@…` 是什么

class 模块的 key 由 class collector 生成为 `loc = "${param.class}@${baseIdentity}"`（`$DEN/nix/lib/aspects/fx/handlers/class-collector.nix:20`，`baseIdentity` 是 aspect 身份，见 `$DEN/nix/lib/aspects/fx/identity.nix:20-23`）。`lostAt` 展示前会 `removePrefix "${cls}@"`（`$DEN/nix/lib/aspects/fx/edges/materialize-unified.nix` 中 `identityOf`），`cls` 是 host 类（本例 `nixos`）。因此：

- nixos 类的条目显示为裸 aspect 名：`klchen`、`root`；
- `os` 类的条目保留自己的 class 前缀，显示为 `os@klchen`、`os@skill`——它们能出现，是因为 `os` 类被 `os-to-host` 路由按 path `[]` 就地并进 host 类（`$DEN/modules/aspects/batteries/os-class.nix:16-38`），模块 key 不变。

（推断，非源码直述：`nixos@…` 前缀被剥掉后剩下裸名，这一条由上面两处代码合成，没有实机求值验证。）

## 2. 三种补救各自的精确含义

| 手段 | 挂在哪 | 实际接受什么 | 是否改变今天的行为 |
| --- | --- | --- | --- |
| `den.batteries.user-aspects` | host 侧：`den.schema.host.includes`、`den.aspects.<host>.includes`、`den.hosts.<sys>.<host>.includes`，可带 `{ users = [ … ]; }` | 用户 aspect 树写进 host 类的**全部**内容（含 `os` 等自定义类经路由进入 host 类）、用户在自身作用域里 policy 产出的内容、host-rooted `den.lib.aspects.resolve` | 不改变；只是把「默认给」变成「显式要」 |
| `den.batteries.mutual-provider` | host 侧 | 只接受用户 `provides.to-hosts` / `provides.<host>` 的投递，且只认该 provider 名下记录的位置（provenance 限定） | 不改变；本仓库这四条都不属于这一类 |
| `den.migrations.user-host-content.acknowledged = true` | 全局（`modules/den.nix`） | 关掉两个 transition default | **改变**：立刻切到终态 |

依据：

- `user-aspects`：描述与三种声明形式在 `$DEN/modules/aspects/batteries/user-aspects.nix:4-12`；接受键按参数集命名、`users = null` 表示全部（`:19-20`、`:50-62`）；在 user scope 里是空操作（`:56` 的 `!(ctx ? user)` gate）。
- `mutual-provider`：描述写明「Delivers what a user provides to its hosts (`provides.to-hosts`, `provides.<host>`)」，且「A host or fleet opts out with an exclude」（`$DEN/modules/aspects/batteries/mutual-provider.nix:3-13`）；实现只发布 `mutualProviderKey`（`:38-43`），并在 `lostAt` 中按 `__fromProvenance` 只读该 provider 名下的位置（`$DEN/nix/lib/aspects/fx/edges/materialize-unified.nix:499-520` 的 `receiverRoutes` / `provenanceRead`）。
- 两者独立：文档明确「With `mutual-provider` excluded and `user-aspects` included, a user's `to-hosts` content still arrives through `user-aspects`」（`$DEN/docs/src/content/docs/explanation/crossing-scopes.mdx:362-364`）。
- `acknowledged`：选项声明在 `$DEN/modules/options.nix:210`（描述明确「Setting this turns both defaults off: that content stays with the user, and only batteries included explicitly apply」），只被 `migrations.nix:12-14` 读，作为 `transitionActive` 的取反项。`transitionActive` 又被 `resolve-entity.nix:70`、`user-aspects.nix:98`、`mutual-provider.nix:48-51`、`resolve.nix:58` 读。
  因此它是**双重开关**：既让 `checkLost` 不再报告（`resolve.nix:58`），也立刻让内容真的留在用户侧。它不是「只静音」的开关。
  den 自己的测试套件就是靠内部选项 `den.internal.transitionDefaults = false` 来跑终态（`$DEN/modules/options.nix:222-228`、`$DEN/nix/lib/migrations.nix:12-14`）。

## 3. 本仓库为什么命中：四条来源逐条对照

host 侧现状（已核对）：

- `modules/den.nix:67-71`：`den.schema.user.includes = [ roleClass hmPlatforms den.provides.mutual-provider ]`；**没有** `den.schema.host.includes`（同文件 59-73 行整段可见）。
- `modules/defaults.nix:64-73`：`den.default.includes = [ <den/mutual-provider> <den/hostname> … ]`。`<den/x>` 通过 `den.batteries.x` 解析（`$DEN/nix/lib/den-brackets.nix:41-60`），而 `den.provides` 是 `den.batteries` 的别名（`$DEN/modules/aspects/batteries.nix:5-8`）。所以 mutual-provider 在任何 entity 上都被**显式**包含了一次。
- a99r50 声明了两个用户：`klchen`、`root`（`modules/hosts/a99r50/default.nix:7-36`），与警告里的两个 entity 一一对应。

| 警告条目 | 定义位置 | 贡献的 host 类（nixos）设置 | 应归属 |
| --- | --- | --- | --- |
| `from klchen (klchen)` | `modules/users/klchen.nix:35-56`（`den.aspects.klchen.nixos`） | `services.openssh.settings.AllowUsers = [ "klchen" "remotebuild" ]`、`users.users.root.openssh.authorizedKeys.keys`、`users.users.klchen.isNormalUser`、`programs.bash.enable`、`users.users.klchen.initialHashedPassword`、`users.users.klchen.extraGroups` | SSH 白名单与 `trusted-users` 属 host 级（`den.aspects.a99r50.nixos` 或 `den.default.nixos`）；账号字段属 `user` 类 |
| `from klchen (os@klchen)` | `modules/users/klchen.nix:57-59`（`den.aspects.klchen.os`） | `nix.settings.trusted-users = [ "klchen" ]` | host 级 |
| `from klchen (os@skill)` | `modules/llm/skill.nix:41-45`（`den.aspects.skill.os`：`home-manager.extraSpecialArgs.inputs = inputs`），由 `modules/users/klchen.nix:158`、`:166` 两处 `<skill>` include 带入 | 给 host 的 home-manager 传 `inputs` 到所有 HM 模块的 `extraSpecialArgs` | host 级（所有 HM 用户都要） |
| `from root (root)` | `modules/users/root.nix:4-13`（`den.aspects.root.nixos`） | `nix.settings.trusted-users = [ "root" ]`、`users.users.root.isSystemUser`、`users.users.root.initialHashedPassword`、`services.openssh.settings.AllowUsers = [ "root" ]` | host 级（系统账号） |

为什么没有 `provides` 类条目：a99r50 的 `provides` 只有 `homeManager` 类内容（`modules/hosts/a99r50/default.nix:39-59` 的 `provides.klchen`），不在 nixos bucket 里；而且 mutual-provider 已在 `den.default` 中显式包含（`modules/defaults.nix:70`），`provides.to-hosts` 本来就走显式投递。所以四条警告全部来自 `user-aspects` 通道。

（推断，需注意）：`modules/den.nix:70` 把 `den.provides.mutual-provider` 放在 **user** 作用域，而该 policy 的实现要求 `host` 已绑定且 **未**绑定 `user`（`$DEN/modules/aspects/batteries/mutual-provider.nix:22-26`），在用户作用域上是空操作。真正让它生效的是 `modules/defaults.nix:70`。这条为代码推断，未做求值验证。

### 2027-01-01 之后（或现在 acknowledge）会掉什么

按终态 `explicitBoundary`（`materialize-unified.nix:153-163`）计算，a99r50 会失去：

1. `services.openssh.settings.AllowUsers` 里的 `"remotebuild"`（`modules/users/klchen.nix:36-39`）。`modules/defaults.nix:28-31` 只给 `[ "klchen" "root" ]`，而 a99r50 的远程构建用的是 `sshUser = "remotebuild"`（`modules/hosts/a99r50/default.nix:166-179` 的 `nix.buildMachines`）——远端构建会直接失败。
2. `users.users.root.openssh.authorizedKeys.keys` 与 `users.users.root` 的密码/isSystemUser（`modules/users/klchen.nix:40`、`modules/users/root.nix:7-11`）——root 无法登录。
3. `nix.settings.trusted-users` 的 `"klchen"` / `"root"`（`modules/users/klchen.nix:58`、`modules/users/root.nix:6`）。
4. `home-manager.extraSpecialArgs.inputs`（`modules/llm/skill.nix:44`）——依赖 `inputs` 的 HM 模块（hermes、agent-skills 等）会因为缺参数而与今天不同，最坏情况是求值报错。
5. `users.users.klchen.extraGroups`（`"wheel" "docker" "hermes" …`）与 `initialHashedPassword`（`modules/users/klchen.nix:43-55`）。注意用户本身不会消失：`<den/define-user>`（`modules/users/klchen.nix` includes 的首项）用 `policy.provide { receiver = host; path = [ "users" "users" <name> ]; … }` 显式投递 `name`/`home`/`isNormalUser`（`$DEN/modules/aspects/batteries/define-user.nix:26-58`），属点名投递，不受 #694 影响。

## 4. 建议（按风险从低到高）

### 方案 A：先止血，零行为变化

在 `modules/den.nix` 的 `den.schema.user.includes`（第 67-71 行）**旁边**加：

```nix
den.schema.host.includes = [ den.batteries.user-aspects ];
```

效果：所有 host 显式接受其所有用户的 host 类内容，四条警告消失，今天的行为一字不变，2027 后也不会变。代价：把「用户 aspect 能改任意 host」的旧语义固化成永久设计，且没有缩小作用域。

如果只想先让 a99r50 干净、暂时不动全局，可以写在 host 侧（与 `den.aspects.${machine}.includes` 并列，`modules/hosts/a99r50/default.nix:183`）：

```nix
den.aspects.a99r50.includes = [ (den.batteries.user-aspects { users = [ "klchen" "root" ]; }) ];
```

文档给出的三种声明形式见 `$DEN/docs/src/content/docs/explanation/crossing-scopes.mdx:341-346`；带 `{ users = … }` 时其他用户不被接受。

### 方案 B：按归属搬内容，然后 acknowledge（推荐）

1. 在 `modules/hosts/a99r50/default.nix` 的 `den.aspects.${machine}`（第 38 行起）里加 `nixos = { … }`，把 `AllowUsers`（含 `remotebuild`）、`users.users.root.*`、`nix.settings.trusted-users`、`programs.bash.enable` 搬过去；root 账号若所有 host 都要，放 `modules/defaults.nix` 的 `den.default.nixos`（同文件第 10 行起）。
2. 账号级字段改用 `user` 类：`den.aspects.klchen.user.extraGroups`、`.user.initialHashedPassword`。`user` 类经 `user-to-host` 路由到 `users.users.<name>`，带 `receiver = host`（`$DEN/modules/aspects/batteries/os-user.nix:59-71`），属点名投递，不在警告范围内。
3. `skill` 的 `os` 设置搬到 host 侧：`den.aspects.skill.nixos.home-manager.extraSpecialArgs.inputs = inputs;`（或放进 a99r50 的 aspect）。它本来就是「给这台机器的所有 HM 用户」的配置，不是某个用户的配置。
4. 上述三条完成后，在 `modules/den.nix` 加 `den.migrations.user-host-content.acknowledged = true;`。

代价：搬动改变了配置的写入位置，需要逐项确认选项来源与合并顺序（例如 `AllowUsers` 是 list，多处定义会 concat）。收益：警告消失且语义正确，2027 的 release 删掉过渡默认时不需要再动。

顺序很重要：**不要先 acknowledge**。acknowledged 会立刻切到终态（`$DEN/nix/lib/migrations.nix:12-14` + `$DEN/modules/options.nix:210` 的描述），第 3 节列的 5 项会当即消失，是静默的行为变化，而不是编译期错误。

### 方案 C：只用 mutual-provider（本仓库不适用）

`den.schema.host.includes = [ den.batteries.mutual-provider ];` 只能让 `provides.to-hosts` / `provides.<host>` 的投递变显式（`$DEN/modules/aspects/batteries/mutual-provider.nix:3-13`）。本仓库这四条都是用户 aspect 自己写的 `nixos`/`os` 内容，不是 `provides`，所以这条不解决问题。

### 验证手段

- 读 host config 里的 `_module.args.denTransitionDefaultLost`（`$DEN/nix/lib/aspects/fx/resolve.nix:71-74`），比读 warning 文本稳定；改造后它应为 `[ ]`。
- 迁移期间可先加方案 A 的 battery、同时观察 `denTransitionDefaultLost`，确认搬动没有遗漏，再删 battery + acknowledge。

## 5. 升级 den 是否是替代方案

不是。

- `flake.lock` 的 den 节点：`rev = 2527e4d234cc4b0a85cdf8de1d60a28a00c44d5e`、`lastModified = 1794964760`（`flake.lock` 的 `nodes.den`；epoch 1794964760 ≈ 2026-11-18，按 lock 内其他节点的同量级时间戳换算，属推断而非文件直述）。
- releases 页面显示 `v0.20.0 - Good Fences` 发布于 11 月 10 日，且这是当前最新版本（<https://github.com/denful/den/releases>）。v0.20.0 正是 #694 落地版本，其 "Fixes reported after the first tag" 段列出 #761–#772 等修（同一页面）。
- 因此锁定的 rev 已在 v0.20.0 之后（含这些后续修），`den.migrations.user-host-content.acknowledged` 与 `den.batteries.user-aspects` / `mutual-provider` 的选项名在 pinned 源码与 main 上一致（`$DEN/modules/options.nix:210`；`$DEN/modules/aspects/batteries/user-aspects.nix:90-93`；`$DEN/modules/aspects/batteries/mutual-provider.nix:38-43`）。
- 2027-01-01 的「移除」是计划中的一次 release，不是按时间自动生效：文档明确写「The date names that release; nothing in den reads the clock, so updating den is what changes behaviour」（`$DEN/docs/src/content/docs/explanation/crossing-scopes.mdx:382-386`），代码里唯一读日期的地方是消息字符串（`$DEN/nix/lib/aspects/fx/resolve.nix:63`）与选项描述插值（`$DEN/modules/options.nix:210-218`）。

## Verification

本次会话只有文件读取工具（无 shell），下文是实际使用的读取路径；`grep -n` 块是等价的复现命令，所有行号来自对同一文件的定点 `read`（用 offset/limit 与内容比对确定的，不是抄 grep 输出）。

等价的 grep 命令（读者可复现）：

```bash
DEN=/nix/store/k3fgjcckicwml7lda49f38nnrxbwlb0a-source

grep -n "receives nixos content only through" $DEN/nix/lib/aspects/fx/resolve.nix
grep -n "removalDate\|transitionActive"          $DEN/nix/lib/migrations.nix
grep -n "user-host-content.acknowledged\|internal.transitionDefaults" $DEN/modules/options.nix
grep -n "userAspectsDefaultKey\|acceptsExplicitly\|^  accepts =" $DEN/nix/lib/acceptance.nix
grep -n "transitionDefaults\|includes = selfProvide" $DEN/nix/lib/resolve-entity.nix
grep -n "transitionDefault\|den.default.includes" $DEN/modules/aspects/batteries/user-aspects.nix \
                                                  $DEN/modules/aspects/batteries/mutual-provider.nix
grep -n "acceptedUserScope\|explicitBoundary\|lostAt\|defaultDelivered" \
        $DEN/nix/lib/aspects/fx/edges/materialize-unified.nix
grep -n 'loc = "${param.class}@' $DEN/nix/lib/aspects/fx/handlers/class-collector.nix
grep -n "os-to-host\|fromClass = \"os\"" $DEN/modules/aspects/batteries/os-class.nix
grep -n "user-to-host\|path = \[" $DEN/modules/aspects/batteries/os-user.nix
grep -n "provides\" \] \[ \"batteries\"" $DEN/modules/aspects/batteries.nix
grep -n "denTransitionDefaultLost" $DEN/nix/lib/aspects/fx/resolve.nix
grep -n "policy.provide" -A12 $DEN/modules/aspects/batteries/define-user.nix

grep -n "den.schema.user.includes\|den.schema.host\|den.provides.mutual-provider" modules/den.nix
grep -n "den.default.nixos\|den.default.includes\|<den/mutual-provider>\|AllowUsers" modules/defaults.nix
grep -n "user = {\|nixos = {\|os = {\|AllowUsers\|trusted-users\|extraGroups\|<skill>" modules/users/klchen.nix
grep -n "" modules/users/root.nix
grep -n "den.aspects.skill.os\|extraSpecialArgs" modules/llm/skill.nix
grep -n "den.hosts\|users.root\|den.aspects.\${machine}\|nix.buildMachines\|includes =" \
        modules/hosts/a99r50/default.nix
grep -n "\"den\"" -A8 flake.lock
```

实际读取（每条行号都来自对同一路径的定点 read）：

- `$DEN/nix/lib/migrations.nix` 全文（15 行）：`removalDate` 在 6，`transitionActive` 在 12-14。
- `$DEN/nix/lib/acceptance.nix`：`mutualProviderRoot` 在 6，`userAspectsDefaultKey` 在 11，`accepts` 在 66-68。
- `$DEN/modules/options.nix`：210 为 `den.migrations.user-host-content.acknowledged`（描述至 218），222-228 为内部 `transitionDefaults`。
- `$DEN/nix/lib/resolve-entity.nix`：66-86 `transitionDefaults`，125 `includes = selfProvide ++ schemaIncludes ++ transitionDefaults ++ …`。
- `$DEN/nix/lib/aspects/fx/resolve.nix`：49-74 `checkLost`（63 为消息串、71-74 注入 `denTransitionDefaultLost`），436-441 调用点。
- `$DEN/nix/lib/aspects/fx/edges/materialize-unified.nix`：100-163（`acceptedUserScope` 138、`entityBoundary` 148、`explicitBoundary` 153），448-478（`lostAt` 在 450）。
- `$DEN/modules/aspects/batteries/user-aspects.nix`：4-12 描述，84-86 默认 form，90-93 电池定义，98 `den.default.includes`。
- `$DEN/modules/aspects/batteries/mutual-provider.nix`：3-13 描述，30-34 默认 form，38-43 电池定义，48-51 `den.default.includes`。
- `$DEN/modules/aspects/batteries/os-class.nix` 全文（39 行）：`os-to-host` 路由，`path = [ ]`。
- `$DEN/modules/aspects/batteries/os-user.nix` 全文（约 80 行）：`user-to-host`，`path = [ "users" "users" user.userName ]`，`receiver = host`。
- `$DEN/modules/aspects/batteries/define-user.nix`：26-58 `policy.provide`（`users.users.<name>`）。
- `$DEN/modules/aspects/batteries.nix`：5-8 `provides` / `_` 别名到 `batteries`。
- `$DEN/nix/lib/den-brackets.nix`：41-60 `<den/x>` 解析。
- `$DEN/nix/lib/aspects/fx/identity.nix`：20-29 身份键构造。
- `$DEN/nix/lib/aspects/fx/handlers/class-collector.nix`（main 版，与 pinned 同构）：`loc = "${param.class}@${baseIdentity}"`。
- `$DEN/docs/src/content/docs/explanation/crossing-scopes.mdx`：330-450（`user-aspects` 三种形式 341-346、两电池独立性 362-364、不读时钟 382-386、示例警告块 389-390）。
- 仓库：`modules/den.nix`（60-73）、`modules/defaults.nix`（10 起、28-31、64-73）、`modules/users/klchen.nix`（31-59、145-193）、`modules/users/root.nix`（4-13）、`modules/llm/skill.nix`（41-45）、`modules/hosts/a99r50/default.nix`（7-36、38-59、166-179、183）、`flake.lock` 的 `nodes.den`。
- 网络：<https://github.com/denful/den/releases>（v0.20.0 说明与发布日期）、<https://github.com/denful/den/blob/main/nix/lib/aspects/fx/handlers/class-collector.nix>（确认 key 格式；pinned store 未逐文件比对整个 handlers 目录）。

## Open questions

1. 其他 host（a2700 / i12400 / sanjiao / wsl / mbp-m1）是否会报同样的警告：本次只求值了 a99r50，未逐个求值验证。按代码它们应有同构的四条。
2. `modules/den.nix:70` 于 user 作用域 include `mutual-provider` 是否完全无副作用（判断基于 `mutual-provider.nix:22-26` 的 gate），未实机验证。
3. 把 `users.users.klchen.extraGroups` 从 `nixos` 块搬到 `user` 类后，与 `<den/define-user>` 的 provide 合并是否如预期（两者都写 `users.users.<name>`，一个经 route、一个经 provide），未求值验证。
4. `os@skill` 的 `home-manager.extraSpecialArgs.inputs` 是否真的被 a99r50 上的 HM 模块消费；若是，acknowledged 后的失败形态可能是求值错误而不是「功能缺失」。
5. den 计划在 2027-01-01 的 release 里是否会改选项名，或让 acknowledge 变成报错（`$DEN/nix/lib/migrations.nix:1-3` 只说是「a throwing stub」），具体形态未确认；cutover 由 den 的 #759 追踪。
6. `nixos-rebuild switch` 时是否还有其他 warning 被这条淹没（本文件只讨论 #694 这一条）。

## Sources

- 保留：`/nix/store/k3fgjcckicwml7lda49f38nnrxbwlb0a-source`（pinned den 源码，ground truth）——所有 den 行为断言的最终依据。
- 保留：<https://github.com/denful/den/releases/tag/v0.20.0> — #694 的官方说明、迁移窗口、后续修列表。
- 保留：<https://github.com/denful/den/releases> — 版本列表与发布日期，用于判断升级是否已改变默认。
- 保留：`$DEN/docs/src/content/docs/explanation/crossing-scopes.mdx` — 与源码一致的说明文本（警告原文、三种 battery 形式、不读时钟）。
- 保留：<https://github.com/denful/den/blob/main/nix/lib/aspects/fx/handlers/class-collector.nix> — 确认 class 模块 key 的 `<class>@<identity>` 形式。
- 降级：<https://github.com/denful/den/issues/694> — 本次抓取被 GitHub 限流（API 与 HTML 都返回 rate limit），无法读正文；#694 的结论改由 v0.20.0 发布说明与 pinned 源码支撑。
- 降级：<https://den.denful.dev/explanation/crossing-scopes/> 等站点页面 — 与 store 内 docs 同源，未单独引用，避免与源码冲突时产生歧义。

## 6. 实施记录（2026-11-20，已应用）

按方案 B 落地，目标：warning 消失、行为逐项不变、不依赖 2027-01-01 会删除的 transition default。

### 6.1 改动

| 文件 | 改动 |
| --- | --- |
| `modules/users/klchen.nix` | `let`（`agentHosts` / `obsidianHosts` / `keys`）提到模块级；原 `den.aspects.klchen.nixos` + `.os` 的全部内容搬到 `den.default.nixos`（`AllowUsers` 含 `remotebuild`、root 的 authorizedKeys、`trusted-users`、`programs.bash.enable`、`users.users.klchen` 的 `isNormalUser`/`initialHashedPassword`/`extraGroups`）。`user` 类保持 `createHome` + `authorizedKeys`。 |
| `modules/users/root.nix` | `den.aspects.root.nixos` → `den.aspects.root.user`（`isSystemUser` + `initialHashedPassword`，经 `user-to-host` 路由到 `users.users.root`）；`trusted-users`/`AllowUsers` 的 `"root"` 由 `modules/defaults.nix` 提供，删除重复声明。 |
| `modules/llm/skill.nix` | `den.aspects.skill.os.home-manager.extraSpecialArgs.inputs` → `den.default.nixos.home-manager.extraSpecialArgs.inputs`（host 级选项）。 |
| `modules/de/niri/noctalia.nix` | `den.aspects.noctalia-shell.nixos` 的 4 项桌面基础服务 → `den.default.nixos`。 |
| `modules/hosts/wsl/default.nix` | `den.default.wsl`（默认 host 作用域的 `wsl` 类内容）搬到该 host 自己的 `nixos` 类，写成真实 NixOS 选项 `wsl.wslConf.*`。原因见 6.3。 |
| `modules/defaults.nix` | 删除 `den.default.wsl` 块（内容已进 wsl host aspect）。 |
| `modules/den.nix` | 新增 `den.migrations.user-host-content.acknowledged = true;`。 |

没有采用 `den.batteries.user-aspects`（方案 A）：它会把「用户 aspect 可写任意 host」的旧语义永久固化。

账号字段（`isNormalUser` / `extraGroups`）没有放进 den 的 `user` 类：`user` 类同样会路由进 nix-darwin 的 `users.users.<name>`（`$DEN/modules/aspects/batteries/os-user.nix:43-66`，`intoClass = host.class`），而 nix-darwin 没有这两个选项；因此它们留在 `den.default.nixos` 的 `users.users.klchen` 上。

### 6.2 验证（全部在本机执行）

```bash
# 1) 快照（迁移前后各一次），6 个 nixos host
nix eval --json --impure --expr '…'   # allow / trusted / klchen.{normal,groups,pw,home,keys} /
                                      # root.{sys,pw,keys} / bash / hmInputs / nm / bt / up
# 比较结果是 IDENTICAL（数组先 sort|unique，故顺序与重复项不影响）：
diff -u <(jq -S … /tmp/den-baseline.json) <(jq -S … /tmp/den-final.json)

# 2) transition default 是否还在生效
nix eval --json --impure --expr '… _module.args.denTransitionDefaultLost …'
# 迁移前：a99r50 4 条、a2700/i12400/sanjiao 各 4 条、init 5 条、wsl 5 条
# 迁移后 + acknowledged：`_module.args` 不再注入该属性（checkLost 直接返回 modules）

# 3) warning
nix eval --impure … 2>&1 | grep -c "evaluation warning"   # => 0

# 4) 格式（pre-commit 用 nixfmt）
nix fmt modules/users/klchen.nix modules/users/root.nix modules/llm/skill.nix \
        modules/de/niri/noctalia.nix modules/hosts/wsl/default.nix \
        modules/defaults.nix modules/den.nix
# => formatted 7 files (0 changed)
```

结果：

- `evaluation warning` 数量 **0**（6 个 nixos host 全部求值过一遍）。
- `AllowUsers` 集合：迁移前后均为 `{klchen, root, remotebuild}`（init 因自身 host aspect 多一组重复项，集合不变）。
- `trusted-users` 集合：a99r50/a2700/i12400/sanjiao = `{root, remotebuild, klchen}`；init = `{root, klchen}`；wsl = `{root, klchen}`——与迁移前一致。
- `klchen`：`isNormalUser=true`、`createHome=true`、`extraGroups` 集合一致、密钥 5 条一致、密码哈希一致。
- `root`：a99r50/init 上 `isSystemUser=true` + 密码哈希；其余 host 上 root 的 authorizedKeys 仍为 5 条（来自 klchen 的公钥），与迁移前一致。
- `programs.bash.enable` / `home-manager.extraSpecialArgs.inputs` / `networkmanager` / `bluetooth` / `upower` 全为 true。

### 6.3 额外发现：`den.default.<自定义类>` 会留下幽灵 lost 条目

`den.default.wsl` 是**默认 host 作用域里的 `wsl` 类内容**。它在 #694 记账里会让 wsl 的 user 作用域出现一条 `unidentified content`（`aspect == null`，scope `host=wsl-nixos,…,user=klchen`）：

- 迁移前：wsl 的 lost 列表里就有它（当时与另外 4 条并列）。
- 只做完 klchen/root/skill/noctalia 之后：其余 host 全部 `lost == []`，**只有 wsl 还剩这一条**。
- 探针实验：注释掉 `modules/defaults.nix` 的 `den.default.wsl` 块后，`denTransitionDefaultLost` 完全消失（即 `lost == []`）。

也就是说 `den.default` 在嵌套作用域里带来的、仅部分 host 才有的类内容，会被 `lostAt`（`$DEN/nix/lib/aspects/fx/edges/materialize-unified.nix`）当成无法归属的 host 类内容记账。把它搬到 host 自己的 `nixos` 类后条目消失、`wsl.wslConf.*` 取值不变（`enable=true`、`automount.root="/mnt"`、`interop.appendWindowsPath=false`、`network.generateHosts=false`、`startMenuLaunchers=true`）。这看起来是 den 侧的记账问题，值得上游报告，但与本仓库的正确写法无关。

### 6.4 首轮验证的范围（2026-11-20）

- **darwin（mbp-m1）无法在 linux 上求值**（`init.el` platform mismatch，仓库已知限制），所以 darwin 侧只是推理无影响：本次改动的 `nixos`/`wsl` 类内容不进 darwin；`klchen` 的 `user` 类未增加 nixos-only 字段；`den.migrations` 与平台无关。
- `config.system.build.toplevel.drvPath` **无法用来做等价性证明**：求值它会触发 den 的 delivery-edge cycle（`den materialize: delivery-edge cycle among […/nixos[merge]<-collected…]`），该现象在改动前就存在，与本次迁移无关。因此证据是逐字段快照而非 drv 哈希。
- 尚未在真机 `nixos-rebuild switch`（需要 sudo 密码），需要本机执行确认。

## 7. den 0.20 的 Home Manager 转发循环（2026-11-21 复核）

在 `2527e4d` 上，`a99r50` 的系统顶层曾报 `den materialize: delivery-edge cycle`，当时临时回退到了 0.19。用下面的命令可以单独触发出错的 Home Manager 求值。

```bash
nix eval --show-trace --raw .#nixosConfigurations.a99r50.config.home-manager.users.klchen.home.username
```

堆栈经过 `applyComplexRouteEdge` 和 `resolveSourceFallback`。当某个 role 或平台 class 没有收集到模块时，`forward` 会从 `fromAspect` 再查一次。原来的 `lib.head aspect-chain` 在这里会重新遍历整个 flake 的主机。第一次报错出现在 `merged.game`（该 role 仅有 NixOS 配置）；单独缩小 role 的查找范围后，相同的循环出现在 `merged.hmLinux`。把 disko 移到 `nixosSystem.modules` 后，原来的转发规则仍然报错。

`modules/den.nix` 现在将 `roleClass` 和 `hmPlatforms` 的 `fromAspect` 都设为 `_: user.aspect`，并启用 `den.migrations.user-host-content.acknowledged`。`disko` 仍由 `den.default.nixos.imports` 导入。`nix flake update den` 跟随上游默认分支，本次解析到 `2527e4d`。

以下命令在 `2527e4d` 上分别返回系统的 `.drv` 路径、磁盘列表 `["main"]` 和 `true`。升级 den 后可以重复执行。

```bash
nix eval --raw .#nixosConfigurations.a99r50.config.system.build.toplevel.drvPath
nix eval --json .#nixosConfigurations.a99r50.config.disko.devices.disk --apply builtins.attrNames
nix eval --json .#nixosConfigurations.a99r50.config.home-manager.users.klchen.xdg.configFile --apply 'files: files ? "uv/uv.toml"'
```

## 8. 收尾：把「默认给所有 host」改成显式可配置（2026-11-21）

第一版迁移把两处内容写进了 `den.default.nixos`（fleet 级），隐含「所有 host 都有 klchen / 都需要桌面服务」。这一节把它们改成按需投递。

### 8.1 niri / 桌面服务的 nixos 配置 → 只在跑桌面环境的 host 上

- 新增 `den.aspects.desktop.nixos`（`modules/de/niri/noctalia.nix`）：`networkmanager` / `bluetooth` / `power-profiles-daemon` / `upower`。
- `den.aspects.niri.includes = [ den.aspects.desktop ]`（`modules/de/niri/default.nix`），即「跑 niri 的 host 才需要这些」。
- 现在只有 a99r50 include 了 `<niri>`；别的 host 想要蓝牙/upower 时单独 include `<desktop>` 即可，不必整套 niri。
- 结果（实测）：`bt/up/ppd` 在 a99r50 为 `true`，a2700 / i12400 / init / sanjiao / wsl 为 `false`。`networkmanager` 在 a2700 / i12400 / sanjiao 由它们自己的 host 配置开启、init 由 `<network>` aspect 开启、a99r50 由 `<desktop>` 开启；**wsl 失去了 networkmanager**（原来只是泄漏来的，WSL 由宿主管理网络）。

### 8.2 klchen 的 host 级配置 → `provides.to-hosts`，不再假设每台机器都有 klchen

`modules/users/klchen.nix` 里原来的 `den.default.nixos` 改成 `den.aspects.klchen.provides.to-hosts.nixos`（`AllowUsers` 含 `remotebuild`、root authorizedKeys、`trusted-users`、`programs.bash.enable`、`users.users.klchen` 的账号字段、`home-manager.backupFileExtension`）。

- `provides.to-hosts` = 「这个用户所在的每台 host」，是点名投递：0.19 是核心能力，0.20 起由 `den.batteries.mutual-provider` 接收（本仓库 `den.default.includes` 已含 `<den/mutual-provider>`）。
- `modules/llm/skill.nix` 同理：`den.aspects.skill.provides.to-hosts.nixos.home-manager.extraSpecialArgs.inputs`。
- `modules/defaults.nix` 的 fleet 基线里删掉了 `AllowUsers` 的 `"klchen"`（现在只剩 `"root"`），也不再写 `home-manager.backupFileExtension`。

验证（临时把 sanjiao 的用户全部移除后求值，再恢复）：

```
{"allow":["root"], "trusted":["root","remotebuild"], "rootKeys":0, "klchenDefined":false, "bash":true}
```

即：**没有 klchen 的 host 不再自动获得 klchen 的 SSH/trusted-users/root 密钥**；`remotebuild` 来自它自己的 `<nix-build-machines>`，与本迁移无关。

### 8.3 顺带修掉一个隐藏假设：`home-manager.*` 不能写在 fleet 基线里

上面那个「没有用户」的探针一开始直接报错：

```
error: The option `home-manager' does not exist. Definition values:
  - In `nixos@default': { backupFileExtension = "hmbp"; }
```

`lib.mkIf (options ? home-manager)` **救不了**——mkIf 只影响取值，option 不存在时定义本身仍是错误。所以 `home-manager.backupFileExtension` 移到了 klchen 的 `provides.to-hosts`：有 HM 用户的 host 才有这个 option，投递自然就不会落到没有它的 host 上。

### 8.4 role 机制仍然正常

`modules/den.nix` 的 `roleClass`（`host.roles ∩ user.roles` → `homeManager`）与 `den.schema.host.roles`（从 `config.users` 汇总）都没有被这次迁移动过，实测：

| 检查 | 结果 |
| --- | --- |
| `python` role（a2700 / a99r50 / wsl 有，sanjiao / init 没有）→ `den.aspects.python.python` 的 `xdg.configFile."uv/uv.toml"` | a2700 `true`, a99r50 `true`, wsl `true`, sanjiao `false`, init `false` |
| `hermes` role（sanjiao 有，a2700 没有）→ HM 的 `services.hermes-agent.enable` | sanjiao `true`, a2700 `false` |

正反两向都对，说明 role 的转发（含 host 级 role 与 user 级 role 的交集、以及 `den.schema.host.roles` 从用户的 `config.users` 汇总）还在工作。
