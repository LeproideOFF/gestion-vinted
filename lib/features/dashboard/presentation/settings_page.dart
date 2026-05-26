import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/theme/settings_provider.dart';
import '../../../shared/glass_container.dart';
import '../../inventory/presentation/market_provider.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../../../core/utils/log_service.dart';
import '../../../core/utils/discord_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _showLogs = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return settingsAsync.when(
      data: (settings) {
        final themeType = settings['theme'] as GlassTheme;

        return Scaffold(
          extendBody: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                const SliverAppBar.large(
                  backgroundColor: Colors.transparent,
                  title: Text('Paramètres', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildSection(
                          'SÉCURITÉ',
                          [
                            _buildSwitchTile(
                              'Verrouillage Biométrique',
                              'FaceID / TouchID',
                              Icons.face_unlock_rounded,
                              settings['useBiometrics'] ?? false,
                              (val) => ref.read(appSettingsProvider.notifier).setBiometrics(val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _buildSection(
                          'NOTIFICATIONS DISCORD',
                          [
                            _buildSwitchTile(
                              'Activer Discord',
                              'Notifications automatiques',
                              Icons.discord_rounded,
                              settings['discordEnabled'] ?? false,
                              (val) => ref.read(appSettingsProvider.notifier).setDiscordEnabled(val),
                            ),
                            if (settings['discordEnabled'] ?? false) ...[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Webhook URL',
                                        prefixIcon: const Icon(Icons.link_rounded),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.send_rounded, color: Colors.blue),
                                          onPressed: () async {
                                            final success = await ref.read(discordServiceProvider.notifier).sendTestMessage();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(success ? '✅ Message de test envoyé !' : '❌ Échec de l\'envoi (vérifiez l\'URL)'),
                                                backgroundColor: success ? Colors.green : Colors.red,
                                              ),
                                            );
                                          },
                                          tooltip: 'Tester le Webhook',
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 12),
                                      controller: TextEditingController(text: settings['discordWebhookUrl'] as String? ?? '')..selection = TextSelection.fromPosition(TextPosition(offset: (settings['discordWebhookUrl'] as String? ?? '').length)),
                                      onChanged: (val) => ref.read(appSettingsProvider.notifier).setDiscordWebhookUrl(val),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Nom du Bot',
                                              prefixIcon: const Icon(Icons.smart_toy_rounded),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                            ),
                                            style: const TextStyle(fontSize: 12),
                                            controller: TextEditingController(text: settings['discordBotName'] as String? ?? ''),
                                            onChanged: (val) => ref.read(appSettingsProvider.notifier).setDiscordBotName(val),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'URL Avatar',
                                              prefixIcon: const Icon(Icons.face_rounded),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                            ),
                                            style: const TextStyle(fontSize: 12),
                                            controller: TextEditingController(text: settings['discordBotAvatar'] as String? ?? ''),
                                            onChanged: (val) => ref.read(appSettingsProvider.notifier).setDiscordBotAvatar(val),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              _buildSwitchTile(
                                'Alertes de Ventes',
                                'Notifier lors d\'une vente et afficher le profit',
                                Icons.monetization_on_rounded,
                                settings['discordNotifySales'] ?? true,
                                (val) => ref.read(appSettingsProvider.notifier).setDiscordNotifySales(val),
                              ),
                              _buildSwitchTile(
                                'Alertes Fiscales',
                                'Prévenir à 80% du seuil des 3000€',
                                Icons.warning_amber_rounded,
                                settings['discordNotifyFiscal'] ?? true,
                                (val) => ref.read(appSettingsProvider.notifier).setDiscordNotifyFiscal(val),
                              ),
                              _buildSwitchTile(
                                'Alertes Synchronisation',
                                'Confirmer les échanges entre appareils',
                                Icons.sync_rounded,
                                settings['discordNotifySync'] ?? true,
                                (val) => ref.read(appSettingsProvider.notifier).setDiscordNotifySync(val),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 25),
                        _buildSection(
                          'DIAGNOSTIC',
                          [
                            ListTile(
                              leading: const Icon(Icons.bug_report_rounded),
                              title: const Text('Voir les logs de crash'),
                              trailing: Switch(value: _showLogs, onChanged: (v) => setState(() => _showLogs = v)),
                            ),
                            if (_showLogs)
                              Container(
                                height: 200,
                                padding: const EdgeInsets.all(10),
                                color: Colors.black12,
                                child: ListView(
                                  children: LogService.logs.reversed.map((l) => Text(l, style: const TextStyle(fontSize: 10, fontFamily: 'monospace'))).toList(),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _buildSection(
                          'SYSTÈME',
                          [
                            ListTile(
                              leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                              title: const Text('Réinitialiser les données', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              onTap: () => _confirmReset(context, ref),
                            ),
                          ],
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Erreur: $e')),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey)),
        ),
        GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
      value: value,
      onChanged: onChanged,
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tout supprimer ?'),
        content: const Text('Cette action supprimera tout votre inventaire et vos réglages.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
          TextButton(
            onPressed: () async {
              final isar = await ref.read(isarServiceProvider).db;
              await isar.writeTxn(() => isar.clear());
              Navigator.pop(context);
            },
            child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
