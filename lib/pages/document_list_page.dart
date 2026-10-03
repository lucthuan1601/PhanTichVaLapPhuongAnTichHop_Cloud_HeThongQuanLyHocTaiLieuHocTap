import 'package:flutter/material.dart';

import '../models/document_struct.dart';
import '../repositories/document_repository.dart';
import 'document_form_page.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key, required this.repository});

  final DocumentRepository repository;

  @override
  State<DocumentListPage> createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  final _searchController = TextEditingController();
  DocumentType? _type;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài liệu học tập')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Tìm kiếm',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<DocumentType?>(
                value: _type,
                hint: const Text('Loại'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Tất cả')),
                  ...DocumentType.values.map((type) =>
                      DropdownMenuItem(value: type, child: Text(type.label))),
                ],
                onChanged: (value) => setState(() => _type = value),
              ),
            ]),
          ),
          Expanded(
            child: StreamBuilder(
              stream: widget.repository.watchDocuments(
                query: _searchController.text,
                type: _type,
              ),
              builder: (context, snapshot) {
                final documents = snapshot.data ?? [];
                if (documents.isEmpty) {
                  return const Center(child: Text('Chưa có tài liệu'));
                }
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text(document.title),
                      subtitle: Text(
                        '${DocumentTypeCodec.fromValue(document.type).label}'
                        '${document.filePath == null ? '' : ' • Có tệp đính kèm'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Sửa tài liệu',
                            icon: const Icon(Icons.edit_outlined),
                            color: Colors.green,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DocumentFormPage(
                                  repository: widget.repository,
                                  document: document,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Xóa tài liệu',
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            onPressed: () =>
                                widget.repository.delete(document.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DocumentFormPage(repository: widget.repository),
        )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
