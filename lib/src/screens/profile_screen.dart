import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../models/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  
  String _selectedGender = 'Male';
  String _selectedRegion = 'Delhi';
  String _selectedLanguage = 'English';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    
    // Initialize with current user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final user = ref.read(userProvider);
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
      _heightController.text = user.height.toString();
      _weightController.text = user.weight.toString();
      _selectedGender = user.gender;
      _selectedRegion = user.region;
      _selectedLanguage = user.language;
      _isDarkMode = user.isDarkMode;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isDarkMode = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              _buildProfileHeader(user),
              
              const SizedBox(height: 24),
              
              // Personal information
              _buildPersonalInfoSection(),
              
              const SizedBox(height: 24),
              
              // App settings
              _buildAppSettingsSection(isDarkMode, language),
              
              const SizedBox(height: 24),
              
              // Privacy settings
              _buildPrivacySection(),
              
              const SizedBox(height: 24),
              
              // Account actions
              _buildAccountActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile picture
          GestureDetector(
            onTap: _changeProfilePicture,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  backgroundImage: user?.profilePicturePath != null
                      ? NetworkImage(user!.profilePicturePath!)
                      : null,
                  child: user?.profilePicturePath == null
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: AppTheme.primaryColor,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User Name',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.region ?? 'Region',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Member since ${_formatDate(user?.createdAt ?? DateTime.now())}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          // Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Age
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              prefixIcon: Icon(Icons.cake_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              }
              final age = int.tryParse(value);
              if (age == null || age < 5 || age > 100) {
                return 'Please enter a valid age';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Gender
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: ['Male', 'Female', 'Other'].map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGender = value!;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Height and Weight
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 50 || height > 250) {
                      return 'Invalid';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 10 || weight > 200) {
                      return 'Invalid';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Region
          DropdownButtonFormField<String>(
            value: _selectedRegion,
            decoration: const InputDecoration(
              labelText: 'Region',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: ['Delhi', 'Mumbai', 'Bangalore', 'Chennai', 'Kolkata', 'Hyderabad'].map((region) {
              return DropdownMenuItem(
                value: region,
                child: Text(region),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRegion = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(bool isDarkMode, String language) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Settings',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          // Dark mode toggle
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Dark Mode'),
            subtitle: Text(isDarkMode ? 'Enabled' : 'Disabled'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
          
          const Divider(),
          
          // Language selection
          ListTile(
            leading: Icon(
              Icons.language,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Language'),
            subtitle: Text(language == 'en' ? 'English' : 'Hindi'),
            trailing: DropdownButton<String>(
              value: language,
              onChanged: (value) {
                ref.read(languageProvider.notifier).setLanguage(value!);
              },
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
              ],
            ),
          ),
          
          const Divider(),
          
          // Notifications
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Notifications'),
            subtitle: const Text('Push notifications enabled'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Handle notification toggle
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Settings',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          ListTile(
            leading: Icon(
              Icons.visibility_outlined,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Profile Visibility'),
            subtitle: const Text('Your profile is visible to other users'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Handle profile visibility toggle
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
          
          const Divider(),
          
          ListTile(
            leading: Icon(
              Icons.analytics_outlined,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Data Sharing'),
            subtitle: const Text('Share anonymous data for research'),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // Handle data sharing toggle
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Actions',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          ListTile(
            leading: Icon(
              Icons.download_outlined,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Export Data'),
            subtitle: const Text('Download your test results and progress'),
            onTap: () {
              _exportData();
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help with using the app'),
            onTap: () {
              _showHelp();
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: AppTheme.primaryColor,
            ),
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            onTap: () {
              _showAbout();
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: Icon(
              Icons.logout,
              color: AppColors.error,
            ),
            title: Text(
              'Logout',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  void _changeProfilePicture() {
    // Handle profile picture change
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture change feature coming soon!'),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(userProvider);
      if (user != null) {
        final updatedUser = user.copyWith(
          name: _nameController.text,
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          height: double.parse(_heightController.text),
          weight: double.parse(_weightController.text),
          region: _selectedRegion,
          language: _selectedLanguage,
        );
        
        ref.read(userProvider.notifier).updateUser(updatedUser);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    }
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'For support and assistance, please contact us at:\n\n'
          'Email: support@saitalent.com\n'
          'Phone: +91-1234567890\n\n'
          'We\'re here to help you with any questions or issues.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About SAI Talent'),
        content: const Text(
          'SAI Talent Assessment\n'
          'Version 1.0.0\n\n'
          'A comprehensive fitness assessment platform powered by AI technology.\n\n'
          '© 2024 Sports Authority of India',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(userProvider.notifier).logout();
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
