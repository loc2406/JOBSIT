import 'package:flutter/material.dart';

class CompanyDetailPage extends StatelessWidget {
  final List<Map<String, dynamic>> jobList = [
    {
      "title": "Job Title",
      "options": ["Option 1", "Option 2", "Option 3"]
    },
    {
      "title": "Job Title",
      "options": ["Option 1", "Option 2"]
    },
    {
      "title": "Job Title",
      "options": ["Option 1", "Option 2", "Option 3"]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Company Detail Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Company Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              const Text(
                "We are a dynamic product company focused on creating innovative digital solutions that solve real-world problems.\n\nOur team is dedicated to developing high-quality products, from mobile apps to software platforms, that enhance user experiences and drive business growth.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                "Company Address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "123, street no. 3, Ward, District, Vietnam",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              const Text(
                "Others Jobs",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: jobList.length,
                  itemBuilder: (context, index) {
                    final job = jobList[index];
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job["title"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: job["options"].map<Widget>((option) {
                              return Chip(
                                label: Text(option),
                                backgroundColor: Colors.blue.shade100,
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}