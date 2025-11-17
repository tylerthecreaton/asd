# UI Design - Authentication Screens

## Login Page Design

### Layout Structure

```
┌─────────────────────────────────────┐
│           [Back Button]             │
│                                     │
│         ┌─────────────┐            │
│         │   🧒 Icon   │            │
│         │  (Circle)   │            │
│         └─────────────┘            │
│                                     │
│      ยินดีต้อนรับกลับ               │
│  เข้าสู่ระบบเพื่อดูแลบุตรหลานของคุณ │
│                                     │
│  ┌────────────────────────────┐   │
│  │ 📧 อีเมล                   │   │
│  │ กรอกอีเมลของคุณ           │   │
│  └────────────────────────────┘   │
│                                     │
│  ┌────────────────────────────┐   │
│  │ 🔒 รหัสผ่าน                │   │
│  │ กรอกรหัสผ่านของคุณ         │   │
│  │                       👁️   │   │
│  └────────────────────────────┘   │
│                                     │
│              ลืมรหัสผ่าน?          │
│                                     │
│  ┌────────────────────────────┐   │
│  │    เข้าสู่ระบบ             │   │
│  └────────────────────────────┘   │
│                                     │
│  ───────────  หรือ  ───────────   │
│                                     │
│  ยังไม่มีบัญชี? สมัครสมาชิก       │
│                                     │
└─────────────────────────────────────┘
```

### Colors Used

- **Background**: `#F5F7FA` (Light gray)
- **Primary Button**: `#5E9CFF` (Blue)
- **Icon Circle Background**: `#5E9CFF` with 10% opacity
- **Text Primary**: `#2D3748` (Dark gray)
- **Text Secondary**: `#718096` (Medium gray)
- **Input Background**: `#F8F9FC` (Very light gray)
- **Error**: `#F56565` (Red)

### Components

1. **Logo/Icon Area**

   - Circular container (100x100)
   - Child care icon
   - Primary color with transparency

2. **Title Section**

   - Large bold text (32sp)
   - Subtitle with lighter color (14sp)
   - Center aligned

3. **Email Input**

   - Label above field
   - Email icon prefix
   - Rounded corners (12px)
   - Validation on submit

4. **Password Input**

   - Label above field
   - Lock icon prefix
   - Toggle visibility icon
   - Rounded corners (12px)
   - Validation on submit

5. **Forgot Password Link**

   - Right aligned
   - Primary color
   - Text button

6. **Login Button**

   - Full width
   - 56px height
   - Rounded corners (12px)
   - Shows loading indicator when pressed

7. **Divider**

   - Horizontal line with "หรือ" text in center

8. **Register Link**
   - Center aligned
   - "ยังไม่มีบัญชี?" in gray
   - "สมัครสมาชิก" in primary color

---

## Register Page Design

### Layout Structure

```
┌─────────────────────────────────────┐
│  [← Back]                           │
│                                     │
│       สร้างบัญชีใหม่               │
│  กรอกข้อมูลของคุณเพื่อเริ่มต้นใช้งาน │
│                                     │
│  ┌────────────────────────────┐   │
│  │ 👤 ชื่อ-นามสกุล            │   │
│  │ กรอกชื่อ-นามสกุลของคุณ     │   │
│  └────────────────────────────┘   │
│                                     │
│  ┌────────────────────────────┐   │
│  │ 📧 อีเมล                   │   │
│  │ กรอกอีเมลของคุณ           │   │
│  └────────────────────────────┘   │
│                                     │
│  ┌────────────────────────────┐   │
│  │ 📱 เบอร์โทรศัพท์ (ไม่บังคับ) │ │
│  │ กรอกเบอร์โทรศัพท์ของคุณ    │   │
│  └────────────────────────────┘   │
│                                     │
│  ┌────────────────────────────┐   │
│  │ 🔒 รหัสผ่าน                │   │
│  │ สร้างรหัสผ่าน (8+ ตัว)     │   │
│  │                       👁️   │   │
│  └────────────────────────────┘   │
│                                     │
│  ┌────────────────────────────┐   │
│  │ 🔒 ยืนยันรหัสผ่าน          │   │
│  │ กรอกรหัสผ่านอีกครั้ง       │   │
│  │                       👁️   │   │
│  └────────────────────────────┘   │
│                                     │
│  ☑️ ฉันยอมรับ เงื่อนไขการใช้งาน   │
│     และ นโยบายความเป็นส่วนตัว      │
│                                     │
│  ┌────────────────────────────┐   │
│  │    สมัครสมาชิก             │   │
│  └────────────────────────────┘   │
│                                     │
│  มีบัญชีอยู่แล้ว? เข้าสู่ระบบ     │
│                                     │
└─────────────────────────────────────┘
```

