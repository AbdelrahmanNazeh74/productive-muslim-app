import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../analytics/domain/entities/analytics_entities.dart';
import '../../../analytics/presentation/bloc/analytics_bloc.dart';
import '../../../analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../habits/presentation/pages/habits_page.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../ramadan/presentation/pages/ramadan_dashboard_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../timeline/presentation/pages/timeline_dashboard_page.dart';

class HomeShell extends StatefulWidget {
  final UserProfile? profile;
  const HomeShell({super.key, this.profile});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final isRamadan = profile?.isRamadanMode ?? false;

    final tabs = [
      TimelineDashboardPage(profile: profile),
      const HabitsPage(),
      const AnalyticsDashboardPage(),
      if (isRamadan && profile != null)
        RamadanDashboardPage(profile: profile),
      const SettingsPage(),
    ];

    final navItems = [
      const _NavItem(icon: Icons.view_day_outlined,        activeIcon: Icons.view_day,            label: 'Timeline'),
      const _NavItem(icon: Icons.local_fire_department_outlined, activeIcon: Icons.local_fire_department, label: 'Habits'),
      const _NavItem(icon: Icons.bar_chart_outlined,       activeIcon: Icons.bar_chart,            label: 'Analytics'),
      if (isRamadan)
        const _NavItem(icon: Icons.nights_stay_outlined,   activeIcon: Icons.nights_stay,          label: 'Ramadan'),
      const _NavItem(icon: Icons.person_outline,           activeIcon: Icons.person,               label: 'Profile'),
    ];

    final safeIndex = _currentIndex.clamp(0, tabs.length - 1);
    final body = _AnalyticsAwareStack(index: safeIndex, children: tabs);

    // ── Tablet: NavigationRail on the side ───────────────────────────────────
    if (context.isTablet) {
      final extended = context.isLandscape;
      final cs = Theme.of(context).colorScheme;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: safeIndex,
              onDestinationSelected: (i) => setState(() => _currentIndex = i),
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              extended: extended,
              backgroundColor: isRamadan
                  ? const Color(0xFF0D1B2A)
                  : cs.surface,
              selectedIconTheme: IconThemeData(
                color: isRamadan ? AppColors.gold : cs.primary,
              ),
              unselectedIconTheme: IconThemeData(
                color: isRamadan ? Colors.white38 : cs.onSurfaceVariant,
              ),
              selectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
                color: isRamadan ? AppColors.gold : cs.primary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
              unselectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
                color: isRamadan ? Colors.white38 : cs.onSurfaceVariant,
                fontSize: 11,
              ),
              indicatorColor: isRamadan
                  ? AppColors.gold.withValues(alpha: 0.15)
                  : cs.primary.withValues(alpha: 0.08),
              destinations: navItems
                  .map((item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.activeIcon),
                        label: Text(item.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    // ── Phone: BottomNavigationBar ────────────────────────────────────────────
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final AuthUser? authUser = authState is AuthAuthenticated &&
                !authState.user.isAnonymous
            ? authState.user
            : null;
        return Scaffold(
          body: body,
          bottomNavigationBar: _BottomNav(
            items: navItems,
            currentIndex: safeIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            isRamadanMode: isRamadan,
            authUser: authUser,
          ),
        );
      },
    );
  }
}

// ─── BOTTOM NAV ───────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isRamadanMode;
  final AuthUser? authUser;

  const _BottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.isRamadanMode,
    this.authUser,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.navItemHPadding(context, items.length);
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: isRamadanMode ? const Color(0xFF0D1B2A) : cs.surface,
        border: Border(
          top: BorderSide(
            color: isRamadanMode
                ? Colors.white.withValues(alpha: 0.08)
                : cs.outlineVariant,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = currentIndex == i;
              final isRamadanTab = item.label == 'Ramadan';

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: hPad * 0.5),
                    padding: EdgeInsets.symmetric(
                        horizontal: hPad, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? (isRamadanTab
                              ? AppColors.gold.withValues(alpha: 0.15)
                              : cs.primary.withValues(alpha: 0.08))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTabIcon(
                          context: context,
                          cs: cs,
                          item: item,
                          isActive: isActive,
                          isRamadanTab: isRamadanTab,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isActive
                                ? (isRamadanTab
                                    ? AppColors.gold
                                    : (isRamadanMode
                                        ? Colors.white
                                        : cs.primary))
                                : (isRamadanMode
                                    ? Colors.white38
                                    : cs.onSurfaceVariant),
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabIcon({
    required BuildContext context,
    required ColorScheme cs,
    required _NavItem item,
    required bool isActive,
    required bool isRamadanTab,
  }) {
    final isProfileTab = item.label == 'Profile';
    if (isProfileTab && authUser != null) {
      // Show network photo when available (BUG 1 fix)
      final photoUrl = authUser!.photoUrl;
      if (photoUrl != null && photoUrl.isNotEmpty) {
        return CircleAvatar(
          radius: 12,
          backgroundImage: NetworkImage(photoUrl),
          onBackgroundImageError: (_, __) {},
          backgroundColor: cs.primary.withValues(alpha: 0.3),
        );
      }
      // Fallback: initial letter avatar
      final initial = (authUser!.displayName?.isNotEmpty == true
              ? authUser!.displayName!
              : authUser!.email)
          .substring(0, 1)
          .toUpperCase();
      return CircleAvatar(
        radius: 12,
        backgroundColor:
            isActive ? cs.primary : cs.primary.withValues(alpha: 0.3),
        child: Text(
          initial,
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Icon(
      isActive ? item.activeIcon : item.icon,
      color: isActive
          ? (isRamadanTab
              ? AppColors.gold
              : (isRamadanMode ? Colors.white : cs.primary))
          : (isRamadanMode ? Colors.white38 : cs.onSurfaceVariant),
      size: 24,
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon,
      required this.activeIcon,
      required this.label});
}

// ─── ANALYTICS-AWARE STACK ───────────────────────────────────────────────────
/// Keeps all tabs alive in a Stack; triggers analytics load on first visit.
class _AnalyticsAwareStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  const _AnalyticsAwareStack(
      {required this.index, required this.children});

  @override
  State<_AnalyticsAwareStack> createState() =>
      _AnalyticsAwareStackState();
}

class _AnalyticsAwareStackState extends State<_AnalyticsAwareStack> {
  static const _analyticsTabIndex = 2;
  bool _analyticsLoaded = false;

  @override
  void didUpdateWidget(_AnalyticsAwareStack old) {
    super.didUpdateWidget(old);
    if (widget.index == _analyticsTabIndex && !_analyticsLoaded) {
      _analyticsLoaded = true;
      context
          .read<AnalyticsBloc>()
          .add(const AnalyticsLoadRequested(AnalyticsPeriod.week));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List.generate(widget.children.length, (i) {
        final isActive = i == widget.index;
        return IgnorePointer(
          ignoring: !isActive,
          child: AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: widget.children[i],
          ),
        );
      }),
    );
  }
}
