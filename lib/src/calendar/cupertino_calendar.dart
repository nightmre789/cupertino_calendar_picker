import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A widget that displays an inline Cupertino-style calendar.
///
/// This widget provides a calendar interface that allows users to select dates or date-time
/// combinations, depending on the mode.
class CupertinoCalendar extends StatefulWidget {
  CupertinoCalendar({
    required this.minimumDateTime,
    required this.maximumDateTime,
    this.mainColor = CupertinoColors.systemRed,
    this.mode = CupertinoCalendarMode.date,
    this.type = CupertinoCalendarType.inline,
    this.onDateTimeChanged,
    this.onDateSelected,
    DateTime? initialDateTime,
    DateTime? currentDateTime,
    this.onDisplayedMonthChanged,
    this.weekdayDecoration,
    this.monthPickerDecoration,
    this.headerDecoration,
    this.footerDecoration,
    this.timeLabel,
    this.minuteInterval = 1,
    this.maxWidth = double.infinity,
    super.key,
  })  : initialDateTime = initialDateTime ?? DateTime.now(),
        currentDateTime = currentDateTime ?? DateTime.now() {
    // ignore: prefer_asserts_in_initializer_lists
    assert(
      !maximumDateTime.isBefore(minimumDateTime),
      'maximumDateTime $maximumDateTime must be on or after minimumDateTime $minimumDateTime.',
    );
    assert(
      !this.initialDateTime.isBefore(minimumDateTime),
      'initialDateTime ${this.initialDateTime} must be on or after minimumDateTime $minimumDateTime.',
    );
    assert(
      !this.initialDateTime.isAfter(maximumDateTime),
      'initialDateTime ${this.initialDateTime} must be on or before maximumDateTime $maximumDateTime.',
    );
  }

  /// The initially selected [DateTime] that the calendar should display.
  ///
  /// This date is highlighted in the picker and the default date when the picker
  /// is first displayed.
  final DateTime initialDateTime;

  /// The earliest selectable [DateTime] in the picker.
  ///
  /// This date must be on or before the [maximumDateTime].
  final DateTime minimumDateTime;

  /// The latest selectable [DateTime] in the picker.
  ///
  /// This date must be on or after the [minimumDateTime].
  final DateTime maximumDateTime;

  /// The current date (i.e., today's date).
  final DateTime currentDateTime;

  /// A callback that is triggered whenever the selected [DateTime] changes in the calendar.
  final ValueChanged<DateTime>? onDateTimeChanged;

  /// A callback that is triggered when the user selects a date in the calendar.
  final ValueChanged<DateTime>? onDateSelected;

  /// A callback that is triggered when the user navigates to a different month in the calendar.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Custom decoration for the weekdays' row in the calendar.
  final CalendarWeekdayDecoration? weekdayDecoration;

  /// Custom decoration for the month picker view.
  final CalendarMonthPickerDecoration? monthPickerDecoration;

  /// Custom decoration for the header of the calendar.
  final CalendarHeaderDecoration? headerDecoration;

  /// Custom decoration for the footer of the calendar.
  final CalendarFooterDecoration? footerDecoration;

  /// The primary color used in the calendar picker, typically for highlighting
  /// the selected date and other important elements.
  ///
  /// The default color is [CupertinoColors.systemRed].
  final Color mainColor;

  /// The mode in which the picker operates.
  ///
  /// This defines whether the picker allows selection of just the date or both date and time.
  final CupertinoCalendarMode mode;

  /// The type of the calendar, which may define specific behaviors or appearances.
  ///  The default type is [CupertinoCalendarType.inline].
  final CupertinoCalendarType type;

  /// The maximum width of the calendar widget.
  ///
  /// The default value is [double.infinity], meaning the widget can expand
  /// to fill available space.
  final double maxWidth;

  /// An optional label to be displayed when the calendar is in a mode that includes time selection.
  ///
  /// This label typically indicates what the selected time is for or provides additional context.
  final String? timeLabel;

  /// The interval of minutes that the time picker should allow, applicable
  /// when the calendar is in a mode that includes time selection.
  ///
  /// The default value is 1 minute, meaning the user can select any minute of the hour.
  final int minuteInterval;

