# AssistanceUploadSwiftVersionTool
###该小工具用于辅助Swift3.2直接升级至Swift4.2  
目前该小工具已经通过公司几个项目测试，并起到了不错的效果。目前为`1.0`初始版本  
仅作为抛砖引玉的作用。
> 1、自动在selector绑定的方法前添加@objc  
> 2、在dynamic变量声明前添加@objc (主要是处理Realm数据库中的变量)  
> 3、替换旧的API

###使用方法:
0、对项目进行完整备份，对项目进行完整备份，对项目进行完整备份  
1、配置均在`main.m`中  
2、设置项目所在路径 `manager.projectPath`  
例：`manager.projectPath = @"/Users/smelltime/Desktop/TestDemo"`  
3、如果需要处理项目全部文件，就不用配置`enablePaths`以及`excludePaths`  
比如：在`Home`分组下有`RankList`分组的代码不需要处理，那设置在`excludePaths` 中即可`excludePaths = @[@"/Users/smelltime/Desktop/TestDemo/Home/RankList"]`   
4、可以补充Swift3.2版本中需要替换为新格式的API名称，在`targetWords`以及`replaceWords`中追加即可  
5、确定项目已经完整备份，且无其他软件正在编辑该项目  
6、确认无误后直接运行`UploadSwift3-2To4-2`工程，等待输出`完成咯`即表示已经完成运行  
7、log日志中以`error - ` 以及`warring -`开头的Llog需要注意，方便排查  

如果疑问以及好的建议或者其他更好的工具欢迎提issue，以及PR～  
期待您的star👏

