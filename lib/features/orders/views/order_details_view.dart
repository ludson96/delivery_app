import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../models/order_model.dart';
import '../viewmodels/orders_viewmodel.dart';

class OrderDetailsView extends ConsumerWidget {
  final int orderId;

  const OrderDetailsView({super.key, required this.orderId});

  Widget _buildStatusTimeline(String currentStatus) {
    final steps = ['Pendente', 'Preparando', 'Em Trânsito', 'Entregue'];
    final s = currentStatus.toLowerCase();
    int activeIndex = 0;
    if (s.contains('entregue')) {
      activeIndex = 3;
    } else if (s.contains('trânsito') || s.contains('transito')) {
      activeIndex = 2;
    } else if (s.contains('preparando')) {
      activeIndex = 1;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acompanhamento em Tempo Real ⚡',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Linha conectora
                final stepIndex = index ~/ 2;
                final isDone = stepIndex < activeIndex;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: isDone ? AppColors.statusDelivered : AppColors.border,
                  ),
                );
              }

              final stepIndex = index ~/ 2;
              final isDone = stepIndex <= activeIndex;
              final isCurrent = stepIndex == activeIndex;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? AppColors.statusDelivered : AppColors.surfaceVariant,
                      border: Border.all(
                        color: isCurrent ? AppColors.primary : (isDone ? AppColors.statusDelivered : AppColors.border),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '${stepIndex + 1}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[stepIndex],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                      color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos o list notifier para pegar atualizações em tempo real vindas do socket
    final ordersAsync = ref.watch(ordersViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detalhes do Pedido #$orderId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/orders');
            }
          },
        ),
      ),
      body: ordersAsync.when(
        data: (orders) {
          final order = orders.firstWhere(
            (o) => o.id == orderId,
            orElse: () => OrderModel(
              id: orderId,
              sellerId: 2,
              status: 'Pendente',
              saleDate: '',
              totalPrice: 0,
            ),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusTimeline(order.status),
                const SizedBox(height: 18),

                // Informações de Endereço e Data
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
                          const Text('Data do Pedido:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const Spacer(),
                          Text(Formatters.formatDate(order.saleDate), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                      if (order.deliveryAddress.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 10),
                            const Text('Entrega:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                '${order.deliveryAddress}, ${order.deliveryNumber}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Lista de Itens do Pedido se disponíveis
                if (order.products.isNotEmpty) ...[
                  const Text(
                    'Produtos do Pedido',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.products.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
                      itemBuilder: (context, index) {
                        final item = order.products[index];
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: item.urlImage.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: item.urlImage,
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.contain,
                                        errorWidget: (context, url, error) => const Icon(Icons.sports_bar),
                                      )
                                    : const Icon(Icons.sports_bar),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text('${item.quantity} un x ${Formatters.formatCurrency(item.price)}',
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text(
                                Formatters.formatCurrency(item.price * item.quantity),
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Total Final
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Formatters.formatCurrency(order.totalPrice),
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}
