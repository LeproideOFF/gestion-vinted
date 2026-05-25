import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/sync_service.dart';
import '../../../shared/glass_container.dart';

class SyncPage extends ConsumerWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Synchronisation P2P', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRadarAnimation(syncState.status),
                const SizedBox(height: 60),
                
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        _getStatusText(syncState),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ).animate(key: ValueKey(syncState.status)).fadeIn().slideY(begin: 0.1, end: 0),
                      
                      if (syncState.pin != null) ...[
                        const SizedBox(height: 20),
                        const Text('CODE D\'APPAIRAGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text(
                          syncState.pin!,
                          style: const TextStyle(fontSize: 42, letterSpacing: 10, fontWeight: FontWeight.w900, color: Colors.blue),
                        ).animate().scale().shake(),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                if (syncState.status == SyncStatus.idle) ...[
                  _buildActionButton(
                    label: 'RECEVOIR (Hôte)',
                    icon: Icons.downloading_rounded,
                    color: Colors.blue,
                    onTap: () => ref.read(syncNotifierProvider.notifier).startAdvertising(),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    label: 'ENVOYER (Client)',
                    icon: Icons.upload_file_rounded,
                    color: Colors.deepPurple,
                    onTap: () => ref.read(syncNotifierProvider.notifier).startDiscovery(),
                  ).animate().fadeIn(delay: 400.ms),
                ] else
                  TextButton.icon(
                    onPressed: () => ref.read(syncNotifierProvider.notifier).stop(),
                    icon: const Icon(Icons.stop_circle_rounded, color: Colors.red),
                    label: const Text('ANNULER LA RECHERCHE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ).animate().fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GlassContainer(
      borderRadius: 20,
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 20),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadarAnimation(SyncStatus status) {
    bool isActive = status == SyncStatus.scanning || status == SyncStatus.advertising;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isActive)
          ...List.generate(3, (i) => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
            ),
          ).animate(onPlay: (c) => c.repeat()).scale(
            begin: const Offset(1, 1),
            end: const Offset(3, 3),
            duration: 2.seconds,
            delay: (i * 600).ms,
            curve: Curves.easeOut,
          ).fadeOut()),
        
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 30, spreadRadius: 10)
            ],
          ),
          child: Icon(
            _getCenterIcon(status),
            size: 60,
            color: _getIconColor(status),
          ).animate(onPlay: (c) => isActive ? c.repeat() : c.stop())
           .shimmer(duration: 2.seconds),
        ),
      ],
    );
  }

  IconData _getCenterIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.success: return Icons.check_circle_rounded;
      case SyncStatus.failure: return Icons.error_rounded;
      case SyncStatus.transferring: return Icons.swap_calls_rounded;
      default: return Icons.bolt_rounded;
    }
  }

  Color _getIconColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.success: return Colors.green;
      case SyncStatus.failure: return Colors.red;
      case SyncStatus.transferring: return Colors.orange;
      default: return Colors.blue;
    }
  }

  String _getStatusText(SyncState state) {
    switch (state.status) {
      case SyncStatus.idle: return 'Prêt pour la synchronisation magique';
      case SyncStatus.advertising: return 'HÔTE : En attente d\'un appareil...';
      case SyncStatus.scanning: return 'CLIENT : Recherche d\'appareils...';
      case SyncStatus.connecting: return 'Connexion sécurisée établie...';
      case SyncStatus.transferring: return 'Transfert des données et photos...';
      case SyncStatus.success: return state.message ?? 'Synchro réussie !';
      case SyncStatus.failure: return state.message ?? 'Échec de la connexion.';
      default: return '';
    }
  }
}
