#DMLC-FM ON yarn (viewfs)
原项目来自：https://github.com/CNevd/FM_DMLC 但不支持viewfs
1. 修改Client.java 中校验hdfs://,将java申请的内存提高到4g
2. io hdfs 等cc文件 添加views校验
3. 重新编译 dmlccore rabit java 等
4. 增加viewfs demo