### Colors Used

- Same color scheme as Login Page
- **Checkbox Active**: `#5E9CFF` (Primary blue)

### Components

1. **Back Button**

   - Top left corner
   - Arrow back icon
   - Transparent background

2. **Title Section**

   - Large bold text (32sp)
   - Subtitle with lighter color (14sp)
   - Center aligned

3. **Full Name Input**

   - Required field
   - Person icon prefix
   - Validation: min 2 characters

4. **Email Input**

   - Required field
   - Email icon prefix
   - Validation: email format

5. **Phone Input**

   - Optional field
   - Phone icon prefix
   - Validation: Thai phone format (10 digits, starts with 0)

6. **Password Input**

   - Required field
   - Lock icon prefix
   - Toggle visibility icon
   - Validation: min 8 characters

7. **Confirm Password Input**

   - Required field
   - Lock icon prefix
   - Toggle visibility icon
   - Validation: must match password

8. **Terms Checkbox**

   - Checkbox with text
   - Links to terms and privacy policy (underlined)
   - Must be checked to proceed

9. **Register Button**

   - Full width
   - 56px height
   - Rounded corners (12px)
   - Disabled until terms accepted
   - Shows loading indicator when pressed

10. **Login Link**
    - Center aligned
    - "มีบัญชีอยู่แล้ว?" in gray
    - "เข้าสู่ระบบ" in primary color

---

## Responsive Behavior

### Mobile (< 600px)

- Single column layout
- Full width inputs
- Padding: 24px

### Tablet (600px - 900px)

- Single column layout
- Max width: 600px
- Centered content

### Desktop (> 900px)

- Single column layout
- Max width: 450px
- Centered content
- Increased padding

---

## Interactions

### Loading States

- Button shows circular progress indicator
- Button is disabled during loading
- Form inputs are enabled during loading

### Error States

- Red border on invalid inputs
- Error message below input
- Scroll to first error on submit

### Success States

- Navigate to home page on success
- Show success message (optional)

### Validation

- On submit validation
- Real-time validation after first submit
- Clear error on input change

---

## Accessibility

1. **Labels**

   - All inputs have visible labels
   - Screen reader friendly

2. **Focus States**

   - Clear focus indicators
   - Keyboard navigation support

3. **Error Messages**

   - Clear and descriptive
   - In Thai language
   - Associated with inputs

4. **Touch Targets**

   - Minimum 48x48 pixels
   - Adequate spacing between elements

5. **Color Contrast**
   - WCAG AA compliant
   - Text on background: > 4.5:1 ratio

---

## Animations

1. **Page Transitions**

   - Slide from right (duration: 300ms)
   - Fade in (duration: 200ms)

2. **Button Press**

   - Scale down slightly (0.95)
   - Duration: 100ms

3. **Input Focus**

   - Border color change
   - Duration: 200ms

4. **Error Shake**

   - Horizontal shake on validation error
   - Duration: 400ms

5. **Loading Indicator**
   - Circular spinner rotation
   - Continuous animation
