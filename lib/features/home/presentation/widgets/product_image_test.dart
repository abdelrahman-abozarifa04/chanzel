import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chanzel/core/constants/app_images.dart';

class ProductImageTest extends StatelessWidget {
  const ProductImageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Image Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Testing Product Images:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Test Product 1
            const Text('Product 1:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Path: ${ImagesManger.product1}'),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                ImagesManger.product1,
                fit: BoxFit.cover,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading Product 1: $error');
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Error Loading Product 1'),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Test Product 2
            const Text('Product 2:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Path: ${ImagesManger.product2}'),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                ImagesManger.product2,
                fit: BoxFit.cover,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading Product 2: $error');
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Error Loading Product 2'),
                      ],
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
