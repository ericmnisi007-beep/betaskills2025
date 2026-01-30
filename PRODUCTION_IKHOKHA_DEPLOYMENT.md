# Production Ikhokha Payment Gateway Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying the Ikhokha payment gateway in production mode with real payment processing capabilities.

## Pre-Deployment Checklist

### 1. Production Credentials Setup

- [ ] Obtain production API credentials from Ikhokha
- [ ] Set up secure environment variable storage
- [ ] Configure production webhook endpoints
- [ ] Test credentials in staging environment

### 2. Environment Configuration

#### Required Environment Variables

```bash
# Production Environment
VITE_NODE_ENV=production

# Ikhokha Production Configuration
VITE_IKHOKHA_API_URL=https://api.ikhokha.com
VITE_IKHOKHA_API_KEY=<your_production_api_key>
VITE_IKHOKHA_API_SECRET=<your_production_api_secret>
VITE_IKHOKHA_WEBHOOK_SECRET=<your_production_webhook_secret>
VITE_IKHOKHA_TEST_MODE=false
VITE_IKHOKHA_TIMEOUT=45000
VITE_IKHOKHA_RETRY_ATTEMPTS=3
VITE_IKHOKHA_RETRY_DELAY=2000
```

#### Security Requirements

- [ ] All credentials stored securely (not in code)
- [ ] HTTPS enforced for all payment endpoints
- [ ] Webhook signature validation enabled
- [ ] Content Security Policy implemented
- [ ] API rate limiting configured

### 3. Production Validation

Run the production configuration validator:

```bash
npm run validate:production
```

Expected output:
```
✅ Production configuration validation passed
💡 Recommendations: [list of recommendations]
```

## Deployment Steps

### Step 1: Environment Setup

1. **Set Production Environment Variables**
   ```bash
   # In your deployment environment
   export VITE_NODE_ENV=production
   export VITE_IKHOKHA_API_URL=https://api.ikhokha.com
   export VITE_IKHOKHA_API_KEY=your_production_key
   export VITE_IKHOKHA_API_SECRET=your_production_secret
   export VITE_IKHOKHA_WEBHOOK_SECRET=your_webhook_secret
   export VITE_IKHOKHA_TEST_MODE=false
   ```

2. **Verify Environment Configuration**
   ```bash
   npm run config:check
   ```

### Step 2: Build and Deploy

1. **Build for Production**
   ```bash
   npm run build
   ```

2. **Deploy to Production Server**
   - Ensure HTTPS is enabled
   - Configure proper security headers
   - Set up monitoring and logging

### Step 3: Post-Deployment Verification

1. **Test Payment Flow**
   - [ ] Initialize payment session
   - [ ] Process small test payment
   - [ ] Verify webhook reception
   - [ ] Confirm enrollment activation

2. **Monitor Initial Transactions**
   - [ ] Check payment processing logs
   - [ ] Verify webhook signature validation
   - [ ] Monitor error rates and response times

## Configuration Details

### API Endpoints

| Environment | API URL | Purpose |
|-------------|---------|---------|
| Development | https://pay.ikhokha.com | Testing and development |
| Production | https://api.ikhokha.com | Real payment processing |

### Webhook Configuration

Production webhooks must:
- Use HTTPS endpoints
- Validate signatures using HMAC-SHA256
- Handle idempotency for duplicate notifications
- Respond with appropriate HTTP status codes

Example webhook endpoint:
```
https://yourdomain.com/api/webhooks/ikhokha
```

### Security Considerations

#### Credential Management
- Never commit credentials to version control
- Use environment variables or secure secret management
- Rotate credentials regularly
- Monitor for credential exposure

#### Payment Security
- Validate all payment amounts and references
- Implement proper error handling
- Log security events for monitoring
- Use secure communication channels

#### Webhook Security
- Always validate webhook signatures
- Implement replay attack protection
- Use HTTPS for all webhook endpoints
- Monitor for suspicious webhook activity

## Monitoring and Maintenance

### Key Metrics to Monitor

1. **Payment Success Rate**
   - Target: >95% success rate
   - Alert if below 90%

2. **Response Times**
   - Payment initialization: <5 seconds
   - Webhook processing: <2 seconds

3. **Error Rates**
   - Payment failures: <5%
   - Webhook validation failures: <1%

### Regular Maintenance Tasks

- [ ] Review payment processing logs weekly
- [ ] Update credentials quarterly
- [ ] Test webhook endpoints monthly
- [ ] Review security configurations quarterly

## Troubleshooting

### Common Issues

#### 1. Configuration Errors
```
❌ Production Ikhokha configuration errors: Test mode must be disabled in production
```
**Solution**: Set `VITE_IKHOKHA_TEST_MODE=false`

#### 2. Credential Issues
```
❌ Production API key appears to be invalid or missing
```
**Solution**: Verify production credentials are properly set

#### 3. Webhook Validation Failures
```
❌ Webhook signature mismatch - potential security issue
```
**Solution**: Check webhook secret configuration

### Support Contacts

- **Ikhokha Support**: support@ikhokha.com
- **Technical Documentation**: https://docs.ikhokha.com
- **Emergency Contact**: [Your emergency contact]

## Rollback Plan

If issues occur in production:

1. **Immediate Actions**
   - Switch to maintenance mode
   - Disable new payment processing
   - Notify users of temporary issues

2. **Rollback Steps**
   - Revert to previous working configuration
   - Re-enable test mode if necessary
   - Investigate and fix issues in staging

3. **Recovery Verification**
   - Test payment flow in staging
   - Validate all configurations
   - Monitor initial production transactions

## Compliance and Legal

- [ ] PCI DSS compliance requirements met
- [ ] Data protection regulations followed
- [ ] Terms of service updated for real payments
- [ ] Privacy policy includes payment processing

## Final Checklist

Before going live:

- [ ] All environment variables configured correctly
- [ ] Production validation passes
- [ ] HTTPS enforced
- [ ] Webhook endpoints tested
- [ ] Monitoring and alerting configured
- [ ] Support team notified
- [ ] Rollback plan tested
- [ ] Documentation updated

## Post-Deployment

After successful deployment:

1. **Monitor for 24 hours**
   - Watch payment success rates
   - Monitor error logs
   - Check webhook processing

2. **Gradual Rollout**
   - Start with limited user base
   - Gradually increase traffic
   - Monitor performance metrics

3. **Documentation**
   - Update operational procedures
   - Document any configuration changes
   - Share lessons learned with team

---

**⚠️ Important**: This deployment involves real money transactions. Ensure all steps are thoroughly tested in staging before production deployment.