## 项目名称
> 同步你的目标git仓库到多个不同的仓库中例如：codeup->github\gitlab\gitee等

## 版本更新说明

|  版本   |      日期       | 日志                                                              |
|:---:|:-------------:|:----------------------------------------------------------------|
| 1.0版本 |  2025-10-30   | 项目init                                                          |
| 1.1版本 |  2025-11-09   | 使用.git-credentials存储密码凭证，解决了因github、gitcode等取消http基础验证功能而导致失败问题 |

## 运行条件
> 列出运行该项目所必须的条件和相关依赖  
* 条件一：在.git-credentials文件中配置你的git相关主机地址、用户名、token，例如：https://18439406854:token@codeup.aliyun.com
* 条件二：你的环境中需要安装jq工具、对json配置文件进行解析
* 条件三：使用前检查脚本运行权限

## 运行说明
> 说明如何运行和使用你的项目，建议给出具体的步骤说明
* 操作一：配置git-sync-config.json文件。说明：name：仓库名称（必须），type：类型（必须），url：仓库地址（必须），sync-list：需要同步的仓库列表（必须）
* 操作二：赋予脚本执行权限 chmod +x git.sh，然后执行./git.sh


## 技术架构
> shell、git

## 协作者
> gaopuguang（2694484453@qq.com）

## 建议
> 搭配流水线、webhook等进行触发仓库代码同步

## 问题
#### 1.出现credential-manager问题
```text
2025-11-09 18:17:35 [INFO] 推送仓库：cloud-server to https://gitcode.com/gaopuguang/cloud-server.git
2025-11-09 18:17:35 [INFO] git: 'credential-manager' is not a git command. See 'git --help'.
```

解决方案：
```git config --global credential.helper store```

#### 2.github提示文件超过100MB 
```text
error: File xxx is 119.22 MB; this exceeds GitHub's file size limit of 100.00 MB        
2025-11-10 18:04:17 [INFO] remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.      

```

解决方案：
```
方法一：全局配置 git config --global http.postBuffer 524288000 
或者 
方法二：当前仓库配置 git config http.postBuffer 524288000
```

#### 3.推送失败被拒绝问题

```text
2025-11-10 18:19:34 [INFO] To https://github.com/2694484453/cloud-web.git
2025-11-10 18:19:34 [INFO]  ! [rejected]        master -> master (fetch first)
2025-11-10 18:19:34 [INFO] error: failed to push some refs to 'https://github.com/2694484453/cloud-web.git'
2025-11-10 18:19:34 [INFO] hint: Updates were rejected because the remote contains work that you do
2025-11-10 18:19:34 [INFO] hint: not have locally. This is usually caused by another repository pushing
2025-11-10 18:19:34 [INFO] hint: to the same ref. You may want to first integrate the remote changes
2025-11-10 18:19:34 [INFO] hint: (e.g., 'git pull ...') before pushing again.
2025-11-10 18:19:34 [INFO] hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
解决方案：目标仓库和推送仓库代码不一致需要本地排除差异保持版本一致后再次执行推送
