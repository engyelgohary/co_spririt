import 'package:flutter/material.dart';

class OpportunityForm extends StatelessWidget {
  const OpportunityForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Title
            Center(
              child: Text(
                "Opportunity Detector",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Customer Name Dropdown
            const Text("Customer Name",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(child: Text("AGL"), value: "AGL"),
                DropdownMenuItem(child: Text("Other"), value: "Other"),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Opportunity Description
            const Text("Opportunity Description",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter opportunity description",
              ),
            ),
            const SizedBox(height: 16),

            // Corelia Solutions Dropdown
            const Text("Corelia Solutions",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(
                    child: Text("Cyber Security"), value: "Cyber Security"),
                DropdownMenuItem(child: Text("Other"), value: "Other"),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Feasibility Dropdown
            const Text("Feasibility",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(child: Text("Low"), value: "Low"),
                DropdownMenuItem(child: Text("Medium"), value: "Medium"),
                DropdownMenuItem(child: Text("High"), value: "High"),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Risk Factors
            const Text("Risk Factors",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(child: Text("No budget"), value: "No budget"),
                DropdownMenuItem(child: Text("Delay"), value: "Delay"),
                DropdownMenuItem(child: Text("Competitors"), value: "High"),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Attachments Upload Button
            const Text("Attachments",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            SizedBox(
              width: screenWidth, // Full screen width
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child:
                    const Text("Upload", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "Upload supporting documents (text, PDF, images)",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit form action
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Submit",style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
