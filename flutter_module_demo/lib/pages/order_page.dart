import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('订单'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: '全部'),
                Tab(text: '待支付'),
                Tab(text: '待使用'),
                Tab(text: '已完成'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList('全部'),
                  _buildOrderList('待支付'),
                  _buildOrderList('待使用'),
                  _buildOrderList('已完成'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    final orders = List.generate(5, (index) => {
      'id': 'ORDER${1000 + index}',
      'title': '订单标题 ${index + 1}',
      'status': status,
      'amount': (index + 1) * 88.0,
      'date': '2024-01-${10 + index}',
    });

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无$status订单',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor;
    switch (order['status']) {
      case '待支付':
        statusColor = Colors.orange;
        break;
      case '待使用':
        statusColor = Colors.blue;
        break;
      case '已完成':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['id'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order['title'],
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['date'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '¥${order['amount'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (order['status'] == '待支付')
                TextButton(
                  onPressed: () {
                    Get.snackbar('提示', '跳转到支付页面');
                  },
                  child: const Text('去支付'),
                ),
              TextButton(
                onPressed: () {
                  Get.snackbar('提示', '查看订单详情');
                },
                child: const Text('查看详情'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

