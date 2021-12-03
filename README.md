# LockWithApps
逆向小项目（简单上锁App）
1、通过hookSpringboard启动App方法做处理（艰难的征途~，尝试很多方法,如监听SBIconView的点击方法，由于UITouch的时效性，没想到怎么添加处理代码）
  HomeScreen启动App方法-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(id)arg3 activationSettings:(id)arg4 actions:(id)arg5；(iOS13及14.4该方法可行，13以下未测试)；
  自己砸壳未果，借鉴大佬导出的SpringBoard头文件（https://github.com/wvabrinskas/SpringBoard-Headers-iOS13）；
2、这里加锁只是增加HomeScreen激活App，通过siri建议及搜索栏进入未做处理，待有时间后完善；
