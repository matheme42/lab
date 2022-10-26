import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lab/controllers/controllers.dart';
import 'package:lab/tools/validators.dart';
import 'package:lab/views/todo_view/end_drawer/bottom_sheet/form/form_context.dart';

class Step1 extends StatelessWidget {
  const Step1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Form(
        key: formKey,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Flexible(
                        flex: 9,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Divider(color: Colors.transparent),
                                TextFormField(
                                  onChanged: (value) {
                                    FormContext.of(context).habit.name = value;
                                  },
                                  initialValue: FormContext.of(context).habit.name,
                                  decoration: InputDecoration(
                                      fillColor: Colors.black.withAlpha(12),
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: 'donne lui un nom...',
                                      prefixIcon: const Icon(Icons.chrome_reader_mode)),
                                  validator: CustomValidator.min4Max40,
                                ),
                                const Divider(color: Colors.transparent),
                                TextFormField(
                                  onChanged: (value) {
                                    FormContext.of(context).habit.description = value;
                                  },
                                  minLines: 5,
                                  maxLines: 5,
                                  initialValue: FormContext.of(context).habit.description,
                                  decoration: InputDecoration(
                                    fillColor: Colors.black.withAlpha(12),
                                    filled: true,
                                    border: InputBorder.none,
                                    hintText: 'décrit ton habitude...',
                                  ),
                                  validator: CustomValidator.max100,
                                ),
                                const Divider(color: Colors.transparent),
                                DropdownSearch<String>(
                                    items: const [
                                      Frequence.daily,
                                      Frequence.hebdo,
                                      Frequence.mensuel
                                    ],
                                    dropdownBuilder: (context, process) {
                                      if (process == null) return const Text('');
                                      return Text(process,
                                          style: const TextStyle(color: Colors.black87));
                                    },
                                    onChanged: (frequence) {
                                      FormContext.of(context).frequence.name = frequence!;
                                    },
                                    selectedItem: FormContext.of(context).frequence.name,
                                    popupProps: PopupProps.menu(
                                        itemBuilder: (context, item, _) {
                                      return ListTile(
                                          title: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.black87),
                                      ));
                                    }, containerBuilder: (context, child) {
                                      return Container(
                                            height: 200,
                                            color: Colors.white54,
                                            child: child);
                                    }),
                                    dropdownDecoratorProps: const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'quel type...',
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.free_cancellation_outlined,
                                        ),
                                      ),
                                    ),
                                    validator: CustomValidator.required),
                                const Divider(color: Colors.transparent),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 1)
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.extended(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          FormContext.of(context).pageViewController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        label: const Text('Suivant', style: TextStyle(color: Colors.black))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
