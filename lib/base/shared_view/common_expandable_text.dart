import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../resource/generated/l10n.dart';
import '../constants/ui/app_colors.dart';
import '../constants/ui/app_text_styles.dart';

class CommonExpandableText extends StatefulWidget {
  const CommonExpandableText({
    super.key,
    this.content,
    this.limitCharacters = 300,
  });

  final String? content;
  final int limitCharacters;

  @override
  State<CommonExpandableText> createState() => _CommonExpandableTextState();
}

class _CommonExpandableTextState extends State<CommonExpandableText> {
  bool showMore = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.content ?? '';
  }

  bool isExpandable(String text) => text.length > widget.limitCharacters;

  String getDisplayText(String text) {
    if (!isExpandable(text) || showMore) return text;
    return "${text.substring(0, widget.limitCharacters)}...";
  }

  void selectAllText() {
    _focusNode.requestFocus();
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  Widget buildReadMoreButton() {
    return GestureDetector(
      onTap: () => setState(() => showMore = !showMore),
      child: Text(
        showMore ? S.current.collapse : S.current.read_more,
        style: AppTextStyles.bodyMediumRegular.copyWith(
          color: AppColors.current.primary500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content ?? '';
    _controller.text = getDisplayText(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: selectAllText,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: true,
            maxLines: null,
            style: AppTextStyles.bodyMediumRegular,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (isExpandable(content)) buildReadMoreButton(),
        const Gap(12),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}