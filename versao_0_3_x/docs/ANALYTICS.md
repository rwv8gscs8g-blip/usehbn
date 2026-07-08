# Analytics

## Objective

Track visits to the canonical public site at `https://usehbn.org` without changing the domain strategy:

- `usehbn.org` remains the canonical public site
- `usehbn.com` remains the redirect alias
- GitHub Pages serves the site
- Cloudflare remains the DNS authority

## Recommended path

Use Cloudflare Web Analytics.

Why:

- it is already aligned with the active DNS authority
- it avoids introducing a second analytics vendor by default
- it is sufficient for traffic monitoring even when the site is hosted on GitHub Pages

## Important constraint

Because `usehbn.org` is served by GitHub Pages and the DNS records were intentionally kept as `DNS only`, Cloudflare will not inject analytics automatically. The site must use the manual beacon snippet.

## Manual setup

1. In Cloudflare, open the `usehbn.org` zone.
2. Open `Analytics & Logs` or `Web Analytics`.
3. Create or enable a site entry for `usehbn.org`.
4. Copy the site token from Cloudflare.
5. Insert the beacon snippet into `site/index.html` before `</body>`:

```html
<script
  defer
  src="https://static.cloudflareinsights.com/beacon.min.js"
  data-cf-beacon='{"token":"YOUR_SITE_TOKEN"}'
></script>
```

6. Commit and publish the site again.
7. Validate traffic inside the Cloudflare analytics dashboard.

## Visible visit counter

Cloudflare Web Analytics provides a dashboard, not a public on-page counter.

If a visible counter is required on the page itself, use one of these options:

- GoatCounter
- a simple custom endpoint on a controlled backend
- a counter route served by the Maurício Zanin Hub application

The preferred order is:

1. Cloudflare Web Analytics for trustworthy traffic monitoring
2. visible counter only if there is a strong communication reason

## Personal site integration

The `MAURICIOZANIN-HUB` application already logs route access through its own tracking hook. The `/usehbn` route on the personal site can therefore act as a second controlled observation point for HBN traffic, separate from the public static site.
