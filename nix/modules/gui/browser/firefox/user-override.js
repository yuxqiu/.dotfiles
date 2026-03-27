/* CUSTOM SECTION */
/* ************** */
/* ************** */
/* ************** */
/* ************** */

/* 0102: set startup page [SETUP-CHROME]
 * 0=blank, 1=home, 2=last visited page, 3=resume previous session
 * [NOTE] Session Restore is cleared with history (2811), and not used in Private Browsing mode
 * [SETTING] General>Startup>Restore previous session ***/
user_pref("browser.startup.page", 1);
/* 0103: set HOME+NEWWINDOW page
 * about:home=Firefox Home (default, see 0105), custom URL, about:blank
 * [SETTING] Home>New Windows and Tabs>Homepage and new windows ***/
user_pref("browser.startup.homepage", "about:home");
/* 0104: set NEWTAB page
 * true=Firefox Home (default, see 0105), false=blank page
 * [SETTING] Home>New Windows and Tabs>New tabs ***/
user_pref("browser.newtabpage.enabled", true);

/* 0401: disable SB (Safe Browsing)
 * [WARNING] Do this at your own risk! These are the master switches
 * [SETTING] Privacy & Security>Security>... Block dangerous and deceptive content ***/
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
/* 0402: disable SB checks for downloads (both local lookups + remote)
 * This is the master switch for the safebrowsing.downloads* prefs (0403, 0404)
 * To verify the safety of certain executable files, Firefox may submit some information about the
 * file, including the name, origin, size and a cryptographic hash of the contents, to the Google
 * Safe Browsing service which helps Firefox determine whether or not the file should be blocked
 * [SETUP-SECURITY] If you do not understand this, or you want this protection, then override this ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", ""); // Defense-in-depth
/* 0404: disable SB checks for unwanted software
 * [SETTING] Privacy & Security>Security>... "Warn you about unwanted and uncommon software" ***/
// prettier-ignore
user_pref(
  "browser.safebrowsing.downloads.remote.block_potentially_unwanted",
  false
);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
/* 0405: disable "ignore this warning" on SB warnings [FF45+]
 * If clicked, it bypasses the block for that session. This is a means for admins to enforce SB
 * [TEST] see https://github.com/arkenfox/user.js/wiki/Appendix-A-Test-Sites#-mozilla
 * [1] https://bugzilla.mozilla.org/1226490 ***/
user_pref("browser.safebrowsing.allowOverride", false);
user_pref("browser.safebrowsing.appRepURL", "");
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.enabled", false);

/*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS / IPv6 ***/
/* 0710: disable DNS-over-HTTPS (DoH) rollout [FF60+]
 * 0=off by default, 2=TRR (Trusted Recursive Resolver) first, 3=TRR only, 5=explicitly off
 * see "doh-rollout.home-region": USA 2019, Canada 2021, Russia/Ukraine 2022 [3]
 * [1] https://hacks.mozilla.org/2018/05/a-cartoon-intro-to-dns-over-https/
 * [2] https://wiki.mozilla.org/Security/DOH-resolver-policy
 * [3] https://support.mozilla.org/en-US/kb/firefox-dns-over-https
 * [4] https://www.eff.org/deeplinks/2020/12/dns-doh-and-odoh-oh-my-year-review-2020 ***/
user_pref("network.trr.mode", 5);

/*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
/* 0801: disable location bar using search
 * Don't leak URL typos to a search engine, give an error message instead
 * Examples: "secretplace,com", "secretplace/com", "secretplace com", "secret place.com"
 * [NOTE] This does not affect explicit user action such as using search buttons in the
 * dropdown, or using keyword search shortcuts you configure in options (e.g. "d" for DuckDuckGo)
 * [SETUP-CHROME] Override this if you trust and use a privacy respecting search engine ***/
user_pref("keyword.enabled", true);

/*** [SECTION 1000]: DISK AVOIDANCE ***/
/* 1001: disable disk cache
 * [NOTE] We also clear cache on exit (2811)
 * [SETUP-CHROME] If you think disk cache helps perf, then feel free to override this ***/
user_pref("browser.cache.disk.enable", true);

