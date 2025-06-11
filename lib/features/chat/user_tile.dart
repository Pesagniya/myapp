import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String email;
  final String photoUrl;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.email,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : const AssetImage('assets/images/default_pp.png')
                          as ImageProvider,
            ),
            const SizedBox(width: 12),
            Text(email, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
