import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class EditProfileScreenView extends StatelessWidget {
  const EditProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('My Profile'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: controller.pickAvatar,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.black12,
                                  backgroundImage: controller.avatar != null ? FileImage(controller.avatar!) : null,
                                  child: controller.avatar == null
                                      ? const Icon(Icons.person, size: 40, color: Colors.black54)
                                      : null,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      const Text(
                        'Personal Info',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.nameController,
                        validator: controller.validateName,
                        decoration: InputDecoration(
                          hintText: 'Your name',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/malaysia-flag.png',
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '+60',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: controller.phoneController,
                              validator: controller.validatePhone,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '167743923',
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // const Text(
                      //   'Email',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // const SizedBox(height: 8),
                      // TextFormField(
                      //   controller: controller.emailController,
                      //   validator: controller.validateEmail,
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: InputDecoration(
                      //     hintText: 'you@example.com',
                      //     filled: true,
                      //     fillColor: Colors.grey.shade100,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //       borderSide: BorderSide(color: Colors.grey.shade300),
                      //     ),
                      //     enabled: true,
                      //   ),
                      // ),
                      // const SizedBox(height: 16),
                      // const Text(
                      //   'Manage Account',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w700,
                      //   ),
                      // ),
                      // const SizedBox(height: 12),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.facebook, color: Colors.blue),
                      //     const SizedBox(width: 8),
                      //     const Expanded(child: Text('Facebook')),
                      //     OutlinedButton(
                      //       onPressed: () {},
                      //       style: OutlinedButton.styleFrom(
                      //         side: const BorderSide(color: Colors.red),
                      //       ),
                      //       child: const Text(
                      //         'Link',
                      //         style: TextStyle(color: Colors.red),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 8),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.g_mobiledata, color: Colors.red),
                      //     const SizedBox(width: 8),
                      //     const Expanded(child: Text('Google')),
                      //     OutlinedButton(
                      //       onPressed: () {},
                      //       child: const Text('Unlink'),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 16),
                      const SizedBox(height: 24),
                      if (controller.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: controller.isSaving
                              ? null
                              : controller.save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
