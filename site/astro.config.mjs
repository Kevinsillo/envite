// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import { unified } from '@astrojs/markdown-remark';
import starlightThemeNext from 'starlight-theme-next';
import rehypeExternalLinks from 'rehype-external-links';

export default defineConfig({
	site: 'https://kevinsillo.github.io',
	base: '/envite',
	redirects: {
		'/': '/envite/en/',
	},
	markdown: {
		processor: unified({
			rehypePlugins: [
				[rehypeExternalLinks, { target: '_blank', rel: ['noopener', 'noreferrer'] }],
			],
		}),
	},
	integrations: [
		starlight({
			plugins: [starlightThemeNext()],
			customCss: ['./src/styles/custom.css'],
			title: 'Envite',
			description: 'Encrypted vaults for environment variables and .env files. Share secrets with your team, keep them on disk or on a server over SSH, and deploy .env files from a fast terminal UI.',
			defaultLocale: 'en',
			locales: {
				en: {
					label: 'English',
					lang: 'en',
				},
			},
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/Kevinsillo/envite' },
			],
			head: [
				{
					tag: 'meta',
					attrs: { property: 'og:type', content: 'website' },
				},
				{
					tag: 'meta',
					attrs: { property: 'og:site_name', content: 'Envite' },
				},
				{
					tag: 'meta',
					attrs: {
						name: 'google-site-verification',
						content: '9Tmam7NPlAYItzsHm5ToS5osD6ccx_ly9B4g4i1qXH0',
					},
				},
			],
			sidebar: [
				{
					label: 'Getting Started',
					items: [
						{ slug: 'getting-started/introduction' },
						{ slug: 'getting-started/installation' },
						{ slug: 'getting-started/first-start' },
						{ slug: 'getting-started/tour' },
					],
				},
				{
					label: 'Concepts',
					items: [
						{ slug: 'concepts/vaults' },
						{ slug: 'concepts/hierarchy' },
						{ slug: 'concepts/secrets' },
						{ slug: 'concepts/variable-states' },
						{ slug: 'concepts/history' },
						{ slug: 'concepts/sync-and-conflicts' },
						{ slug: 'concepts/remote-vaults' },
					],
				},
				{
					label: 'Guides',
					items: [
						{ slug: 'guides/share-a-vault' },
						{ slug: 'guides/organize-variables' },
						{ slug: 'guides/deploy' },
						{ slug: 'guides/import' },
						{ slug: 'guides/resolve-conflicts' },
						{ slug: 'guides/history' },
						{ slug: 'guides/options' },
					],
				},
				{
					label: 'Reference',
					items: [
						{ slug: 'reference/keyboard-shortcuts' },
						{ slug: 'reference/env-format' },
						{ slug: 'reference/vault-format' },
						{ slug: 'reference/configuration' },
						{ slug: 'reference/command-line' },
						{ slug: 'reference/security' },
						{ slug: 'reference/architecture' },
						{ slug: 'reference/faq' },
					],
				},
			],
		}),
	],
});
