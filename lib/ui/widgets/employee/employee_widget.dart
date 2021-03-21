import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/widgets/common/account/account_widget.dart';
import 'package:sopi/ui/widgets/employee/orders/order_widget.dart';

class EmployeeWidget extends StatefulWidget {
  @override
  _EmployeeWidgetState createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget> {
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  int _bottomSelectedIndex = 0;

  void _bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _bottomTapped,
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white30,
        selectedItemColor: Colors.white,
        currentIndex: _bottomSelectedIndex,
        items: _buildBottomNavBarItems(),
      ),
    );
  }

  Widget _buildPageView() {
    List<Widget> children = [
      OrderWidget(),
      AccountWidget()
    ];
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _pageChanged(index);
      },
      children: children,
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.list_alt,
        ),
        label: 'Orders',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
        ),
        label: 'Account',
      ),
    ];
  }
}
