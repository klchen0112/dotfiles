#
# Download client
#
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  programs.yt-dlp = {
    enable = true;
  };
  home.file.".config/aria2/clean.sh".source = ./aria2/clean.sh;
  home.file.".config/aria2/delete.sh".source = ./aria2/delete.sh;

  programs.aria2 = {
    enable = false;
    settings = {
      dir = "$\{HOME\}/Downloads"; # 下载目录。可使用绝对路径或相对路径, 默认: 当前启动位置
      disk-cache = "64M";
      file-allocation = "none";
      no-file-allocation-limit = "64M";
      continue = true;
      always-resume = false;
      max-resume-failure-tries = 0;
      remote-time = true;
      input-file = "$\{HOME\}/.config/aria2/aria2.session";
      save-session = "$\{HOME\}/.config/aria2/aria2.session";
      save-session-interval = 1;
      auto-save-interval = 20;
      force-save = false;
      max-file-not-found = 10;
      max-tries = 0;
      retry-wait = 10;
      connect-timeout = 10;
      timeout = 10;
      max-concurrent-downloads = 5;
      max-connection-per-server = 16;
      split = 64;
      min-split-size = "4M";
      piece-length = "1M";
      allow-piece-length-change = true;
      lowest-speed-limit = 0;
      # 全局最大下载速度限制, 运行时可修改, 默认：0 (无限制)
      max-overall-download-limit = 0;

      # 单任务下载速度限制, 默认：0 (无限制)
      max-download-limit = 0;

      # 禁用 IPv6, 默认:false
      disable-ipv6 = true;

      # GZip 支持，默认:false
      http-accept-gzip = true;

      # URI 复用，默认: true
      reuse-uri = false;

      # 禁用 netrc 支持，默认:false
      no-netrc = true;
      # 允许覆盖，当相关控制文件(.aria2)不存在时从头开始重新下载。默认:false
      allow-overwrite = false;

      # 文件自动重命名，此选项仅在 HTTP(S)/FTP 下载中有效。新文件名在名称之后扩展名之前加上一个点和一个数字（1..9999）。默认:true
      auto-file-renaming = true;

      # 使用 UTF-8 处理 Content-Disposition ，默认:false
      content-disposition-default-utf8 = true;
      listen-port = 51413;
      # DHT 网络与 UDP tracker 监听端口(UDP), 默认:6881-6999
      # 因协议不同，可以与 BT 监听端口使用相同的端口，方便配置防火墙和端口转发策略。
      dht-listen-port = 51413;

      # 启用 IPv4 DHT 功能, PT 下载(私有种子)会自动禁用, 默认:true
      enable-dht = true;

      # 启用 IPv6 DHT 功能, PT 下载(私有种子)会自动禁用，默认:false
      # 在没有 IPv6 支持的环境开启可能会导致 DHT 功能异常
      enable-dht6 = false;

      # 指定 BT 和 DHT 网络中的 IP 地址
      # 使用场景：在家庭宽带没有公网 IP 的情况下可以把 BT 和 DHT 监听端口转发至具有公网 IP 的服务器，在此填写服务器的 IP ，可以提升 BT 下载速率。
      #bt-external-ip=

      # IPv4 DHT 文件路径，默认：$\{HOME\}/.aria2/dht.dat
      dht-file-path = "$\{HOME\}/.config/aria2/dht.dat";

      # IPv6 DHT 文件路径，默认：$\{HOME\}/.aria2/dht6.dat
      dht-file-path6 = "$\{HOME\}/.config/aria2/dht6.dat";
      # IPv4 DHT 网络引导节点
      dht-entry-point = "dht.transmissionbt.com:6881";

      # IPv6 DHT 网络引导节点
      dht-entry-point6 = "dht.transmissionbt.com:6881";

      # 本地节点发现, PT 下载(私有种子)会自动禁用 默认:false
      bt-enable-lpd = true;
      # 指定用于本地节点发现的接口，可能的值：接口，IP地址
      # 如果未指定此选项，则选择默认接口。
      #bt-lpd-interface=

      # 启用节点交换, PT 下载(私有种子)会自动禁用, 默认:true
      enable-peer-exchange = true;

      # BT 下载最大连接数（单任务），运行时可修改。0 为不限制，默认:55
      # 理想情况下连接数越多下载越快，但在实际情况是只有少部分连接到的做种者上传速度快，其余的上传慢或者不上传。
      # 如果不限制，当下载非常热门的种子或任务数非常多时可能会因连接数过多导致进程崩溃或网络阻塞。
      # 进程崩溃：如果设备 CPU 性能一般，连接数过多导致 CPU 占用过高，因资源不足 Aria2 进程会强制被终结。
      # 网络阻塞：在内网环境下，即使下载没有占满带宽也会导致其它设备无法正常上网。因远古低性能路由器的转发性能瓶颈导致。
      bt-max-peers = 128;

      # BT 下载期望速度值（单任务），运行时可修改。单位 K 或 M 。默认:50K
      # BT 下载速度低于此选项值时会临时提高连接数来获得更快的下载速度，不过前提是有更多的做种者可供连接。
      # 实测临时提高连接数没有上限，但不会像不做限制一样无限增加，会根据算法进行合理的动态调节。
      bt-request-peer-speed-limit = "10M";

      # 全局最大上传速度限制, 运行时可修改, 默认:0 (无限制)
      # 设置过低可能影响 BT 下载速度
      max-overall-upload-limit = "2M";

      # 单任务上传速度限制, 默认:0 (无限制)
      max-upload-limit = 0;

      # 最小分享率。当种子的分享率达到此选项设置的值时停止做种, 0 为一直做种, 默认:1.0
      # 强烈建议您将此选项设置为大于等于 1.0
      seed-ratio = 1.0;

      # 最小做种时间（分钟）。设置为 0 时将在 BT 任务下载完成后停止做种。
      seed-time = 0;

      # 做种前检查文件哈希, 默认:true
      bt-hash-check-seed = true;

      # 继续之前的BT任务时, 无需再次校验, 默认:false
      bt-seed-unverified = false;

      # BT tracker 服务器连接超时时间（秒）。默认：60
      # 建立连接后，此选项无效，将使用 bt-tracker-timeout 选项的值
      bt-tracker-connect-timeout = 10;

      # BT tracker 服务器超时时间（秒）。默认：60
      bt-tracker-timeout = 10;

      # BT 服务器连接间隔时间（秒）。默认：0 (自动)
      #bt-tracker-interval=0;

      # BT 下载优先下载文件开头或结尾
      bt-prioritize-piece = "head=32M,tail=32M";

      # 保存通过 WebUI(RPC) 上传的种子文件(.torrent)，默认:true
      # 所有涉及种子文件保存的选项都建议开启，不保存种子文件有任务丢失的风险。
      # 通过 RPC 自定义临时下载目录可能不会保存种子文件。
      rpc-save-upload-metadata = true;

      # 下载种子文件(.torrent)自动开始下载, 默认:true，可选：false|mem
      # true：保存种子文件
      # false：仅下载种子文件
      # mem：将种子保存在内存中
      follow-torrent = true;
      # 种子文件下载完后暂停任务，默认：false
      # 在开启 follow-torrent 选项后下载种子文件或磁力会自动开始下载任务进行下载，而同时开启当此选项后会建立相关任务并暂停。
      pause-metadata = false;

      # 保存磁力链接元数据为种子文件(.torrent), 默认:false
      bt-save-metadata = true;

      # 加载已保存的元数据文件(.torrent)，默认:false
      bt-load-saved-metadata = true;

      # 删除 BT 下载任务中未选择文件，默认:false
      bt-remove-unselected-file = true;

      # BT强制加密, 默认: false
      # 启用后将拒绝旧的 BT 握手协议并仅使用混淆握手及加密。可以解决部分运营商对 BT 下载的封锁，且有一定的防版权投诉与迅雷吸血效果。
      # 此选项相当于后面两个选项(bt-require-crypto=true, bt-min-crypto-level=arc4)的快捷开启方式，但不会修改这两个选项的值。
      bt-force-encryption = true;

      # BT加密需求，默认：false
      # 启用后拒绝与旧的 BitTorrent 握手协议(\19BitTorrent protocol)建立连接，始终使用混淆处理握手。
      #bt-require-crypto=true

      # BT最低加密等级，可选：plain（明文），arc4（加密），默认：plain
      #bt-min-crypto-level=arc4

      # 分离仅做种任务，默认：false
      # 从正在下载的任务中排除已经下载完成且正在做种的任务，并开始等待列表中的下一个任务。
      bt-detach-seed-only = true;

      ## 客户端伪装 ##

      # 自定义 User Agent
      user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.47";
      # BT 客户端伪装
      # PT 下载需要保持 user-agent 和 peer-agent 两个参数一致
      # 部分 PT 站对 Aria2 有特殊封禁机制，客户端伪装不一定有效，且有封禁账号的风险。
      #user-agent=Deluge 1.3.15
      peer-agent = "Deluge 1.3.15";
      peer-id-prefix = "-DE13F0-";

      ## 执行额外命令 ##

      # 下载停止后执行的命令
      # 从 正在下载 到 删除、错误、完成 时触发。暂停被标记为未开始下载，故与此项无关。
      on-download-stop = "$\{HOME\}/.config/aria2/delete.sh";

      # 下载完成后执行的命令
      # 此项未定义则执行 下载停止后执行的命令 (on-download-stop)
      on-download-complete = "$\{HOME\}/.config/aria2/clean.sh";

      # 下载错误后执行的命令
      # 此项未定义则执行 下载停止后执行的命令 (on-download-stop)
      #on-download-error=

      # 下载暂停后执行的命令
      #on-download-pause=

      # 下载开始后执行的命令
      #on-download-start=

      # BT 下载完成后执行的命令
      #on-bt-download-complete=

      ## RPC 设置 ##

      # 启用 JSON-RPC/XML-RPC 服务器, 默认:false
      enable-rpc = true;

      # 接受所有远程请求, 默认:false
      rpc-allow-origin-all = true;

      # 允许外部访问, 默认:false
      rpc-listen-all = true;

      # RPC 监听端口, 默认:6800
      rpc-listen-port = 6800;

      # RPC 密钥
      rpc-secret = "ckl418";

      # RPC 最大请求大小
      rpc-max-request-size = "10M";

      # RPC 服务 SSL/TLS 加密, 默认：false
      # 启用加密后必须使用 https 或者 wss 协议连接
      # 不推荐开启，建议使用 web server 反向代理，比如 Nginx、Caddy ，灵活性更强。
      #rpc-secure=false

      # 在 RPC 服务中启用 SSL/TLS 加密时的证书文件(.pem/.crt)
      #rpc-certificate=$\{HOME\}/.config/aria2/xxx.pem

      # 在 RPC 服务中启用 SSL/TLS 加密时的私钥文件(.key)
      #rpc-private-key=$\{HOME\}/.config/aria2/xxx.key

      # 事件轮询方式, 可选：epoll, kqueue, port, poll, select, 不同系统默认值不同
      #event-poll=select

      ## 高级选项 ##

      # 启用异步 DNS 功能。默认：true
      async-dns = true;

      # 指定异步 DNS 服务器列表，未指定则从 /etc/resolv.conf 中读取。
      async-dns-server = "119.29.29.29,223.5.5.5,8.8.8.8,1.1.1.1";

      # 指定单个网络接口，可能的值：接口，IP地址，主机名
      # 如果接口具有多个 IP 地址，则建议指定 IP 地址。
      # 已知指定网络接口会影响依赖本地 RPC 的连接的功能场景，即通过 localhost 和 127.0.0.1 无法与 Aria2 服务端进行讯通。
      #interface=

      # 指定多个网络接口，多个值之间使用逗号(,)分隔。
      # 使用 interface 选项时会忽略此项。
      #multiple-interface=

      ## 日志设置 ##

      # 日志文件保存路径，忽略或设置为空为不保存，默认：不保存
      #log=

      # 日志级别，可选 debug, info, notice, warn, error 。默认：debug
      #log-level=warn

      # 控制台日志级别，可选 debug, info, notice, warn, error ，默认：notice
      console-log-level = "notice";

      # 安静模式，禁止在控制台输出日志，默认：false
      quiet = false;

      # 下载进度摘要输出间隔时间（秒），0 为禁止输出。默认：60
      summary-interval = 0;

      ## 增强扩展设置(非官方) ##

      # 仅适用于 myfreeer/aria2-build-msys2 (Windows) 和 P3TERX/Aria2-Pro-Core (GNU/Linux) 项目所构建的增强版本

      # 在服务器返回 HTTP 400 Bad Request 时重试，仅当 retry-wait > 0 时有效，默认 false
      #retry-on-400=true

      # 在服务器返回 HTTP 403 Forbidden 时重试，仅当 retry-wait > 0 时有效，默认 false
      #retry-on-403=true

      # 在服务器返回 HTTP 406 Not Acceptable 时重试，仅当 retry-wait > 0 时有效，默认 false
      #retry-on-406=true

      # 在服务器返回未知状态码时重试，仅当 retry-wait > 0 时有效，默认 false
      #retry-on-unknown=true

      # 是否发送 Want-Digest HTTP 标头。默认：false (不发送)
      # 部分网站会把此标头作为特征来检测和屏蔽 Aria2
      #http-want-digest=false

      ## BitTorrent trackers ##
      bt-tracker = "http://tracker.opentrackr.org:1337/announce,udp://opentracker.i2p.rocks:6969/announce,udp://open.demonii.com:1337/announce,udp://tracker.openbittorrent.com:6969/announce,http://tracker.openbittorrent.com:80/announce,udp://open.stealth.si:80/announce,udp://exodus.desync.com:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://explodie.org:6969/announce,udp://tracker1.bt.moack.co.kr:80/announce,udp://tracker.theoks.net:6969/announce,udp://tracker.bittor.pw:1337/announce,udp://tracker-udp.gbitt.info:80/announce,udp://retracker01-msk-virt.corbina.net:80/announce,udp://open.free-tracker.ga:6969/announce,udp://movies.zsw.ca:6969/announce,https://tracker.gbitt.info:443/announce,http://tracker.ipv6tracker.org:80/announce,http://tracker.gbitt.info:80/announce,udp://uploads.gamecoast.net:6969/announce";
    };
  };
}
