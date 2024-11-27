import 'package:flutter/material.dart';
import '../../core/app_ui.dart';

class ImportForm extends StatelessWidget {
  const ImportForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Spacer
              const SizedBox(height: 10),

              // Download Template Section
              const Text(
                "Download Template",
                style: TextStyle(
                  fontSize: 16,
                  color: AppUI.omMainColor,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement download functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download clicked!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUI.omMainColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: const Text(
                  "Download",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "upload supporting documents (CSV)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Upload Template Section
              const Text(
                "Upload Template",
                style: TextStyle(
                  fontSize: 16,
                  color: AppUI.omMainColor,

                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement upload functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Upload clicked!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUI.omMainColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "upload supporting documents (CSV)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Cancel and Submit Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close modal
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Submit Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement submit functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Submit clicked!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppUI.omMainColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
