# Card Payment System Production Deployment Guide

This guide provides step-by-step instructions for deploying the card payment immediate access system to production.

## Table of Contents

1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Environment Configuration](#environment-configuration)
3. [Database Setup](#database-setup)
4. [Security Configuration](#security-configuration)
5. [Monitoring and Alerting Setup](#monitoring-and-alerting-setup)
6. [Deployment Steps](#deployment-steps)
7. [Post-Deployment Verification](#post-deployment-verification)
8. [Rollback Procedures](#rollback-procedures)
9. [Troubleshooting](#troubleshooting)

## Pre-Deployment Checklist

Before deploying to production, ensure the following:

- [ ] All tests pass (run `npm test`)
- [ ] Deployment verification tests pass (run `npm run test:deployment`)
- [ ] Production environment variables are configured
- [ ] Ikhokha production credentials are obtained and secured
- [ ] Database migrations are ready
- [ ] Monitoring and alerting endpoints are configured
- [ ] Security measures are in place
- [ ] Rollback plan is documented
- [ ] Team is notified of deployment window

## Environment Configuration

### 1. Copy Production Environment Template

```bash
cp .env.production.card-payment .env.production
```

### 2. Configure Required Variables

Edit `.env.production` and set the following critical variables:

```bash
# Ikhokha Production Credentials (REQUIRED)
VITE_IKHOKHA_API_KEY=your_production_api_key
VITE_IKHOKHA_API_SECRET=your_production_api_secret
VITE_IKHOKHA_WEBHOOK_SECRET=your_production_webhook_secret

# Production URLs
VITE_PRODUCTION_URL=https://app.betaskill.com
VITE_WEBHOOK_ENDPOINT=https://app.betaskill.com/.netlify/functions/ikhokha-webhook

# Alerting Endpoints (REQUIRED for production monitoring)
VITE_ALERT_WEBHOOK_URL=your_alert_webhook_url
VITE_ALERT_EMAIL=alerts@betaskill.com
VITE_ALERT_SLACK_WEBHOOK=your_slack_webhook_url

# Manual Intervention Notifications
VITE_MANUAL_INTERVENTION_WEBHOOK=your_intervention_webhook
VITE_MANUAL_INTERVENTION_EMAIL=support@betaskill.com

# Webhook IP Whitelist (if IP verification enabled)
VITE_WEBHOOK_ALLOWED_IPS=ikhokha_ip_1,ikhokha_ip_2

# Log Aggregation (optional but recommended)
VITE_LOG_AGGREGATION_ENDPOINT=your_log_service_endpoint
```

### 3. Configure Netlify Environment Variables

In your Netlify dashboard:

1. Go to Site Settings > Environment Variables
2. Add all production environment variables
3. Ensure sensitive values are marked as secret
4. Set deployment context to "Production"

### 4. Validate Configuration

Run the configuration validation:

```bash
npm run validate:config
```

## Database Setup

### 1. Run Database Migrations

Apply the monitoring tables migration:

```bash
# Using Supabase CLI
supabase db push

# Or manually run the migration
psql $DATABASE_URL -f supabase/migrations/20241003000000_create_card_payment_monitoring_tables.sql
```

### 2. Verify Tables Created

```sql
-- Check that all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
  'card_payment_metrics',
  'card_payment_performance',
  'card_payment_alerts',
  'card_payment_business_metrics',
  'fast_track_approvals'
);
```

### 3. Verify RLS Policies

```sql
-- Check RLS policies are enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename LIKE 'card_payment%';
```

## Security Configuration

### 1. Webhook Security

Ensure webhook signature validation is enabled:

```bash
VITE_ENABLE_ENHANCED_WEBHOOK_VALIDATION=true
VITE_WEBHOOK_SIGNATURE_ALGORITHM=sha256
VITE_WEBHOOK_TIMESTAMP_TOLERANCE=300
```

### 2. IP Whitelisting

If using IP verification, obtain Ikhokha's webhook IP addresses:

```bash
VITE_ENABLE_WEBHOOK_IP_VERIFICATION=true
VITE_WEBHOOK_ALLOWED_IPS=ip1,ip2,ip3
```

### 3. Audit Logging

Enable comprehensive audit logging:

```bash
VITE_ENABLE_CARD_PAYMENT_AUDIT_LOGGING=true
VITE_AUDIT_LOG_RETENTION_DAYS=365
```

### 4. Threat Detection

Enable threat detection:

```bash
VITE_ENABLE_CARD_PAYMENT_THREAT_DETECTION=true
```

## Monitoring and Alerting Setup

### 1. Configure Monitoring

Enable all monitoring features:

```bash
VITE_ENABLE_CARD_PAYMENT_MONITORING=true
VITE_ENABLE_PERFORMANCE_MONITORING=true
VITE_ENABLE_BUSINESS_METRICS=true
```

### 2. Set Performance Thresholds

Configure appropriate thresholds for your traffic:

```bash
VITE_WEBHOOK_PROCESSING_THRESHOLD=5000
VITE_PAYMENT_DETECTION_THRESHOLD=2000
VITE_APPROVAL_PROCESSING_THRESHOLD=3000
VITE_UI_UPDATE_THRESHOLD=2000
VITE_END_TO_END_THRESHOLD=10000
VITE_ERROR_RATE_ALERT_THRESHOLD=5
```

### 3. Configure Alert Channels

Set up multiple alert channels for redundancy:

```bash
# Webhook alerts
VITE_ALERT_WEBHOOK_URL=https://your-monitoring-service.com/webhook

# Email alerts
VITE_ALERT_EMAIL=alerts@betaskill.com

# Slack alerts
VITE_ALERT_SLACK_WEBHOOK=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
```

### 4. Test Alert Delivery

Before deployment, test that alerts are delivered:

```bash
npm run test:alerts
```

## Deployment Steps

### 1. Pre-Deployment Verification

```bash
# Run all tests
npm test

# Run deployment verification tests
npm run test:deployment

# Build production bundle
npm run build

# Verify build output
ls -la dist/
```

### 2. Deploy to Netlify

```bash
# Deploy via Netlify CLI
netlify deploy --prod

# Or push to main branch for automatic deployment
git push origin main
```

### 3. Monitor Deployment

Watch the deployment logs in Netlify dashboard:

1. Check build logs for errors
2. Verify environment variables are loaded
3. Confirm functions are deployed
4. Check for any warnings

### 4. Verify Deployment

Once deployed, verify the deployment:

```bash
# Check health endpoint
curl https://app.betaskill.com/.netlify/functions/health-check

# Verify configuration endpoint
curl https://app.betaskill.com/.netlify/functions/config-check
```

## Post-Deployment Verification

### 1. Run Smoke Tests

```bash
npm run test:smoke
```

### 2. Verify Core Functionality

- [ ] Homepage loads correctly
- [ ] Course enrollment flow works
- [ ] Payment gateway integration is active
- [ ] Webhook endpoint is accessible
- [ ] Monitoring dashboard shows data
- [ ] Alerts are being received

### 3. Test Card Payment Flow

Perform a test card payment:

1. Select a course
2. Click "Enroll Now"
3. Complete payment with test card
4. Verify immediate access is granted
5. Check monitoring dashboard for metrics
6. Verify no alerts were triggered

### 4. Monitor Initial Traffic

Watch the monitoring dashboard for:

- Processing times
- Success rates
- Error rates
- Alert frequency

### 5. Verify Database

Check that data is being recorded:

```sql
-- Check recent metrics
SELECT * FROM card_payment_metrics 
ORDER BY timestamp DESC 
LIMIT 10;

-- Check recent performance data
SELECT * FROM card_payment_performance 
ORDER BY timestamp DESC 
LIMIT 10;

-- Check for any alerts
SELECT * FROM card_payment_alerts 
WHERE resolved = FALSE 
ORDER BY timestamp DESC;
```

## Rollback Procedures

If issues are detected after deployment:

### 1. Immediate Rollback

```bash
# Rollback to previous deployment in Netlify
netlify rollback

# Or via dashboard: Deploys > Previous Deploy > Publish
```

### 2. Disable Fast-Track (Partial Rollback)

If only card payment fast-track is problematic:

```bash
# Set environment variable
VITE_ENABLE_CARD_PAYMENT_FAST_TRACK=false

# Redeploy
netlify deploy --prod
```

### 3. Database Rollback

If database changes need to be reverted:

```sql
-- Drop monitoring tables (only if necessary)
DROP TABLE IF EXISTS card_payment_metrics CASCADE;
DROP TABLE IF EXISTS card_payment_performance CASCADE;
DROP TABLE IF EXISTS card_payment_alerts CASCADE;
DROP TABLE IF EXISTS card_payment_business_metrics CASCADE;
```

### 4. Notify Team

Send notification to team about rollback:

- Reason for rollback
- Current system status
- Expected resolution time
- Next steps

## Troubleshooting

### Common Issues

#### 1. Webhook Validation Failures

**Symptoms:** Webhooks are being rejected

**Solutions:**
- Verify webhook secret is correct
- Check timestamp tolerance settings
- Verify IP whitelist if enabled
- Check webhook signature algorithm

#### 2. High Processing Times

**Symptoms:** Alerts for slow processing

**Solutions:**
- Check database performance
- Verify network connectivity
- Review error logs
- Consider increasing timeouts temporarily

#### 3. UI Not Updating

**Symptoms:** Course access not showing immediately

**Solutions:**
- Check real-time sync configuration
- Verify broadcast channels are working
- Check browser console for errors
- Verify persistence strategies

#### 4. Alerts Not Being Received

**Symptoms:** No alerts despite issues

**Solutions:**
- Verify alert endpoints are correct
- Check alert service credentials
- Test alert delivery manually
- Review alert configuration

### Debug Mode

Enable debug logging temporarily:

```bash
VITE_ENABLE_DETAILED_CARD_PAYMENT_LOGGING=true
VITE_CARD_PAYMENT_LOG_LEVEL=debug
```

### Support Contacts

- **Technical Issues:** support@betaskill.com
- **Ikhokha Support:** support@ikhokha.com
- **Emergency Hotline:** [Your emergency contact]

## Monitoring Dashboard Access

Access the monitoring dashboard at:

```
https://app.betaskill.com/admin/card-payment-monitoring
```

## Maintenance

### Regular Tasks

- **Daily:** Review monitoring dashboard
- **Weekly:** Check alert trends
- **Monthly:** Review performance metrics
- **Quarterly:** Rotate webhook secrets
- **Annually:** Review and update thresholds

### Data Retention

Monitoring data is automatically cleaned up based on retention policies:

- Metrics: 90 days
- Performance data: 90 days
- Resolved alerts: 365 days
- Audit logs: 365 days

To manually trigger cleanup:

```sql
SELECT cleanup_old_card_payment_metrics();
```

## Success Criteria

Deployment is considered successful when:

- [ ] All deployment verification tests pass
- [ ] No critical alerts in first hour
- [ ] Card payment success rate > 95%
- [ ] Average processing time < 10 seconds
- [ ] UI update success rate > 98%
- [ ] Error rate < 5%
- [ ] All monitoring channels receiving data
- [ ] Team confirms system is operational

## Additional Resources

- [Card Payment Design Document](.kiro/specs/ikhokha-card-payment-immediate-access/design.md)
- [Card Payment Requirements](.kiro/specs/ikhokha-card-payment-immediate-access/requirements.md)
- [Ikhokha API Documentation](https://docs.ikhokha.com)
- [Netlify Deployment Documentation](https://docs.netlify.com)

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-01-06 | 1.0.0 | Initial deployment guide | System |

---

**Last Updated:** 2025-01-06
**Document Owner:** Technical Team
**Review Frequency:** Quarterly
