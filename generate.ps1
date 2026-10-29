[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

$workspaceRoot = "c:\Users\Admin\Documents\AntiGravity\Faatima 2"
Set-Location $workspaceRoot

# Ensure ta directory exists
New-Item -ItemType Directory -Force -Path "ta" | Out-Null

# Load metadata
$jsonContent = [System.IO.File]::ReadAllText((Join-Path $workspaceRoot "metadata.json"), [System.Text.Encoding]::UTF8)
$meta = $jsonContent | ConvertFrom-Json

function Get-HeaderHtml($lang, $currentSlug, $pageTitle, $isHome = $false) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $langAttr = if ($lang -eq "ta") { "ta-IN" } else { "en-US" }
    
    # Toggle target
    $toggleHref = ""
    $toggleText = ""
    if ($lang -eq "en") {
        $toggleText = "தமிழ்"
        if ($isHome) {
            $toggleHref = "ta/index-ta.html"
        } else {
            $toggleHref = "ta/$currentSlug.html"
        }
    } else {
        $toggleText = "English"
        if ($isHome) {
            $toggleHref = "../index.html"
        } else {
            $toggleHref = "../$currentSlug.html"
        }
    }

    $navHtml = ""
    $mobileNavHtml = ""

    foreach ($menu in $meta.navStructure) {
        # In Tamil, skip gallery and contact from the main bar so they are placed in "More" (கூடுதல்)
        if ($lang -eq "ta" -and ($menu.id -eq "gallery" -or $menu.id -eq "contact")) {
            continue
        }
        $menuTitle = if ($lang -eq "ta") { $menu.ta } else { $menu.en }
        
        if ($menu.id -eq "home") {
            $homeUrl = if ($lang -eq "ta") { "index-ta.html" } else { "index.html" }
            $isActive = if ($isHome) { "active" } else { "" }
            $navHtml += "<li class='nav-item-shrine $isActive'><a href='$homeUrl' class='nav-link-shrine'><i class='fa $($menu.icon)'></i> $menuTitle</a></li>`n"
            $mobileNavHtml += "<li><a href='$homeUrl' style='font-weight: 700; color: var(--primary); display: block; padding: 6px 0;'><i class='fa $($menu.icon)'></i> $menuTitle</a></li>`n"
        }
        elseif (-not $menu.items -or $menu.items.Count -eq 0) {
            $itemUrl = "$($menu.slug).html"
            $isActive = if ($currentSlug -eq $menu.slug) { "active" } else { "" }
            $navHtml += "<li class='nav-item-shrine $isActive'><a href='$itemUrl' class='nav-link-shrine'><i class='fa $($menu.icon)'></i> $menuTitle</a></li>`n"
            $mobileNavHtml += "<li><a href='$itemUrl' style='font-weight: 700; color: var(--primary); display: block; padding: 6px 0;'><i class='fa $($menu.icon)'></i> $menuTitle</a></li>`n"
        }
        else {
            $isParentActive = $false
            foreach ($sub in $menu.items) {
                if ($sub.slug -eq $currentSlug) { $isParentActive = $true }
                if ($sub.isSubmenu) {
                    foreach ($ssub in $sub.subitems) {
                        if ($ssub.slug -eq $currentSlug) { $isParentActive = $true }
                    }
                }
            }
            $parentActiveCls = if ($isParentActive) { "active" } else { "" }

            $dropdownHtml = ""
            $mobileSubHtml = ""

            foreach ($sub in $menu.items) {
                if ($sub.isSubmenu) {
                    $subTitle = if ($lang -eq "ta") { $sub.ta } else { $sub.en }
                    $dropdownHtml += "<li class='dropdown-submenu-shrine'><a href='#' class='dropdown-item-shrine'>$subTitle <i class='fa fa-angle-right'></i></a><ul class='dropdown-menu-sub'>`n"
                    $mobileSubHtml += "<li style='font-weight: 700; color: var(--secondary); padding: 4px 0 2px 0;'>${subTitle}:</li>`n"

                    foreach ($ssub in $sub.subitems) {
                        $ssubTitle = if ($lang -eq "ta") { $ssub.ta } else { $ssub.en }
                        $ssubUrl = "$($ssub.slug).html"
                        $isSubActive = if ($currentSlug -eq $ssub.slug) { "active" } else { "" }
                        $dropdownHtml += "<li><a href='$ssubUrl' class='dropdown-item-shrine $isSubActive'>$ssubTitle</a></li>`n"
                        $mobileSubHtml += "<li style='padding-left: 10px;'><a href='$ssubUrl' style='color: #475569; display: block; padding: 3px 0;'>$ssubTitle</a></li>`n"
                    }
                    $dropdownHtml += "</ul></li>`n"
                }
                else {
                    $subTitle = if ($lang -eq "ta") { $sub.ta } else { $sub.en }
                    $subUrl = "$($sub.slug).html"
                    $isSubActive = if ($currentSlug -eq $sub.slug) { "active" } else { "" }
                    $dropdownHtml += "<li><a href='$subUrl' class='dropdown-item-shrine $isSubActive'>$subTitle</a></li>`n"
                    $mobileSubHtml += "<li><a href='$subUrl' style='color: #475569; display: block; padding: 4px 0;'>$subTitle</a></li>`n"
                }
            }

            $navHtml += "<li class='nav-item-shrine $parentActiveCls'><a href='#' class='nav-link-shrine'>$menuTitle <i class='fa fa-angle-down'></i></a><ul class='dropdown-menu-shrine'>$dropdownHtml</ul></li>`n"
            $mobileNavHtml += "<li class='mobile-nav-item'><a href='#' class='mobile-dropdown-toggle' style='font-weight: 700; color: var(--primary); display: flex; justify-content: space-between; padding: 6px 0;'>$menuTitle <i class='fa fa-angle-down'></i></a><ul class='mobile-submenu' style='display: none; list-style: none; padding-left: 15px; margin: 5px 0;'>$mobileSubHtml</ul></li>`n"
        }
    }

    # In Tamil, add "More" (கூடுதல்) dropdown for Gallery and Contact to keep single row
    if ($lang -eq "ta") {
        $isMoreActive = if ($currentSlug -eq "gallery" -or $currentSlug -eq "contact") { "active" } else { "" }
        $galleryActive = if ($currentSlug -eq "gallery") { "active" } else { "" }
        $contactActive = if ($currentSlug -eq "contact") { "active" } else { "" }

        $moreDropdownHtml = "<li><a href='gallery.html' class='dropdown-item-shrine $galleryActive'><i class='fa fa-camera'></i> புகைப்படங்கள்</a></li>`n" +
                            "<li><a href='contact.html' class='dropdown-item-shrine $contactActive'><i class='fa fa-envelope-o'></i> தொடர்புக்கு</a></li>`n"

        $moreMobileHtml = "<li><a href='gallery.html' style='color: #475569; display: block; padding: 4px 0;'><i class='fa fa-camera'></i> புகைப்படங்கள்</a></li>`n" +
                          "<li><a href='contact.html' style='color: #475569; display: block; padding: 4px 0;'><i class='fa fa-envelope-o'></i> தொடர்புக்கு</a></li>`n"

        $navHtml += "<li class='nav-item-shrine $isMoreActive'><a href='#' class='nav-link-shrine'>கூடுதல் <i class='fa fa-angle-down'></i></a><ul class='dropdown-menu-shrine'>$moreDropdownHtml</ul></li>`n"
        $mobileNavHtml += "<li class='mobile-nav-item'><a href='#' class='mobile-dropdown-toggle' style='font-weight: 700; color: var(--primary); display: flex; justify-content: space-between; padding: 6px 0;'>கூடுதல் <i class='fa fa-angle-down'></i></a><ul class='mobile-submenu' style='display: none; list-style: none; padding-left: 15px; margin: 5px 0;'>$moreMobileHtml</ul></li>`n"
    }

    $topMassText = if ($lang -eq "ta") { "அடுத்த திருப்பலி: காலை 6:00 AM" } else { "Upcoming Mass: 6:00 AM" }
    $massBookingText = if ($lang -eq "ta") { "திருப்பலி கருத்து" } else { "Mass Booking" }
    $donationText = if ($lang -eq "ta") { "நன்கொடை" } else { "Donation" }
    $popeRole = if ($lang -eq "ta") { "திருத்தந்தை" } else { "Holy Father" }
    $popeName = if ($lang -eq "ta") { "பிரான்சிஸ்" } else { "Pope Francis" }
    $bishopRole = if ($lang -eq "ta") { "மறைமாவட்ட ஆயர்" } else { "Bishop" }
    $bishopName = if ($lang -eq "ta") { "மேதகு லாரன்ஸ் பியூஸ்" } else { "Most Rev. Lawrence Pius" }
    $priestRole = if ($lang -eq "ta") { "பங்குத்தந்தை" } else { "Parish Priest" }
    $priestName = if ($lang -eq "ta") { "அருட்பணி. இசையாஸ்" } else { "Rev. Fr. Isaias" }
    $shrineTamilTitle = "பாத்திமா அன்னை திருத்தலம்"
    $shrineEnglishTitle = "Our Lady of Fatima Shrine"
    $shrineLocation = if ($lang -eq "ta") { "கிருஷ்ணகிரி - 635001, தமிழ்நாடு" } else { "Krishnagiri - 635001, Tamil Nadu, India" }
    $shrineAffiliation = if ($lang -eq "ta") { "தருமபுரி மறைமாவட்டம் | பொன்விழா திருத்தலம் (1972)" } else { "Diocese of Dharmapuri | Affiliated 1997" }

    return @"
<!DOCTYPE html>
<html lang="$langAttr">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$pageTitle - $shrineTamilTitle | $shrineEnglishTitle</title>
  <meta name="description" content="Our Lady of Fatima Shrine, Krishnagiri (Diocese of Dharmapuri), Tamil Nadu. Mass timings, history, sacraments, and parish ministries.">
  <link rel="icon" type="image/png" href="${prefix}images/favicon.png">
  <link rel="apple-touch-icon" href="${prefix}images/favicon.png">
  
  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Tamil:wght@400;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  
  <!-- FontAwesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  
  <!-- Custom Stylesheet -->
  <link rel="stylesheet" href="${prefix}style.css">
</head>
<body>

  <!-- Top Header Area -->
  <header class="top-header-area">
    <div class="container">
      <div class="top-header-content">
        <div class="top-header-left">
          <button type="button" class="btn-top-mass" data-open-modal="massTimingsModal" title="Click to view all mass timings">
            <i class="fa fa-clock-o"></i> <strong id="nextMassDisplay">$topMassText</strong>
          </button>
        </div>
        <div class="top-header-right">
          <button type="button" class="btn-mass-booking" data-open-modal="massBookingModal">
            <i class="fa fa-calendar-check-o"></i> $massBookingText
          </button>
          <button type="button" class="btn-donation" data-open-modal="donationModal">
            <i class="fa fa-heart"></i> $donationText
          </button>
          <!-- Dual Language Switcher Toggle -->
          <a class="lang-toggle" href="$toggleHref" title="Switch Language">
            <i class="fa fa-language"></i> $toggleText
          </a>
          <div class="social-links-top">
            <a href="https://www.youtube.com/c/OurLadyOfFatimaShrine" target="_blank" rel="noopener" title="YouTube"><i class="fa fa-youtube-play"></i></a>
            <a href="https://www.facebook.com/OurLadyOfFatimaShrineKrishnagiri/" target="_blank" rel="noopener" title="Facebook"><i class="fa fa-facebook"></i></a>
            <a href="https://www.instagram.com/our_lady_of_fatima_shrine/" target="_blank" rel="noopener" title="Instagram"><i class="fa fa-instagram"></i></a>
            <a href="https://x.com/OurLadyFatima13" target="_blank" rel="noopener" title="X (Twitter)"><svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor" style="vertical-align: middle;"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg></a>
            <a href="https://whatsapp.com/channel/0029VbBoNHZI7BeA5acx7V2R" target="_blank" rel="noopener" title="WhatsApp"><i class="fa fa-whatsapp"></i></a>
          </div>
        </div>
      </div>
    </div>
  </header>

  <!-- Brand Header Area -->
  <section class="brand-header-area">
    <div class="container">
      <div class="brand-header-grid">
        <!-- 1. Left Corner: Pope Image & Church Logo -->
        <div class="header-left-brand">
          <div class="dignitary-photo-wrap" title="Pope Francis">
            <img src="${prefix}images/pope-photo.png" alt="Pope Francis">
          </div>
          <a href="$(if ($lang -eq 'ta') { 'index-ta.html' } else { 'index.html' })" title="$shrineEnglishTitle">
            <img src="${prefix}images/Church-logo.png" alt="Fatima Shrine Logo" class="shrine-main-logo">
          </a>
        </div>

        <!-- 2. Center: Shrine Title & Location (Always Centered) -->
        <div class="brand-center-title">
          <div class="brand-text-block">
            <span class="shrine-tamil-title">பாத்திமா அன்னை திருத்தலம்</span>
            <h1 class="shrine-english-title">Our Lady of Fatima Shrine</h1>
            <span class="shrine-location-subtitle">$shrineLocation</span>
          </div>
        </div>

        <!-- 3. Right Corner: Bishop & Parish Priest Images -->
        <div class="header-right-brand">
          <div class="dignitary-photo-wrap" title="Bishop">
            <img src="${prefix}images/Bishop-Photo.png" alt="Bishop">
          </div>
          <div class="dignitary-photo-wrap" title="Parish Priest">
            <img src="${prefix}images/Parish-Priest-Photo.png" alt="Parish Priest">
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Mobile Bar -->
  <div class="mobile-navbar-bar">
    <div style="display: flex; align-items: center; gap: 8px;">
      <img src="${prefix}images/Church-logo.png" alt="Logo" style="height: 32px;">
      <span style="font-weight: 700; font-size: 0.95rem;">$shrineEnglishTitle</span>
    </div>
    <div style="display: flex; align-items: center; gap: 10px;">
      <a class="lang-toggle" href="$toggleHref" style="padding: 3px 10px; font-size: 0.75rem;">$toggleText</a>
      <button type="button" class="btn-mobile-toggle" id="mobileNavToggle" aria-label="Open Navigation">
        <i class="fa fa-bars"></i>
      </button>
    </div>
  </div>

  <!-- Desktop Navigation -->
  <nav class="main-navbar-area">
    <div class="container">
      <div class="navbar-shrine">
        <ul class="navbar-nav-shrine">
          $navHtml
        </ul>
      </div>
    </div>
  </nav>

  <!-- Mobile Drawer -->
  <div id="mobileNavDrawer" class="modal-shrine-backdrop" style="justify-content: flex-start;">
    <div style="background: #ffffff; width: 85%; max-width: 320px; height: 100%; overflow-y: auto; padding: 20px; box-shadow: 2px 0 15px rgba(0,0,0,0.3);">
      <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--gold); padding-bottom: 12px; margin-bottom: 15px;">
        <div style="display: flex; align-items: center; gap: 8px;">
          <img src="${prefix}images/Church-logo.png" alt="Logo" style="height: 36px;">
          <strong style="color: var(--primary); font-size: 0.95rem;">$shrineEnglishTitle</strong>
        </div>
        <button type="button" id="mobileNavClose" style="background: none; border: none; font-size: 1.4rem; color: #64748b; cursor: pointer;">&times;</button>
      </div>
      <ul style="list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 8px;">
        $mobileNavHtml
      </ul>
    </div>
  </div>
