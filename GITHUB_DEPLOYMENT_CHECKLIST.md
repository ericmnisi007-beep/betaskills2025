# 🚀 GitHub to Netlify Deployment Checklist

## ✅ Pre-Deployment Checklist

### 1. Code Preparation
- [x] Build test successful (`npm run build`)
- [x] `.gitignore` configured properly
- [x] `netlify.toml` created
- [x] `_redirects` file exists
- [x] Environment variables documented

### 2. Files Ready for GitHub
- [x] All source code
- [x] `package.json` with dependencies
- [x] `vite.config.ts`
- [x] `netlify.toml`
- [x] `public/_redirects`
- [x] `README.md` (if exists)

## 📋 Step-by-Step Deployment Process

### Step 1: Create GitHub Repository
1. Go to [github.com](https://github.com)
2. Click **"New repository"**
3. Name your repository (e.g., `beta-skill-learning-platform`)
4. Make it **Public** or **Private** (your choice)
5. **Don't** initialize with README (you already have files)
6. Click **"Create repository"**

### Step 2: Push Your Code to GitHub
```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit your changes
git commit -m "Initial commit: Beta Skill Learning Platform"

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 3: Deploy to Netlify
1. Go to [netlify.com](https://netlify.com)
2. Sign up/login to your account
3. Click **"New site from Git"**
4. Choose **"GitHub"** as your Git provider
5. Authorize Netlify to access your GitHub account
6. Select your repository from the list

### Step 4: Configure Build Settings
In Netlify, set these build settings:
- **Build command**: `npm run build`
- **Publish directory**: `dist`
- **Node version**: `18` (or leave default)

### Step 5: Set Environment Variables
1. In your Netlify site dashboard
2. Go to **Site settings** → **Environment variables**
3. Add these variables:
   ```
   VITE_SUPABASE_URL=your_actual_supabase_url
   VITE_SUPABASE_ANON_KEY=your_actual_supabase_anon_key
   ```

### Step 6: Deploy
1. Click **"Deploy site"**
2. Wait for build to complete (usually 2-5 minutes)
3. Your site will be live at a Netlify URL

## 🔧 Post-Deployment

### Verify Your Deployment
- [ ] Site loads without errors
- [ ] Authentication works
- [ ] Course navigation works
- [ ] Images load properly
- [ ] All routes work (SPA routing)

### Custom Domain (Optional)
1. In Netlify dashboard → **Domain settings**
2. Click **"Add custom domain"**
3. Follow DNS configuration instructions

## 🚨 Troubleshooting

### Build Fails
- Check Netlify build logs
- Verify all dependencies are in `package.json`
- Ensure environment variables are set

### Environment Variables Issues
- Variables must start with `VITE_`
- Redeploy after adding variables
- Check for typos in variable names

### Routing Issues
- Verify `_redirects` file is in `public/` folder
- Check that all routes redirect to `index.html`

## 📞 Support
- Netlify build logs show detailed error information
- GitHub repository should be accessible to Netlify
- Environment variables are case-sensitive

---

**Ready to deploy? Follow the steps above! 🚀** 