# 今日穿搭 APP

基于Flutter开发的穿搭分享社交应用,支持图片标签编辑、商品推荐、佣金结算等功能。

## 技术栈

- **Flutter**: 3.16+
- **Dart**: 3.0+
- **架构**: Clean Architecture + BLoC
- **状态管理**: flutter_bloc
- **依赖注入**: get_it + injectable
- **路由**: go_router
- **网络**: dio
- **本地存储**: hive + flutter_secure_storage

## 项目结构

```
lib/
├── core/                          # 核心基础设施
│   ├── constants/                 # 常量定义
│   ├── errors/                    # 异常处理
│   ├── usecases/                  # 通用用例基类
│   ├── utils/                     # 工具类
│   ├── network/                   # 网络层
│   ├── storage/                   # 本地存储
│   ├── theme/                     # 主题配置
│   └── di/                        # 依赖注入
├── features/                      # 业务功能模块
│   ├── auth/                      # 认证模块
│   ├── feed/                      # 内容流模块
│   ├── post_editor/               # 发布编辑器模块
│   ├── product_detail/            # 商品详情模块
│   ├── user_profile/              # 用户个人页
│   └── wallet/                    # 钱包/佣金模块
├── shared/                        # 跨模块共享组件
│   ├── widgets/                   # 通用UI组件
│   ├── models/                    # 共享模型
│   └── services/                  # 共享服务
└── main.dart                      # 应用入口
```

## 核心功能

### 1. 认证模块
- 手机号+验证码登录
- 自动Token刷新
- 用户信息管理

### 2. Feed流
- 双列瀑布流布局
- 下拉刷新、上拉加载更多
- 图片懒加载、缓存优化
- 点赞、评论、分享

### 3. 发布编辑器
- 支持1-9张图片选择
- 图片标签编辑(长按添加、拖拽移动)
- 三步式发布流程
- 草稿自动保存

### 4. 商品详情
- 商品信息展示
- 跨平台唤起淘宝/京东
- 佣金信息展示

### 5. 用户中心
- 个人信息展示
- 粉丝/关注管理
- 帖子/喜欢/收藏

### 6. 钱包
- 佣金余额展示
- 提现功能
- 佣金趋势图表
- 佣金明细列表

## 开发指南

### 安装依赖

```bash
flutter pub get
```

### 运行代码生成

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 运行应用

```bash
flutter run
```

### 构建

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## 注意事项

1. 首次运行需要执行代码生成命令
2. 需要配置后端API地址
3. 需要配置淘宝联盟AppKey等第三方服务密钥
4. iOS需要在真机上测试相机和相册功能

## License

Copyright © 2024 今日穿搭# OOTD
