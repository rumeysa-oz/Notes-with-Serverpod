import 'package:flutter/material.dart';

void showNoteDialog({
  required BuildContext context,
  String text = '',
  required ValueChanged<String> onSaved,
}) {
  showDialog(
    context: context,
    builder: (context) => NoteDialog(
      text: text,
      onSaved: onSaved,
    ),
  );
}

class NoteDialog extends StatefulWidget {
  const NoteDialog({
    required this.text,
    required this.onSaved,
    super.key,
  });

  final String text;
  final ValueChanged<String> onSaved;

  @override
  NoteDialogState createState() => NoteDialogState();
}

class NoteDialogState extends State<NoteDialog> {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                child: TextFormField(
                  controller: controller,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write your note here...',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Note cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onSaved(controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
