import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60); // Adjust the height as needed

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.equalizer, color: AppColors.black, size: 35),
                  onPressed: () {
                    Navigator.pushNamed(context, '/noti-setting');
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profile_page/dog.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        // const SizedBox(width: 20),
      ],
    );
  }
}
