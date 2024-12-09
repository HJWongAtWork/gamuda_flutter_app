import 'package:flutter/material.dart';

class CityTreemap extends StatelessWidget {
  final Map<String, dynamic> data;

  const CityTreemap({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedCities = data.entries.toList()
      ..sort((a, b) => (b.value['id'] as num).compareTo(a.value['id'] as num));

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users by City',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: sortedCities.map((entry) {
                        final proportion =
                            (entry.value['id'] as num).toDouble() /
                                (sortedCities[0].value['id'] as num).toDouble();
                        final double bubbleSize =
                            (120.0 * proportion).clamp(60.0, 120.0);

                        return SizedBox(
                          width: bubbleSize,
                          height: bubbleSize,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.primaries[
                                      sortedCities.indexOf(entry) %
                                          Colors.primaries.length]
                                  .withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${entry.key}: ${entry.value['id']} users\n'
                                        'Avg Salary: \$${(entry.value['salary'] as num).round()}\n'
                                        'Avg Age: ${(entry.value['age'] as num).round()}',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                borderRadius:
                                    BorderRadius.circular(bubbleSize / 2),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: bubbleSize * 0.12,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: bubbleSize * 0.05),
                                      Text(
                                        '${entry.value['id']} users',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: bubbleSize * 0.1,
                                        ),
                                      ),
                                      Text(
                                        '\$${(entry.value['salary'] as num).round()}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: bubbleSize * 0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
