
import 'package:flutter/material.dart';


class ChatTextField extends StatelessWidget {
  final Function onSendPressed;


  final TextEditingController textEditingController;


  
  

  ChatTextField({
    Key? key,
    required this.onSendPressed, required this.textEditingController,

  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: 12,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom + 8,
          left: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Сообщение',
                ),
              ),
            ),
            IconButton(
              onPressed: () => onSendPressed(textEditingController.text),
              icon: const Icon(Icons.attachment_outlined),
              color: colorScheme.onSurface,
            ),
            IconButton(
              onPressed: () => onSendPressed(textEditingController.text),
              icon: const Icon(Icons.location_on_rounded),
              color: colorScheme.onSurface,
            ),
            IconButton(
              onPressed: () => onSendPressed(),
              icon: const Icon(Icons.send),
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
