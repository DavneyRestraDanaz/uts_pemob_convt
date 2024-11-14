import 'package:flutter/material.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentPage = 1;

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
  final Color _primaryOrange = const Color(0xFFFF8C00);

  Future<void> _onItemTapped(int index) async {
    if (index == _currentPage) return;

    try {
      if (index == 0) {
        await Navigator.pushReplacementNamed(context, '/menu');
      } else if (index == 1) {
        await Navigator.pushReplacementNamed(context, '/profile');
      }
      
      if (mounted) {
        setState(() {});
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

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _primaryOrange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: _primaryOrange.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _primaryOrange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryOrange.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: _primaryOrange.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryOrange),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: _primaryOrange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/menu');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: _primaryOrange,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/menu');
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            _primaryOrange,
                            _primaryOrange.darker,
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/me.jpg'),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Davney Restra Danaz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'davney.restra@mhs.itenas.ac.id',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('Semester', '5'),
                          _buildStatCard('SKS', '80'),
                          _buildStatCard('IPK', '3.49'),
                        ],
                      ),
                    ),
                    _buildSectionTitle('Informasi Personal'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildInfoCard(
                            Icons.school,
                            'Institut',
                            'Institut Teknologi Nasional Bandung',
                          ),
                          _buildInfoCard(
                            Icons.book,
                            'Program Studi',
                            'Informatika',
                          ),
                          _buildInfoCard(
                            Icons.badge,
                            'NIM',
                            '152022069',
                          ),
                          _buildInfoCard(
                            Icons.location_on,
                            'Alamat',
                            'Bandung, Jawa Barat',
                          ),
                          _buildInfoCard(
                            Icons.phone,
                            'Nomor Telepon',
                            '+62 895-3719-68864',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CubertoBottomBar(
          key: const Key("BottomBar"),
          inactiveIconColor: _inactiveColor,
          tabStyle: CubertoTabStyle.styleNormal,
          selectedTab: _currentPage,
          tabs: tabs,
          onTabChangedListener: (position, title, color) async {
            await _onItemTapped(position);
          },
        ),
      ),
    );
  }
}

extension ColorExtension on Color {
  Color get darker {
    const factor = 0.8;
    return Color.fromARGB(
      alpha,
      (red * factor).round(),
      (green * factor).round(),
      (blue * factor).round(),
    );
  }
}
