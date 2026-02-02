# Mock 数据使用说明

## 概述

本目录包含 OOTD 应用的完整 Mock 数据集，用于开发和测试阶段模拟所有 API 接口的响应。

## 文件结构

```
lib/core/mock/
├── mock_config.dart          # Mock 配置（开关、测试账号）
├── mock_user_data.dart       # 用户相关 Mock 数据
├── mock_data.dart            # 完整 Mock 数据集合
├── mock_service.dart         # Mock 服务（统一管理数据获取）
└── README.md                 # 本文档
```

## 使用方法

### 1. 启用/禁用 Mock 模式

在 `mock_config.dart` 中设置：

```dart
class MockConfig {
  /// 是否启用 Mock 模式
  static const bool enabled = true;  // 设为 false 关闭 Mock
}
```

### 2. 获取 Mock 响应

#### 方式一：通过 MockService 获取

```dart
import 'package:ootd/core/mock/mock_service.dart';

// 同步获取
final response = MockService.getMockResponse('/auth/login');

// 异步获取（模拟网络延迟）
final response = await MockService.getMockResponseAsync(
  '/auth/login',
  delayMs: 300,
);
```

#### 方式二：直接使用 Mock 数据对象

```dart
import 'package:ootd/core/mock/mock_data.dart';

// 获取登录响应
final loginResponse = mockLoginResponse;

// 获取用户信息
final user = mockCurrentUser;

// 获取 Feed 流
final feedResponse = mockFeedResponse;
```

### 3. 在网络层集成 Mock

在 `dio_client.dart` 中集成 Mock：

```dart
class DioClient {
  Future<Map<String, dynamic>> get(String path) async {
    // 如果启用 Mock，返回 Mock 数据
    if (MockService.enabled) {
      return MockService.getMockResponseAsync(path);
    }
    
    // 否则发起真实网络请求
    final response = await _dio.get(path);
    return response.data;
  }
}
```

## 支持的 API 端点

### 认证相关
- `POST /auth/login` - 登录
- `POST /auth/register` - 注册
- `POST /auth/sms/send` - 发送短信验证码
- `POST /auth/sms/verify` - 验证短信验证码
- `POST /auth/refresh` - 刷新 Token
- `POST /auth/logout` - 退出登录

### 用户相关
- `GET /user/profile` - 获取用户资料
- `PUT /user/profile/update` - 更新用户资料
- `POST /user/follow` - 关注用户
- `POST /user/unfollow` - 取消关注
- `GET /user/followers` - 获取粉丝列表
- `GET /user/following` - 获取关注列表

### 帖子相关
- `GET /posts/feed` - 获取 Feed 流
- `GET /posts` - 获取帖子详情
- `POST /posts` - 创建帖子
- `PUT /posts` - 更新帖子
- `DELETE /posts` - 删除帖子
- `POST /posts/like` - 点赞帖子
- `POST /posts/unlike` - 取消点赞
- `POST /posts/collect` - 收藏帖子
- `POST /posts/uncollect` - 取消收藏
- `POST /posts/share` - 分享帖子

### 评论相关
- `GET /comments` - 获取评论列表
- `POST /comments` - 创建评论
- `DELETE /comments` - 删除评论
- `POST /comments/like` - 点赞评论
- `POST /comments/unlike` - 取消点赞评论

### 商品相关
- `GET /products/search` - 搜索商品
- `GET /products/detail` - 获取商品详情
- `POST /products/convert-link` - 转换商品链接
- `POST /products/parse-taobao-password` - 解析淘口令
- `GET /products/favorites` - 获取收藏商品列表
- `POST /products/favorites` - 添加收藏
- `DELETE /products/favorites` - 取消收藏

### 上传相关
- `POST /upload/image` - 上传图片
- `POST /upload/video` - 上传视频

### 钱包/佣金相关
- `GET /wallet` - 获取钱包信息
- `GET /wallet/commission` - 获取佣金记录
- `POST /wallet/withdraw` - 申请提现
- `GET /wallet/withdraw/history` - 获取提现记录

### 数据分析相关
- `GET /analytics` - 获取数据分析汇总
- `GET /analytics/gmv-trend` - 获取 GMV 趋势
- `GET /analytics/conversion-funnel` - 获取转化漏斗
- `GET /analytics/category-distribution` - 获取类目分布

