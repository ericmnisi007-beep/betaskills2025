# Webhook Integration with Make.com

## Overview
The authentication page has been integrated with make.com webhooks to send real-time triggers for various user actions.

## Webhook URL
**Current URL**: `https://hook.eu2.make.com/cjidqgl89n2sw81cs64krdscwt13e38u`

**Status**: ⚠️ **URL may be expired** (returned 410 Gone error)

## Integration Points

### 1. Page Visit Tracking
- **Trigger**: When auth page loads
- **Action**: `page_visit`
- **Data Sent**:
  ```json
  {
    "action": "page_visit",
    "timestamp": "2025-08-17T15:36:33.531Z",
    "user": {
      "email": "",
      "firstName": "",
      "lastName": "",
      "role": "student"
    },
    "platform": "Beta Skill Learning Platform",
    "source": "Auth Page",
    "additionalData": {
      "page": "auth",
      "action": "page_loaded",
      "timestamp": "2025-08-17T15:36:33.531Z"
    }
  }
  ```

### 2. Login Events
- **Trigger**: When user successfully logs in
- **Action**: `login`
- **Data Sent**:
  ```json
  {
    "action": "login",
    "timestamp": "2025-08-17T15:36:33.531Z",
    "user": {
      "email": "user@example.com",
      "firstName": "",
      "lastName": "",
      "role": "student"
    },
    "platform": "Beta Skill Learning Platform",
    "source": "Auth Page"
  }
  ```

### 3. Signup Events
- **Trigger**: When user successfully signs up
- **Action**: `signup`
- **Data Sent**:
  ```json
  {
    "action": "signup",
    "timestamp": "2025-08-17T15:36:33.531Z",
    "user": {
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "student"
    },
    "platform": "Beta Skill Learning Platform",
    "source": "Auth Page"
  }
  ```

### 4. Password Reset Events
- **Trigger**: When user requests password reset
- **Action**: `password_reset`
- **Data Sent**:
  ```json
  {
    "action": "password_reset",
    "timestamp": "2025-08-17T15:36:33.531Z",
    "user": {
      "email": "user@example.com",
      "firstName": "",
      "lastName": "",
      "role": "student"
    },
    "platform": "Beta Skill Learning Platform",
    "source": "Auth Page",
    "additionalData": {
      "resetRequested": true,
      "action": "password_reset_request"
    }
  }
  ```

### 5. UI Interaction Events
- **Trigger**: When user switches between login/signup modes
- **Action**: `page_visit`
- **Data Sent**:
  ```json
  {
    "action": "page_visit",
    "timestamp": "2025-08-17T15:36:33.531Z",
    "user": {
      "email": "",
      "firstName": "",
      "lastName": "",
      "role": "student"
    },
    "platform": "Beta Skill Learning Platform",
    "source": "Auth Page",
    "additionalData": {
      "page": "auth",
      "action": "mode_switch",
      "newMode": "signup",
      "timestamp": "2025-08-17T15:36:33.531Z"
    }
  }
  ```

## Implementation Details

### File Modified
- `src/pages/Auth.tsx`

### Key Functions
1. `sendWebhookToMake()` - Main webhook function
2. Enhanced `handleSubmit()` - Sends webhooks on login/signup
3. Enhanced `handleResetPassword()` - Sends webhook on password reset
4. Enhanced `useEffect()` - Sends webhook on page load
5. Enhanced UI buttons - Send webhooks on user interactions

### Error Handling
- Webhook failures are logged but don't affect user experience
- Non-blocking implementation
- Graceful error handling with console logging

## Setup Instructions

### 1. Create New Webhook URL
1. Go to [Make.com](https://www.make.com)
2. Create a new scenario
3. Add a webhook trigger
4. Copy the new webhook URL
5. Update the URL in `src/pages/Auth.tsx`

### 2. Update Webhook URL
Replace the webhook URL in the `sendWebhookToMake` function:

```typescript
const webhookUrl = 'YOUR_NEW_WEBHOOK_URL_HERE';
```

### 3. Test the Integration
1. Run the development server: `npm run dev`
2. Visit the auth page
3. Try logging in, signing up, or requesting password reset
4. Check the browser console for webhook logs
5. Verify data is received in your Make.com scenario

## Data Structure

All webhook calls follow this structure:
```typescript
{
  action: string,           // 'login' | 'signup' | 'password_reset' | 'page_visit'
  timestamp: string,        // ISO timestamp
  user: {
    email: string,
    firstName: string,
    lastName: string,
    role: string
  },
  platform: string,         // 'Beta Skill Learning Platform'
  source: string,           // 'Auth Page'
  additionalData?: object   // Additional context data
}
```

## Troubleshooting

### Common Issues
1. **410 Gone Error**: Webhook URL is expired - create a new one
2. **CORS Error**: Make.com webhooks support CORS
3. **Network Error**: Check internet connection
4. **Console Errors**: Check browser console for detailed error messages

### Debug Mode
Enable debug logging by checking the browser console for:
- `Sending webhook to make.com:` - Shows data being sent
- `✅ Webhook sent successfully to make.com` - Success message
- `❌ Webhook failed:` - Error details

## Security Considerations

- Webhook URLs should be kept secure
- Consider using environment variables for webhook URLs
- Implement rate limiting if needed
- Monitor webhook usage and costs

## Future Enhancements

1. **Environment Variables**: Move webhook URL to `.env` file
2. **Retry Logic**: Implement retry mechanism for failed webhooks
3. **Analytics**: Add more detailed user analytics
4. **Custom Events**: Add more specific event tracking
5. **Error Reporting**: Send webhook errors to monitoring service
