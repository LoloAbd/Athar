import '../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/text_form_field.dart';
import '../widgets/shared_text.dart';
import '../widgets/shared_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? _email;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        _nameController.text = data?['name'] ?? '';
        _usernameController.text = data?['username'] ?? '';
        _email = data?['email'] ?? user.email ?? '';
      } else {
        _email = user.email ?? '';
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveChanges(AppLocalizations t) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'username': _usernameController.text.trim(),
      });

      if (!mounted) return;

      SharedSnackBar.showSuccess(
        context: context,
        message: t.profileUpdatedSuccessfully,
      );
      
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('Error updating profile: $e');

      if (!mounted) return;

      SharedSnackBar.showError(context: context, message: t.failedToSave);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,

        title: SharedText(
          title: t.editProfile,
          colorString: Colors.white,
          fontNum: 19,
          fontWeight: FontWeight.bold,
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.gold,
                                width: 3.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.background.withValues(
                                    alpha: 0.5,
                                  ),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 65.0,
                              backgroundImage: AssetImage(
                                'assets/images/loginProf.jpg',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: SharedText(
                          title: t.personalInformation,
                          colorString: AppColors.darkBlue,
                          fontNum: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.favBordar,
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.favBoxShadow,
                              blurRadius: 20,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Name
                            SharedTextFormField(
                              controller: _nameController,
                              labelText: t.name,
                              hintText: t.enterYourName,
                              iconReq: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return t.nameRequired;
                                }

                                if (value.trim().length < 3) {
                                  return t.nameTooShort;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Username
                            SharedTextFormField(
                              controller: _usernameController,
                              labelText: t.username,
                              hintText: t.usernameHint,
                              iconReq: Icons.alternate_email_rounded,
                              validator: (value) {
                                final text = value?.trim() ?? '';

                                if (text.isEmpty) {
                                  return t.usernameRequired;
                                }

                                if (text.length < 3) {
                                  return t.usernameTooShort;
                                }

                                if (!RegExp(
                                  r'^[a-zA-Z][a-zA-Z0-9_.]*$',
                                ).hasMatch(text)) {
                                  return t.invalidUsername;
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: SharedText(
                                  title: t.email,
                                  colorString: AppColors.darkBlue,
                                  fontNum: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            TextFormField(
                              initialValue: _email,
                              enabled: false,
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                              ),
                              decoration:
                                  _inputDecoration(
                                    icon: Icons.email_outlined,
                                  ).copyWith(
                                    filled: true,
                                    fillColor: AppColors.emptyFavBackground,
                                    suffixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                      color: AppColors.secondaryText,
                                      size: 20,
                                    ),
                                  ),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    size: 15,
                                    color: AppColors.secondaryText,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: SharedText(
                                      title: t.emailCannotBeChanged,
                                      colorString: AppColors.secondaryText,
                                      fontNum: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ------------------------------------------------
                      // Save button
                      // ------------------------------------------------
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            _isSaving ? null : _saveChanges(t);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            disabledBackgroundColor: AppColors.gold.withValues(
                              alpha: 0.55,
                            ),
                            elevation: 4,
                            shadowColor: AppColors.gold.withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 23,
                                  height: 23,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: AppColors.darkBlue,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_rounded,
                                      color: AppColors.darkBlue,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    SharedText(
                                      title: t.saveChanges,
                                      colorString: AppColors.darkBlue,
                                      fontNum: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  InputDecoration _inputDecoration({required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 21),

      filled: true,
      fillColor: AppColors.primaryColor,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.borderColor.withValues(alpha: 0.5),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.6),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );
  }
}
