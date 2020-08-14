# 使用以下命令构建一个Image
        git clone https://github.com/zhaiweiwei/damengdb.git
        cd damengdb
        docker build -t="damengdb" .

# 使用以下命令运行容器
        docker run --name dameng -d -p 5236:5236 damengdb
        docker run --name dameng -d -p 5237:5236 -p 10022:22 damengdb

# 本镜像开放以下端口
        5236    数据库连接端口
        22      ssh远程连接端口

# 用户名密码
        SYSDBA/SYSDBA
        SYSAUDITOR/SYSAUDITOR
        SYSSSO/SYSSSO
        SYSDBO/SYSDBO
