# Authentication Feature

## Overview

Feature นี้จัดการเกี่ยวกับการ Authentication ของผู้ใช้งาน รวมถึง Login, Register และ Logout

## Structure

```
authentication/
├── data/
│   ├── datasources/      # Data sources (API, Local storage)
│   ├── models/           # Data models
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business entities
│   │   └── user.dart    # User entity
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Use cases
└── presentation/
    ├── pages/
    │   ├── login_page.dart      # หน้า Login
    │   └── register_page.dart   # หน้า Register
    ├── providers/
    │   ├── auth_provider.dart   # State management สำหรับ Authentication
    │   ├── auth_state.dart      # Authentication state
    │   └── providers.dart       # Export file
    └── widgets/
        ├── auth_button.dart          # ปุ่มสำหรับ Authentication
        ├── auth_text_field.dart      # TextField สำหรับ Authentication
        ├── loading_overlay.dart      # Loading overlay
        ├── social_login_button.dart  # ปุ่ม Social login
        └── widgets.dart              # Export file
```

## Features

### 1. Login Page

- ฟอร์ม Login ที่สวยงาม responsive
- Validation สำหรับ Email และ Password
- ลิงก์ไปหน้า Register และ Forgot Password
- แสดง Loading state ขณะ Login
- แสดง Error message เมื่อ Login ไม่สำเร็จ

### 2. Register Page

- ฟอร์มสมัครสมาชิกที่ครบถ้วน
- Fields:
  - ชื่อ-นามสกุล (required)
  - อีเมล (required)
  - เบอร์โทรศัพท์ (optional)
  - รหัสผ่าน (required, minimum 8 characters)
  - ยืนยันรหัสผ่าน (required)
- Checkbox ยอมรับเงื่อนไขการใช้งาน
- Validation แบบ real-time
- ลิงก์กลับไปหน้า Login

### 3. Authentication Provider

- จัดการ State ของ Authentication
- Methods:
  - `login(email, password)` - เข้าสู่ระบบ
  - `register(...)` - สมัครสมาชิก
  - `logout()` - ออกจากระบบ
  - `clearError()` - ล้าง Error message

### 4. Reusable Widgets

#### AuthTextField

- TextField ที่ปรับแต่งแล้วสำหรับฟอร์ม Authentication
- รองรับ:
  - Label และ Hint text
  - Prefix icon
  - Password visibility toggle
  - Validation
  - Enable/Disable state

#### AuthButton

- ปุ่มที่ใช้ในฟอร์ม Authentication
- รองรับ:
  - Loading state
  - Outlined style
  - Custom colors
  - Full width

#### LoadingOverlay

- แสดง Loading overlay ทับหน้าจอ
- รองรับ custom message

#### SocialLoginButton

- ปุ่มสำหรับ Social login (Google, Facebook, Apple)
- รองรับ custom icon และ text

## Validators

อยู่ใน `core/utils/validators.dart`:

- `validateEmail(value)` - ตรวจสอบรูปแบบ Email
- `validatePassword(value)` - ตรวจสอบรหัสผ่าน (min 8 characters)
- `validateRequired(value, fieldName)` - ตรวจสอบ required field
- `validatePhoneNumber(value)` - ตรวจสอบเบอร์โทรศัพท์ไทย (10 หลัก)
- `validateConfirmPassword(value, originalPassword)` - ตรวจสอบยืนยันรหัสผ่าน
- `validateName(value, fieldName)` - ตรวจสอบชื่อ (min 2 characters)

## Usage

### 1. Navigation to Login

```dart
context.go(RouteConstants.login);
```

### 2. Navigation to Register

```dart
context.push(RouteConstants.register);
```

### 3. Using Auth Provider

```dart
// ใน Widget
final authState = ref.watch(authProvider);

// Login
await ref.read(authProvider.notifier).login(email, password);

// Register
await ref.read(authProvider.notifier).register(
  email: email,
  password: password,
  fullName: fullName,
  phoneNumber: phone,
);

// Check authentication status
if (authState.isAuthenticated) {
  // User is logged in
}
```

## TODO

- [ ] เชื่อมต่อกับ Supabase Authentication
- [ ] Implement Forgot Password
- [ ] เพิ่ม Social Login (Google, Facebook, Apple)
- [ ] เพิ่ม Email Verification
- [ ] เพิ่ม Biometric Authentication
- [ ] เพิ่ม Remember Me feature
- [ ] เพิ่ม Auto-login after registration

## Dependencies

- `flutter_riverpod` - State management
- `go_router` - Navigation
- `equatable` - Value equality
- `supabase_flutter` - Authentication backend (ยังไม่ได้ implement)

## Theme

ใช้ theme จาก `app/theme/`:

- Colors: `AppColors` (colors.dart)
- Text Styles: `AppTextStyles` (text_styles.dart)
- Input Decoration: กำหนดใน `AppTheme` (app_theme.dart)