"@
}

function Get-FooterHtml($lang, $isHome = $false) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $homeUrl = if ($lang -eq "ta") { "index-ta.html" } else { "index.html" }
    
    $usefulLinksTitle = if ($lang -eq "ta") { "பயனுள்ள இணைப்புகள்" } else { "Useful Links" }
    $massTimingsTitle = if ($lang -eq "ta") { "திருப்பலி நேரங்கள்" } else { "Mass Timings" }
    $visitorsTitle = if ($lang -eq "ta") { "பார்வையாளர்கள் எண்ணிக்கை" } else { "Website Visitors" }
    $officeTitle = if ($lang -eq "ta") { "திருத்தல முகவரி" } else { "Shrine Location" }

    return @"
  <!-- Footer Main Area -->
  <footer class="footer-main-area">
    <div class="container">
      <div class="footer-realigned-grid">
        <!-- Col 1: Wired Useful Links -->
        <div>
          <h4 class="footer-widget-title">$usefulLinksTitle</h4>
          <ul class="footer-links-list">
            <li><a href="history.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'வரலாறு' } else { 'History' })</a></li>
            <li><a href="rosary.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'ஜெபமாலை (Rosary in Tamil)' } else { 'Rosary in Tamil' })</a></li>
            <li><a href="org-vdp.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'வின்சென்ட் டி பவுல்' } else { 'Vincent De Paul' })</a></li>
            <li><a href="service-hall.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'சமுதாய கூடம்' } else { 'Community Hall' })</a></li>
            <li><a href="service-cemetery.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'கல்லறை தோட்டம்' } else { 'Cemetery' })</a></li>
            <li><a href="assoc-altar.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'பலிபீட சிறுவர் / சிறுமியர்' } else { 'Altar Boys/Girls' })</a></li>
            <li><a href="anbiyam.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'அன்பியம் (BCC)' } else { 'Anbiyam (BCC)' })</a></li>
            <li><a href="catechism.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'ஞாயிறு மறைக்கல்வி' } else { 'Sunday Catechism' })</a></li>
          </ul>
        </div>

        <!-- Col 2: Mass Timings -->
        <div>
          <h4 class="footer-widget-title">$massTimingsTitle</h4>
          <div style="font-size: 0.85rem; color: #94a3b8; line-height: 1.75;">
            <div style="border-bottom: 1px dashed rgba(255,255,255,0.15); padding-bottom: 5px; margin-bottom: 5px;">
              <strong style="color: #ffffff;">$(if ($lang -eq 'ta') { 'ஞாயிறு திருப்பலிகள்:' } else { 'Sunday Masses:' })</strong><br>
              <span style="color: #e2e8f0;">06:00 AM, 08:00 AM, 06:30 PM</span>
            </div>
            <div style="border-bottom: 1px dashed rgba(255,255,255,0.15); padding-bottom: 5px; margin-bottom: 5px;">
              <strong style="color: #ffffff;">$(if ($lang -eq 'ta') { 'வாரநாட்கள் திருப்பலி:' } else { 'Weekday Masses:' })</strong><br>
              <span style="color: #cbd5e1;">
              $(if ($lang -eq 'ta') {
                'திங்கள்: 06:00 AM & 06:00 PM (பழையபேட்டை)<br>செவ்வாய் & புதன்: 06:00 AM<br>வியாழன் & சனி: 06:00 AM & 06:30 PM'
              } else {
                'Mon: 06:00 AM & 06:00 PM (Oldpet)<br>Tue & Wed: 06:00 AM<br>Thu & Sat: 06:00 AM & 06:30 PM'
              })
              </span>
            </div>
            <div style="border-bottom: 1px dashed rgba(255,255,255,0.15); padding-bottom: 5px; margin-bottom: 5px;">
              <strong style="color: var(--gold);">$(if ($lang -eq 'ta') { 'மாதாந்திர திருப்பலி & தேர்பவனி:' } else { 'Monthly Mass & Car Procession:' })</strong><br>
              <span style="color: #cbd5e1;">$(if ($lang -eq 'ta') { 'முதல் வெள்ளி: 06:30 PM' } else { 'First Fri: 06:30 PM' })</span>
            </div>
            <div>
              <strong style="color: #ffffff;">$(if ($lang -eq 'ta') { 'ஜெபமாலை:' } else { 'Rosary:' })</strong><br>
              <span style="color: #cbd5e1;">$(if ($lang -eq 'ta') { 'தினமும் : மாலை 6:00 PM' } else { 'Every day : 6 PM' })</span>
            </div>
          </div>
        </div>

        <!-- Col 3: Flag Counter (Shrine Visitors) -->
        <div>
          <h4 class="footer-widget-title">$visitorsTitle</h4>
          <div class="flag-counter-box" style="margin-top: 0; background: transparent; border: none; padding: 0;">
            <a href="https://info.flagcounter.com/4jL0" target="_blank" rel="noopener">
              <img src="https://s11.flagcounter.com/count2/4jL0/bg_07253D/txt_FFFFFF/border_1E3A5F/columns_3/maxflags_15/viewers_Visitors+from+1+Jan+2020/labels_1/pageviews_1/flags_0/percent_0/" alt="Flag Counter" border="0" style="max-width: 100%; height: auto; border-radius: 4px; display: block;">
            </a>
          </div>
          <div style="margin-top: 25px; padding-top: 15px; border-top: 1px dashed rgba(255,255,255,0.15);">
            <div style="margin-bottom: 10px;"><strong style="color: #ffffff; font-size: 1.02rem; letter-spacing: 0.3px;">$(if ($lang -eq 'ta') { 'சமூக ஊடகங்கள்:' } else { 'Follow Us:' })</strong></div>
            <div class="footer-social-icons">
              <a href="https://www.youtube.com/c/OurLadyOfFatimaShrine" target="_blank" rel="noopener" class="footer-social-btn footer-yt" title="YouTube"><i class="fa fa-youtube-play"></i></a>
              <a href="https://www.facebook.com/OurLadyOfFatimaShrineKrishnagiri/" target="_blank" rel="noopener" class="footer-social-btn footer-fb" title="Facebook"><i class="fa fa-facebook"></i></a>
              <a href="https://www.instagram.com/our_lady_of_fatima_shrine/" target="_blank" rel="noopener" class="footer-social-btn footer-ig" title="Instagram"><i class="fa fa-instagram"></i></a>
              <a href="https://x.com/OurLadyFatima13" target="_blank" rel="noopener" class="footer-social-btn footer-x" title="X (Twitter)"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="vertical-align: middle;"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg></a>
              <a href="https://whatsapp.com/channel/0029VbBoNHZI7BeA5acx7V2R" target="_blank" rel="noopener" class="footer-social-btn footer-wa" title="WhatsApp"><i class="fa fa-whatsapp"></i></a>
            </div>
          </div>
        </div>

        <!-- Col 4: Contact & Google Map -->
        <div>
          <h4 class="footer-widget-title">$officeTitle</h4>
          <div class="footer-contact-item">
            <i class="fa fa-map-marker"></i>
            <span>Our Lady of Fatima Shrine, Bangalore Road, Krishnagiri - 635001</span>
          </div>
          <div class="footer-contact-item">
            <i class="fa fa-phone"></i>
            <span>Office: 04343 - 236836</span>
          </div>
          <div class="footer-contact-item">
            <i class="fa fa-envelope"></i>
            <span>fathimashrine.kgri@gmail.com</span>
          </div>

          <!-- Google Map Embed -->
          <div class="map-frame-box" style="margin-top: 10px; height: 110px;">
            <iframe src="https://maps.google.com/maps?q=Our%20Lady%20of%20Fatima%20Shrine,%20Bangalore%20Road,%20Krishnagiri&t=&z=14&ie=UTF8&iwloc=&output=embed" loading="lazy" title="Fatima Shrine Krishnagiri Location"></iframe>
          </div>
        </div>
      </div>

      <!-- Footer Bottom Bar -->
      <div class="footer-bottom-bar">
        <div>
          &copy; 2026 <strong>Our Lady of Fatima Shrine, Krishnagiri</strong>. All Rights Reserved.
        </div>
        <div>
          $(if ($lang -eq 'ta') { 'உருவாக்கம் & பராமரிப்பு: <strong>புனித பவுல் இளைஞர் இயக்கம்</strong>, பாத்திமா அன்னை திருத்தலம்.' } else { 'Created & Maintained by <strong>St. Paul''s Youth</strong>, Our Lady of Fatima Shrine.' })
        </div>
      </div>
    </div>
  </footer>

  <!-- Modals -->
  <!-- 1. Mass Booking Modal -->
  <div id="massBookingModal" class="modal-shrine-backdrop">
    <div class="card" style="max-width: 500px; width: 90%; margin: 20px;">
      <div class="card-header-shrine">
        <h3 class="card-header-title"><i class="fa fa-calendar-check-o"></i> $(if ($lang -eq 'ta') { 'திருப்பலி கருத்து பதிவு' } else { 'Mass Intention Booking' })</h3>
        <button type="button" data-close-modal style="background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
      </div>
      <p>$(if ($lang -eq 'ta') { 'திருப்பலி கருத்துக்களை பதிவு செய்ய பங்கு அலுவலகத்தை நேரில் தொடர்பு கொள்ளவும்:' } else { 'To book Holy Mass intentions for thanksgiving, birthdays, or departed souls, please contact the shrine office directly:' })</p>
      <div style="background: #f8fafc; padding: 15px; border-radius: 8px; border-left: 3px solid var(--gold); margin-bottom: 15px;">
        <strong>Shrine Office:</strong> 04343 - 236836<br>
        <strong>Email:</strong> fathimashrine.kgri@gmail.com<br>
        <span style="color: var(--primary); font-weight: 600; display: block; margin-top: 6px;">$(if ($lang -eq 'ta') { 'பங்குப் பொறுப்பாளரை பங்கு அலுவலகத்தில் நேரில் தொடர்பு கொள்ளவும்.' } else { 'Contact parish in-charge directly in parish office.' })</span>
      </div>
      <button type="button" class="btn-read-more" data-close-modal style="margin-top: 0; width: 100%; justify-content: center;">Close</button>
    </div>
  </div>

  <!-- 2. Donation Modal -->
  <div id="donationModal" class="modal-shrine-backdrop">
    <div class="card" style="max-width: 520px; width: 90%; margin: 20px;">
      <div class="card-header-shrine">
        <h3 class="card-header-title"><i class="fa fa-heart" style="color: #ef4444;"></i> $(if ($lang -eq 'ta') { 'திருத்தல நன்கொடை' } else { 'Shrine Offerings & Donations' })</h3>
        <button type="button" data-close-modal style="background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
      </div>
      <p style="font-size: 0.9rem;">Devotees wishing to contribute to the Shrine Renovation Fund and church maintenance may transfer directly to the official bank account:</p>
      <div style="background: #f8fafc; padding: 12px; border-radius: 8px; font-size: 0.88rem; line-height: 1.8;">
        <strong>Bank:</strong> Federal Bank<br>
        <strong>A/C Name:</strong> OUR LADY OF FATIMA RENOVATION FUND<br>
        <strong>A/C No:</strong> <code>19930100068839</code> <button type="button" class="btn-copy" data-copy="19930100068839" data-label="Account"><i class="fa fa-clone"></i></button><br>
        <strong>IFSC:</strong> <code>FDRL0001993</code> <button type="button" class="btn-copy" data-copy="FDRL0001993" data-label="IFSC"><i class="fa fa-clone"></i></button><br>
        <strong>UPI ID:</strong> <code>fatimachurch@fbl</code> <button type="button" class="btn-copy" data-copy="fatimachurch@fbl" data-label="UPI"><i class="fa fa-clone"></i></button>
      </div>
      <button type="button" class="btn-read-more" data-close-modal style="margin-top: 15px; width: 100%; justify-content: center;">Close</button>
    </div>
  </div>

  <!-- 3. Mass Timings Modal -->
  <div id="massTimingsModal" class="modal-shrine-backdrop">
    <div class="card" style="max-width: 550px; width: 90%; margin: 20px;">
      <div class="card-header-shrine">
        <h3 class="card-header-title"><i class="fa fa-clock-o"></i> $(if ($lang -eq 'ta') { 'முழு திருப்பலி அட்டவணை' } else { 'Complete Mass Schedule' })</h3>
        <button type="button" data-close-modal style="background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
      </div>
      <div style="font-size: 0.9rem; line-height: 1.8;">
        <h4 style="color: var(--primary); margin: 8px 0 4px 0;">$(if ($lang -eq 'ta') { 'ஞாயிறு திருப்பலிகள்:' } else { 'Sunday Masses:' })</h4>
        <p style="margin-bottom: 10px;">$(if ($lang -eq 'ta') { 'காலை 06:00 AM, காலை 08:00 AM மற்றும் மாலை 06:30 PM' } else { '06:00 AM, 08:00 AM, and 06:30 PM' })</p>
        <h4 style="color: var(--primary); margin: 8px 0 4px 0;">$(if ($lang -eq 'ta') { 'வாரநாட்கள் திருப்பலிகள்:' } else { 'Weekday Masses:' })</h4>
        <p style="margin-bottom: 10px;">$(if ($lang -eq 'ta') { '<strong>திங்கள்:</strong> காலை 06:00 AM & மாலை 06:00 PM (பழையபேட்டை)<br><strong>செவ்வாய் & புதன்:</strong> காலை 06:00 AM<br><strong>வியாழன்:</strong> காலை 06:00 AM & மாலை 06:30 PM<br><strong>வெள்ளி:</strong> காலை 06:00 AM (மாதத்தின் முதல் வெள்ளி மட்டும் மாலை 06:30 PM)<br><strong>சனி:</strong> காலை 06:00 AM & மாலை 06:30 PM' } else { '<strong>Monday:</strong> 06:00 AM & 06:00 PM (Oldpet church)<br><strong>Tuesday & Wednesday:</strong> 06:00 AM<br><strong>Thursday:</strong> 06:00 AM & 06:30 PM<br><strong>Friday:</strong> 06:00 AM (First Friday: 06:30 PM)<br><strong>Saturday:</strong> 06:00 AM & 06:30 PM' })</p>


      </div>
      <button type="button" class="btn-read-more" data-close-modal style="margin-top: 15px; width: 100%; justify-content: center;">$(if ($lang -eq 'ta') { 'மூடுக' } else { 'Close' })</button>
    </div>
  </div>

  <!-- Toast Container -->
  <div id="toast"></div>

  <!-- Script -->
  <script src="${prefix}main.js"></script>
