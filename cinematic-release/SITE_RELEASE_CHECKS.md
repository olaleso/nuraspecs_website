# NuraSpecs website cutover checklist

- [ ] Verify approved company logo and domain branding (website uses provisional concept logo).
- [ ] Approve final privacy notice for NuraSpecs Solutions and product-specific privacy documentation.
- [ ] Confirm public company email and WhatsApp number.
- [ ] Test enquiry email workflow on desktop and mobile; plan server-side contact form separately if required.
- [ ] Get customer permission before identifying live school customer or publishing any real school screenshots.
- [ ] Verify School Management feature list and availability of assisted demos/onboarding.
- [ ] Confirm NuraSpecs One remains clearly labelled pre-launch, and all mock data are synthetic.
- [ ] Save copy of the old website source and record current Cloudflare DNS, Pages/Workers routes and GitHub Pages configuration.
- [ ] Stage deployment to separate Cloudflare Pages preview and test home/product/demo/contact/404/redirects.
- [ ] Test desktop/mobile performance and reduced-motion preferences.
- [ ] Verify current root and www traffic path before custom domain migration.
- [ ] Attach only intended domain(s) in Cloudflare Pages Custom domains; keep DNS for existing email and applications intact.
- [ ] Confirm HTTPS, legacy links, email delivery, contact flow and roll-back option after cutover.
