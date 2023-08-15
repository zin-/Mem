import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/components/l10n.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/mems/list/page.dart';
import 'package:mem/mems/list/show_new_mem_fab.dart';
import 'package:mem/notifications/client.dart';
import 'package:mem/values/colors.dart';

class MemApplication extends StatelessWidget {
  final Widget? home;
  final String? languageCode;

  const MemApplication(this.languageCode, {this.home, super.key});

  @override
  Widget build(BuildContext context) => i(
        () {
          NotificationClient(context);
          final l10n = buildL10n(context);

          return ProviderScope(
            child: MaterialApp(
              onGenerateTitle: (context) => l10n.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: languageCode == null ? null : Locale(languageCode!),
              theme: ThemeData(
                primarySwatch: primaryColor,
                bottomAppBarTheme: const BottomAppBarTheme(
                  color: primaryColor,
                ),
              ),
              home: home ?? _HomePage(),
            ),
          );
        },
      );
}

class _HomePage extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO ScaffoldからNavigationBarまでの制御をここで行う
    return Scaffold(
      body: MemListPage(_scrollController),
      floatingActionButton: ShowNewMemFab(_scrollController),
    );
  }
}