</body>
</html>
"@
}

function Convert-ContentToHtml($txtContent, $slug, $lang, $prefix, $pageTitle) {
    $lines = $txtContent -split "`r?`n"
    $html = ""
    $h1Found = $false
    $inTable = $false
    $tableContent = ""
    $inList = $false

    foreach ($rawLine in $lines) {
        $line = $rawLine.Trim()
        
        if ($line -match "<table") {
            $inTable = $true
            $tableContent = $line + "`n"
            continue
        }
        if ($inTable) {
            $tableContent += $line + "`n"
            if ($line -match "</table>") {
                $inTable = $false
                $tableStyled = $tableContent -replace "<table\s*>", "<div class='table-responsive'><table class='table-shrine'>"
                $tableStyled = $tableStyled -replace "</table>", "</table></div>"
                $html += $tableStyled + "`n"
                $tableContent = ""
            }
            continue
        }

        if ($line.Trim().StartsWith("<div") -or $line.Trim().StartsWith("</div") -or $line.Trim().StartsWith("<section") -or $line.Trim().StartsWith("</section") -or $line.Trim().StartsWith("<iframe") -or $line.Trim().StartsWith("<a ") -or $line.Trim().StartsWith("<style") -or $line.Trim().StartsWith("</style")) {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $html += $line + "`n"
            continue
        }

        if ($line -eq "") {
            if ($inList) {
                $html += "</ul>`n"
                $inList = $false
            }
            continue
        }

        if ($line -match "^#\s*(.*)$") {
            $title = $Matches[1].Trim()
            if (-not $h1Found) {
                $html += "  <h1 style='color: var(--warm-brown);'>$title</h1>`n"
                $h1Found = $true
            } else {
                $html += "  <h2>$title</h2>`n"
            }
            continue
        }

        if ($line -match "^##\s*(.*)$") {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $h2 = $Matches[1].Trim()
            $html += "  <h2>$h2</h2>`n"
            continue
        }

        if ($line -match "^###\s*(.*)$") {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $h3 = $Matches[1].Trim()
            $html += "  <h3>$h3</h3>`n"
            continue
        }

        if ($line.StartsWith(">") -or ($line.StartsWith('"') -and $line.EndsWith('"')) -or ($line.StartsWith('“') -and $line.EndsWith('”'))) {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $cleanQuote = $line.TrimStart('>').Trim('"', '“', '”').Trim()
            if ($cleanQuote.Length -gt 0) {
                $cleanQuote = $cleanQuote -replace "\*\*(.*?)\*\*", "<strong>`$1</strong>"
                $html += "  <blockquote><p>$cleanQuote</p></blockquote>`n"
            }
            continue
        }

        if ($line -match "^[-*•]\s+(.*)$") {
            if (-not $inList) {
                $html += "  <ul>`n"
                $inList = $true
            }
            $itemText = $Matches[1].Trim()
            $itemText = $itemText -replace "\*\*(.*?)\*\*", "<strong>`$1</strong>"
            $html += "    <li>$itemText</li>`n"
            continue
        }

        if ($line -match "\[image\s*:\s*([^\]]+)\]" -or $line -match "<(contact-image-[^>]+)>") {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $imgName = $Matches[1].Trim()
            if (-not ($imgName -match "\.(png|jpg|jpeg|gif)$")) {
                if (Test-Path "images\$imgName.png") { $imgName = "$imgName.png" }
                elseif (Test-Path "images\$imgName.jpg") { $imgName = "$imgName.jpg" }
                elseif (Test-Path "images\$imgName.jpeg") { $imgName = "$imgName.jpeg" }
            }
            if ($imgName -eq "contact-image-4.png" -and -not (Test-Path "images\contact-image-4.png")) {
                $imgName = "contact-image-4.jpg"
            }
            $html += "  <div style='text-align: center; margin: 20px 0;'><img src='${prefix}images/$imgName' alt='$imgName' class='content-img'></div>`n"
            continue
        }

        if ($inList) {
            $html += "</ul>`n"
            $inList = $false
        }

        $pText = $line -replace "\*\*(.*?)\*\*", "<strong>`$1</strong>"
        $html += "  <p>$pText</p>`n"
    }

    if ($inList) { $html += "</ul>`n" }

    # If no h1 was present in raw lines, prepend it
    if (-not $h1Found) {
        $html = "  <h1 style='color: var(--warm-brown);'>$pageTitle</h1>`n" + $html
    }

    return $html
}

