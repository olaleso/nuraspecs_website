# NuraSpecs cinematic website — Cloudflare release v3

This release updates **School Management** to say it is **already live with a customer**, while **NuraSpecs One** remains clearly **pre-launch**. Both PUBLIC browser demos use fictional/sample information and are NOT connected to any customer systems.

## Recommended: deploy safely in two stages

### 0. Important checks before making the new site public

1. Verify that `site/assets/logo.svg`, `favicon.svg`, and preview/OG imagery reflect your **approved** company logo. The previous package used provisional branding.
2. Read `site/privacy.html` and obtain your company's approval of the factual website privacy information. It is an initial website-specific draft, not a legally reviewed statement of regulatory compliance. Product-specific notices remain separate.
3. Check `info@nuraspecs.com` and the WhatsApp link `https://wa.me/2348038455341`. The contact form opens an EMAIL DRAFT, not a CRM ticket or automatic form submission. Test actual sending on your devices.
4. Do not link to a real customer school's admin portal or display customer-identifiable records, testimonials or logo without their explicit approval.
5. Test all demos, page navigation, HTTPS, smartphone layout, accessibility basics, Open Graph image and link previews.
6. Save your existing website GitHub repo/production deployment as a rollback point. **Do not delete or alter other Cloudflare zones, Workers routes, DNS, or email records.**

### 1. Stage on Cloudflare Pages (no effect on existing domain)

From PowerShell in this extracted directory:

```powershell
npx wrangler whoami
npx wrangler pages project list
```

If a new Pages project named `nuraspecs-cinematic` DOES NOT already exist in your account, create it:

```powershell
npx wrangler pages project create nuraspecs-cinematic --production-branch main
```

Then upload the staging preview:

```powershell
.\DEPLOY_STAGING.ps1 -ProjectName nuraspecs-cinematic
```

The PowerShell script asks you to type `PREVIEW` after verifying the project, and deploys to the `staging` branch. The returned URL will usually resemble `staging.nuraspecs-cinematic.pages.dev`. Cloudflare adds a `noindex` header to preview deployments by default. Do not attach the public domain at this stage.

> Cloudflare **Direct Upload** projects cannot later be converted into native Git-integrated Pages projects. If you want native Git integration from day one, first push `site/` to a dedicated repo and create the new Pages project using **Connect to Git** instead of the `pages project create` command. You can still automate a Direct Upload project from GitHub Actions by running Wrangler in CI later.

### 2. Check the staging site

- Home carousel, mobile menu, flagship One links and both live-school product status labels.
- `.../products/school-management.html`: live with a customer; fictional demo has no access to customer information.
- `.../products/nuraspecs-one.html`: pre-launch, not a production signup.
- `.../demo.html?product=school` and `.../demo.html?product=one` both interactive.
- `.../contact.html?product=school` and `...?product=one`: email draft is generated and actually SENDS only if visitor sends it.
- Legacy URL `/school-management.html` redirects to the new school page.

### 3. Publish the Cloudflare Pages site

After verifying staging and completing signoffs, run:

```powershell
.\DEPLOY_PRODUCTION.ps1 -ProjectName nuraspecs-cinematic
```

The script requires you to type `RELEASE`; it uploads `site/` to the production branch `main` and does **not** modify your existing domain or DNS.

### 4. Move `nuraspecs.com` to Cloudflare Pages

1. Identify your **current** origin first. If Cloudflare is only providing DNS for GitHub Pages, the old site will remain live until you update the DNS/custom domain.
2. In the Cloudflare dashboard, go to **Workers & Pages > your Pages project > Custom domains > Set up a domain**. Select `nuraspecs.com` in the account that manages the domain. Follow the Cloudflare-recommended record change, checking for conflicting existing apex records. Do not manually point DNS to an unregistered Pages hostname.
3. Also address `www.nuraspecs.com`. Either attach it to the Pages project or redirect it to the apex domain with a Cloudflare redirect rule. Verify both hostnames return the intended website.
4. **Do not change nameservers or unrelated DNS records.** Preserve MX, SPF, DKIM, DMARC, app subdomains, Workers routes, and any other existing services.
5. Test HTTPS, `www`, email delivery, contact links, school links, and old bookmarked URLs from a separate device after propagation.
6. If your current site was previously auto-deployed by GitHub Pages, stop the old publish workflow only AFTER the new site is stable, and keep the repository as a rollback/reference.

### Recovery

Your previous website should still be backed up. Before the DNS cutover, a bad new deployment cannot replace it on the public domain. After cutover, use **Cloudflare Pages > Deployments > Roll back** to a previous Pages deployment, or restore your previous DNS/origin if needed. Check DNS propagation and the certificate status before switching back. Avoid rapid DNS flipping.

### Structure

- `site/` is the deployable public website. Wrangler must upload THIS DIRECTORY, not the enclosing release ZIP or scripts.
- `site/_redirects`: preserves selected old URL paths.
- `site/_headers`: basic response-security headers (not a security certification).
- `DEPLOY_STAGING.ps1`/`DEPLOY_PRODUCTION.ps1` deploy only when you explicitly confirm.
- `SITE_RELEASE_CHECKS.md`: checks that require real account/customer knowledge.

Current limitations: Static website; contact form invokes mail client; demos use sample data; no live SaaS customer sign-up or public live school login link. The existing live school application is not modified by this website release.
