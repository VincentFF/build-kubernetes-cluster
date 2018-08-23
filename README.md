# centos7+ansible+kubeadm，搭建高可用kubernetes集群


**注:**  
在AWS上生产ec2实例时选用`kubernetes-1.11.2`镜像，里面安装好了kubernetes和docker组件。  
为了节省时间，所以默认注释掉了`roles/common/tasks/main.yml`中安装docker和kubernetes部分。如果机器上没有预装kubernetes和docker组件，则将注释去掉即可。  
## 版本
- ansible: 2.5.1 +
- kubeadm: 1.11.2
- docker: docker-ce-18.03.1.ce +

## 机器（至少5台）
- 1台控制节点，用来控制整个集群和执行安装命令。(只需要有其他所有节点的ssh权限的任意机器，可以是你本机)
- 3台master节点。(用来安装etcd和master)
- 其他为node节点。

## 准备工作
### 两个负载均衡器
所谓kubernetes集群的高可用，实际上就是etcd集群的高可用和kube-apiserver的高可用。  
需要提前创建好两个负载均衡器，可以用lvs+haproxy自己搭建，或者亚马逊的负载均衡器都可以。  

- etcd负载均衡器。转发到3个master节点的2379端口。
- kube-apiserver负载均衡器。转发到3个master节点的6443端口。

### 控制节点ssh设置（在控制节点执行）
- 如果是第一次ssh连接远程机器,默认需要手动输入yes确认公钥。这里关闭`StrictHostKeyChecking`检查，可以在任务执行完成后再打开。  
- 如果控制节点没有其他节点的ssh权限，但你的主机拥有所有节点的ssh权限。打开`ForwardAgent`开启代理转发即可。  
完整配置如下`vim /etc/ssh/ssh_config`：  
```
Host *
    ForwardAgent yes
    ForwardX11 yes
    GSSAPIAuthentication yes
    StrictHostKeyChecking no
    ForwardX11Trusted yes
    SendEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
    SendEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
    SendEnv LC_IDENTIFICATION LC_ALL LANGUAGE
    SendEnv XMODIFIERS
```

## 安装etcd集群及kubernetes集群
1. 修改./build-kubernetes-cluster/hosts文件。  
    ```
    # 下面的host_name不是你目前节点的hostname，而是你规划的hostname，程序会根据你填入的名称对节点进行修改。
    # 只需填入ip和host_name,其他保持默认。

    # 这里只需要讲三台master节点的ip填入即可，host_name建议保持默认。
    [master01]
    10.0.x.x host_name=master01
    [master02]
    10.0.x.x host_name=master02
    [master03]
    10.0.x.x host_name=master03

    # 这里需要填入node节点ip和host_name。
    [nodes]
    10.0.x.x host_name=node01
    10.0.x.x host_name=node0x
    10.0.x.x host_name=node0x
    ```
2. 修改参数  
    vim ./build-kubernetes-cluster/group_vars/all  
    ```
    # 这里主要是route_ip，如果使用aws内网的ec2实例，默认是不能链接网络的。这里添加一个路由，会自动设置到不能联网的节点上去。
    route_ip: 10.0.1.9

    # 建议保持默认
    kube_version: 1.11.2
    docker_version: 18.03.1.ce
    ```
    vim ./build-kubernetes-cluster/group_vars/masters  
    ```
    # 只需填入load_blance_ip 和 etcd_blance_ip即可。
    # 这里即是你准备的负载均衡的地址。
    load_blance_ip: "10.0.1.1"
    etcd_blance_ip: "10.0.1.1"

    # 建议保持默认
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