function Generate-RosaryPage($lang) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $title = if ($lang -eq "ta") { "ஜெபமாலை" } else { "The Holy Rosary" }
    $pageSlug = "rosary"
    $header = Get-HeaderHtml $lang $pageSlug $title $false
    $footer = Get-FooterHtml $lang $false

    $joyfulTitle = if ($lang -eq "ta") { "மகிழ்ச்சி நிறை மறையுண்மைகள் (திங்கள், சனி)" } else { "The Joyful Mysteries (Monday & Saturday)" }
    $sorrowfulTitle = if ($lang -eq "ta") { "துயரம் நிறை மறையுண்மைகள் (செவ்வாய், வெள்ளி)" } else { "The Sorrowful Mysteries (Tuesday & Friday)" }
    $gloriousTitle = if ($lang -eq "ta") { "மகிமை நிறை மறையுண்மைகள் (புதன், ஞாயிறு)" } else { "The Glorious Mysteries (Wednesday & Sunday)" }
    $luminousTitle = if ($lang -eq "ta") { "ஒளியின் மறையுண்மைகள் (வியாழன்)" } else { "The Luminous Mysteries (Thursday)" }

    $joyfulDecades = if ($lang -eq "ta") {
        @(
            "1. கபிரியேல் தூதர் கன்னிமரியாவுக்கு மங்கள வார்த்தை சொன்னது குறித்து தியானிப்போமாக. மற்றும் தாழ்ச்சி என்னும் வரம் கேட்போமாக.",
            "2. அன்னை மரியாள் எலிசபெத் அம்மாளை சந்தித்தது குறித்து தியானிப்போமாக. மற்றும் பிறர் அன்பில் வளர வரம் கேட்போமாக.",
            "3. இயேசு பிறந்தது குறித்து தியானிப்போமாக. மற்றும் எளிமையை விரும்பி ஏழைகளுக்கு உதவி செய்ய வரம் கேட்போமாக.",
            "4. இயேசு பாலனை ஆலயத்தில் காணிக்கையாக ஒப்புக்கொடுத்தது குறித்து தியானிப்போமாக. மற்றும் இறை திருவுளத்திற்குப் பணிந்து வாழும் வரம் கேட்போமாக.",
            "5. காணாமற்போன இயேசுவைக் கண்டடைந்தது குறித்து தியானிப்போமாக. மற்றும் நாள்தோறும் இறைவனைச் சார்ந்து வாழ வரம் கேட்போமாக."
        )
    } else {
        @(
            "1. The Annunciation of the Angel Gabriel to Mary. Fruit of the Mystery: Humility.",
            "2. The Visitation of Mary to Saint Elizabeth. Fruit of the Mystery: Love of Neighbour.",
            "3. The Nativity of Jesus Christ in Bethlehem. Fruit of the Mystery: Poverty of Spirit.",
            "4. The Presentation of the Infant Jesus in the Temple. Fruit of the Mystery: Obedience.",
            "5. The Finding of the Child Jesus in the Temple. Fruit of the Mystery: Joy in Finding Christ."
        )
    }

    $luminousDecades = if ($lang -eq "ta") {
        @(
            "1. இயேசு யோர்தான் ஆற்றில் திருமுழுக்கு பெற்றது குறித்து தியானிப்போமாக. நாம் பாவத்திற்கு மனம் வருந்தி புது மனிதனாக வாழ வரம் வேண்டுவோமாக.",
            "2. இயேசு கானாவூர் திருமணத்தில் முதல் புதுமை செய்தது குறித்து தியானிப்போமாக. நம் மனதில் எழும் எண்ணங்களை இறைவன் ஆசீர்வதிக்க வரம் வேண்டுவோமாக.",
            "3. இயேசு விண்ணரசை அறிவித்து மனந்திரும்ப அழைத்தது குறித்து தியானிப்போமாக. நற்செய்தி அறிவிப்பவர்களை இறைவன் வழிநடத்தும்படி வேண்டுவோமாக.",
            "4. இயேசு தாபோர் மலையில் உருமாற்றம் ஆனது குறித்து தியானிப்போமாக. நாம் இறை அன்பையும் மாட்சிமையையும் வெளிப்படுத்தும் அடையாளங்களாக வாழ வரம் வேண்டுவோமாக.",
            "5. இயேசு நற்கருணையை ஏற்படுத்தியது குறித்து தியானிப்போமாக. இயேசுவைப் போல் மற்றவர்களுக்குக் கையளித்து வாழ வரம் வேண்டுவோமாக."
        )
    } else {
        @(
            "1. The Baptism of Jesus in the Jordan. Fruit of the Mystery: Openness to the Holy Spirit.",
            "2. The Wedding at Cana. Fruit of the Mystery: To Jesus through Mary.",
            "3. The Proclamation of the Kingdom. Fruit of the Mystery: Repentance and Trust in God.",
            "4. The Transfiguration. Fruit of the Mystery: Desire for Holiness.",
            "5. The Institution of the Eucharist. Fruit of the Mystery: Adoration."
        )
    }

    $sorrowfulDecades = if ($lang -eq "ta") {
        @(
            "1. இயேசு இரத்த வியர்வை வியர்த்தது குறித்து தியானிப்போமாக. நாள்தோறும் பாவங்களுக்காக மனம் வருந்தி மன்னிப்புக் கேட்போமாக.",
            "2. இயேசுவைக் கற்றூணில் கட்டியடித்தது குறித்து தியானிப்போமாக. நமது உடல் உறுப்புக்களை அடக்கி வாழும் வரம் கேட்போமாக.",
            "3. இயேசுவுக்கு முள்முடி சூட்டியது குறித்து தியானிப்போமாக. வாழ்க்கையில் வரும் இன்னல்களை ஏற்று வாழ வரம் கேட்போமாக.",
            "4. இயேசு சிலுவை சுமந்து சென்றது குறித்து தியானிப்போமாக. வாழ்க்கைச் சுமைகளைப் பொறுமையுடன் ஏற்று வாழ வரம் கேட்போமாக.",
            "5. இயேசு சிலுவையில் அறையப்பட்டு உயிர் துறந்தது குறித்து தியானிப்போமாக. நம் எதிரிகளையும் மன்னித்து வாழ வரம் கேட்போமாக."
        )
    } else {
        @(
            "1. The Agony in the Garden of Gethsemane. Fruit of the Mystery: Sorrow for Sin.",
            "2. The Scourging of Jesus at the Pillar. Fruit of the Mystery: Purity and Mortification.",
            "3. The Crowning with Thorns. Fruit of the Mystery: Courage and Humility.",
            "4. The Carrying of the Cross to Calvary. Fruit of the Mystery: Patience in Suffering.",
            "5. The Crucifixion and Death of Jesus. Fruit of the Mystery: Forgiveness and Salvation."
        )
    }

    $gloriousDecades = if ($lang -eq "ta") {
        @(
            "1. இயேசு உயிர்த்தெழுந்தது குறித்து தியானிப்போமாக. விசுவாசத்தில் நிலைத்திருக்க வரம் கேட்போமாக.",
            "2. இயேசு விண்ணகம் சென்றது குறித்து தியானிப்போமாக. விண்ணகத்தை நோக்கி வாழ வரம் கேட்போமாக.",
            "3. தூய ஆவியார் திருத்தூதர்கள் மீது இறங்கி வந்தது குறித்து தியானிப்போமாக. தூய ஆவியாரின் வழிகாட்டுதலில் வாழ வரம் கேட்போமாக.",
            "4. அன்னை மரியாள் விண்ணகத்திற்கு ஆன்மாவோடும் உடலோடும் எடுத்துக்கொள்ளப்பட்டது குறித்து தியானிப்போமாக. நற்பேறுபெற்ற மரணத்தை வரம் கேட்போமாக.",
            "5. அன்னை மரியாள் விண்ணக மண்ணக அரசியாக முடிசூட்டப்பட்டது குறித்து தியானிப்போமாக. அன்னை மரியாளின் பாதுகாவலில் நிலைத்திருக்க வரம் கேட்போமாக."
        )
    } else {
        @(
            "1. The Resurrection of Jesus from the Dead. Fruit of the Mystery: Faith.",
            "2. The Ascension of Jesus into Heaven. Fruit of the Mystery: Christian Hope.",
            "3. The Descent of the Holy Spirit upon the Apostles. Fruit of the Mystery: Love of God.",
            "4. The Assumption of the Blessed Virgin Mary into Heaven. Fruit of the Mystery: Grace of a Happy Death.",
            "5. The Coronation of Our Lady as Queen of Heaven and Earth. Fruit of the Mystery: Trust in Mary's Intercession."
        )
    }

    $joyfulDecadesHtml = "<ul class='decade-list'>`n"
    foreach ($d in $joyfulDecades) { $joyfulDecadesHtml += "  <li class='decade-item'><i class='fa fa-circle-o' style='color: var(--gold); margin-right: 6px;'></i> $d</li>`n" }
    $joyfulDecadesHtml += "</ul>`n"

    $luminousDecadesHtml = "<ul class='decade-list'>`n"
    foreach ($d in $luminousDecades) { $luminousDecadesHtml += "  <li class='decade-item'><i class='fa fa-circle-o' style='color: var(--gold); margin-right: 6px;'></i> $d</li>`n" }
    $luminousDecadesHtml += "</ul>`n"

    $sorrowfulDecadesHtml = "<ul class='decade-list'>`n"
    foreach ($d in $sorrowfulDecades) { $sorrowfulDecadesHtml += "  <li class='decade-item'><i class='fa fa-circle-o' style='color: var(--gold); margin-right: 6px;'></i> $d</li>`n" }
    $sorrowfulDecadesHtml += "</ul>`n"

    $gloriousDecadesHtml = "<ul class='decade-list'>`n"
    foreach ($d in $gloriousDecades) { $gloriousDecadesHtml += "  <li class='decade-item'><i class='fa fa-circle-o' style='color: var(--gold); margin-right: 6px;'></i> $d</li>`n" }
    $gloriousDecadesHtml += "</ul>`n"

    $content = @"
  <main class="section-padding">
    <div class="container">
      <div class="card">
        <h1 style="color: var(--warm-brown);">$title</h1>
        
        <div style="background: #fdfbf7; border: 1px solid var(--border); border-left: 4px solid var(--gold); padding: 16px; border-radius: 8px; margin-bottom: 25px;">
          <h3 style="color: var(--primary); margin-top: 0;"><i class="fa fa-cross"></i> $(if ($lang -eq 'ta') { 'சிலுவை அடையாளம் & நம்பிக்கை அறிக்கை' } else { 'Sign of the Cross & Apostles Creed' })</h3>
          <p>$(if ($lang -eq 'ta') { 'தந்தை, மகன், தூய ஆவியாரின் பெயராலே. ஆமென்.' } else { 'In the name of the Father, and of the Son, and of the Holy Spirit. Amen.' })</p>
          <p style="margin-bottom: 0;"><em>$(if ($lang -eq 'ta') { 'விண்ணகத்தையும் மண்ணகத்தையும் படைத்த எல்லாம் வல்ல தந்தையாகிய கடவுளை நம்புகிறேன்...' } else { 'I believe in God, the Father Almighty, Creator of heaven and earth...' })</em></p>
        </div>

        <!-- Mystery 1: Joyful -->
        <div id="mystery-joyful" class="mystery-block">
          <h2 class="mystery-title"><i class="fa fa-sun-o" style="color: var(--gold);"></i> $joyfulTitle</h2>
          <div class="collage-grid">
            <img src="${prefix}images/history-1.jpg" alt="Joyful Mystery Decade 1 - Annunciation">
            <img src="${prefix}images/history-2.jpg" alt="Joyful Mystery Decade 2 - Visitation">
            <img src="${prefix}images/history-3.png" alt="Joyful Mystery Decade 3 - Nativity">
            <img src="${prefix}images/history-4.png" alt="Joyful Mystery Decade 4 - Presentation">
            <img src="${prefix}images/catechism.png" alt="Joyful Mystery Decade 5 - Finding in Temple">
          </div>
          $joyfulDecadesHtml
        </div>

        <!-- Mystery 2: Luminous -->
        <div id="mystery-luminous" class="mystery-block">
          <h2 class="mystery-title"><i class="fa fa-star" style="color: var(--gold);"></i> $luminousTitle</h2>
          <div class="collage-grid">
            <img src="${prefix}images/sac-Baptism.png" alt="Luminous Mystery Decade 1 - Baptism of Jesus">
            <img src="${prefix}images/sac-Marriage.png" alt="Luminous Mystery Decade 2 - Miracle at Cana">
            <img src="${prefix}images/anbiyam.png" alt="Luminous Mystery Decade 3 - Proclamation of Kingdom">
            <img src="${prefix}images/sac-Confirmation.png" alt="Luminous Mystery Decade 4 - Transfiguration">
            <img src="${prefix}images/sac-Holy-Communion-1.png" alt="Luminous Mystery Decade 5 - Institution of Eucharist">
          </div>
          $luminousDecadesHtml
        </div>

        <!-- Mystery 3: Sorrowful -->
        <div id="mystery-sorrowful" class="mystery-block">
          <h2 class="mystery-title"><i class="fa fa-tint" style="color: #ef4444;"></i> $sorrowfulTitle</h2>
          <div class="collage-grid">
            <img src="${prefix}images/history-2.jpg" alt="Sorrowful Mystery Decade 1 - Agony in the Garden">
            <img src="${prefix}images/sac-Confession.jpeg" alt="Sorrowful Mystery Decade 2 - Scourging at Pillar">
            <img src="${prefix}images/sac-Unction.png" alt="Sorrowful Mystery Decade 3 - Crowning with Thorns">
            <img src="${prefix}images/history-1.jpg" alt="Sorrowful Mystery Decade 4 - Carrying of the Cross">
            <img src="${prefix}images/history-3.png" alt="Sorrowful Mystery Decade 5 - Crucifixion">
          </div>
          $sorrowfulDecadesHtml
        </div>

        <!-- Mystery 4: Glorious -->
        <div id="mystery-glorious" class="mystery-block">
          <h2 class="mystery-title"><i class="fa fa-diamond" style="color: var(--gold);"></i> $gloriousTitle</h2>
          <div class="collage-grid">
            <img src="${prefix}images/Banner-1.png" alt="Glorious Mystery Decade 1 - Resurrection">
            <img src="${prefix}images/Banner-2.png" alt="Glorious Mystery Decade 2 - Ascension">
            <img src="${prefix}images/assoc-media.jpg" alt="Glorious Mystery Decade 3 - Pentecost">
            <img src="${prefix}images/Shrine of Our Lady of Fatima - Copy.png" alt="Glorious Mystery Decade 4 - Assumption of Mary">
            <img src="${prefix}images/Church-logo.png" alt="Glorious Mystery Decade 5 - Coronation of Mary">
          </div>
          $gloriousDecadesHtml
        </div>

      </div>
    </div>
  </main>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const today = new Date().getDay();
      let activeMysteryId = "";
      switch(today) {
        case 1: case 6: activeMysteryId = "mystery-joyful"; break;
        case 2: case 5: activeMysteryId = "mystery-sorrowful"; break;
        case 3: case 0: activeMysteryId = "mystery-glorious"; break;
        case 4: activeMysteryId = "mystery-luminous"; break;
      }
      const targetBlock = document.getElementById(activeMysteryId);
      if (targetBlock) {
        targetBlock.classList.add('active-mystery');
        targetBlock.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }
    });
  </script>
