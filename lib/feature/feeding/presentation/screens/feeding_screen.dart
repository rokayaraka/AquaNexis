import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../shared/utils/validators.dart';

class Feeding extends StatefulWidget {
  const Feeding({super.key});
  static const routeName = '/feeding';
  @override
  State<Feeding> createState() => _FeedingState();
}

class _FeedingState extends State<Feeding> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  // ignore: prefer_final_fields
  bool _isSaveing = false;
  @override
  void dispose() {
    _weightController.dispose();
    _timeController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Feeding',
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
        centerTitle: true,
        leadingWidth: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppColors.textColorDarkSecondary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: .symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter feed weight(gm)',
                    hintStyle: textTheme.labelMedium,
                  ),
                  validator: (value) => Validators.validateInput(
                    value,
                    'Please enter feed weight(gm)',
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(
                      value: '3',
                      child: Text('3 Hour', style: textTheme.labelMedium),
                    ),
                    DropdownMenuItem(
                      value: '6',
                      child: Text('6 Hour', style: textTheme.labelMedium),
                    ),
                    DropdownMenuItem(
                      value: '12',
                      child: Text('12 Hour', style: textTheme.labelMedium),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Select feeding Schedule',
                    hintStyle: textTheme.labelMedium,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onChanged,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _isSaveing ? null : _onTapSave,
                  child: _isSaveing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
                const SizedBox(height: 20),
                Text("OR", style: textTheme.labelMedium),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _onTapInstatntFeed,
                  child: Text('Insatnt Feed'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onChanged(String? value) {
    // Handle the selected value
  }
  void _onTapSave() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaveing = true;
      });
      // Perform save operation here
      // After saving, reset the form and update the state
      setState(() {
        _isSaveing = false;
        _weightController.clear();
        _timeController.clear();
      });
    }
  }

  void _onTapInstatntFeed() {
    // Perform instant feed operation here
  }
}
