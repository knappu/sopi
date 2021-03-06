import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopi/services/authentication/authentication_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';

class AccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight + 20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: primaryColor,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            radius: double.infinity,
                            backgroundImage:
                                AssetImage('assets/images/sopi_logo.png'),
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(.7),
                          radius: 14.0,
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text('Hi, Thomas'),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                  },
                  child: Text("Sign out"),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text('  ')),
        ],
      ),
    );
  }
}