"@

    return $header + $content + $footer
}

function Generate-ContactPage($lang) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $title = if ($lang -eq "ta") { "தொடர்புக்கு" } else { "Contact Us" }
    $pageSlug = "contact"
    $header = Get-HeaderHtml $lang $pageSlug $title $false
    $footer = Get-FooterHtml $lang $false

    $content = @"
  <main class="section-padding">
    <div class="container">
      <div class="card">
        <h1 style="color: var(--warm-brown);">$title</h1>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px; margin-bottom: 30px;">
          <!-- Office Address Card -->
          <div style="background: #f8fafc; border: 1px solid var(--border); border-left: 4px solid var(--gold); padding: 20px; border-radius: 8px;">
            <h3 style="color: var(--primary); margin-top: 0;"><i class="fa fa-map-marker" style="color: var(--gold);"></i> Address</h3>
            <p style="font-size: 0.95rem; line-height: 1.7; color: #334155; margin-bottom: 12px;">
              <strong>Our Lady of Fatima Shrine</strong><br>
              Bangalore Road, Krishnagiri - 635001<br>
              Tamil Nadu, India
            </p>
            <p style="margin-bottom: 6px;"><i class="fa fa-phone" style="color: var(--secondary);"></i> <strong>Phone:</strong> 04343 - 236836</p>
            <p style="margin-bottom: 0;"><i class="fa fa-envelope" style="color: var(--secondary);"></i> <strong>Email:</strong> fathimashrine.kgri@gmail.com</p>
          </div>

          <!-- Shrine Office Hours Card -->
          <div style="background: #f8fafc; border: 1px solid var(--border); border-left: 4px solid var(--secondary); padding: 20px; border-radius: 8px;">
            <h3 style="color: var(--primary); margin-top: 0;"><i class="fa fa-clock-o" style="color: var(--secondary);"></i> Office Hours & Helplines</h3>
            <p style="font-size: 0.92rem; line-height: 1.7; color: #334155; margin-bottom: 10px;">
              <strong>Monday - Saturday:</strong> 09:00 AM - 01:00 PM & 04:30 PM - 07:30 PM<br>
              <strong>Sunday:</strong> 07:00 AM - 01:00 PM
            </p>
            <div style="margin-top: 15px; border-top: 1px dashed var(--border); padding-top: 12px;">
              <strong style="color: var(--primary); font-size: 0.88rem; display: block; margin-bottom: 8px;">
                <i class="fa fa-share-alt" style="color: var(--gold);"></i> $(if ($lang -eq 'ta') { 'சமூக ஊடகங்கள்:' } else { 'Follow Our Social Channels:' })
              </strong>
              <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
                <a href="https://www.youtube.com/c/OurLadyOfFatimaShrine" target="_blank" rel="noopener" style="color: #ef4444; font-size: 1.35rem;" title="YouTube"><i class="fa fa-youtube-play"></i></a>
                <a href="https://www.facebook.com/OurLadyOfFatimaShrineKrishnagiri/" target="_blank" rel="noopener" style="color: #3b82f6; font-size: 1.35rem;" title="Facebook"><i class="fa fa-facebook-square"></i></a>
                <a href="https://www.instagram.com/our_lady_of_fatima_shrine/" target="_blank" rel="noopener" style="color: #ec4899; font-size: 1.35rem;" title="Instagram"><i class="fa fa-instagram"></i></a>
                <a href="https://x.com/OurLadyFatima13" target="_blank" rel="noopener" style="color: #0f172a; font-size: 1.25rem;" title="X (Twitter)"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="vertical-align: middle;"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg></a>
                <a href="https://whatsapp.com/channel/0029VbBoNHZI7BeA5acx7V2R" target="_blank" rel="noopener" style="color: #22c55e; font-size: 1.35rem;" title="WhatsApp"><i class="fa fa-whatsapp"></i></a>
              </div>
            </div>
          </div>
        </div>

        <!-- Shrine Administrators (4 Images Cohesive Grid) -->
        <h2 style="color: var(--primary); border-bottom: 2px solid var(--gold); padding-bottom: 8px; margin-bottom: 20px;">
          <i class="fa fa-users" style="color: var(--gold);"></i> $(if ($lang -eq 'ta') { 'திருத்தல நிருவாகிகள்' } else { 'Shrine Administrators & Office Bearers' })
        </h2>

        <div class="contact-person-grid">
          <!-- Administrator 1 -->
          <div class="contact-person-card">
            <img src="${prefix}images/contact-image-1.png" alt="Fr. Arulraj - Parish Priest">
            <div class="contact-person-name">Fr. அருள்ராஜ்</div>
            <div class="contact-person-role">பங்கு அருள்பணியாளர்<br><span style="font-size: 0.78rem; color: #64748b;">(Parish Priest)</span></div>
          </div>

          <!-- Administrator 2 -->
          <div class="contact-person-card">
            <img src="${prefix}images/contact-image-2.png" alt="Fr. Sebastian - Assistant Parish Priest">
            <div class="contact-person-name">Fr. செபாஸ்டின்</div>
            <div class="contact-person-role">உதவி பங்கு அருள்பணியாளர்<br><span style="font-size: 0.78rem; color: #64748b;">(Assistant Parish Priest)</span></div>
          </div>

          <!-- Administrator 3 -->
          <div class="contact-person-card">
            <img src="${prefix}images/contact-image-3.png" alt="Mr. Thomas - Shrine Worker">
            <div class="contact-person-name">திரு. தாமஸ்</div>
            <div class="contact-person-role">ஆலயப் பணியாளர்<br><span style="font-size: 0.78rem; color: #64748b;">(Shrine Caretaker)</span></div>
          </div>

          <!-- Administrator 4 -->
          <div class="contact-person-card">
            <img src="${prefix}images/contact-image-4.jpg" alt="Mr. Pushparaj - Office In-charge">
            <div class="contact-person-name">திரு. புஷ்பராஜ்</div>
            <div class="contact-person-role">பங்கு அலுவலகப் பொறுப்பாளர்<br><span style="font-size: 0.78rem; color: #64748b;">(Parish Office In-charge)</span></div>
          </div>
        </div>

        <!-- Church Location Map -->
        <div style="margin-top: 30px;">
          <h2 style="color: var(--primary); margin-bottom: 15px;"><i class="fa fa-map" style="color: var(--secondary);"></i> Google Map Location (Our Lady of Fatima Shrine, Krishnagiri)</h2>
          <div style="width: 100%; height: 350px; border-radius: 10px; overflow: hidden; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
            <iframe src="https://maps.google.com/maps?q=Our%20Lady%20of%20Fatima%20Shrine,%20Bangalore%20Road,%20Krishnagiri&t=&z=15&ie=UTF8&iwloc=&output=embed" style="width: 100%; height: 100%; border: 0;" loading="lazy" title="Fatima Shrine Map"></iframe>
          </div>
        </div>

        <!-- Sub-Station Church maps (3 Segments) -->
        <div style="margin-top: 35px;">
          <h2 style="color: var(--primary); margin-bottom: 15px; border-bottom: 2px solid var(--gold); padding-bottom: 8px;">
            <i class="fa fa-map-signs" style="color: var(--gold);"></i> $(if ($lang -eq 'ta') { 'கிளை பங்கு ஆலயங்களின் வரைபடங்கள் (Sub-Station Church maps)' } else { 'Sub-Station Church maps' })
          </h2>
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px;">
            <!-- 1. St. Joseph's Church - Periya Erikodi -->
            <div style="background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; padding: 14px; box-shadow: var(--shadow-sm);">
              <h4 style="color: var(--primary); margin: 0 0 10px 0; font-size: 0.98rem;"><i class="fa fa-church"></i> St. Joseph's Church - Periya Erikodi</h4>
              <div style="width: 100%; height: 300px; border-radius: 6px; overflow: hidden;">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d798381.9723964307!2d77.09230624687501!3d12.54619350000002!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3badcb10c84a9a9d%3A0xe449007e23e9fb01!2sSt.%20Joseph's%20Church%20-%20Periya%20Erikodi!5e1!3m2!1sen!2sin!4v1793158910074!5m2!1sen!2sin" width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="strict-origin-when-cross-origin" title="St. Joseph's Church - Periya Erikodi"></iframe>
              </div>
            </div>

            <!-- 2. The Sacred Heart Church - V Madepalli -->
            <div style="background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; padding: 14px; box-shadow: var(--shadow-sm);">
              <h4 style="color: var(--primary); margin: 0 0 10px 0; font-size: 0.98rem;"><i class="fa fa-church"></i> The Sacred Heart Church - V Madepalli</h4>
              <div style="width: 100%; height: 300px; border-radius: 6px; overflow: hidden;">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d487.53467569512384!2d78.18014018131689!3d12.656803542399667!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3badcfa65b17ff79%3A0x72e7c9d9d24018e5!2sThe%20Sacred%20Heart%20Church%20-%20V%20Madepalli!5e1!3m2!1sen!2sin!4v1793158836049!5m2!1sen!2sin" width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="strict-origin-when-cross-origin" title="The Sacred Heart Church - V Madepalli"></iframe>
              </div>
            </div>

            <!-- 3. St. Ignatius Of Loyola Church - Oldpet -->
            <div style="background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; padding: 14px; box-shadow: var(--shadow-sm);">
              <h4 style="color: var(--primary); margin: 0 0 10px 0; font-size: 0.98rem;"><i class="fa fa-church"></i> St. Ignatius Of Loyola Church - Oldpet</h4>
              <div style="width: 100%; height: 300px; border-radius: 6px; overflow: hidden;">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d798378.6462582325!2d77.09228312254268!3d12.547266067289149!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3bac34b09f79c6d9%3A0xb0c3baf9c5d9a056!2sSt.%20Ignatius%20Of%20Loyola%20Church!5e1!3m2!1sen!2sin!4v1793158961080!5m2!1sen!2sin" width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="strict-origin-when-cross-origin" title="St. Ignatius Of Loyola Church"></iframe>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </main>
