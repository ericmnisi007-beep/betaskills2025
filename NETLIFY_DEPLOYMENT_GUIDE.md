# 🚀 Netlify Deployment Guide

## Quick Deploy (Recommended)

### Method 1: Drag & Drop (Easiest)
1. Go to [netlify.com](https://netlify.com) and sign up/login
2. Drag and drop your `dist` folder (after running `npm run build`) to the Netlify dashboard
3. Your site will be live instantly!

### Method 2: Connect GitHub Repository
1. Push your code to GitHub
2. Go to [netlify.com](https://netlify.com) and click "New site from Git"
3. Connect your GitHub account
4. Select your repository
5. Configure build settings:
   - **Build command**: `npm run build`
   - **Publish directory**: `dist`
6. Click "Deploy site"

## Environment Variables Setup

After deployment, you'll need to set up your environment variables in Netlify:

1. Go to your site's dashboard in Netlify
2. Navigate to **Site settings** → **Environment variables**
3. Add the following variables:

```
VITE_SUPABASE_URL=your_supabase_url_here
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

## Build Settings

Your project is configured with:
- ✅ **Build command**: `npm run build`
- ✅ **Publish directory**: `dist`
- ✅ **Node version**: 18+
- ✅ **SPA routing**: Configured with `_redirects`
- ✅ **Security headers**: Configured in `netlify.toml`

## Custom Domain (Optional)

1. In your Netlify dashboard, go to **Domain settings**
2. Click **Add custom domain**
3. Follow the DNS configuration instructions

## Troubleshooting

### Build Fails
- Check that all dependencies are in `package.json`
- Ensure Node version is 18+
- Verify environment variables are set

### Routing Issues
- The `_redirects` file handles SPA routing
- All routes redirect to `index.html`

### Environment Variables Not Working
- Make sure variables start with `VITE_`
- Redeploy after adding variables

## Performance Optimization

Your deployment includes:
- ✅ Asset caching (1 year for static assets)
- ✅ Security headers
- ✅ Gzip compression
- ✅ CDN distribution

## Support

If you encounter issues:
1. Check Netlify build logs
2. Verify environment variables
3. Test locally with `npm run build`
4. Check Netlify documentation

---

**Your app is ready to deploy! 🎉** 