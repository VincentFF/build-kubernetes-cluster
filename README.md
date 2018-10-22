# centos7+ansible+kubeadm，搭建高可用kubernetes集群


**备注:**  

*只支持Centos, 且只在centos7上做过测试。*  
*在AWS上生成ec2实例时建议选用`kubernetes-1.11.2`镜像，里面安装好了kubernetes和docker组件,可以节省安装时间。*  

*程序关闭了firewalld和selinux。  
网络插件使用flannel, kube-proxy使用ipvs模式。  
安装了dashboard, heapster, logrotete插件。  
生成了两个default/sa用户，一个admin,有管理权限。另一个viewer,有查看权限。基于这两个用户的dashboard登录文件在build-kubernetes-cluster下生成   *

## 版本
- ansible: 2.5.1 +
- kubeadm: 1.11.2
- docker: docker-ce-18.03.1.ce +

## 机器（至少4台）
- 1台控制节点，即运行安装程序所在的节点。(任意拥有所有节点ssh权限的机器，都可以作为控制节点，建议专门选取一台机器作为控制节点。你也可以使用一台master或node节点作为控制节点，需要保证它有自己的ssh权限。)  
- 3台master节点。(用来安装etcd和master)
- 其他为node节点。

## 准备工作
### kube-api负载均衡器（必须）
- kube-apiserver负载均衡器。转发到3个master节点的6443端口。如：10.1.11.11:6443 ---> mastersip:6443

<!-- ### 控制节点ssh设置（在控制节点执行, 非必须）
- 如果是第一次ssh连接远程机器,默认需要手动输入yes确认公钥。这里关闭`StrictHostKeyChecking`检查以跳开这一步，可以在任务执行完成后再打开。  
- 如果控制节点没有其他节点的ssh权限，但你的主机拥有所有节点的ssh权限。打开`ForwardAgent`开启代理转发即可拥有所有节点ssh权限。   -->

<!-- 完整配置如下`vim /etc/ssh/ssh_config`：  
```
Host *
    StrictHostKeyChecking no
    ForwardAgent yes
    ForwardX11 yes
    GSSAPIAuthentication yes
    ForwardX11Trusted yes
    SendEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
    SendEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
    SendEnv LC_IDENTIFICATION LC_ALL LANGUAGE
    SendEnv XMODIFIERS
``` -->

## 安装etcd集群及kubernetes集群（必须）
1. 修改./build-kubernetes-cluster/hosts文件。  
    ```
    # 下面的host_name不是你目前节点的hostname，而是你规划的hostname，程序会根据你填入的名称对节点进行修改。
    # 只需填入ip和host_name,其他保持默认。

    # 这里只需三台master节点的ip填入即可。
    [master01]
    10.0.x.x major=true
    [master02]
    10.0.x.x major=false
    [master03]
    10.0.x.x major=false

    # etcd ips. Can be master ips or not.
    [etcds]
    1.1.1.1
    1.1.1.1
    1.1.1.1

    # 这里需要填入node节点ip
    [nodes]
    10.0.x.x
    10.0.x.x
    10.0.x.x
    ```
2. 修改参数  
    vim ./build-kubernetes-cluster/group_vars/all  
    ```
    # 在内网机器不能联网的情况下，需要设置这个路由ip。
    # 这个路由会自动设置到不能联网的节点上去，对于能够联网的节点，则会跳过这一步。
    route_ip: 10.0.1.9

    # 建议保持默认. support kube 1.11.x
    kube_version: 1.11.2
    docker_version: 18.03.1.ce
    ```
    vim ./build-kubernetes-cluster/group_vars/masters  
    ```
    # 只需填入load_blance_ip，即上面你自己创建的负载均衡器ip。
    load_blance_ip: "10.0.1.1"

    # 建议保持默认。load_blance_port即你负载均衡器的port,如果设置的不是6443,在这里更改即可。
    load_blance_port: 6443
    etcd_version: 3.2.18
    ```
3. 执行启动脚本
    ```
    cd ./build-kubernetes-cluster/
    ./setup.sh

    # 等待几分钟，整个集群就搭建起来了。
    ```

## 其他
目前除了搭建集群，还默认安装了heapster+influetdb, dashboard(nodeport:30001), logroate，后续考虑会加入其他常用扩展。  
目前只适用于centos7，后续考虑兼容ubuntu.