"@

    return $header + $content + $footer
}

function Generate-GalleryPage($lang) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $title = if ($lang -eq "ta") { "புகைப்பட தொகுப்பு" } else { "Photo & Video Gallery" }
    $pageSlug = "gallery"
    $header = Get-HeaderHtml $lang $pageSlug $title $false
    $footer = Get-FooterHtml $lang $false

    $galleryImages = @(
        @{ file = "Banner-1.png"; alt = "Our Lady of Fatima Shrine Sanctuary and High Altar Krishnagiri" },
        @{ file = "Banner-2.png"; alt = "Fatima Shrine Exterior Front Elevation and Bell Tower Krishnagiri" },
        @{ file = "history-1.jpg"; alt = "Historic St. Ignatius Church Oldpet Krishnagiri" },
        @{ file = "history-2.jpg"; alt = "Historic Church Renovation and Parish Memorial Krishnagiri" },
        @{ file = "history-3.png"; alt = "Miraculous Fatima Statue brought from Fatima Portugal" },
        @{ file = "history-4.png"; alt = "Shrine Foundation and Construction History Krishnagiri" },
        @{ file = "sub-periya.jpg"; alt = "St. Joseph Sub-station Church Periya Erikodi Krishnagiri" },
        @{ file = "sub-madhe.png"; alt = "Sacred Heart Church Sub-station V. Madhepalli Krishnagiri" },
        @{ file = "sub-oldpet.png"; alt = "Centenary St. Ignatius Church Oldpet Krishnagiri" },
        @{ file = "assoc-altar.png"; alt = "Altar Servers and Altar Girls Ministry Our Lady of Fatima Shrine" },
        @{ file = "assoc-board-1.png"; alt = "Parish Pastoral Council Board Members Meeting Krishnagiri" },
        @{ file = "assoc-board-2.png"; alt = "Shrine Committee and Council Office Bearers Krishnagiri" },
        @{ file = "assoc-treasurer.png"; alt = "Shrine Treasury and Finance Committee Krishnagiri" },
        @{ file = "assoc-choir-1.png"; alt = "Shrine Holy Rosary and Liturgical Youth Choir Krishnagiri" },
        @{ file = "assoc-choir-2.png"; alt = "Fatima Shrine Choir Festal Carol and Music Ministry Krishnagiri" },
        @{ file = "assoc-flower.png"; alt = "Altar Flower Decoration and Liturgical Arrangement Team" },
        @{ file = "assoc-media.jpg"; alt = "Parish Media and Digital Broadcast Ministry Team" },
        @{ file = "org-vdp.png"; alt = "Society of St. Vincent de Paul Charitable Service Krishnagiri" },
        @{ file = "org-vdp-women.png"; alt = "Society of St. Vincent de Paul Women's Chapter Krishnagiri" },
        @{ file = "org-legion-1.png"; alt = "Legion of Mary (Mariyan Seanai) Weekly Prayer Meeting Krishnagiri" },
        @{ file = "org-youth.png"; alt = "St. Paul's Youth Movement Catholic Fellowship Krishnagiri" },
        @{ file = "org-teachers.png"; alt = "Catholic School Teachers Association Krishnagiri" },
        @{ file = "catechism.png"; alt = "Sunday Catechism Children and Faith Formation Krishnagiri" },
        @{ file = "anbiyam.png"; alt = "Anbiyam Basic Christian Community Fellowship Krishnagiri" },
        @{ file = "service-hall.png"; alt = "Shrine Community Hall and Pastoral Center Krishnagiri" },
        @{ file = "service-cemetery.png"; alt = "Shrine Holy Cemetery and Memorial Chapel Krishnagiri" }
    )

    $gridHtml = "<div class='image-grid'>`n"
    foreach ($img in $galleryImages) {
        $gridHtml += "  <div style='overflow: hidden; border-radius: 8px;'><img src='${prefix}images/$($img.file)' alt='$($img.alt)' loading='lazy'></div>`n"
    }
    $gridHtml += "</div>`n"

    $content = @"
  <main class="section-padding">
    <div class="container">
      <div class="card">
        <h1 style="color: var(--warm-brown);">$title</h1>
        <p>$(if ($lang -eq 'ta') { 'கிருஷ்ணகிரி பாத்திமா அன்னை திருத்தலத்தின் திருவிழா நிகழ்வுகள், பங்கு அமைப்புகள், கல்வி நிறுவனங்கள் மற்றும் ஆலய திருவுருவப் படங்களின் தொகுப்பு.' } else { 'Explore the pictorial journey of Our Lady of Fatima Shrine, Krishnagiri, showcasing festal processions, community ministries, sub-stations, and historic moments.' })</p>
        
        $gridHtml

        <!-- YouTube Video Gallery -->
        <h2 style="color: var(--primary); margin-top: 35px; border-bottom: 2px solid var(--gold); padding-bottom: 8px;">
          <i class="fa fa-video-camera" style="color: #ff0000;"></i> $(if ($lang -eq 'ta') { 'வீடியோ தொகுப்பு' } else { 'Video Highlights' })
        </h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px; margin-top: 20px;">
          <div class="video-responsive-wrap">
            <iframe src="https://www.youtube.com/embed/videoseries?list=UUe7i0e-o2n2qZ5_kU9W9a8A" title="Fatima Shrine Holy Mass Live Stream" allowfullscreen></iframe>
          </div>
          <div class="video-responsive-wrap">
            <iframe src="https://www.youtube.com/embed/videoseries?list=UUe7i0e-o2n2qZ5_kU9W9a8A" title="Fatima Shrine Feast Procession Highlights" allowfullscreen></iframe>
          </div>
        </div>
      </div>
    </div>
  </main>
"@

    return $header + $content + $footer
}

