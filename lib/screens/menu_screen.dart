import 'package:flutter/material.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentPage = 0;
  bool _isGridView = true;

  final List<TabData> tabs = [
    const TabData(
      title: 'Menu',
      iconData: Icons.home,
      tabColor: Color(0xFFFF8C00),
    ),
    const TabData(
      title: 'Profil',
      iconData: Icons.person,
      tabColor: Color(0xFFFF8C00),
    ),
  ];

  final Color _inactiveColor = const Color(0xFFFF8C00);

  Future<void> _onItemTapped(int index) async {
    if (index == _currentPage) return;

    try {
      if (index == 0) {
        await Navigator.pushReplacementNamed(context, '/menu');
      } else if (index == 1) {
        await Navigator.pushReplacementNamed(context, '/profile');
      }
      
      if (mounted) {
        setState(() {
          _currentPage = index;
        });
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat berpindah halaman'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        backgroundColor: const Color(0xFFFF8C00),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: _isGridView ? _buildGridView() : _buildListView(),
      bottomNavigationBar: CubertoBottomBar(
        key: const Key("BottomBar"),
        inactiveIconColor: _inactiveColor,
        tabStyle: CubertoTabStyle.styleNormal,
        selectedTab: _currentPage,
        tabs: tabs,
        onTabChangedListener: (position, title, color) {
          _onItemTapped(position);
        },
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildMenuItem(context, 'Kalkulator', Icons.calculate, '/calculator'),
        _buildMenuItem(context, 'Konversi Mata Uang', Icons.attach_money, '/currency_conversion'),
        _buildMenuItem(context, 'Ukur Panjang', Icons.straighten, '/length_conversion'),
        _buildMenuItem(context, 'Ukur Suhu', Icons.thermostat, '/temperature_conversion'),
        _buildMenuItem(context, 'Ukur Waktu', Icons.access_time, '/time_conversion'),
        _buildMenuItem(context, 'Ukur BMI', Icons.health_and_safety, '/bmi_calculator'),
        _buildMenuItem(context, 'Ukur Volume', Icons.invert_colors, '/volume_conversion'),
      ],
    );
  }

  Widget _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMenuItem(context, 'Kalkulator', Icons.calculate, '/calculator'),
        _buildMenuItem(context, 'Konversi Mata Uang', Icons.attach_money, '/currency_conversion'),
        _buildMenuItem(context, 'Ukur Panjang', Icons.straighten, '/length_conversion'),
        _buildMenuItem(context, 'Ukur Suhu', Icons.thermostat, '/temperature_conversion'),
        _buildMenuItem(context, 'Ukur Waktu', Icons.access_time, '/time_conversion'),
        _buildMenuItem(context, 'Ukur BMI', Icons.health_and_safety, '/bmi_calculator'),
        _buildMenuItem(context, 'Ukur Volume', Icons.invert_colors, '/volume_conversion'),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: _isGridView ? 0 : 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8C00),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: _isGridView ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              if (!_isGridView) ...[
                const SizedBox(width: 20),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
