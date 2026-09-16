import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';

const Color kPrimaryColor = Color.fromARGB(255, 15, 20, 51);
const Color kAccentColor = Color.fromARGB(255, 14, 61, 148);
const Color kBackgroundColor = Color(0xFFF8F9FC);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  File? _pickedImage;
  String? _currentPhotoUrl;
  String? _email;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // ============================================================
  // Load user data
  // ============================================================
  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();
    final photoUrl = await _authService.getUserPhotoUrl();

    if (!mounted) return;

    setState(() {
      _nameController.text = (data?['name'] ?? '') as String;
      _usernameController.text = (data?['username'] ?? '') as String;
      _email = (data?['email'] ?? _authService.getUserEmail() ?? '') as String;
      _currentPhotoUrl = photoUrl;
      _isLoading = false;
    });
  }

  // ============================================================
  // Pick image
  // ============================================================
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      _pickedImage = File(file.path);
    });
  }

  // ============================================================
  // Image options
  // ============================================================
  void _showImageOptions() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  l10n.profilePhoto,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                _imageOption(
                  icon: Icons.photo_library_outlined,
                  title: l10n.chooseFromGallery,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),

                const SizedBox(height: 10),

                _imageOption(
                  icon: Icons.camera_alt_outlined,
                  title: l10n.takePhoto,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),

                if (_pickedImage != null ||
                    (_currentPhotoUrl != null &&
                        _currentPhotoUrl!.isNotEmpty)) ...[
                  const SizedBox(height: 10),
                  _imageOption(
                    icon: Icons.delete_outline,
                    title: l10n.deletePhoto,
                    iconColor: Colors.redAccent,
                    onTap: () async {
                      Navigator.pop(context);

                      await _authService.deleteProfileImage();

                      if (!mounted) return;

                      setState(() {
                        _pickedImage = null;
                        _currentPhotoUrl = null;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = kPrimaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 23),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Save
  // ============================================================
  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _authService.updateProfile(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        imageFile: _pickedImage,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccessfully),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade600,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      final String message = e.toString().contains('username-already-taken')
          ? l10n.usernameAlreadyTaken
          : l10n.profileUpdateError;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kBackgroundColor,

      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: kPrimaryColor,

        title: Text(
          l10n.editProfile,
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ------------------------------------------------
                      // Profile header
                      // ------------------------------------------------
                      _buildProfileHeader(),

                      const SizedBox(height: 30),

                      // ------------------------------------------------
                      // Personal information
                      // ------------------------------------------------
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          l10n.personalInformation,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Name
                            _buildLabel(l10n.name),

                            TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                hint: l10n.enterYourName,
                                icon: Icons.person_outline_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.nameRequired;
                                }

                                if (value.trim().length < 3) {
                                  return l10n.nameTooShort;
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Username
                            _buildLabel(l10n.username),

                            TextFormField(
                              controller: _usernameController,
                              textInputAction: TextInputAction.done,
                              decoration: _inputDecoration(
                                hint: l10n.usernameHint,
                                icon: Icons.alternate_email_rounded,
                              ),
                              validator: (value) {
                                final text = value?.trim() ?? '';

                                if (text.isEmpty) {
                                  return l10n.usernameRequired;
                                }

                                if (text.length < 3) {
                                  return l10n.usernameTooShort;
                                }

                                if (!RegExp(
                                  r'^[a-zA-Z0-9._]+$',
                                ).hasMatch(text)) {
                                  return l10n.usernameInvalid;
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Email
                            _buildLabel(l10n.email),

                            TextFormField(
                              initialValue: _email,
                              enabled: false,
                              decoration:
                                  _inputDecoration(
                                    hint: '',
                                    icon: Icons.email_outlined,
                                  ).copyWith(
                                    filled: true,
                                    fillColor: const Color(0xFFF1F2F6),
                                    suffixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.grey,
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
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      l10n.emailCannotBeChanged,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
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
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            disabledBackgroundColor: kPrimaryColor.withValues(
                              alpha: 0.6,
                            ),
                            elevation: 4,
                            shadowColor: kPrimaryColor.withValues(alpha: 0.25),
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
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.saveChanges,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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

  // ============================================================
  // Profile Header
  // ============================================================
  Widget _buildProfileHeader() {
    final l10n = AppLocalizations.of(context)!;

    ImageProvider? image;

    if (_pickedImage != null) {
      image = FileImage(_pickedImage!);
    } else if (_currentPhotoUrl != null && _currentPhotoUrl!.isNotEmpty) {
      image = NetworkImage(_currentPhotoUrl!);
    }

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 62,
                backgroundColor: kPrimaryColor.withValues(alpha: 0.08),
                backgroundImage: image,
                child: image == null
                    ? const Icon(
                        Icons.person_rounded,
                        size: 62,
                        color: kPrimaryColor,
                      )
                    : null,
              ),
            ),

            PositionedDirectional(
              bottom: 2,
              end: 2,
              child: GestureDetector(
                onTap: _showImageOptions,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Text(
          l10n.profilePhoto,
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          l10n.changeProfilePhoto,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),

        const SizedBox(height: 8),

        TextButton(
          onPressed: _showImageOptions,
          style: TextButton.styleFrom(foregroundColor: kAccentColor),
          child: Text(
            l10n.changePhoto,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Label
  // ============================================================
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Input decoration
  // ============================================================
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon, color: kPrimaryColor, size: 21),

      filled: true,
      fillColor: const Color(0xFFF6F7FA),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: kAccentColor, width: 1.4),
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