function Generate-HomePage($lang) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $title = if ($lang -eq "ta") { "முகப்பு | Home" } else { "Home | முகப்பு" }
    $pageSlug = "index"
    $header = Get-HeaderHtml $lang $pageSlug $title $true
    $footer = Get-FooterHtml $lang $true

    $heroTitle1 = if ($lang -eq "ta") { "பாத்திமா அன்னை திருத்தலத்திற்கு அன்புடன் வரவேற்கிறோம்" } else { "Welcome to Our Lady of Fatima Shrine" }
    $heroSub1 = if ($lang -eq "ta") { "கிருஷ்ணகிரி நகரின் இதயப்பகுதியில் விசுவாசத்தின் விளக்காக திகழும் கத்தோலிக்கத் திருத்தலம்." } else { "A venerable Catholic shrine of prayer, grace, and hope nestled in Krishnagiri, Tamil Nadu." }
    $heroTitle2 = if ($lang -eq "ta") { "பொன்விழா கண்ட புகழ்பெற்ற திருத்தலம் (1972 - 2022)" } else { "50 Glorious Years of Faith & Community" }
    $heroSub2 = if ($lang -eq "ta") { "போர்ச்சுகல் நாட்டிலிருந்து கொண்டுவரப்பட்ட பாத்திமா அன்னை திருவுருவம். ஆண்டுப் பெருவிழா ஜூலை 13-க்கு அடுத்த ஞாயிறு." } else { "Blessed with the miraculous statue brought from Fátima, Portugal. Annual Feast celebrated on the Sunday after July 13." }

    $aboutHeader = if ($lang -eq "ta") { "எங்கள் திருத்தலம் பற்றி" } else { "About Our Shrine" }
    $announcementsHeader = if ($lang -eq "ta") { "அறிவிப்புகள்" } else { "Announcements" }
    $latestMassHeader = if ($lang -eq "ta") { "சமீபத்திய திருப்பலி" } else { "Latest Mass Video" }
    $specialMassHeader = if ($lang -eq "ta") { "சிறப்பு திருப்பலி" } else { "Special Mass" }
    $shortsHeader = if ($lang -eq "ta") { "தினசரி நற்செய்தி சிந்தனை & ரீல்ஸ்" } else { "Daily Reels & Shorts" }
    $bankHeader = if ($lang -eq "ta") { "வங்கி விவரங்கள் & காணிக்கை" } else { "Bank Details & Offerings" }
    $calendarHeader = if ($lang -eq "ta") { "வழிபாட்டு நாட்காட்டி" } else { "Liturgical Calendar" }
    $vaticanTitle = if ($lang -eq 'ta') { "வத்திக்கான் செய்தி (Vatican News)" } else { "Vatican News" }
    $vaticanSub = if ($lang -eq 'ta') { "திருத்தந்தையின் சர்வதேச செய்தி ஊடகம்" } else { "Official news portal of the Holy See" }
    $fatimaTitle = if ($lang -eq 'ta') { "பாத்திமா திருத்தலம் (போர்ச்சுகல்)" } else { "Sanctuary of Fatima (Portugal)" }
    $fatimaSub = if ($lang -eq 'ta') { "போர்ச்சுகல் பாத்திமா அன்னையின் சர்வதேச தளம்" } else { "Official shrine of Our Lady of Fatima" }
    $dharmapuriTitle = if ($lang -eq 'ta') { "தருமபுரி மறைமாவட்டம்" } else { "Diocese of Dharmapuri" }
    $dharmapuriSub = if ($lang -eq 'ta') { "நமது மறைமாவட்டத்தின் அதிகாரப்பூர்வ இணையதளம்" } else { "Official portal of the Catholic Diocese of Dharmapuri" }
    $officialWebsitesHeader = if ($lang -eq 'ta') { "முக்கிய கத்தோலிக்க தளங்கள்" } else { "Other Official Websites" }

    $content = @"
  <!-- Hero Banner Slider (Full View 3712x1152 - No Crop) -->
  <section class="hero-slider-area">
    <div class="hero-slider-container">
      <!-- Slide 1 -->
      <div class="hero-slide active">
        <img src="${prefix}images/Banner-1.png" alt="Our Lady of Fatima Shrine Krishnagiri Altar" class="hero-slide-bg">
      </div>

      <!-- Slide 2 -->
      <div class="hero-slide">
        <img src="${prefix}images/Banner-2.png" alt="Our Lady of Fatima Shrine Krishnagiri Front View" class="hero-slide-bg">
      </div>
    </div>

    <!-- Controls -->
    <div class="slider-controls">
      <button type="button" class="btn-slider-arrow btn-slider-prev" aria-label="Previous Slide"><i class="fa fa-chevron-left"></i></button>
      <button type="button" class="btn-slider-arrow btn-slider-next" aria-label="Next Slide"><i class="fa fa-chevron-right"></i></button>
    </div>
  </section>

  <!-- Homepage Grids -->
  <main class="section-padding">
    <div class="container">
      
      <!-- ROW 1: Grid 1 (About Shrine) & Grid 2 (Announcements) -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px; margin-bottom: 25px;">
        
        <!-- Grid 1: About Shrine -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-church" style="color: var(--secondary);"></i> $aboutHeader</h3>
          </div>
          <p style="font-size: 0.94rem; line-height: 1.75; color: #334155;">
            $(if ($lang -eq 'ta') {
                "கிருஷ்ணகிரி பாத்திமா அன்னை திருத்தலம் தமிழ்நாடு தருமபுரி மறைமாவட்டத்தில் அமைந்துள்ள ஒரு பிரசித்தி பெற்ற கத்தோலிக்க திருத்தலமாகும். 1972-இல் பெங்களூர் பிரதான சாலையில் புதிய ஆலயமாக நிறுவப்பட்ட இத்திருத்தலம், 850-க்கும் மேற்பட்ட குடும்பங்களைக் கொண்டு மறைமாவட்டத்தின் மிகப்பெரிய பங்குகளுள் ஒன்றாகத் திகழ்கிறது."
            } else {
                "Our Lady of Fatima Shrine stands as a revered Roman Catholic church nestled in the heart of Krishnagiri town in Tamil Nadu, India. Affiliated with the Diocese of Dharmapuri, this parish embraces over 850 families, making it one of the largest Catholic communities in the region. Established in 1972, the shrine radiates faith, prayer, and community service."
            })
          </p>
          <p style="font-size: 0.94rem; line-height: 1.75; color: #334155;">
            $(if ($lang -eq 'ta') {
                "போர்ச்சுகல் நாட்டின் பாத்திமா நகரில் ஆசீர்வதிக்கப்பட்டு கொண்டுவரப்பட்ட அன்னை மரியாவின் திருவுருவச் சிலை இவ்வாலயத்திற்கு தனித்துவமான ஆன்மீக அருளைச் சேர்க்கிறது. ஆண்டுதோறும் ஜூலை 13-க்கு அடுத்த ஞாயிற்றுக்கிழமை நடைபெறும் ஆண்டுத் திருவிழா கிருஷ்ணகிரி நகரின் புகழ்பெற்ற விழாவாகும்."
            } else {
                "The church is spiritually blessed by the sacred statue of Our Lady of Fatima brought directly from Fátima, Portugal. Countless pilgrims visit seeking peace and solace. The annual feast, celebrated with deep devotion and a grand candlelight car procession on the Sunday after July 13, is renowned as a festival of grace and unity."
            })
          </p>
          <a href="history.html" class="btn-read-more">$(if ($lang -eq 'ta') { 'முழு வரலாறு வாசிக்க' } else { 'Read More' }) <i class="fa fa-angle-right"></i></a>
        </div>

        <!-- Grid 2: Announcements -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-bullhorn" style="color: #f59e0b;"></i> $announcementsHeader</h3>
          </div>
          <ul class="announcement-list">
            <li class="announcement-item">
              <div class="announcement-item-top">
                <div class="announcement-chips-left">
                  <span class="chip-date"><i class="fa fa-calendar"></i> 13-Nov</span>
                  <span class="chip-day">Fri</span>
                </div>
                <span class="announcement-tag tag-event">Event</span>
              </div>
              <h4 class="announcement-title">மாதாந்திர 13-ஆம் நாள் பாத்திமா தேர்பவனி</h4>
              <p class="announcement-desc">மாலை 5:30 மணிக்கு பாத்திமா அன்னை திருவுருவ பவனி, செபமாலை மற்றும் சிறப்புத் திருப்பலி.</p>
            </li>

            <li class="announcement-item">
              <div class="announcement-item-top">
                <div class="announcement-chips-left">
                  <span class="chip-date"><i class="fa fa-calendar"></i> Sundays</span>
                  <span class="chip-day">Sun</span>
                </div>
                <span class="announcement-tag tag-catechism">Catechism</span>
              </div>
              <h4 class="announcement-title">Sunday Catechism & Faith Formation</h4>
              <p class="announcement-desc">Weekly Sunday faith formation classes following 7:30 AM Holy Mass.</p>
            </li>

            <li class="announcement-item">
              <div class="announcement-item-top">
                <div class="announcement-chips-left">
                  <span class="chip-date"><i class="fa fa-calendar"></i> 2nd Sun</span>
                  <span class="chip-day">Sun</span>
                </div>
                <span class="announcement-tag tag-meet">Meet</span>
              </div>
              <h4 class="announcement-title">Parish Pastoral Council Meeting</h4>
              <p class="announcement-desc">Monthly council meeting held at parish conference hall under parish priest.</p>
            </li>
          </ul>
        </div>

      </div>

      <!-- ROW 2: Latest Mass Video (2/3) & Special Mass (1/3) -->
      <div class="home-video-row">
        
        <!-- Grid 3: Main YouTube Video (Two-Thirds) -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-youtube-play" style="color: #ff0000;"></i> $latestMassHeader</h3>
          </div>
          <div class="video-responsive-wrap">
            <iframe src="https://www.youtube.com/embed/videoseries?list=UUe7i0e-o2n2qZ5_kU9W9a8A" title="Fatima Shrine Latest Holy Mass" allowfullscreen></iframe>
          </div>
          <div class="yt-channel-badge">
            <div style="display: flex; align-items: center; gap: 8px;">
              <i class="fa fa-video-camera" style="color: #ff0000; font-size: 1.1rem;"></i>
              <div>
                <div style="font-weight: 700; color: var(--primary); font-size: 0.85rem;">Our Lady of Fatima Shrine</div>
                <div style="font-size: 0.75rem; color: var(--text-muted);">Official YouTube Channel</div>
              </div>
            </div>
            <a href="https://www.youtube.com/c/OurLadyOfFatimaShrine" target="_blank" rel="noopener" style="background: #ff0000; color: #fff; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: 700;">Subscribe</a>
          </div>
        </div>

        <!-- Grid 4: Special Mass (One-Third) -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-star" style="color: var(--gold);"></i> $specialMassHeader</h3>
          </div>
          <div class="special-mass-list">
            <div class="special-mass-item">
              <div class="special-mass-title">Christmas Night Vigil Mass</div>
              <p class="special-mass-desc">கிறிஸ்துமஸ் இரவு சிறப்பு திருவிழிப்பு கூட்டுத்திருப்பலி</p>
              <div class="special-mass-meta">
                <span class="special-mass-chip-date"><i class="fa fa-calendar"></i> 24/Dec/2026</span>
                <span class="special-mass-chip-time"><i class="fa fa-clock-o"></i> 11:00 PM</span>
              </div>
            </div>
            <div class="special-mass-item">
              <div class="special-mass-title">Christmas Day Festal Mass</div>
              <p class="special-mass-desc">கிறிஸ்துமஸ் பெருவிழா விடியற்காலை திருப்பலி</p>
              <div class="special-mass-meta">
                <span class="special-mass-chip-date"><i class="fa fa-calendar"></i> 25/Dec/2026</span>
                <span class="special-mass-chip-time"><i class="fa fa-clock-o"></i> 08:00 AM</span>
              </div>
            </div>
            <div class="special-mass-item">
              <div class="special-mass-title">Oldpet St. Ignatius Feast Mass</div>
              <p class="special-mass-desc">பழையபேட்டை தூய லயோலா இஞ்ஞாசியார் திருவிழா</p>
              <div class="special-mass-meta">
                <span class="special-mass-chip-date"><i class="fa fa-calendar"></i> 12/Feb/2027</span>
                <span class="special-mass-chip-time"><i class="fa fa-clock-o"></i> 06:00 PM</span>
              </div>
            </div>
            <div class="special-mass-item">
              <div class="special-mass-title">Annual Shrine Feast Pontifical Mass</div>
              <p class="special-mass-desc">பாத்திமா அன்னை ஆண்டுப் பெருவிழா ஆடம்பர கூட்டுத்திருப்பலி</p>
              <div class="special-mass-meta">
                <span class="special-mass-chip-date"><i class="fa fa-calendar"></i> 19/Jul/2027</span>
                <span class="special-mass-chip-time"><i class="fa fa-clock-o"></i> 08:30 AM</span>
              </div>
            </div>
          </div>
        </div>

      </div>

      <!-- ROW 3: Grid 6 (ICS Calendar) & Grid 7 (Bank Details) -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px; margin-bottom: 25px;">
        
        <!-- Grid 6: Liturgical Calendar (7-Day Schedule from local .ICS) -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-calendar" style="color: var(--secondary);"></i> $calendarHeader</h3>
          </div>
          <p style="font-size: 0.82rem; color: #64748b; margin-bottom: 12px;">
            $(if ($lang -eq 'ta') { 'கத்தோலிக்க திருச்சபையின் தினசரி வழிபாட்டுத் திருநாட்கள் அட்டவணை:' } else { 'Upcoming daily liturgical feasts, solemnities, and saints memorials:' })
          </p>
          <div id="parishCalendar">
            <div style="text-align: center; padding: 20px; color: var(--text-muted);"><i class="fa fa-spinner fa-spin"></i> Loading liturgical schedule...</div>
          </div>
        </div>

        <!-- Right Column: Bank Details + Other Official Websites -->
        <div style="display: flex; flex-direction: column; gap: 25px;">

        <!-- Grid 7: Bank Details & Offerings -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-bank" style="color: var(--gold);"></i> $bankHeader</h3>
          </div>
          <p style="font-size: 0.85rem; color: #475569; margin-bottom: 12px;">
            $(if ($lang -eq 'ta') {
                'பாத்திமா அன்னை திருத்தல பராமரிப்பு மற்றும் திருப்பணிக்கு அன்புடன் நன்கொடை செலுத்த அதிகாரப்பூர்வ வங்கிக் கணக்கு:'
            } else {
                'Devotees wishing to contribute to the Shrine Renovation Fund and church maintenance can transfer directly to the official account:'
            })
          </p>
          <div class="bank-row-item">
            <span class="bank-row-label">Bank Name:</span>
            <span class="bank-row-value">OUR LADY OF FATIMA RENOVATION FUND</span>
          </div>
          <div class="bank-row-item">
            <span class="bank-row-label">Account No:</span>
            <span class="bank-row-value">
              <code>19930100068839</code>
              <button type="button" class="btn-copy" data-copy="19930100068839" data-label="Account"><i class="fa fa-clone"></i></button>
            </span>
          </div>
          <div class="bank-row-item">
            <span class="bank-row-label">Bank & IFSC:</span>
            <span class="bank-row-value">
              Federal Bank | <code>FDRL0001993</code>
              <button type="button" class="btn-copy" data-copy="FDRL0001993" data-label="IFSC"><i class="fa fa-clone"></i></button>
            </span>
          </div>
          <div class="bank-row-item">
            <span class="bank-row-label">UPI ID:</span>
            <span class="bank-row-value">
              fatimachurch@fbl
              <button type="button" class="btn-copy" data-copy="fatimachurch@fbl" data-label="UPI"><i class="fa fa-clone"></i></button>
            </span>
          </div>

          <!-- UPI QR Box -->
          <div class="bank-qr-box">
            <svg width="65" height="65" viewBox="0 0 100 100" class="bank-qr-img">
              <rect x="0" y="0" width="30" height="30" fill="#0c3b60"/>
              <rect x="5" y="5" width="20" height="20" fill="#fff"/>
              <rect x="10" y="10" width="10" height="10" fill="#0c3b60"/>
              <rect x="70" y="0" width="30" height="30" fill="#0c3b60"/>
              <rect x="75" y="5" width="20" height="20" fill="#fff"/>
              <rect x="80" y="10" width="10" height="10" fill="#0c3b60"/>
              <rect x="0" y="70" width="30" height="30" fill="#0c3b60"/>
              <rect x="5" y="75" width="20" height="20" fill="#fff"/>
              <rect x="10" y="80" width="10" height="10" fill="#0c3b60"/>
              <rect x="40" y="15" width="10" height="20" fill="#0c3b60"/>
              <rect x="45" y="45" width="20" height="15" fill="#0c3b60"/>
              <rect x="70" y="70" width="25" height="25" fill="#0c3b60"/>
            </svg>
            <div class="bank-qr-text">
              <strong>Scan to Pay via UPI</strong>
              <span>Instant offerings via PhonePe, Google Pay, Paytm, or BHIM.</span>
            </div>
          </div>
        </div>

        <!-- Grid 8: Other Official Catholic Websites -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-globe" style="color: var(--secondary);"></i> $officialWebsitesHeader</h3>
          </div>
          <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 5px;">
            <!-- 1. Vatican News -->
            <a href="https://www.vaticannews.va/ta.html" target="_blank" rel="noopener" class="official-link-card" title="Vatican News">
              <img src="${prefix}images/logo-vatican.svg" alt="Vatican News Logo" class="official-link-logo">
              <div class="official-link-content">
                <div class="official-link-title">$vaticanTitle</div>
                <div class="official-link-sub">$vaticanSub</div>
              </div>
              <i class="fa fa-external-link official-link-arrow"></i>
            </a>

            <!-- 2. Sanctuary of Fatima, Portugal -->
            <a href="https://www.fatima.pt/en/" target="_blank" rel="noopener" class="official-link-card" title="Sanctuary of Fatima Portugal">
              <img src="${prefix}images/logo-fatima-portugal.svg" alt="Fatima Portugal Logo" class="official-link-logo">
              <div class="official-link-content">
                <div class="official-link-title">$fatimaTitle</div>
                <div class="official-link-sub">$fatimaSub</div>
              </div>
              <i class="fa fa-external-link official-link-arrow"></i>
            </a>

            <!-- 3. Dharmapuri Diocese -->
            <a href="https://dharmapuridiocese.in/" target="_blank" rel="noopener" class="official-link-card" title="Diocese of Dharmapuri">
              <img src="${prefix}images/logo-dharmapuri-diocese.svg" alt="Dharmapuri Diocese Logo" class="official-link-logo">
              <div class="official-link-content">
                <div class="official-link-title">$dharmapuriTitle</div>
                <div class="official-link-sub">$dharmapuriSub</div>
              </div>
              <i class="fa fa-external-link official-link-arrow"></i>
            </a>
          </div>
        </div>

        </div>


      </div>

    </div>
  </main>
