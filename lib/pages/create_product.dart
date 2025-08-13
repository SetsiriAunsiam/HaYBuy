import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

import '../models/product.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final List<Product> _productsDb = [];
  List<Product> get productsDb => _productsDb;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final provider = context.read<ProductProvider>();
    
    if (provider.imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกรูปภาพสินค้า')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final product = Product(
        id: '',
        name: _nameController.text,
        description: _descriptionController.text,
        category: 'Aum',
        imageUrl: '',
        sellerId: provider.user?.uid ?? 'unknown',
        location: GeoPoint(0,0),
        price: Decimal.parse(_priceController.text),
        rating: Decimal.zero,
        status: 'ขาย',
      );

      final success = await provider.submitProduct(product);
      
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกข้อมูลสินค้าเรียบร้อยแล้ว')),
        );
      } else if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึก')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างสินค้า (Provider)'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: context.read<ProductProvider>().pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: provider.imageFile != null
                        ? Image.file(provider.imageFile!, fit: BoxFit.cover)
                        : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
                  validator: (v) => (v==null||v.isEmpty) ? 'กรุณากรอกชื่อ' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'ราคา'),
                  keyboardType: TextInputType.number,
                   validator: (v) => (v==null||v.isEmpty) ? 'กรุณากรอกราคา' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'คำอธิบายสินค้า'),
                  maxLines: 4,
                  validator: (v) => (v==null||v.isEmpty) ? 'กรุณากรอกคำอธิบาย' : null,
                ),
                const SizedBox(height: 24),
                
                // ปุ่มบันทึก
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(provider.isSubmitting ? 'กำลังบันทึก...' : 'บันทึกสินค้า'),
                  onPressed: provider.isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}