### 草稿箱相关
- `GET /drafts` - 获取草稿列表
- `POST /drafts` - 保存草稿
- `DELETE /drafts` - 删除草稿

### 话题相关
- `GET /topics/hot` - 获取热门话题

## Mock 数据结构

### 用户数据
```dart
{
  "id": "mock_user_001",
  "nickname": "测试用户",
  "avatar": "https://...",
  "bio": "热爱穿搭，分享生活",
  "phone": "13800138000",
  "email": "test@example.com",
  "followersCount": 1256,
  "followingCount": 89,
  "postsCount": 42,
  "isVerified": true,
  "createdAt": "2024-01-15T00:00:00.000Z",
  "updatedAt": "2024-01-20T00:00:00.000Z"
}
```

### 帖子数据
```dart
{
  "id": "post_001",
  "author": { /* 用户数据 */ },
  "images": [
    {
      "id": "media_001",
      "url": "https://...",
      "type": "image",
      "width": 1080,
      "height": 1440
    }
  ],
  "tags": [
    {
      "id": "tag_001",
      "imageIndex": 0,
      "relativePosition": {"dx": 0.3, "dy": 0.4},
      "product": { /* 商品数据 */ }
    }
  ],
  "content": "今天的穿搭分享...",
  "likesCount": 234,
  "commentsCount": 45,
  "sharesCount": 12,
  "viewsCount": 1523,
  "isLiked": false,
  "isCollected": false,
  "topics": ["日常穿搭", "舒适风"],
  "createdAt": "2024-01-20T14:30:00.000Z"
}
```

### 商品数据
```dart
{
  "id": "product_001",
  "title": "2024新款宽松卫衣男女同款ins潮牌",
  "imageUrl": "https://...",
  "originalPrice": 299.0,
  "finalPrice": 159.0,
  "commission": 15.9,
  "platform": "taobao",
  "productUrl": "https://item.taobao.com/item.htm?id=123456",
  "taobaoPassword": "￥ABcdEF￥",
  "salesCount": 5234,
  "rating": 4.8,
  "shopName": "潮流服饰旗舰店",
  "createdAt": "2024-01-10T00:00:00.000Z"
}
```

## 高级功能

### 1. 搜索功能

```dart
// 搜索商品
final result = MockService.searchProducts('卫衣');

// 搜索话题
final result = MockService.searchTopics('日常');
```

### 2. 分页功能

```dart
// 分页获取 Feed
final feed = MockService.getFeedPaginated(page: 1, pageSize: 10);

// 分页获取评论
final comments = MockService.getCommentsPaginated('post_001', page: 1, pageSize: 20);
```

### 3. 时间范围查询

```dart
// 获取不同时间范围的 GMV 趋势
final trend7d = MockService.getGMVTrendByPeriod('7d');
final trend30d = MockService.getGMVTrendByPeriod('30d');
final trend90d = MockService.getGMVTrendByPeriod('90d');
```

### 4. 导出和调试

```dart
// 导出所有 Mock 数据
final allData = MockService.exportAllMockData();

// 打印所有 Mock 数据（用于调试）
MockService.printAllMockData();
```

### 5. 模拟错误

```dart
// 模拟 Token 过期
final error = MockService.getErrorResponse('/auth/login');

// 模拟网络错误
final networkError = MockService.getNetworkError();
```

## 测试账号

| 手机号 | 验证码 | 昵称 |
|--------|--------|------|
| 13800138000 | 123456 | 测试用户 |
| 13900139000 | 123456 | 时尚达人 |
| 13700137000 | 123456 | 简约生活 |

## 注意事项

1. **生产环境**：发布前务必将 `MockConfig.enabled` 设置为 `false`
2. **数据一致性**：Mock 数据应与真实 API 返回的数据结构保持一致
3. **图片资源**：Mock 数据中使用的图片来自 Unsplash，网络环境差时可能加载缓慢
4. **Token 管理**：Mock Token 有效期设置为 7200 秒，测试时注意刷新逻辑

## 扩展 Mock 数据

如需添加新的 Mock 数据：

1. 在 `mock_data.dart` 中添加数据对象
2. 在 `mock_service.dart` 的 `_getMockResponseByEndpoint` 方法中添加对应的端点处理
3. 更新本文档的 API 端点列表

## 相关文档

- [需求文档](../../../../需求文档.md)
- [API 端点定义](../constants/api_endpoints.dart)
- [数据模型](../../shared/models/)