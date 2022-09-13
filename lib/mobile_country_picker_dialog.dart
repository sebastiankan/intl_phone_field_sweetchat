import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/helpers.dart';

class MobileCountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;

  MobileCountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
  }) : super(key: key);

  @override
  _MobileCountryPickerDialogState createState() =>
      _MobileCountryPickerDialogState();
}

class _MobileCountryPickerDialogState extends State<MobileCountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;
  FocusNode _searchFieldNode = FocusNode();

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;
    _searchFieldNode.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultHorizontalPadding = 0.0;
    final defaultVerticalPadding = 0.0;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: defaultVerticalPadding,
          horizontal: defaultHorizontalPadding),
      backgroundColor: widget.style?.backgroundColor,
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          padding: widget.style?.padding ?? EdgeInsets.all(10),
          height: constraints.maxHeight * 0.8,
          child: Column(
            children: <Widget>[
              widget.style?.title ?? SizedBox(),
              Padding(
                padding: widget.style?.searchFieldPadding ?? EdgeInsets.all(0),
                child: TextField(
                  focusNode: _searchFieldNode,
                  cursorColor: widget.style?.searchFieldCursorColor,
                  style: widget.style?.searchFieldInputDecoration?.labelStyle,
                  decoration: widget.style?.searchFieldInputDecoration ??
                      InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          border: InputBorder.none
                          // labelText: widget.searchText,
                          ),
                  onChanged: (value) {
                    _filteredCountries = isNumeric(value)
                        ? widget.countryList
                            .where(
                                (country) => country.dialCode.contains(value))
                            .toList()
                        : widget.countryList
                            .where((country) => country.name
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                    if (this.mounted) setState(() {});
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.style?.listTileDivider?.color ??
                              Colors.transparent),
                      borderRadius: BorderRadius.circular(14)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredCountries.length,
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    itemBuilder: (ctx, index) => Column(
                      children: <Widget>[
                        ListTile(
                          // leading: Image.asset(
                          //   'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                          //   package: 'intl_phone_field',
                          //   width: 32,
                          // ),
                          contentPadding: widget.style?.listTilePadding,
                          title: Text(
                            _filteredCountries[index].name,
                            style: widget.style?.countryNameStyle ??
                                TextStyle(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text(
                            '+${_filteredCountries[index].dialCode}',
                            style: widget.style?.countryCodeStyle ??
                                TextStyle(fontWeight: FontWeight.w700),
                          ),
                          onTap: () {
                            _selectedCountry = _filteredCountries[index];
                            widget.onCountryChanged(_selectedCountry);
                            Navigator.of(context).pop();
                          },
                        ),
                        widget.style?.listTileDivider ?? Divider(thickness: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
