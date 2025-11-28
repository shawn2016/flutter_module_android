import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // 用户信息卡片
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.purple.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '用户名',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '手机号：138****8888',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    Get.snackbar('提示', '跳转到个人信息页面');
                  },
                ),
              ],
            ),
          ),

          // 订单统计
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('待支付', '2', Colors.orange),
                _buildStatItem('待使用', '5', Colors.blue),
                _buildStatItem('已完成', '12', Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 功能列表
          _buildSectionTitle('常用功能'),
          _buildMenuItem(
            icon: Icons.favorite_border,
            title: '我的收藏',
            color: Colors.red,
            onTap: () => Get.snackbar('提示', '我的收藏'),
          ),
          _buildMenuItem(
            icon: Icons.location_on,
            title: '收货地址',
            color: Colors.blue,
            onTap: () => Get.snackbar('提示', '收货地址'),
          ),
          _buildMenuItem(
            icon: Icons.card_giftcard,
            title: '优惠券',
            color: Colors.orange,
            onTap: () => Get.snackbar('提示', '优惠券'),
          ),
          _buildMenuItem(
            icon: Icons.stars,
            title: '积分中心',
            color: Colors.amber,
            onTap: () => Get.snackbar('提示', '积分中心'),
          ),

          const SizedBox(height: 20),

          _buildSectionTitle('设置'),
          _buildMenuItem(
            icon: Icons.settings,
            title: '设置',
            color: Colors.grey,
            onTap: () => Get.snackbar('提示', '设置'),
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: '帮助中心',
            color: Colors.blue,
            onTap: () => Get.snackbar('提示', '帮助中心'),
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: '关于我们',
            color: Colors.grey,
            onTap: () => Get.snackbar('提示', '关于我们'),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, Color color) {
    return GestureDetector(
      onTap: () {
        Get.snackbar('提示', '查看$label订单');
      },
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}

