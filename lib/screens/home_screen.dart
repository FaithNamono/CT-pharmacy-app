import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Tracks which tab is selected

  // List of screens for each tab
  final List<Widget> _screens = [
    const DashboardScreen(), // Tab 0 - Dashboard
    const InventoryScreen(), // Tab 1 - Inventory
    const SalesScreen(),     // Tab 2 - Sales
    const PrescriptionScreen(), // Tab 3 - Prescriptions
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light grey background
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.medical_services, color: Colors.white), // Pharmacy icon
            SizedBox(width: 8), // Spacing between icon and text
            Text(
              'CT Pharmacy',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60), // Green app bar
        elevation: 0, // Remove shadow
        centerTitle: false, // Align left
        actions: [
          // Notification icon
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
            tooltip: 'Notifications',
          ),
          // Profile icon
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implement profile
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: _screens[_currentIndex], // Show current screen based on selected tab
      bottomNavigationBar: _buildBottomNavigationBar(), // Navigation bar at bottom
      floatingActionButton: _currentIndex == 2 
          ? FloatingActionButton(
              onPressed: () {
                _startNewSale(); // Start new sale when FAB pressed
              },
              backgroundColor: const Color(0xFF27AE60), // Green FAB
              child: const Icon(Icons.add, color: Colors.white), // Plus icon
            )
          : null, // Only show FAB on Sales tab
    );
  }

  void _startNewSale() {
    print('Starting new sale...'); // TODO: Implement new sale functionality
  }

  // Build the bottom navigation bar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Currently selected tab
      onTap: (index) {
        setState(() {
          _currentIndex = index; // Update selected tab when user taps
        });
      },
      type: BottomNavigationBarType.fixed, // All tabs visible
      backgroundColor: Colors.white, // White background
      selectedItemColor: const Color(0xFF27AE60), // Green selected tab
      unselectedItemColor: Colors.grey[600], // Grey unselected tabs
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600), // Bold selected label
      elevation: 4, // Shadow
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale_outlined),
          activeIcon: Icon(Icons.point_of_sale),
          label: 'POS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services_outlined),
          activeIcon: Icon(Icons.medical_services),
          label: 'Prescriptions',
        ),
      ],
    );
  }
}

// Dashboard Screen - Main home screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align left
        children: [
          _buildWelcomeCard(), // Welcome card at top
          const SizedBox(height: 24), // Spacing
          const Text(
            'Quick Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50), // Dark text
            ),
          ),
          const SizedBox(height: 16), // Spacing
          _buildStatsGrid(), // Statistics cards grid
          const SizedBox(height: 24), // Spacing
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16), // Spacing
          _buildQuickActions(), // Quick action buttons grid
          const SizedBox(height: 24), // Spacing
          _buildRecentActivity(), // Recent activity list
        ],
      ),
    );
  }

  // Welcome card with gradient background
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity, // Full width
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF27AE60), Color(0xFF219653)], // Green gradient
        ),
        borderRadius: BorderRadius.circular(16), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3), // Green shadow
            blurRadius: 10,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4), // Small spacing
                const Text(
                  'Credibal Therauptics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8), // Spacing
                Text(
                  'Manage your pharmacy efficiently',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9), // Semi-transparent white
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Semi-transparent white circle
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // Grid of statistics cards
  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2, // 2 cards per row
      shrinkWrap: true, // Only take needed space
      physics: const NeverScrollableScrollPhysics(), // Prevent scrolling inside grid
      crossAxisSpacing: 12, // Horizontal spacing between cards
      mainAxisSpacing: 12, // Vertical spacing between cards
      children: [
        _buildStatCard(
          'Today\'s Sales',
          'UGX 285,000',
          Icons.attach_money_rounded,
          const Color(0xFF27AE60), // Green
          '+12% from yesterday',
        ),
        _buildStatCard(
          'Total Products',
          '142',
          Icons.inventory_2_rounded,
          const Color(0xFF3498DB), // Blue
          '8 low in stock',
        ),
        _buildStatCard(
          'Pending Rx',
          '7',
          Icons.medical_services,
          const Color(0xFF9B59B6), // Purple
          '3 need attention',
        ),
        _buildStatCard(
          'Expiring Soon',
          '5 Items',
          Icons.calendar_today_rounded,
          const Color(0xFFE74C3C), // Red
          'Next 30 days',
        ),
      ],
    );
  }

  // Individual statistic card
  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      elevation: 2, // Shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1), // Light background for icon
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12), // Spacing
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50), // Dark text
              ),
            ),
            const SizedBox(height: 4), // Small spacing
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600], // Grey text
              ),
            ),
            const SizedBox(height: 4), // Small spacing
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500], // Light grey text
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid of quick action buttons
  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2, // 2 buttons per row
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildActionCard(
          'New Sale',
          Icons.point_of_sale_rounded,
          const Color(0xFF27AE60), // Green
        ),
        _buildActionCard(
          'Add Product',
          Icons.add_circle_outline_rounded,
          const Color(0xFF3498DB), // Blue
        ),
        _buildActionCard(
          'Stock Check',
          Icons.search_rounded,
          const Color(0xFF9B59B6), // Purple
        ),
        _buildActionCard(
          'View Reports',
          Icons.analytics_rounded,
          const Color(0xFFE74C3C), // Red
        ),
      ],
    );
  }

  // Individual quick action card
  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          print('$title tapped'); // TODO: Implement action
        },
        borderRadius: BorderRadius.circular(12), // Rounded corners for tap area
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1), // Light background for icon
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12), // Spacing
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50), // Dark text
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Recent activity section
  Widget _buildRecentActivity() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history_rounded, color: Color(0xFF27AE60)), // History icon
                SizedBox(width: 8), // Spacing
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Spacing
            _buildActivityItem('Paracetamol 500mg', 'Sale completed', 'UGX 3,000', Icons.sell_rounded),
            _buildActivityItem('Amoxicillin 250mg', 'Low stock alert', '12 units left', Icons.warning_amber_rounded),
            _buildActivityItem('Vitamin C 1000mg', 'New stock added', '50 units', Icons.inventory_2_rounded),
            _buildActivityItem('Dr. Mugisha', 'Prescription received', '2 items', Icons.description),
          ],
        ),
      ),
    );
  }

  // Individual activity item in the list
  Widget _buildActivityItem(String title, String subtitle, String value, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // Remove default padding
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF27AE60).withOpacity(0.1), // Light green background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF27AE60), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF27AE60), // Green value text
        ),
      ),
    );
  }
}

// Placeholder screen for Inventory tab
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Inventory Management',
        style: TextStyle(fontSize: 24, color: Color(0xFF2C3E50)),
      ),
    );
  }
}

// Placeholder screen for Sales tab
class SalesScreen extends StatelessWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Point of Sale',
        style: TextStyle(fontSize: 24, color: Color(0xFF2C3E50)),
      ),
    );
  }
}

// Placeholder screen for Prescriptions tab
class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Prescription Management',
        style: TextStyle(fontSize: 24, color: Color(0xFF2C3E50)),
      ),
    );
  }
}