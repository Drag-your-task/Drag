import 'package:drag/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // 밝은 테마 정의
  static ThemeData get lightTheme {

    return ThemeData(
      primaryColor: AppColors.primary,
      hintColor: AppColors.secondary,
      // scaffoldBackgroundColor: Colors.white,
      // canvasColor: Colors.white,

      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: AppColors.primary, // 선택 핸들의 색상을 변경합니다.
        selectionColor: AppColors.primary.withOpacity(0.5), // 선택된 텍스트의 색상을 변경합니다.
        cursorColor: AppColors.primary,
      ),


      bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.white,
        elevation: 0,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.whiteText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButtonBackground,
          foregroundColor: AppColors.whiteText, // 버튼의 글자색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      // colorScheme: ColorScheme(
      //     brightness: Brightness.light,
      //     primary: AppColors.primary,
      //     onPrimary: AppColors.whiteText,
      //     secondary: AppColors.secondary,
      //     onSecondary: AppColors.blackText,
      //     error: Colors.red,
      //     onError: Colors.red,
      //     background: Colors.white,
      //     onBackground: Colors.black,
      //     surface: surface,
      //     onSurface: onSurface
      // ),
    );
  }

  // 어두운 테마 정의
  static ThemeData get darkTheme {
    // ColorScheme를 사용하여 어두운 테마 색상을 정의합니다.
    var colorScheme = ColorScheme.dark().copyWith(
      primary: Color(0xFFFF6348), // 기본 색상
      secondary: Color(0xFFFFF3F1),
      // ... 다른 색상 정의
    );

    // ThemeData 객체를 생성하고 반환합니다.
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      hintColor: colorScheme.secondary,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colorScheme.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      // ... 다른 테마 관련 설정들
    );
  }
}