"@

    return $header + $content + $footer
}

function Generate-InnerPage($pageInfo, $lang) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $slug = $pageInfo.slug
    $txtFileName = if ($lang -eq "ta") { $pageInfo.taFile } else { $pageInfo.enFile }
    $txtPath = Join-Path $workspaceRoot "text\$txtFileName"

    $rawText = ""
    if (Test-Path $txtPath) {
        $rawText = [System.IO.File]::ReadAllText($txtPath, [System.Text.Encoding]::UTF8)
    } else {
        Write-Warning "File not found: $txtPath"
        $rawText = "# $($pageInfo.defaultEnTitle)`n`nContent in progress."
    }

    $lines = $rawText -split "`r?`n"
    $title = ""
    foreach ($l in $lines) {
        if ($l.Trim().StartsWith("#")) {
            $title = $l.Trim().TrimStart('#').Trim()
            break
        }
    }
    if (-not $title) {
        $title = if ($lang -eq "ta") { $pageInfo.defaultTaTitle } else { $pageInfo.defaultEnTitle }
    }

    $header = Get-HeaderHtml $lang $slug $title $false
    $footer = Get-FooterHtml $lang $false

    $parsedHtml = Convert-ContentToHtml $rawText $slug $lang $prefix $title

    $imagesHtml = ""
    if ($pageInfo.images -and $pageInfo.images.Count -gt 0) {
        $unseenImages = @()
        foreach ($img in $pageInfo.images) {
            if (-not ($parsedHtml -match [regex]::Escape($img))) {
                $unseenImages += $img
            }
        }
        if ($unseenImages.Count -eq 1) {
            $imagesHtml = "<div style='text-align: center; margin: 20px 0;'><img src='${prefix}images/$($unseenImages[0])' alt='$title' class='page-image-banner'></div>`n"
        } elseif ($unseenImages.Count -gt 1) {
            $imagesHtml = "<div class='image-grid'>`n"
            foreach ($img in $unseenImages) {
                $imagesHtml += "  <div><img src='${prefix}images/$img' alt='$title - Our Lady of Fatima Shrine' loading='lazy'></div>`n"
            }
            $imagesHtml += "</div>`n"
        }
    }

    $bodyHtml = @"
  <main class="section-padding">
    <div class="container">
      <div class="card">
        $imagesHtml
        $parsedHtml
      </div>
    </div>
  </main>
"@

    return $header + $bodyHtml + $footer
}

# Execution
Write-Output "Generating Homepages..."
$indexHtml = Generate-HomePage "en"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "index.html"), $indexHtml, [System.Text.Encoding]::UTF8)

$indexTaHtml = Generate-HomePage "ta"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\index-ta.html"), $indexTaHtml, [System.Text.Encoding]::UTF8)

Write-Output "Generating Gallery Pages..."
$galleryEn = Generate-GalleryPage "en"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "gallery.html"), $galleryEn, [System.Text.Encoding]::UTF8)

$galleryTa = Generate-GalleryPage "ta"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\gallery.html"), $galleryTa, [System.Text.Encoding]::UTF8)

$count = 0
foreach ($p in $meta.pagesList) {
    if ($p.slug -eq "rosary") {
        Write-Output "Generating Rosary pages..."
        $rosaryEn = Generate-RosaryPage "en"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "rosary.html"), $rosaryEn, [System.Text.Encoding]::UTF8)
        
        $rosaryTa = Generate-RosaryPage "ta"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\rosary.html"), $rosaryTa, [System.Text.Encoding]::UTF8)
        $count += 2
        continue
    }

    if ($p.slug -eq "contact") {
        Write-Output "Generating Contact Us pages..."
        $contactEn = Generate-ContactPage "en"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "contact.html"), $contactEn, [System.Text.Encoding]::UTF8)
        
        $contactTa = Generate-ContactPage "ta"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\contact.html"), $contactTa, [System.Text.Encoding]::UTF8)
        $count += 2
        continue
    }

    Write-Output "Generating $($p.slug).html & ta/$($p.slug).html..."
    $pageEn = Generate-InnerPage $p "en"
    [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "$($p.slug).html"), $pageEn, [System.Text.Encoding]::UTF8)

    $pageTa = Generate-InnerPage $p "ta"
    [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\$($p.slug).html"), $pageTa, [System.Text.Encoding]::UTF8)

    $count += 2
}

Write-Output "=========================================================="
Write-Output "SUCCESS: Generated all pages! Total inner pages generated: $count"
Write-Output "Homepages: 2 (index.html, ta/index-ta.html)"
Write-Output "Gallery pages: 2 (gallery.html, ta/gallery.html)"
Write-Output "Total HTML files: $($count + 4)"
Write-Output "=========================================================="