/*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
/* 2002: force WebRTC inside the proxy [FF70+] ***/
// Disable to ensure the stability of WebRTC behind proxy
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", false);
/* 2003: force a single network interface for ICE candidates generation [FF42+]
 * When using a system-wide proxy, it uses the proxy interface
 * [1] https://developer.mozilla.org/en-US/docs/Web/API/RTCIceCandidate
 * [2] https://wiki.mozilla.org/Media/WebRTC/Privacy ***/
// Disable to ensure the stability of WebRTC behind proxy
user_pref("media.peerconnection.ice.default_address_only", false);

/*** [SECTION 4500]: OPTIONAL RFP (resistFingerprinting) ***/
/* 4520: disable WebGL (Web Graphics Library)
 * [SETUP-WEB] If you need it then override it. RFP still randomizes canvas for naive scripts ***/
user_pref("webgl.disabled", false);

// disable email tracking data collection
// prettier-ignore
user_pref(
  "privacy.trackingprotection.emailtracking.data_collection.enabled",
  false
);
// enable email tracking protection
user_pref("privacy.trackingprotection.emailtracking.enabled", true);

// allow macos native fullscreen
user_pref("full-screen-api.macos-native-full-screen", true);

// add custom search
user_pref("browser.urlbar.update2.engineAliasRefresh", true);

// reject all cookies by default and prompt users if cannot do so
user_pref("cookiebanners.service.mode", 1);

// disable all promos
user_pref("browser.contentblocking.report.vpn-promo.url", "");
user_pref("browser.promo.cookiebanners.enabled", false);
user_pref("browser.promo.focus.enabled", false);
user_pref("browser.promo.pin.enabled", false);
user_pref("browser.vpn_promo.enabled", false);
user_pref("identity.mobilepromo.android", "");
user_pref("identity.mobilepromo.ios", "");
user_pref("identity.sendtabpromo.url", "");

// disable feature recommendation
user_pref("browser.newtabpage.activity-stream.feeds.asrouterfeed", false);
// prettier-ignore
user_pref(
  "browser.newtabpage.activity-stream.feeds.discoverystreamfeed",
  false
);

// disable experiments or studies
user_pref("experiments.activeExperiment", false);
user_pref("experiments.enabled", false);
user_pref("experiments.manifest.uri", "");
user_pref("experiments.supported", false);
user_pref("messaging-system.rsexperimentloader.enabled", false);
user_pref("network.allow-experiments", false);

// disable geolocation for default search engine
user_pref("browser.search.geoip.url", "");

// disable add-on metadata updating
user_pref("extensions.getAddons.cache.enabled", false);

// disable auto submit crash report
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);

// disable "you haven't started Firefox in a while." message
// https://support.mozilla.org/en-US/questions/1231948
user_pref("browser.disableResetPrompt", false);

// disable self support
user_pref("browser.selfsupport.url", "");

// disable default browser check
user_pref("browser.shell.checkDefaultBrowser", false);

// disable health report
user_pref("datareporting.healthreport.service.enabled", false);

// disable battery access
user_pref("dom.battery.enabled", false);

// disable more telemetry
user_pref("toolkit.telemetry.cachedClientID", "");
user_pref("toolkit.telemetry.cachedProfileGroupID", "");
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", true);
user_pref("toolkit.telemetry.unifiedIsOptIn", false);
user_pref("toolkit.telemetry.pioneer-new-studies-available", false);

// hide "More from Mozilla" in Settings
user_pref("browser.preferences.moreFromMozilla", false);

// disable fullscreen delay and notice
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.delay", -1);
user_pref("full-screen-api.warning.timeout", 0);

// disable welcome notices
user_pref("browser.aboutwelcome.enabled", false);

// open PDFs inline (FF103+)
// [1] https://support.mozilla.org/en-US/questions/1387228
user_pref("browser.download.open_pdf_attachments_inline", true);

// prevent password truncation when submitting form data
// [1] https://www.ghacks.net/2020/05/18/firefox-77-wont-truncate-text-exceeding-max-length-to-address-password-pasting-issues/
user_pref("editor.truncate_user_pastes", false);

// disable Form Autofill
// NOTE: stored data is not secure (uses a JSON file)
// [1] https://wiki.mozilla.org/Firefox/Features/Form_Autofill
// [2] https://www.ghacks.net/2017/05/24/firefoxs-new-form-autofill-is-awesome
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.heuristics.enabled", false);
user_pref("browser.formfill.enable", false);

