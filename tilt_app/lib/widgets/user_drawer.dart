import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDrawer extends StatelessWidget {
  final GoogleSignInAccount? account;
  final List<Widget>? actions;
  final VoidCallback? onLogout;

  UserDrawer({this.account, this.actions, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(account?.email ?? "Unknown user email"),
            accountName: Text(account?.displayName ?? "Unknown user name"),
            currentAccountPicture: CircleAvatar(
              radius: 10.0,
              backgroundImage: NetworkImage(account?.photoUrl ?? ""),
            ),
          ),
          ...actions ?? [],
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
