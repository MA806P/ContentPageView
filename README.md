# ContentPageView


### 分页视图

在 APP 中经常遇到滑动分页的情况，本例子就是来实现这样的界面。
实现的方法多种多样，大致就是 ScrollView 的嵌套，在上下滑动中解决手势冲突的情况。

![demo](https://github.com/MA806P/ContentPageView/blob/master/Screenshot/page.png)

本例子的实现，页面分上中下三个部分，最重要的就是，下面的列表部分，将 tableView 添加到 scrollView 中，外面的 scrollView 负责左右滑动 不能上下滑动，上下滑动都是由 tableView 来进行响应。
通过设置 tableView.contentInset 的 top 让上部空出来显示上面的两个部分，然后上下滑动通过监听 tableView.contentOffset 来计算上面两部分的位置。效果如下：

![demo](https://github.com/MA806P/ContentPageView/blob/master/Screenshot/page.gif)

<br>

还有其他的实现方法可参考： <br>
https://github.com/xichen744/SPPage <br>
https://github.com/Roylee-ML/SwipeTableView <br>
https://github.com/12207480/TYPagerController <br>


<br>


### 编辑类别视图  

本例子还添加了修改，类别的视图。通过拖动修改顺序，添加或删除类别。效果如下图

![demo](https://github.com/MA806P/ContentPageView/blob/master/Screenshot/drag.gif)