// software that continually reports what default browser you are using
// [WARNING] Breaks "Make Default..." button in Preferences to set Firefox as the default browser [1].
// [1] https://github.com/yokoffing/Betterfox/issues/166
user_pref("default-browser-agent.enabled", false);

// PREF: PDF sidebar on load [HIDDEN]
// 2=table of contents (if not available, will default to 1)
// 1=view pages
// -1=disabled (default)
user_pref("pdfjs.sidebarViewOnLoad", 2);

// hide toolbar shown after pressing Alt
user_pref("ui.key.menuAccessKeyFocuses", false);

// disable accessibility
user_pref("accessibility.force_disabled", 1);
user_pref("devtools.accessibility.enabled", false);
user_pref("accessibility.typeaheadfind", false);

// don't close browser when last tab is closed
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Let's Encrypt starts to drop OCSP Support
// Also, there are privacy concerns regarding OCSP
user_pref("security.OCSP.enabled", 0);
user_pref("security.OCSP.require", false);

// disable region updates
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);

// disable fetch of safebrowsing updates
user_pref("browser.safebrowsing.provider.google4.advisoryURL", "");
user_pref("browser.safebrowsing.provider.google4.dataSharingURL", "");
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google.advisoryURL", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google.updateURL", "");

// disable reader mode
user_pref("reader.parse-on-load.enabled", false);

// disable push notification connection
user_pref("dom.push.connection.enabled", false);
user_pref("dom.push.serverURL", "");

// disable activity stream
user_pref("browser.newtabpage.activity-stream.discoverystream.enabled", false);

// disable topsites
user_pref("browser.topsites.contile.enabled", false);
user_pref("browser.topsites.contile.endpoint", "");

// disable geo location
user_pref("geo.provider.network.url", "");

// enable copy link to highlight
user_pref("dom.text_fragments.create_text_fragment.enabled", true);

// enable RFP via FPP
// https://bugzilla.mozilla.org/show_bug.cgi?id=1732114
user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.fingerprintingProtection", true);
// prettier-ignore
user_pref(
  "privacy.fingerprintingProtection.overrides",
  "+AllTargets,-CSSPrefersColorScheme"
);

// Prevent Firefox from adding back search engines after you removed them.
// [NOTE] This does not affect Mozilla's built-in or Web Extension search engines.
user_pref("browser.search.update", false);

// PREF: purge session icon in Private Browsing windows
user_pref("browser.privatebrowsing.resetPBM.enabled", true);

// PREF: prevent title bar hiding on fullscreen
user_pref("browser.fullscreen.autohide", false);

// PREF: enable local network access permission management
user_pref("network.lna.enabled", true);
user_pref("network.lna.blocking", true);
user_pref("network.lna.block_trackers", true);

// PREF: Webrender layer compositor (from FastFox)
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1945683
// [2] https://www.reddit.com/r/firefox/comments/1p58qre/firefox_is_getting_ready_to_make_youtube_fast/
// [3] https://www.ghacks.net/2025/11/24/these-two-tweaks-should-improve-firefoxs-performance-on-youtube-significantly/
user_pref("gfx.webrender.layer-compositor", true);

// PREF: styling
// - legacy stylesheet support
// - custom stylings
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("widget.gtk.rounded-bottom-corners.enabled", true);
user_pref("browser.toolbars.bookmarks.showOtherBookmarks", false);
user_pref("browser.toolbars.bookmarks.visibility", "never");

// PREF: vertical bar by default
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);

// PREF: rounded content area
user_pref("sidebar.revamp.round-content-area", true);

// PREF: AI
user_pref("browser.ai.control.default", "blocked");
user_pref("browser.ai.control.linkPreviewKeyPoints", "blocked");
user_pref("browser.ai.control.pdfjsAltText", "blocked");
user_pref("browser.ai.control.sidebarChatbot", "blocked");
user_pref("browser.ai.control.smartTabGroups", "blocked");
user_pref("browser.ai.control.translations", "available");
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.linkPreview.collapsed", true);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.ml.linkPreview.onboardingTimes", "");

// PREF: disable about:config warning
user_pref("browser.aboutConfig.showWarning", false);

// PREF: open new tab next to the current one
user_pref("browser.tabs.insertAfterCurrent", true);

// PREF: ip protection
user_pref("browser.ipProtection.enabled", true);
