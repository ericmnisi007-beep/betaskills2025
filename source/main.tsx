import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.tsx'
import './index.css'

const initializeApp = async () => {
  try {
    console.log('🚀 Initializing Beta Skills application...');
    console.log(`📊 Environment: ${import.meta.env.VITE_NODE_ENV || 'development'}`);
    console.log(`🌐 Mode: ${import.meta.env.MODE || 'unknown'}`);
    
    // Setup basic error handling
    window.addEventListener('error', (event) => {
      console.error('Global error:', event.error);
    });

    window.addEventListener('unhandledrejection', (event) => {
      console.error('Unhandled promise rejection:', event.reason);
    });

    // Get root element
    const rootElement = document.getElementById('root');
    if (!rootElement) {
      throw new Error('Root element not found');
    }

    // Create and render the app
    const root = createRoot(rootElement);
    root.render(React.createElement(App));
    
    console.log('✅ Application initialized successfully');

  } catch (initError) {
    console.error('❌ Failed to initialize app:', initError);
    showApplicationError(initError);
  }
};

// Show application error to user
const showApplicationError = (error: any) => {
  console.error('Application initialization error:', error);
  
  const rootElement = document.getElementById('root');
  if (rootElement) {
    rootElement.innerHTML = `
      <div style="
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        padding: 20px;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        text-align: center;
      ">
        <div style="
          background: rgba(255, 255, 255, 0.1);
          padding: 40px;
          border-radius: 20px;
          backdrop-filter: blur(10px);
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
          max-width: 500px;
        ">
          <h1 style="margin: 0 0 20px 0; font-size: 2.5rem;">🚀 Beta Skills</h1>
          <p style="margin: 0 0 20px 0; font-size: 1.2rem; opacity: 0.9;">
            Loading your learning platform...
          </p>
          <p style="margin: 0 0 30px 0; font-size: 1rem; opacity: 0.7;">
            If this persists, please refresh the page.
          </p>
          <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap;">
            <button 
              onclick="window.location.reload()" 
              style="
                background: #ff6b6b;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-size: 1rem;
                cursor: pointer;
                transition: all 0.3s ease;
              "
              onmouseover="this.style.background='#ff5252'"
              onmouseout="this.style.background='#ff6b6b'"
            >
              🔄 Refresh Page
            </button>
          </div>
        </div>
      </div>
    `;
  }
};

// Initialize the application
initializeApp();
