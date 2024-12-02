import 'package:flutter/material.dart';
import 'package:todo/service/constants.dart';
import 'package:todo/service/database.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    void resetPassword() async {
      if (emailController.text.isNotEmpty &&
          newPasswordController.text.isNotEmpty) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );

        String res = await DatabaseMethods().forgot(emailController.text);

        // Ensure the widget is still mounted before calling Navigator.pop
        if (!context.mounted) {
          return;
        }
        if (res != success) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(content: Text(res)));
          return;
        }
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content:
                const Text('Password reset link has been sent to your email'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          ),
        );
      } else {
        // If fields are empty, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields.')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: Colors.yellow[500],
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.yellow[50],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your email and new password:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[500],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