  @override
  State<CupertinoCalendar> createState() => _CupertinoCalendarState();
}

class _CupertinoCalendarState extends State<CupertinoCalendar> {
  late DateTime _currentlyDisplayedMonthDate;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _initializeInitialDate();
  }

  @override
  void didUpdateWidget(CupertinoCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _initializeInitialDate();
    }
  }

  void _initializeInitialDate() {
    final DateTime initialDateTime = widget.initialDateTime;
    _currentlyDisplayedMonthDate =
        PackageDateUtils.monthDateOnly(initialDateTime);
    _selectedDateTime = initialDateTime;
  }

  void _handleCalendarDateChange(DateTime date) {
    final int year = date.year;
    final int month = date.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    int selectedDay = _selectedDateTime.day;

    if (daysInMonth < selectedDay) {
      selectedDay = daysInMonth;
    }
    DateTime newDate = date.copyWith(day: selectedDay);

    final bool exceedMinimumDate = newDate.isBefore(widget.minimumDateTime);
    final bool exceedMaximumDate = newDate.isAfter(widget.maximumDateTime);
    if (exceedMinimumDate) {
      newDate = widget.minimumDateTime;
    } else if (exceedMaximumDate) {
      newDate = widget.maximumDateTime;
    }
    _handleCalendarMonthChange(newDate);
    _handleCalendarDayChange(newDate);
  }

  void _handleCalendarMonthChange(DateTime newMonthDate) {
    final DateTime displayedMonth = PackageDateUtils.monthDateOnly(
      _currentlyDisplayedMonthDate,
    );
    final bool monthChanged = !DateUtils.isSameMonth(
      displayedMonth,
      newMonthDate,
    );
    if (monthChanged) {
      _currentlyDisplayedMonthDate = PackageDateUtils.monthDateOnly(
        newMonthDate,
      );
      widget.onDisplayedMonthChanged?.call(_currentlyDisplayedMonthDate);
    }
  }

  void _handleCalendarDayChange(DateTime date) {
    setState(() {
      _selectedDateTime = date;
      widget.onDateTimeChanged?.call(_selectedDateTime);
    });
  }

  void _onDateTimeChanged(DateTime date) {
    _handleCalendarDayChange(date);
    widget.onDateSelected?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    final double height = switch (widget.mode) {
      CupertinoCalendarMode.date => calendarDatePickerHeight,
      CupertinoCalendarMode.dateTime => calendarDateTimePickerHeight,
    };
    const double minWidth = calendarWidth;
    final double maxWidth =
        widget.maxWidth <= minWidth ? minWidth : widget.maxWidth;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
        minWidth: calendarWidth,
        maxWidth: maxWidth,
      ),
      child: CupertinoCalendarPicker(
        initialMonth: _currentlyDisplayedMonthDate,
        currentDateTime: widget.currentDateTime,
        minimumDateTime: widget.minimumDateTime,
        maximumDateTime: widget.maximumDateTime,
        selectedDateTime: _selectedDateTime,
        onDateTimeChanged: _onDateTimeChanged,
        onDisplayedMonthChanged: _handleCalendarMonthChange,
        onYearPickerChanged: _handleCalendarDateChange,
        mainColor: widget.mainColor,
        weekdayDecoration: widget.weekdayDecoration ??
            CalendarWeekdayDecoration.withDynamicColor(context),
        monthPickerDecoration: widget.monthPickerDecoration ??
            CalendarMonthPickerDecoration.withDynamicColor(
              context,
              mainColor: widget.mainColor,
            ),
        headerDecoration: widget.headerDecoration ??
            CalendarHeaderDecoration.withDynamicColor(
              context,
              mainColor: widget.mainColor,
            ),
        footerDecoration: widget.footerDecoration ??
            CalendarFooterDecoration.withDynamicColor(context),
        mode: widget.mode,
        type: widget.type,
        timeLabel: widget.timeLabel,
        minuteInterval: widget.minuteInterval,
      ),
    );
  }
}
