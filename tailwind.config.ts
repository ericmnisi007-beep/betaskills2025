import type { Config } from "tailwindcss";

export default {
	darkMode: ["class"],
	content: [
		'./pages/**/*.{ts,tsx}',
		'./components/**/*.{ts,tsx}',
		'./app/**/*.{ts,tsx}',
		'./src/pages/**/*.{ts,tsx}',
		'./src/components/**/*.{ts,tsx}',
		'./src/app/**/*.{ts,tsx}',
		'./src/layouts/**/*.{ts,tsx}',
		'./src/views/**/*.{ts,tsx}',
		'./src/index.tsx',
		'./src/App.tsx'
	],
	prefix: "",
	theme: {
		container: {
			center: true,
			padding: {
				DEFAULT: '1.5rem',
				sm: '2rem',
				md: '3rem',
				lg: '4rem',
				xl: '5rem',
				'2xl': '6rem'
			},
			screens: {
				'2xl': '1400px'
			}
		},
		screens: {
			'xs': '475px',
			'sm': '640px',
			'md': '768px',
			'lg': '1024px',
			'xl': '1280px',
			'2xl': '1536px',
		},
		extend: {
			fontFamily: {
				'inter': ['Inter', 'sans-serif'],
			},
			colors: {
				border: 'hsl(var(--border))',
				input: 'hsl(var(--input))',
				ring: 'hsl(var(--ring))',
				background: 'hsl(var(--background))',
				foreground: 'hsl(var(--foreground))',
				primary: {
					DEFAULT: '#e11d48',
					dark: '#111111',
					light: '#ffffff',
				},
				secondary: {
					DEFAULT: '#1f2937',
					light: '#374151',
					dark: '#111827',
					foreground: 'hsl(var(--secondary-foreground))'
				},
				accent: {
					DEFAULT: '#f87171',
					light: '#fca5a5',
					dark: '#dc2626',
					foreground: 'hsl(var(--accent-foreground))'
				},
				destructive: {
					DEFAULT: 'hsl(var(--destructive))',
					foreground: 'hsl(var(--destructive-foreground))'
				},
				muted: {
					DEFAULT: 'hsl(var(--muted))',
					foreground: 'hsl(var(--muted-foreground))'
				},
				popover: {
					DEFAULT: 'hsl(var(--popover))',
					foreground: 'hsl(var(--popover-foreground))'
				},
				card: {
					DEFAULT: 'hsl(var(--card))',
					foreground: 'hsl(var(--card-foreground))'
				},
				sidebar: {
					DEFAULT: 'hsl(var(--sidebar-background))',
					foreground: 'hsl(var(--sidebar-foreground))',
					primary: 'hsl(var(--sidebar-primary))',
					'primary-foreground': 'hsl(var(--sidebar-primary-foreground))',
					accent: 'hsl(var(--sidebar-accent))',
					'accent-foreground': 'hsl(var(--sidebar-accent-foreground))',
					border: 'hsl(var(--sidebar-border))',
					ring: 'hsl(var(--sidebar-ring))'
				},
				black: '#111111',
				white: '#ffffff',
				red: {
					50: '#fef2f2',
					100: '#fee2e2',
					200: '#fecaca',
					300: '#fca5a5',
					400: '#f87171',
					500: '#ef4444',
					600: '#e11d48',
					700: '#be123c',
					800: '#991b1b',
					900: '#7f1d1d',
				},
			},
			backgroundImage: {
				'gradient-primary': 'linear-gradient(135deg, #dc2626 0%, #1f2937 100%)',
				'gradient-secondary': 'linear-gradient(135deg, #ef4444 0%, #374151 100%)',
				'gradient-card': 'linear-gradient(135deg, #fef2f2 0%, #f3f4f6 100%)',
			},
			borderRadius: {
				lg: 'var(--radius)',
				md: 'calc(var(--radius) - 2px)',
				sm: 'calc(var(--radius) - 4px)'
			},
			keyframes: {
				'accordion-down': {
					from: { height: '0' },
					to: { height: 'var(--radix-accordion-content-height)' }
				},
				'accordion-up': {
					from: { height: 'var(--radix-accordion-content-height)' },
					to: { height: '0' }
				},
				'fade-in': {
					'0%': { opacity: '0', transform: 'translateY(20px)' },
					'100%': { opacity: '1', transform: 'translateY(0)' }
				},
				'slide-in-left': {
					'0%': { opacity: '0', transform: 'translateX(-30px)' },
					'100%': { opacity: '1', transform: 'translateX(0)' }
				},
				'slide-in-right': {
					'0%': { opacity: '0', transform: 'translateX(30px)' },
					'100%': { opacity: '1', transform: 'translateX(0)' }
				},
				'scale-in': {
					'0%': { opacity: '0', transform: 'scale(0.9)' },
					'100%': { opacity: '1', transform: 'scale(1)' }
				},
				'pulse-glow': {
					'0%, 100%': { boxShadow: '0 0 20px rgba(220, 38, 38, 0.4)' },
					'50%': { boxShadow: '0 0 40px rgba(220, 38, 38, 0.8)' }
				},
				'gradient-x': {
					'0%, 100%': { backgroundPosition: '0% 50%' },
					'50%': { backgroundPosition: '100% 50%' }
				},
				'pulse-slow': {
					'0%, 100%': { opacity: '0.6' },
					'50%': { opacity: '1' }
				},
			},
			animation: {
				'accordion-down': 'accordion-down 0.2s ease-out',
				'accordion-up': 'accordion-up 0.2s ease-out',
				'fade-in': 'fade-in 0.6s ease-out',
				'slide-in-left': 'slide-in-left 0.6s ease-out',
				'slide-in-right': 'slide-in-right 0.6s ease-out',
				'scale-in': 'scale-in 0.4s ease-out',
				'pulse-glow': 'pulse-glow 2s ease-in-out infinite',
				'gradient-x': 'gradient-x 3s ease-in-out infinite',
				'pulse-slow': 'pulse-slow 1.5s infinite',
			},
			gradientColorStops: theme => ({
				...theme('colors'),
				'red-black': '#e11d48',
				'black': '#111111',
				'white': '#ffffff',
			}),
		}
	},
	plugins: [require("tailwindcss-animate")],
} satisfies Config;
