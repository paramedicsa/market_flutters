import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'notifications_screen.dart';
import 'affiliates_screen.dart';
import 'artists_screen.dart';
import 'members_screen.dart';
import 'users_screen.dart';
import 'collections_management_screen.dart';
import 'gift_cards_screen.dart';
import 'vault_screen.dart';
import 'social_media_screen.dart';
import 'weekly_winners_screen.dart';
import 'expenses_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 14,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: AppTheme.black,
              child: TabBar(
                isScrollable: true,
                indicatorColor: AppTheme.shockingPink,
                indicatorWeight: 3,
                labelColor: AppTheme.shockingPink,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Orders'),
                  Tab(text: 'Products'),
                  Tab(text: 'Collections'),
                  Tab(text: 'Vault'),
                  Tab(text: 'Notifications'),
                  Tab(text: 'Affiliates'),
                  Tab(text: 'Artists'),
                  Tab(text: 'Members'),
                  Tab(text: 'Users'),
                  Tab(text: 'Gift Cards'),
                  Tab(text: 'Social Media'),
                  Tab(text: 'Weekly Winners'),
                  Tab(text: 'Expenses'),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: AppTheme.black,
          child: const TabBarView(
            children: [
              DashboardScreen(),
              OrdersScreen(),
              ProductsScreen(),
              CollectionsManagementScreen(),
              VaultScreen(),
              NotificationsScreen(),
              AffiliatesScreen(),
              ArtistsScreen(),
              MembersScreen(),
              UsersScreen(),
              GiftCardsScreen(),
              SocialMediaScreen(),
              WeeklyWinnersScreen(),
              ExpensesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
