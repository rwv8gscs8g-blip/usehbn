# Domains

## Canonical Public Strategy

HBN should expose one canonical public site:

- `usehbn.org` = canonical public site
- `usehbn.com` = redirect to `https://usehbn.org`

This keeps the public identity simple while preserving both semantic anchors.

## Semantic Role

The domains are not only web destinations. They are also semantic anchors used across:

- natural language references
- runtime adapters
- public documentation
- future distribution flows

In the current system:

- `usehbn`
- `use hbn`
- `usehbn.com`
- `usehbn.org`

should all be understood as references to the HBN protocol identity.

## Recommended Hosting Model

Recommended public setup:

1. publish the static site from `site/` via GitHub Pages
2. set `usehbn.org` as the custom domain in GitHub Pages
3. manage DNS in Cloudflare
4. use Cloudflare redirect rules so `usehbn.com` permanently redirects to `https://usehbn.org`

## Registrar and DNS Authority

Recommended control model:

- keep both domains registered in GoDaddy
- delegate authoritative DNS for both domains to Cloudflare
- host the canonical public site on GitHub Pages under `usehbn.org`
- handle redirect logic for `usehbn.com` in Cloudflare, not in GitHub Pages

This keeps one content origin and one redirect layer:

- GitHub Pages serves `usehbn.org`
- Cloudflare resolves DNS and applies redirect rules
- GoDaddy remains only the registrar

## DNS Model

### `usehbn.org`

Recommended as the canonical apex domain for the Pages site.

DNS records:

- `A @ -> 185.199.108.153`
- `A @ -> 185.199.109.153`
- `A @ -> 185.199.110.153`
- `A @ -> 185.199.111.153`
- optional `AAAA @ -> 2606:50c0:8000::153`
- optional `AAAA @ -> 2606:50c0:8001::153`
- optional `AAAA @ -> 2606:50c0:8002::153`
- optional `AAAA @ -> 2606:50c0:8003::153`
- `CNAME www -> rwv8gscs8g-blip.github.io`

Cloudflare proxy mode:

- keep GitHub Pages DNS records as `DNS only`, not proxied, while the certificate and Pages validation are stabilizing
- after Pages is healthy, keep the setup conservative unless there is a clear operational reason to proxy it

### `usehbn.com`

Recommended as alias/redirect-only domain.

If `usehbn.com` is on Cloudflare:

- `A @ -> 192.0.2.1` proxied
- `A www -> 192.0.2.1` proxied
- redirect rule from `http*://usehbn.com/*` to `https://usehbn.org/${2}` with `301`
- equivalent rule for `www.usehbn.com`

The placeholder IP only exists so Cloudflare has a record to attach the redirect rule to. The redirect is the actual behavior.

## What Must Be Configured in GitHub

In repository settings:

1. enable GitHub Pages from Actions
2. set custom domain to `usehbn.org`
3. wait for certificate issuance
4. enable `Enforce HTTPS`

## What Must Be Configured in GoDaddy

For both `usehbn.org` and `usehbn.com`:

1. open the domain in GoDaddy
2. switch from GoDaddy default nameservers to the two Cloudflare nameservers assigned to that zone
3. save and wait for delegation to propagate

Do not configure the final DNS records in GoDaddy if Cloudflare is the DNS authority. Once nameservers point to Cloudflare, the working records must live in Cloudflare.

## What Must Be Verified

- GitHub Pages deploy succeeds on `main`
- `site/CNAME` contains `usehbn.org`
- `https://usehbn.org` resolves and serves the landing page
- `https://usehbn.com` returns a permanent redirect to `https://usehbn.org`

## Screenshots Needed If Manual Review Is Required

If final DNS or redirect behavior still does not work, capture:

1. GoDaddy nameserver screen for `usehbn.org`
2. GoDaddy nameserver screen for `usehbn.com`
3. Cloudflare overview page for the `usehbn.org` zone
4. Cloudflare DNS records for the `usehbn.org` zone
5. Cloudflare DNS records for the `usehbn.com` zone
6. Cloudflare redirect rule for `usehbn.com`
7. GitHub repository Pages settings showing custom domain and HTTPS status
