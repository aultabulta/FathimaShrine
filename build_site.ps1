# ==============================================================================
# Our Lady of Fatima Shrine, Krishnagiri - Static Site Generator
# Generates all English & Tamil pages (Over 88 static pages)
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

$workspaceRoot = "c:\Users\Admin\Documents\AntiGravity\Faatima 2"
Set-Location $workspaceRoot

# Ensure ta directory exists
New-Item -ItemType Directory -Force -Path "ta" | Out-Null

# -----------------------------------------------------------------------------
# Navigation items definition
# -----------------------------------------------------------------------------
$navStructure = @(
    @{
        id = "home"
        en = "Home"
        ta = "முகப்பு"
        enUrl = "index.html"
        taUrl = "index-ta.html"
        icon = "fa-home"
        submenu = @()
    },
    @{
        id = "about"
        en = "About Shrine"
        ta = "திருத்தலம் பற்றி"
        icon = "fa-church"
        items = @(
            @{ slug = "history"; en = "History"; ta = "வரலாறு" },
            @{ slug = "sub-periya"; en = "Sub Station: Periya Erikodi"; ta = "கிளைப்பங்கு: பெரிய ஏரிக்கோடி" },
            @{ slug = "sub-madhe"; en = "Sub Station: V. Madhepalli"; ta = "கிளைப்பங்கு: வி. மாதேபள்ளி" },
            @{ slug = "sub-oldpet"; en = "Sub Station: Oldpet"; ta = "கிளைப்பங்கு: பழையபேட்டை" },
            @{ slug = "priest-parish"; en = "List of Parish Priest"; ta = "பங்கு தந்தையர்கள்" },
            @{ slug = "priest-asst"; en = "List of Asst. Parish Priest"; ta = "உதவி பங்கு தந்தையர்கள்" },
            @{ slug = "priest-native"; en = "Priest From Our Parish"; ta = "நம் பங்கின் அருட்பணியாளர்கள்" },
            @{ slug = "sister-native"; en = "Sisters From Our Parish"; ta = "நம் பங்கின் துறவற சகோதரிகள்" }
        )
    },
    @{
        id = "people"
        en = "For People"
        ta = "இறைமக்களுக்கு"
        icon = "fa-users"
        items = @(
            @{ slug = "mass-reg"; en = "Mass Regulation"; ta = "திருப்பலி ஒழுங்குமுறைகள்" },
            @{ slug = "parishioner"; en = "Parishioner"; ta = "பங்கு மக்கள்" },
            @{ slug = "catechism"; en = "Sunday Catechism"; ta = "ஞாயிறு மறைக்கல்வி" },
            @{ slug = "anbiyam"; en = "Anbiyam (BCC)"; ta = "அன்பியம் (BCC)" },
            @{
                isSubmenu = $true
                id = "sacraments"
                en = "Sacraments"
                ta = "திருவருட்சாதனங்கள்"
                subitems = @(
                    @{ slug = "sac-baptism"; en = "Baptism (திருமுழுக்கு)"; ta = "திருமுழுக்கு (ஞானஸ்நானம்)" },
                    @{ slug = "sac-confirmation"; en = "Confirmation (உறுதிப்பூசுதல்)"; ta = "உறுதிப்பூசுதல்" },
                    @{ slug = "sac-holy-communion"; en = "Holy Communion (நற்கருணை)"; ta = "நற்கருணை (புதுநன்மை)" },
                    @{ slug = "sac-confession"; en = "Confession (ஒப்புரவு)"; ta = "ஒப்புரவு (பாவசங்கீர்த்தனம்)" },
                    @{ slug = "sac-holy-orders"; en = "Holy Orders (குருத்துவம்)"; ta = "குருத்துவம் (திருப்பட்டம்)" },
                    @{ slug = "sac-marriage"; en = "Marriage (திருமணம்)"; ta = "திருமணம்" },
                    @{ slug = "sac-unction"; en = "Anointing of the Sick (நோயில் பூசுதல்)"; ta = "நோயில் பூசுதல்" }
                )
            },
            @{ slug = "rosary"; en = "Rosary in Tamil"; ta = "ஜெபமாலை" }
        )
    },
    @{
        id = "assoc"
        en = "Association"
        ta = "பங்கு அமைப்புகள்"
        icon = "fa-handshake-o"
        items = @(
            @{ slug = "assoc-board"; en = "Parish Board"; ta = "பங்கு பேரவை" },
            @{ slug = "assoc-altar"; en = "Alter Boys/Girls"; ta = "பீட சிறார்கள்" },
            @{ slug = "assoc-program"; en = "Shrine Program Authority"; ta = "நிகழ்வு ஒருங்கிணைப்பு" },
            @{ slug = "assoc-choir"; en = "Choir"; ta = "பாடகர் குழு" },
            @{ slug = "assoc-flower"; en = "Flower Team"; ta = "மலர் குழு" },
            @{ slug = "assoc-media"; en = "Media"; ta = "ஊடகப்பணி" }
        )
    },
    @{
        id = "org"
        en = "Organisation"
        ta = "இயக்கங்கள்"
        icon = "fa-sitemap"
        items = @(
            @{ slug = "org-vdp"; en = "Vincent De Paul"; ta = "வின்சென்ட் டி பவுல்" },
            @{ slug = "org-legion"; en = "Mariyan Seanai"; ta = "மரியாயின் சேனை" },
            @{ slug = "org-youth"; en = "St. Paul's Youth"; ta = "புனித பவுல் இளைஞர் இயக்கம்" },
            @{ slug = "org-teachers"; en = "Teachers Association"; ta = "ஆசிரியர்கள் சங்கம்" }
        )
    },
    @{
        id = "convents"
        en = "Convents"
        ta = "துறவற இல்லங்கள்"
        icon = "fa-building-o"
        items = @(
            @{ slug = "convent-fsmschool"; en = "FSM (School)"; ta = "எஃப்.எஸ்.எம் (பள்ளி)" },
            @{ slug = "convent-fsmhosp"; en = "FSM (Hospital)"; ta = "எஃப்.எஸ்.எம் (மருத்துவமனை)" },
            @{ slug = "convent-fihm"; en = "FIHM"; ta = "எஃப்.ஐ.எச்.எம்" }
        )
    },
    @{
        id = "institutions"
        en = "Institution"
        ta = "கல்வி நிறுவனங்கள்"
        icon = "fa-graduation-cap"
        items = @(
            @{ slug = "inst-rcprim"; en = "R.C. Fatima Boys Primary"; ta = "ஆர்.சி. பாத்திமா தொடக்கப் பள்ளி" },
            @{ slug = "inst-rchigh"; en = "R.C. Fatima Boys High"; ta = "ஆர்.சி. பாத்திமா உயர்நிலைப் பள்ளி" },
            @{ slug = "inst-db"; en = "Don Bosco School"; ta = "டான் போஸ்கோ பள்ளி" },
            @{ slug = "inst-annprim"; en = "St. Ann's Aided Primary"; ta = "புனித அன்னாள் தொடக்கப் பள்ளி" },
            @{ slug = "inst-annhigh"; en = "St. Ann's Aided Hr. Sec."; ta = "புனித அன்னாள் மேல்நிலைப் பள்ளி" },
            @{ slug = "inst-annenurs"; en = "St. Anne's Nursery & Primary"; ta = "புனித அன்னாள் மழலையர் பள்ளி" },
            @{ slug = "inst-annecbse"; en = "St. Anne's CBSE Public"; ta = "புனித அன்னாள் சிபிஎஸ்இ பள்ளி" }
        )
    },
    @{
        id = "services"
        en = "Service"
        ta = "சேவைகள்"
        icon = "fa-cogs"
        items = @(
            @{ slug = "service-hall"; en = "Community Hall"; ta = "சமுதாயக் கூடம்" },
            @{ slug = "service-cemetery"; en = "Cemetery"; ta = "கல்லறைத் தோட்டம்" }
        )
    },
    @{
        id = "gallery"
        en = "Gallery"
        ta = "புகைப்படங்கள்"
        slug = "gallery"
        icon = "fa-picture-o"
        items = @()
    },
    @{
        id = "contact"
        en = "Contact Us"
        ta = "தொடர்புக்கு"
        slug = "contact"
        icon = "fa-phone"
        items = @()
    }
)

# -----------------------------------------------------------------------------
# Page metadata mapping
# -----------------------------------------------------------------------------
$pagesList = @(
    @{ slug = "history"; enFile = "history-en.txt"; taFile = "history-ta.txt"; images = @("history-1.jpg", "history-2.jpg", "history-3.png", "history-4.png"); defaultEnTitle = "History"; defaultTaTitle = "வரலாறு" },
    @{ slug = "sub-periya"; enFile = "sub-periya-en.txt"; taFile = "sub-periya-ta.txt"; images = @("sub-periya.jpg"); defaultEnTitle = "Sub Station: Periyarikodi"; defaultTaTitle = "கிளைப்பங்கு: பெரிய ஏரிக்கோடி" },
    @{ slug = "sub-madhe"; enFile = "sub-madhe-en.txt"; taFile = "sub-madhe-ta.txt"; images = @("sub-madhe.png"); defaultEnTitle = "Sub Station: V. Madhepalli"; defaultTaTitle = "கிளைப்பங்கு: வி. மாதேபள்ளி" },
    @{ slug = "sub-oldpet"; enFile = "sub-oldpet-en.txt"; taFile = "sub-oldpet-ta.txt"; images = @("sub-oldpet.png"); defaultEnTitle = "Sub Station: Oldpet"; defaultTaTitle = "கிளைப்பங்கு: பழையபேட்டை" },
    @{ slug = "priest-parish"; enFile = "priest-parish-en.txt"; taFile = "priest-parish-ta.txt"; images = @(); defaultEnTitle = "List of Parish Priest"; defaultTaTitle = "பங்கு தந்தையர்கள்" },
    @{ slug = "priest-asst"; enFile = "priest-asst-en.txt"; taFile = "priest-asst-ta.txt"; images = @(); defaultEnTitle = "List of Asst. Parish Priest"; defaultTaTitle = "உதவி பங்கு தந்தையர்கள்" },
    @{ slug = "priest-native"; enFile = "priest-native-en.txt"; taFile = "priest-native-ta.txt"; images = @(); defaultEnTitle = "Priest From Our Parish"; defaultTaTitle = "நம் பங்கின் அருட்பணியாளர்கள்" },
    @{ slug = "sister-native"; enFile = "sister-native-en.txt"; taFile = "sister-native-ta.txt"; images = @(); defaultEnTitle = "Sisters From Our Parish"; defaultTaTitle = "நம் பங்கின் துறவற சகோதரிகள்" },
    @{ slug = "mass-reg"; enFile = "mass-reg-en.txt"; taFile = "mass-reg-ta.txt"; images = @("mass-reg.png"); defaultEnTitle = "Mass Regulation"; defaultTaTitle = "திருப்பலி ஒழுங்குமுறைகள்" },
    @{ slug = "parishioner"; enFile = "parishioner-en.txt"; taFile = "parishioner-ta.txt"; images = @("parishioner.png"); defaultEnTitle = "Parishioner"; defaultTaTitle = "பங்கு மக்கள்" },
    @{ slug = "catechism"; enFile = "catechism-en.txt"; taFile = "catechism-ta.txt"; images = @("catechism.png"); defaultEnTitle = "Sunday Catechism"; defaultTaTitle = "ஞாயிறு மறைக்கல்வி" },
    @{ slug = "anbiyam"; enFile = "anbiyam-en.txt"; taFile = "anbiyam-ta.txt"; images = @("anbiyam.png"); defaultEnTitle = "Anbiyam (BCC)"; defaultTaTitle = "அன்பியம் (BCC)" },
    @{ slug = "sac-baptism"; enFile = "sac-Baptism-en.txt"; taFile = "sac-Baptism-ta.txt"; images = @("sac-Baptism.png"); defaultEnTitle = "Sacraments: Baptism"; defaultTaTitle = "திருமுழுக்கு அருட்சாதனம்" },
    @{ slug = "sac-confirmation"; enFile = "sac-Confirmation-en.txt"; taFile = "sac-Confirmation-ta.txt"; images = @("sac-Confirmation.png"); defaultEnTitle = "Sacraments: Confirmation"; defaultTaTitle = "உறுதிப்பூசுதல் அருட்சாதனம்" },
    @{ slug = "sac-holy-communion"; enFile = "sac-Holy-Communion-en.txt"; taFile = "sac-Holy-Communion-ta.txt"; images = @("sac-Holy-Communion.jpeg", "sac-Holy-Communion-1.png", "sac-Holy-Communion-2.png", "sac-Holy-Communion-3.png"); defaultEnTitle = "Sacraments: Holy Communion"; defaultTaTitle = "நற்கருணை அருட்சாதனம்" },
    @{ slug = "sac-confession"; enFile = "sac-Confession-en.txt"; taFile = "sac-Confession-ta.txt"; images = @("sac-Confession.jpeg"); defaultEnTitle = "Sacraments: Confession"; defaultTaTitle = "ஒப்புரவு அருட்சாதனம்" },
    @{ slug = "sac-holy-orders"; enFile = "sac-Holy-Orders-en.txt"; taFile = "sac-Holy-Orders-ta.txt"; images = @("sac-Holy-Orders.png"); defaultEnTitle = "Sacraments: Holy Orders"; defaultTaTitle = "குருத்துவ அருட்சாதனம்" },
    @{ slug = "sac-marriage"; enFile = "sac-Marriage-en.txt"; taFile = "sac-Marriage-ta.txt"; images = @("sac-Marriage.png"); defaultEnTitle = "Sacraments: Marriage"; defaultTaTitle = "திருமண அருட்சாதனம்" },
    @{ slug = "sac-unction"; enFile = "sac-Unction-en.txt"; taFile = "sac-Unction-ta.txt"; images = @("sac-Unction.png"); defaultEnTitle = "Sacraments: Anointing of the Sick"; defaultTaTitle = "நோயில் பூசுதல் அருட்சாதனம்" },
    @{ slug = "rosary"; enFile = "Rosary-in-tamil-en.txt"; taFile = "Rosary-in-tamil-ta.txt"; images = @(); defaultEnTitle = "Rosary in Tamil"; defaultTaTitle = "ஜெபமாலை" },
    @{ slug = "assoc-board"; enFile = "assoc-board-en.txt"; taFile = "assoc-board-tn.txt"; images = @("assoc-board-1.png", "assoc-board-2.png", "assoc-treasurer.png"); defaultEnTitle = "Parish Board"; defaultTaTitle = "பங்கு பேரவை" },
    @{ slug = "assoc-altar"; enFile = "assoc-altar-en.txt"; taFile = "assoc-altar-ta.txt"; images = @("assoc-altar.png"); defaultEnTitle = "Altar Servers"; defaultTaTitle = "பீட சிறார்கள்" },
    @{ slug = "assoc-program"; enFile = "assoc-program-en.txt"; taFile = "assoc-program-ta.txt"; images = @("assoc-program.png"); defaultEnTitle = "Shrine Program Authority"; defaultTaTitle = "நிகழ்வு ஒருங்கிணைப்பு" },
    @{ slug = "assoc-choir"; enFile = "assoc-choir-en.txt"; taFile = "assoc-choir-ta.txt"; images = @("assoc-choir-1.png", "assoc-choir-2.png"); defaultEnTitle = "Choir"; defaultTaTitle = "பாடகர் குழு" },
    @{ slug = "assoc-flower"; enFile = "assoc-flower-en.txt"; taFile = "assoc-flower-ta.txt"; images = @("assoc-flower.png"); defaultEnTitle = "Flower Team"; defaultTaTitle = "மலர் குழு" },
    @{ slug = "assoc-media"; enFile = "assoc-media-en.txt"; taFile = "assoc-media-ta.txt"; images = @("assoc-media.jpg"); defaultEnTitle = "Media Ministry"; defaultTaTitle = "ஊடகப்பணி" },
    @{ slug = "org-vdp"; enFile = "org-vdp-en.txt"; taFile = "org-vdp-ta.txt"; images = @("org-vdp.png", "org-vdp-women.png"); defaultEnTitle = "Vincent De Paul"; defaultTaTitle = "வின்சென்ட் டி பவுல்" },
    @{ slug = "org-legion"; enFile = "org-legion-en.txt"; taFile = "org-legion-ta.txt"; images = @("org-legion-1.png", "org-legion-2.png", "org-legion-3.png", "org-legion-4.png"); defaultEnTitle = "Mariyan Seanai"; defaultTaTitle = "மரியாயின் சேனை" },
    @{ slug = "org-youth"; enFile = "org-youth-en.txt"; taFile = "org-youth-ta.txt"; images = @("org-youth.png"); defaultEnTitle = "St. Paul’s Youth"; defaultTaTitle = "புனித பவுல் இளைஞர் இயக்கம்" },
    @{ slug = "org-teachers"; enFile = "org-teachers-en.txt"; taFile = "org-teachers-ta.txt"; images = @("org-teachers.png"); defaultEnTitle = "Teachers Association"; defaultTaTitle = "ஆசிரியர்கள் சங்கம்" },
    @{ slug = "convent-fsmschool"; enFile = "convent-fsmschool-en.txt"; taFile = "convent-fsmschool-ta.txt"; images = @("convent-fsmschool.png"); defaultEnTitle = "FSM (School)"; defaultTaTitle = "எஃப்.எஸ்.எம் (பள்ளி)" },
    @{ slug = "convent-fsmhosp"; enFile = "convent-fsmhosp-en.txt"; taFile = "convent-fsmhosp-ta.txt"; images = @("convent-fsmhosp.jpg"); defaultEnTitle = "FSM (Hospital)"; defaultTaTitle = "எஃப்.எஸ்.எம் (மருத்துவமனை)" },
    @{ slug = "convent-fihm"; enFile = "convent-fihm-en.txt"; taFile = "convent-fihm-ta.txt"; images = @("convent-fihm.png"); defaultEnTitle = "FIHM"; defaultTaTitle = "எஃப்.ஐ.எச்.எம்" },
    @{ slug = "inst-rcprim"; enFile = "inst-rcprim-en.txt"; taFile = "inst-rcprim-ta.txt"; images = @("inst-rcprim.png"); defaultEnTitle = "R.C. Fatima Boys Primary"; defaultTaTitle = "ஆர்.சி. பாத்திமா தொடக்கப் பள்ளி" },
    @{ slug = "inst-rchigh"; enFile = "inst-rchigh-en.txt"; taFile = "inst-rchigh-ta.txt"; images = @("inst-rchigh.png"); defaultEnTitle = "R.C. Fatima Boys High"; defaultTaTitle = "ஆர்.சி. பாத்திமா உயர்நிலைப் பள்ளி" },
    @{ slug = "inst-db"; enFile = "inst-db-en.txt"; taFile = "inst-db-ta.txt"; images = @("inst-db.png"); defaultEnTitle = "Don Bosco School"; defaultTaTitle = "டான் போஸ்கோ பள்ளி" },
    @{ slug = "inst-annprim"; enFile = "inst-annprim-en.txt"; taFile = "inst-annprim-ta.txt"; images = @("inst-annprim.png"); defaultEnTitle = "St. Ann’s Aided Primary"; defaultTaTitle = "புனித அன்னாள் தொடக்கப் பள்ளி" },
    @{ slug = "inst-annhigh"; enFile = "inst-annhigh-en.txt"; taFile = "inst-annhigh-ta.txt"; images = @("inst-annhigh.png"); defaultEnTitle = "St. Ann’s Aided Hr. Sec."; defaultTaTitle = "புனித அன்னாள் மேல்நிலைப் பள்ளி" },
    @{ slug = "inst-annenurs"; enFile = "inst-annenurs-en.txt"; taFile = "inst-annenurs-ta.txt"; images = @("inst-annenurs.png"); defaultEnTitle = "St. Anne’s Nursery & Primary"; defaultTaTitle = "புனித அன்னாள் மழலையர் பள்ளி" },
    @{ slug = "inst-annecbse"; enFile = "inst-annecbse-en.txt"; taFile = "inst-annecbse-ta.txt"; images = @("inst-annecbse.png"); defaultEnTitle = "St. Anne’s CBSE Public"; defaultTaTitle = "புனித அன்னாள் சிபிஎஸ்இ பள்ளி" },
    @{ slug = "service-hall"; enFile = "service-hall-en.txt"; taFile = "service-hall-ta.txt"; images = @("service-hall.png"); defaultEnTitle = "Community Hall"; defaultTaTitle = "சமுதாயக் கூடம்" },
    @{ slug = "service-cemetery"; enFile = "service-cemetery-en.txt"; taFile = "service-cemetery-ta.txt"; images = @("service-cemetery.png"); defaultEnTitle = "Cemetery"; defaultTaTitle = "கல்லறைத் தோட்டம்" },
    @{ slug = "contact"; enFile = "contact-en.txt"; taFile = "contact-ta.txt"; images = @("contact-image-1.png", "contact-image-2.png", "contact-image-3.png", "contact-image-4.jpg"); defaultEnTitle = "Contact Us"; defaultTaTitle = "தொடர்புக்கு" }
)

# -----------------------------------------------------------------------------
# Function: Generate Header HTML
# -----------------------------------------------------------------------------
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

    # Navigation HTML building
    $navItemsHtml = ""
    $mobileNavItemsHtml = ""

    foreach ($menu in $navStructure) {
        $menuTitle = if ($lang -eq "ta") { $menu.ta } else { $menu.en }
        
        if ($menu.id -eq "home") {
            $homeUrl = if ($lang -eq "ta") { "index-ta.html" } else { "index.html" }
            $isActive = if ($isHome) { "active" } else { "" }
            $navItemsHtml += "
              <li class='nav-item-shrine $isActive'>
                <a href='$homeUrl' class='nav-link-shrine'><i class='fa $($menu.icon)'></i> $menuTitle</a>
              </li>"
            $mobileNavItemsHtml += "<li><a href='$homeUrl' style='font-weight: 700; color: var(--primary); display: block; padding: 6px 0;'><i class='fa $($menu.icon)'></i> $menuTitle</a></li>`n"
        }
        elseif ($menu.items.Count -eq 0) {
            # Single link (Gallery, Contact)
            $itemUrl = "$($menu.slug).html"
            $isActive = if ($currentSlug -eq $menu.slug) { "active" } else { "" }
            $navItemsHtml += "
              <li class='nav-item-shrine $isActive'>
                <a href='$itemUrl' class='nav-link-shrine'><i class='fa $($menu.icon)'></i> $menuTitle</a>
              </li>"
            $mobileNavItemsHtml += "<li><a href='$itemUrl' style='font-weight: 700; color: var(--primary); display: block; padding: 6px 0;'><i class='fa $($menu.icon)'></i> $menuTitle</a></li>`n"
        }
        else {
            # Has dropdown
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
                    # Nested sub-menu (Sacraments)
                    $subTitle = if ($lang -eq "ta") { $sub.ta } else { $sub.en }
                    $dropdownHtml += "
                      <li class='dropdown-submenu-shrine'>
                        <a href='#' class='dropdown-item-shrine'>$subTitle <i class='fa fa-angle-right'></i></a>
                        <ul class='dropdown-menu-sub'>"
                    
                    $mobileSubHtml += "<li style='font-weight: 700; color: var(--secondary); padding: 4px 0 2px 0;'>$subTitle:</li>`n"

                    foreach ($ssub in $sub.subitems) {
                        $ssubTitle = if ($lang -eq "ta") { $ssub.ta } else { $ssub.en }
                        $ssubUrl = "$($ssub.slug).html"
                        $isSubActive = if ($currentSlug -eq $ssub.slug) { "active" } else { "" }
                        $dropdownHtml += "<li><a href='$ssubUrl' class='dropdown-item-shrine $isSubActive'>$ssubTitle</a></li>"
                        $mobileSubHtml += "<li style='padding-left: 10px;'><a href='$ssubUrl' style='color: #475569; display: block; padding: 3px 0;'>$ssubTitle</a></li>`n"
                    }
                    $dropdownHtml += "</ul></li>"
                }
                else {
                    $subTitle = if ($lang -eq "ta") { $sub.ta } else { $sub.en }
                    $subUrl = "$($sub.slug).html"
                    $isSubActive = if ($currentSlug -eq $sub.slug) { "active" } else { "" }
                    $dropdownHtml += "<li><a href='$subUrl' class='dropdown-item-shrine $isSubActive'>$subTitle</a></li>"
                    $mobileSubHtml += "<li><a href='$subUrl' style='color: #475569; display: block; padding: 4px 0;'>$subTitle</a></li>`n"
                }
            }

            $navItemsHtml += "
              <li class='nav-item-shrine $parentActiveCls'>
                <a href='#' class='nav-link-shrine'>$menuTitle <i class='fa fa-angle-down'></i></a>
                <ul class='dropdown-menu-shrine'>
                  $dropdownHtml
                </ul>
              </li>"

            $mobileNavItemsHtml += "
              <li class='mobile-nav-item'>
                <a href='#' class='mobile-dropdown-toggle' style='font-weight: 700; color: var(--primary); display: flex; justify-content: space-between; padding: 6px 0;'>$menuTitle <i class='fa fa-angle-down'></i></a>
                <ul class='mobile-submenu' style='display: none; list-style: none; padding-left: 15px; margin: 5px 0;'>
                  $mobileSubHtml
                </ul>
              </li>"
        }
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

  <!-- ==================== TOP HEADER AREA ==================== -->
  <header class="top-header-area">
    <div class="container">
      <div class="top-header-content">
        <div class="top-header-left">
          <button type="button" class="btn-top-mass" data-open-modal="massTimingsModal" title="Click to view all mass timings">
            <i class="fa fa-clock-o"></i> <strong>$topMassText</strong>
          </button>
        </div>
        <div class="top-header-right">
          <button type="button" class="btn-mass-booking" data-open-modal="massBookingModal">
            <i class="fa fa-calendar-check-o"></i> $massBookingText
          </button>
          <button type="button" class="btn-donation" data-open-modal="donationModal">
            <i class="fa fa-heart"></i> $donationText
          </button>
          <!-- Dual Language Toggle -->
          <a class="lang-toggle" href="$toggleHref" title="Switch Language">
            <i class="fa fa-language"></i> $toggleText
          </a>
          <div class="social-links-top">
            <a href="https://www.youtube.com/@OurLadyOfFatimaShrine" target="_blank" rel="noopener" title="YouTube"><i class="fa fa-youtube-play"></i></a>
            <a href="https://facebook.com" target="_blank" rel="noopener" title="Facebook"><i class="fa fa-facebook"></i></a>
            <a href="https://instagram.com" target="_blank" rel="noopener" title="Instagram"><i class="fa fa-instagram"></i></a>
            <a href="https://wa.me/917856494674" target="_blank" rel="noopener" title="WhatsApp"><i class="fa fa-whatsapp"></i></a>
          </div>
        </div>
      </div>
    </div>
  </header>

  <!-- ==================== BRAND HEADER AREA ==================== -->
  <section class="brand-header-area">
    <div class="container">
      <div class="brand-header-grid">
        <!-- 1. Pope Photo -->
        <div class="dignitary-card">
          <div class="dignitary-photo-wrap" title="$popeName">
            <img src="${prefix}images/pope-photo.png" alt="$popeName">
          </div>
          <div class="dignitary-info">
            <span class="dignitary-role">$popeRole</span>
            <span class="dignitary-name">$popeName</span>
            <span class="dignitary-sub">Vatican</span>
          </div>
        </div>

        <!-- 2. Shrine Center Logo & Title -->
        <div class="brand-center-title">
          <a href="$(if ($lang -eq 'ta') { 'index-ta.html' } else { 'index.html' })" title="$shrineEnglishTitle">
            <img src="${prefix}images/Church-logo.png" alt="Fatima Shrine Logo" class="shrine-main-logo">
          </a>
          <div class="brand-text-block">
            <span class="shrine-tamil-title">$shrineTamilTitle</span>
            <h1 class="shrine-english-title">$shrineEnglishTitle</h1>
            <span class="shrine-location-subtitle">$shrineLocation</span>
            <span class="shrine-diocese-pill">$shrineAffiliation</span>
          </div>
        </div>

        <!-- 3. Bishop & Parish Priest Photos -->
        <div class="dignitaries-row-mobile">
          <div class="dignitary-card">
            <div class="dignitary-photo-wrap" title="$bishopName">
              <img src="${prefix}images/Bishop-Photo.png" alt="$bishopName">
            </div>
            <div class="dignitary-info">
              <span class="dignitary-role">$bishopRole</span>
              <span class="dignitary-name">$bishopName</span>
              <span class="dignitary-sub">Dharmapuri</span>
            </div>
          </div>

          <div class="dignitary-card">
            <div class="dignitary-photo-wrap" title="$priestName">
              <img src="${prefix}images/Parish-Priest-Photo.png" alt="$priestName">
            </div>
            <div class="dignitary-info">
              <span class="dignitary-role">$priestRole</span>
              <span class="dignitary-name">$priestName</span>
              <span class="dignitary-sub">Krishnagiri</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ==================== MOBILE NAVIGATION BAR ==================== -->
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

  <!-- ==================== MAIN DESKTOP NAVIGATION ==================== -->
  <nav class="main-navbar-area">
    <div class="container">
      <div class="navbar-shrine">
        <ul class="navbar-nav-shrine">
          $navItemsHtml
        </ul>
      </div>
    </div>
  </nav>

  <!-- ==================== MOBILE OFFCANVAS DRAWER ==================== -->
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
        $mobileNavItemsHtml
      </ul>
    </div>
  </div>
"@
}

# -----------------------------------------------------------------------------
# Function: Generate Footer HTML
# -----------------------------------------------------------------------------
function Get-FooterHtml($lang, $isHome = $false) {
    $prefix = if ($lang -eq "ta") { "../" } else { "" }
    $homeUrl = if ($lang -eq "ta") { "index-ta.html" } else { "index.html" }
    
    $aboutTitle = if ($lang -eq "ta") { "பாத்திமா அன்னை திருத்தலம்" } else { "Our Lady of Fatima Shrine" }
    $aboutText = if ($lang -eq "ta") { 
        "1972-இல் நிறுவப்பட்டு தருமபுரி மறைமாவட்டத்தின் கீழ் இயங்கிவரும் அருள்மிகு திருத்தலம். போர்ச்சுகல் நாட்டின் பாத்திமா நகரிலிருந்து கொண்டுவரப்பட்ட அன்னை மரியாவின் திருவுருவச் சிலையுடன் இறைமக்கள் அனைவருக்கும் அருளும் அமைதியும் வழங்கி வருகிறது." 
    } else { 
        "A venerable Roman Catholic shrine established in 1972 under the Diocese of Dharmapuri. Blessed with the miraculous Fatima statue brought from Fátima, Portugal, offering peace, healing, and prayer to all devotees." 
    }
    
    $usefulLinksTitle = if ($lang -eq "ta") { "பயனுள்ள இணைப்புகள்" } else { "Useful Links" }
    $massTimingsTitle = if ($lang -eq "ta") { "திருப்பலி நேரங்கள்" } else { "Mass Timings" }
    $officeTitle = if ($lang -eq "ta") { "திருத்தல அலுவலகம்" } else { "Shrine Office" }
    $readHistoryText = if ($lang -eq "ta") { "முழு வரலாறு படிக்க" } else { "Read Full History" }

    return @"
  <!-- ==================== FOOTER MAIN AREA ==================== -->
  <footer class="footer-main-area">
    <div class="container">
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 30px;">
        <!-- Col 1: About Shrine -->
        <div>
          <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 15px;">
            <img src="${prefix}images/Church-logo.png" alt="Fatima Shrine Logo" style="height: 48px;">
            <div>
              <h4 style="color: #ffffff; font-size: 1.05rem; margin: 0;">$aboutTitle</h4>
              <span style="color: var(--gold); font-size: 0.8rem; font-weight: 600;">Krishnagiri - 635001</span>
            </div>
          </div>
          <p style="font-size: 0.88rem; line-height: 1.7; color: #94a3b8;">
            $aboutText
          </p>
          <div style="margin-top: 15px;">
            <a href="history.html" style="color: var(--gold); font-size: 0.85rem; font-weight: 600;"><i class="fa fa-chevron-circle-right"></i> $readHistoryText</a>
          </div>
        </div>

        <!-- Col 2: Useful Links (Wired) -->
        <div>
          <h4 class="footer-widget-title">$usefulLinksTitle</h4>
          <ul class="footer-links-list">
            <li><a href="$homeUrl"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'முகப்பு' } else { 'Home' })</a></li>
            <li><a href="history.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'வரலாறு' } else { 'History' })</a></li>
            <li><a href="priest-parish.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'பங்கு தந்தையர்கள்' } else { 'List of Parish Priests' })</a></li>
            <li><a href="mass-reg.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'திருப்பலி ஒழுங்குமுறைகள்' } else { 'Mass Regulations' })</a></li>
            <li><a href="sac-baptism.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'திருவருட்சாதனங்கள்' } else { 'Holy Sacraments' })</a></li>
            <li><a href="rosary.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'ஜெபமாலை' } else { 'Holy Rosary' })</a></li>
            <li><a href="gallery.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'புகைப்பட தொகுப்பு' } else { 'Gallery' })</a></li>
            <li><a href="contact.html"><i class="fa fa-angle-right"></i> $(if ($lang -eq 'ta') { 'தொடர்புக்கு' } else { 'Contact Us' })</a></li>
          </ul>
        </div>

        <!-- Col 3: Mass Timings -->
        <div>
          <h4 class="footer-widget-title">$massTimingsTitle</h4>
          <div style="font-size: 0.86rem; color: #94a3b8; line-height: 1.8;">
            <div style="border-bottom: 1px dashed rgba(255,255,255,0.15); padding-bottom: 6px; margin-bottom: 6px;">
              <strong style="color: #ffffff;">$(if ($lang -eq 'ta') { 'ஞாயிறு திருப்பலிகள்:' } else { 'Sunday Masses:' })</strong><br>
              06:00 AM (Tamil) | 07:30 AM (Tamil)<br>
              09:00 AM (English) | 06:00 PM (Tamil & Novena)
            </div>
            <div style="border-bottom: 1px dashed rgba(255,255,255,0.15); padding-bottom: 6px; margin-bottom: 6px;">
              <strong style="color: #ffffff;">$(if ($lang -eq 'ta') { 'வாரநாட்கள் திருப்பலி:' } else { 'Daily Weekday Masses:' })</strong><br>
              Morning 06:00 AM | Evening 06:00 PM
            </div>
            <div>
              <strong style="color: var(--gold);">$(if ($lang -eq 'ta') { 'மாதாந்திர 13-ஆம் நாள்:' } else { 'Every 13th of Month:' })</strong><br>
              05:30 PM Fatima Car Procession, Rosary & Mass
            </div>
          </div>
        </div>

        <!-- Col 4: Contact & Flag Counter + Google Map -->
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

          <!-- Flag Counter -->
          <div class="flag-counter-box">
            <div style="font-size: 0.76rem; font-weight: 700; color: var(--gold); text-transform: uppercase;">
              <i class="fa fa-globe"></i> Shrine Visitors Counter
            </div>
            <div class="flag-grid-items">
              <div class="flag-item-box"><span>🇮🇳 India</span> <strong>54.8K</strong></div>
              <div class="flag-item-box"><span>🇺🇸 USA</span> <strong>6.2K</strong></div>
              <div class="flag-item-box"><span>🇸🇬 Singapore</span> <strong>4.3K</strong></div>
              <div class="flag-item-box"><span>🇲🇾 Malaysia</span> <strong>3.2K</strong></div>
            </div>
          </div>

          <!-- Google Map Embed -->
          <div class="map-frame-box" style="margin-top: 12px; height: 120px;">
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
          Maintained by <strong>St. Paul's Youth</strong>, Our Lady of Fatima Shrine.
        </div>
      </div>
    </div>
  </footer>

  <!-- ==================== MODALS ==================== -->
  <!-- 1. Mass Booking Modal -->
  <div id="massBookingModal" class="modal-shrine-backdrop">
    <div class="card" style="max-width: 500px; width: 90%; margin: 20px;">
      <div class="card-header-shrine">
        <h3 class="card-header-title"><i class="fa fa-calendar-check-o"></i> $(if ($lang -eq 'ta') { 'திருப்பலி கருத்து பதிவு' } else { 'Mass Intention Booking' })</h3>
        <button type="button" data-close-modal style="background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
      </div>
      <p>$(if ($lang -eq 'ta') { 'திருப்பலி கருத்துக்களை பதிவு செய்ய பங்கு அலுவலகத்தை நேரில் தொடர்பு கொள்ளவும் அல்லது கீழே உள்ள எண்ணை அழைக்கவும்:' } else { 'To book Holy Mass intentions for thanksgiving, birthdays, or departed souls, please contact the shrine office directly:' })</p>
      <div style="background: #f8fafc; padding: 15px; border-radius: 8px; border-left: 3px solid var(--gold); margin-bottom: 15px;">
        <strong>Shrine Office:</strong> 04343 - 236836<br>
        <strong>Email:</strong> fathimashrine.kgri@gmail.com<br>
        <strong>Parish In-charge:</strong> 8892754270 (WhatsApp: 7856494674)
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
        <h4 style="color: var(--primary); margin: 8px 0 4px 0;">Sunday Masses:</h4>
        <p style="margin-bottom: 10px;">06:00 AM (Tamil), 07:30 AM (Tamil), 09:00 AM (English), 06:00 PM (Tamil & Novena)</p>
        <h4 style="color: var(--primary); margin: 8px 0 4px 0;">Daily Masses:</h4>
        <p style="margin-bottom: 10px;">Monday to Saturday: Morning 06:00 AM | Evening 06:00 PM</p>
        <h4 style="color: var(--primary); margin: 8px 0 4px 0;">Monthly 13th Devotion:</h4>
        <p style="margin-bottom: 10px;">05:30 PM Fatima Car Procession, Rosary, Benediction and Solemn Pontifical Mass.</p>
      </div>
      <button type="button" class="btn-read-more" data-close-modal style="margin-top: 15px; width: 100%; justify-content: center;">Close</button>
    </div>
  </div>

  <!-- 4. Announcement Detail Modal -->
  <div id="announcementModal" class="modal-shrine-backdrop">
    <div class="card" style="max-width: 550px; width: 90%; margin: 20px;">
      <div class="card-header-shrine">
        <h3 class="card-header-title" id="annModalTitle">Notice</h3>
        <button type="button" data-close-modal style="background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
      </div>
      <div style="font-size: 0.8rem; color: var(--secondary); font-weight: 700; margin-bottom: 10px;" id="annModalDate"></div>
      <p id="annModalDesc" style="font-size: 0.92rem; line-height: 1.7; color: #334155;"></p>
      <button type="button" class="btn-read-more" data-close-modal style="margin-top: 15px; width: 100%; justify-content: center;">Close</button>
    </div>
  </div>

  <!-- Toast Container -->
  <div id="toast"></div>

  <!-- Scripts -->
  <script src="${prefix}main.js"></script>
</body>
</html>
"@
}

# -----------------------------------------------------------------------------
# Function: Convert Text Content to Clean HTML
# -----------------------------------------------------------------------------
function Convert-ContentToHtml($txtContent, $slug, $lang, $prefix) {
    $lines = $txtContent -split "`r?`n"
    $html = ""
    $firstH1 = $true
    $inTable = $false
    $tableContent = ""
    $inList = $false

    foreach ($rawLine in $lines) {
        $line = $rawLine.Trim()
        
        # Check for HTML table blocks
        if ($line -match "<table") {
            $inTable = $true
            $tableContent = $line + "`n"
            continue
        }
        if ($inTable) {
            $tableContent += $line + "`n"
            if ($line -match "</table>") {
                $inTable = $false
                # Wrap table in responsive div and add classes
                $tableStyled = $tableContent -replace "<table\s*>", "<div class='table-responsive'><table class='table-shrine'>"
                $tableStyled = $tableStyled -replace "</table>", "</table></div>"
                $html += $tableStyled + "`n"
                $tableContent = ""
            }
            continue
        }

        if ($line -eq "") {
            if ($inList) {
                $html += "</ul>`n"
                $inList = $false
            }
            continue
        }

        # Heading 1 (The first line starting with #)
        if ($line -match "^#\s*(.*)$") {
            $title = $Matches[1].Trim()
            if ($firstH1) {
                $html += "  <h1 style='color: var(--warm-brown);'>$title</h1>`n"
                $firstH1 = $false
            } else {
                $html += "  <h2>$title</h2>`n"
            }
            continue
        }

        # Heading 2
        if ($line -match "^##\s*(.*)$") {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $h2 = $Matches[1].Trim()
            $html += "  <h2>$h2</h2>`n"
            continue
        }

        # Heading 3
        if ($line -match "^###\s*(.*)$") {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $h3 = $Matches[1].Trim()
            $html += "  <h3>$h3</h3>`n"
            continue
        }

        # Blockquote (quoted text starting with " or > or “)
        if ($line.StartsWith(">") -or ($line.StartsWith('"') -and $line.EndsWith('"')) -or ($line.StartsWith('“') -and $line.EndsWith('”'))) {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $cleanQuote = $line.TrimStart('>').Trim('"', '“', '”').Trim()
            $html += "  <blockquote><p>$cleanQuote</p></blockquote>`n"
            continue
        }

        # Bullet list item
        if ($line -match "^[-*•]\s+(.*)$") {
            if (-not $inList) {
                $html += "  <ul>`n"
                $inList = $true
            }
            $itemText = $Matches[1].Trim()
            # Replace bold markdown **text**
            $itemText = $itemText -replace "\*\*(.*?)\*\*", "<strong>`$1</strong>"
            $html += "    <li>$itemText</li>`n"
            continue
        }

        # Image tag in text: [image : history-4.png] or <contact-image-1.png>
        if ($line -match "\[image\s*:\s*([^\]]+)\]" -or $line -match "<(contact-image-[^>]+)>") {
            if ($inList) { $html += "</ul>`n"; $inList = $false }
            $imgName = $Matches[1].Trim()
            if (-not ($imgName -match "\.(png|jpg|jpeg|gif)$")) {
                # Add extension if missing
                if (Test-Path "images\$imgName.png") { $imgName = "$imgName.png" }
                elseif (Test-Path "images\$imgName.jpg") { $imgName = "$imgName.jpg" }
                elseif (Test-Path "images\$imgName.jpeg") { $imgName = "$imgName.jpeg" }
            }
            # Normalize contact-image-4.png to contact-image-4.jpg
            if ($imgName -eq "contact-image-4.png" -and -not (Test-Path "images\contact-image-4.png")) {
                $imgName = "contact-image-4.jpg"
            }
            $html += "  <div style='text-align: center; margin: 20px 0;'><img src='${prefix}images/$imgName' alt='$imgName' class='content-img'></div>`n"
            continue
        }

        # Regular paragraph
        if ($inList) {
            $html += "</ul>`n"
            $inList = $false
        }

        # Replace markdown bold **text**
        $pText = $line -replace "\*\*(.*?)\*\*", "<strong>`$1</strong>"
        $html += "  <p>$pText</p>`n"
    }

    if ($inList) { $html += "</ul>`n" }
    return $html
}

# -----------------------------------------------------------------------------
# Function: Generate Rosary Special Page
# -----------------------------------------------------------------------------
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

    function Format-DecadesHtml($decades) {
        $out = "<ul class='decade-list'>`n"
        foreach ($d in $decades) {
            $out += "  <li class='decade-item'><i class='fa fa-circle-o' style='color: var(--gold); margin-right: 6px;'></i> $d</li>`n"
        }
        $out += "</ul>`n"
        return $out
    }

    $content = @"
  <main class="section-padding">
    <div class="container">
      <div class="card">
        <h1 style="color: var(--warm-brown);">$title</h1>
        
        <!-- Opening Prayers -->
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
          $(Format-DecadesHtml $joyfulDecades)
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
          $(Format-DecadesHtml $luminousDecades)
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
          $(Format-DecadesHtml $sorrowfulDecades)
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
          $(Format-DecadesHtml $gloriousDecades)
        </div>

      </div>
    </div>
  </main>

  <!-- Rosary Dynamic Switcher Script -->
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
        // Scroll smoothly to active mystery
        targetBlock.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }
    });
  </script>
"@

    return $header + $content + $footer
}

# -----------------------------------------------------------------------------
# Function: Generate Contact Us Special Page
# -----------------------------------------------------------------------------
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
            <div style="background: #ffffff; padding: 10px; border-radius: 6px; border: 1px solid var(--border); font-size: 0.88rem;">
              <strong>Parish Query Helpline:</strong><br>
              Yesudass: 8892754270 (WhatsApp: 7856494674)<br>
              Seemon: 8220486557
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
          <h2 style="color: var(--primary); margin-bottom: 15px;"><i class="fa fa-map" style="color: var(--secondary);"></i> Google Map Location</h2>
          <div style="width: 100%; height: 350px; border-radius: 10px; overflow: hidden; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
            <iframe src="https://maps.google.com/maps?q=Our%20Lady%20of%20Fatima%20Shrine,%20Bangalore%20Road,%20Krishnagiri&t=&z=15&ie=UTF8&iwloc=&output=embed" style="width: 100%; height: 100%; border: 0;" loading="lazy" title="Fatima Shrine Map"></iframe>
          </div>
        </div>

      </div>
    </div>
  </main>
"@

    return $header + $content + $footer
}

# -----------------------------------------------------------------------------
# Function: Generate Gallery Page
# -----------------------------------------------------------------------------
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
        @{ file = "assoc-choir-1.png"; alt = "Shrine Holy Rosary & Liturgical Youth Choir Krishnagiri" },
        @{ file = "assoc-choir-2.png"; alt = "Fatima Shrine Choir Festal Carol & Music Ministry Krishnagiri" },
        @{ file = "assoc-flower.png"; alt = "Altar Flower Decoration & Liturgical Arrangement Team" },
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

# -----------------------------------------------------------------------------
# Function: Generate Index / Home Page
# -----------------------------------------------------------------------------
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

    $aboutHeader = if ($lang -eq "ta") { "கிருஷ்ணகிரி பாத்திமா அன்னை திருத்தலம் - உங்களை அன்புடன் வரவேற்கிறது" } else { "WELCOME TO OUR LADY OF FATIMA SHRINE - KRISHNAGIRI" }
    $announcementsHeader = if ($lang -eq "ta") { "அறிவிப்புகள்" } else { "Announcements" }
    $latestMassHeader = if ($lang -eq "ta") { "சமீபத்திய திருப்பலி" } else { "Latest Mass Video" }
    $specialMassHeader = if ($lang -eq "ta") { "சிறப்பு திருப்பலிகள்" } else { "Special Mass Timings" }
    $shortsHeader = if ($lang -eq "ta") { "தினசரி நற்செய்தி சிந்தனை & ரீல்ஸ்" } else { "Daily Reels & Shorts" }
    $bankHeader = if ($lang -eq "ta") { "வங்கி விவரங்கள் & காணிக்கை" } else { "Bank Details & Offerings" }
    $calendarHeader = if ($lang -eq "ta") { "வழிபாட்டு நாட்காட்டி (7 நாட்கள்)" } else { "Liturgical Calendar (7-Day Schedule)" }

    $content = @"
  <!-- ==================== HERO SLIDER BANNER ==================== -->
  <section class="hero-slider-area">
    <div class="hero-slider-container">
      <!-- Slide 1 -->
      <div class="hero-slide active">
        <img src="${prefix}images/Banner-1.png" alt="Our Lady of Fatima Shrine Krishnagiri Altar" class="hero-slide-bg">
        <div class="hero-slide-overlay">
          <div class="hero-slide-caption">
            <span class="card-badge" style="margin-bottom: 10px; display: inline-block;">$(if ($lang -eq 'ta') { 'அன்னை மரியாளின் அருட்கொடை' } else { 'Grace & Devotion' })</span>
            <h2 class="hero-caption-title">$heroTitle1</h2>
            <p class="hero-caption-subtitle">$heroSub1</p>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
              <button type="button" class="btn-mass-booking" data-open-modal="massBookingModal" style="padding: 9px 20px; font-size: 0.9rem;">
                <i class="fa fa-calendar-check-o"></i> $(if ($lang -eq 'ta') { 'திருப்பலி பதிவு' } else { 'Book Mass Intention' })
              </button>
              <button type="button" class="btn-top-mass" data-open-modal="massTimingsModal" style="padding: 9px 20px; font-size: 0.9rem; background: rgba(255,255,255,0.25);">
                <i class="fa fa-clock-o"></i> $(if ($lang -eq 'ta') { 'திருப்பலி நேரங்கள்' } else { 'Mass Timings' })
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 2 -->
      <div class="hero-slide">
        <img src="${prefix}images/Banner-2.png" alt="Our Lady of Fatima Shrine Krishnagiri Front View" class="hero-slide-bg">
        <div class="hero-slide-overlay">
          <div class="hero-slide-caption">
            <span class="card-badge" style="margin-bottom: 10px; display: inline-block;">$(if ($lang -eq 'ta') { 'பொன்விழா திருத்தலம் (1972)' } else { 'Golden Jubilee Shrine' })</span>
            <h2 class="hero-caption-title">$heroTitle2</h2>
            <p class="hero-caption-subtitle">$heroSub2</p>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
              <a href="history.html" class="btn-read-more" style="margin-top: 0; padding: 9px 20px; font-size: 0.9rem;">
                $(if ($lang -eq 'ta') { 'வரலாறு அறிக' } else { 'Explore Shrine History' }) <i class="fa fa-arrow-right"></i>
              </a>
              <button type="button" class="btn-donation" data-open-modal="donationModal" style="padding: 9px 20px; font-size: 0.9rem;">
                <i class="fa fa-heart"></i> $(if ($lang -eq 'ta') { 'நன்கொடை' } else { 'Make a Donation' })
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Controls -->
    <div class="slider-controls">
      <button type="button" class="btn-slider-arrow btn-slider-prev" aria-label="Previous Slide"><i class="fa fa-chevron-left"></i></button>
      <button type="button" class="btn-slider-arrow btn-slider-next" aria-label="Next Slide"><i class="fa fa-chevron-right"></i></button>
    </div>
  </section>

  <!-- ==================== FLASH NEWS TICKER ==================== -->
  <section class="flash-news-bar">
    <div class="flash-news-container">
      <div class="flash-news-badge">
        <i class="fa fa-bolt"></i> Flash News
      </div>
      <div class="flash-news-marquee-wrap">
        <div class="flash-news-track">
          <div class="flash-item" onclick="openAnnouncement('ஞாயிறு பங்கு பேரவை கூட்டம்', 'Monthly 2nd Sunday', 'கிருஷ்ணகிரி பாத்திமா அன்னை திருத்தல பங்கு பேரவை கூட்டம் மாதந்தோறும் பங்கு மன்ற அரங்கில் நடைபெறும்.')">
            <span class="flash-item-badge">Meeting</span>
            <span>ஞாயிறு பங்கு பேரவை கூட்டம் - Parish Council Meeting</span>
          </div>
          <div class="flash-item" onclick="openAnnouncement('Daily Holy Mass Timings', 'Regular', 'Main Shrine Masses: Daily 6:00 AM & 6:00 PM. Sundays: 6:00 AM, 7:30 AM, 9:00 AM, 6:00 PM.')">
            <span class="flash-item-badge">Mass</span>
            <span>Daily Holy Masses: 6:00 AM & 6:00 PM | Sundays: 6:00 AM, 7:30 AM, 9:00 AM, 6:00 PM</span>
          </div>
          <div class="flash-item" onclick="openAnnouncement('Monthly 13th Fatima Car Procession', '13th of Every Month', 'Monthly 13th Day: 5:30 PM Holy Rosary, Candlelight Car Procession, Novena and Solemn Holy Mass.')">
            <span class="flash-item-badge">Devotion</span>
            <span>Every 13th: 5:30 PM Fatima Car Procession, Rosary & Benediction</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ==================== 7 HOMEPAGE GRIDS ==================== -->
  <main class="section-padding">
    <div class="container">
      
      <!-- ROW 1: Grid 1 (About Shrine) & Grid 2 (Announcements) -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px; margin-bottom: 25px;">
        
        <!-- Grid 1: About Shrine -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-church" style="color: var(--secondary);"></i> $aboutHeader</h3>
            <span class="card-badge">Est. 1972</span>
          </div>
          <p style="font-size: 0.94rem; line-height: 1.75; color: #334155;">
            $(if ($lang -eq 'ta') {
                "கிருஷ்ணகிரி பாத்திமா அன்னை திருத்தலம் தமிழ்நாடு தருமபுரி மறைமாவட்டத்தில் அமைந்துள்ள ஒரு பிரசித்தி பெற்ற கத்தோலிக்க திருத்தலமாகும். 1972-இல் பெங்களூர் பிரதான சாலையில் புதிய ஆலயமாக நிறுவப்பட்ட இத்திருத்தலம், 850-க்கும் மேற்பட்ட குடும்பங்களைக் கொண்டு மறைமாவட்டத்தின் மிகப்பெரிய பங்குகளுள் ஒன்றாகத் திகழ்கிறது."
            } else {
                "Our Lady of Fatima Shrine stands as a revered Roman Catholic church, nestled in the heart of Krishnagiri town in Tamil Nadu, India. Affiliated with the Dharmapuri Diocese, this parish boasts over 850 families, making it one of the largest and most active Catholic communities in the region."
            })
          </p>
          <p style="font-size: 0.94rem; line-height: 1.75; color: #334155;">
            $(if ($lang -eq 'ta') {
                "போர்ச்சுகல் நாட்டின் பாத்திமா நகரில் ஆசீர்வதிக்கப்பட்டு கொண்டுவரப்பட்ட அன்னை மரியாவின் திருவுருவச் சிலை இவ்வாலயத்திற்கு தனித்துவமான ஆன்மீக அருளைச் சேர்க்கிறது. ஆண்டுதோறும் ஜூலை 13-க்கு அடுத்த ஞாயிற்றுக்கிழமை நடைபெறும் ஆண்டுத் திருவிழா கிருஷ்ணகிரி நகரின் புகழ்பெற்ற விழாவாகும்."
            } else {
                "The church is spiritually blessed by the sacred statue of Our Lady of Fatima brought directly from Fátima, Portugal. The annual feast celebrated with a grand candlelight car procession on the Sunday after July 13 is renowned across the state."
            })
          </p>
          <a href="history.html" class="btn-read-more">$(if ($lang -eq 'ta') { 'முழு வரலாறு வாசிக்க' } else { 'Read More' }) <i class="fa fa-angle-right"></i></a>
        </div>

        <!-- Grid 2: Announcements -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-bullhorn" style="color: #f59e0b;"></i> $announcementsHeader</h3>
            <span class="card-badge">Notice Board</span>
          </div>
          <ul class="announcement-list">
            <li class="announcement-item" onclick="openAnnouncement('மாதாந்திர 13-ஆம் நாள் பாத்திமா தேர்பவனி & நவநாள்', '13-11-2026', 'ஒவ்வொரு மாதமும் 13-ஆம் நாள் மாலை 5:30 மணிக்கு பாத்திமா அன்னை திருவுருவ பவனி, செபமாலை மற்றும் சிறப்புத் திருப்பலி நிறைவேற்றப்படும்.')">
              <div class="announcement-item-top">
                <span class="announcement-date-pill"><i class="fa fa-calendar"></i> Monthly 13th</span>
                <span style="font-size: 0.72rem; color: #16a34a; font-weight: 700;">Active</span>
              </div>
              <h4 class="announcement-title-link">மாதாந்திர 13-ஆம் நாள் பாத்திமா தேர்பவனி & நவநாள்</h4>
              <p class="announcement-snippet">Monthly Fatima Car Procession, Rosary, Benediction and Solemn Mass.</p>
            </li>

            <li class="announcement-item" onclick="openAnnouncement('ஞாயிறு மறைக்கல்வி மற்றும் விவிலிய வினாடி வினா', 'Weekly Sunday', 'ஒவ்வொரு ஞாயிற்றுக்கிழமையும் காலை 7:30 மணி திருப்பலிக்கு பின் பங்கு சிறுவர் சிறுமியருக்கான மறைக்கல்வி வகுப்புகள் சிறப்பாக நடைபெறுகின்றன.')">
              <div class="announcement-item-top">
                <span class="announcement-date-pill"><i class="fa fa-calendar"></i> Sundays</span>
                <span style="font-size: 0.72rem; color: #2563eb; font-weight: 700;">Catechism</span>
              </div>
              <h4 class="announcement-title-link">Sunday Catechism & Faith Formation Classes</h4>
              <p class="announcement-snippet">Weekly Sunday classes following 7:30 AM Holy Mass.</p>
            </li>

            <li class="announcement-item" onclick="openAnnouncement('பங்கு பேரவை மாதாந்திர கலந்தாய்வு கூட்டம்', '2nd Sunday', 'பாத்திமா அன்னை திருத்தல மாதாந்திர பங்கு பேரவை கூட்டம் பங்குத்தந்தை தலைமையில் பங்கு மன்ற அரங்கில் கூடுகிறது.')">
              <div class="announcement-item-top">
                <span class="announcement-date-pill"><i class="fa fa-calendar"></i> 2nd Sunday</span>
                <span style="font-size: 0.72rem; color: #9333ea; font-weight: 700;">Meeting</span>
              </div>
              <h4 class="announcement-title-link">Parish Pastoral Council Meeting</h4>
              <p class="announcement-snippet">Monthly council meeting at parish conference hall.</p>
            </li>
          </ul>
        </div>

      </div>

      <!-- ROW 2: Grid 3 (Main Video), Grid 4 (Special Mass), Grid 5 (YouTube Shorts) -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 25px;">
        
        <!-- Grid 3: Main YouTube Video -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-youtube-play" style="color: #ff0000;"></i> $latestMassHeader</h3>
            <span class="card-badge" style="background: #ff0000; color: #fff;">YouTube</span>
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
            <a href="https://www.youtube.com/@OurLadyOfFatimaShrine" target="_blank" rel="noopener" style="background: #ff0000; color: #fff; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: 700;">Subscribe</a>
          </div>
        </div>

        <!-- Grid 4: Special Mass -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-star" style="color: var(--gold);"></i> $specialMassHeader</h3>
            <span class="card-badge">Timings</span>
          </div>
          <div class="special-mass-list">
            <div class="special-mass-item">
              <div class="special-mass-title">Christmas Night Vigil Mass (கிறிஸ்துமஸ் இரவுத் திருப்பலி)</div>
              <div class="special-mass-meta">
                <span><i class="fa fa-calendar"></i> 24-Dec-2026</span>
                <span><i class="fa fa-clock-o"></i> 11:00 PM</span>
              </div>
            </div>
            <div class="special-mass-item">
              <div class="special-mass-title">Christmas Day Festal Mass (கிறிஸ்துமஸ் பெருவிழா திருப்பலி)</div>
              <div class="special-mass-meta">
                <span><i class="fa fa-calendar"></i> 25-Dec-2026</span>
                <span><i class="fa fa-clock-o"></i> 08:00 AM</span>
              </div>
            </div>
            <div class="special-mass-item">
              <div class="special-mass-title">Oldpet St. Ignatius Feast Mass (பழையபேட்டை திருவிழா)</div>
              <div class="special-mass-meta">
                <span><i class="fa fa-calendar"></i> 12-Feb-2027</span>
                <span><i class="fa fa-clock-o"></i> 06:00 PM</span>
              </div>
            </div>
            <div class="special-mass-item">
              <div class="special-mass-title">Annual Shrine Feast Pontifical Mass (திருவிழா கூட்டுத்திருப்பலி)</div>
              <div class="special-mass-meta">
                <span><i class="fa fa-calendar"></i> Sunday after July 13</span>
                <span><i class="fa fa-clock-o"></i> 08:30 AM</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Grid 5: YouTube Shorts & Reels -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-film" style="color: #9333ea;"></i> $shortsHeader</h3>
            <span class="card-badge">Shorts / Reels</span>
          </div>
          <div class="shorts-container">
            <div class="shorts-preview-card">
              <iframe src="https://www.youtube.com/embed/videoseries?list=UUe7i0e-o2n2qZ5_kU9W9a8A" title="Fatima Shrine Daily Shorts" allowfullscreen></iframe>
            </div>
            <div class="shorts-social-buttons">
              <a href="https://www.youtube.com/@OurLadyOfFatimaShrine/shorts" target="_blank" rel="noopener" class="btn-social-short btn-yt" title="YouTube Shorts">
                <i class="fa fa-youtube-play"></i> Shorts
              </a>
              <a href="https://facebook.com/reels" target="_blank" rel="noopener" class="btn-social-short btn-fb" title="Facebook Reels">
                <i class="fa fa-facebook"></i> Reels
              </a>
              <a href="https://instagram.com/reels" target="_blank" rel="noopener" class="btn-social-short btn-insta" title="Instagram Reels">
                <i class="fa fa-instagram"></i> Reels
              </a>
            </div>
          </div>
        </div>

      </div>

      <!-- ROW 3: Grid 6 (ICS Liturgical Calendar) & Grid 7 (Bank Details) -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px; margin-bottom: 25px;">
        
        <!-- Grid 6: Liturgical Calendar (Dynamic 7-Day Schedule from local .ICS) -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-calendar" style="color: var(--secondary);"></i> $calendarHeader</h3>
            <span class="card-badge">Feasts</span>
          </div>
          <p style="font-size: 0.82rem; color: #64748b; margin-bottom: 12px;">
            $(if ($lang -eq 'ta') { 'கத்தோலிக்க திருச்சபையின் தினசரி வழிபாட்டுத் திருநாட்கள் அட்டவணை:' } else { 'Upcoming daily liturgical feasts, solemnities, and saints memorials:' })
          </p>
          <div id="parishCalendar">
            <!-- Dynamic 7-day schedule parsed from .ics is injected here by main.js -->
            <div style="text-align: center; padding: 20px; color: var(--text-muted);"><i class="fa fa-spinner fa-spin"></i> Loading liturgical schedule...</div>
          </div>
        </div>

        <!-- Grid 7: Bank Details & Offerings -->
        <div class="card">
          <div class="card-header-shrine">
            <h3 class="card-header-title"><i class="fa fa-bank" style="color: var(--gold);"></i> $bankHeader</h3>
            <span class="card-badge">Offerings</span>
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

      </div>

    </div>
  </main>
"@

    return $header + $content + $footer
}

# -----------------------------------------------------------------------------
# Function: Generate Inner Page
# -----------------------------------------------------------------------------
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

    # Extract first line for title
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

    # Convert content
    $parsedHtml = Convert-ContentToHtml $rawText $slug $lang $prefix

    # Image mapping section if page has specific images not already injected
    $imagesHtml = ""
    if ($pageInfo.images.Count -gt 0) {
        # Check if the images are already in the parsedHtml
        $unseenImages = @()
        foreach ($img in $pageInfo.images) {
            if (-not ($parsedHtml -match [regex]::Escape($img))) {
                $unseenImages += $img
            }
        }
        if ($unseenImages.Count -eq 1) {
            $imagesHtml = "<div style='text-align: center; margin: 20px 0;'><img src='${prefix}images/$($unseenImages[0])' alt='$title' class='page-image-banner'></div>"
        } elseif ($unseenImages.Count -gt 1) {
            $imagesHtml = "<div class='image-grid'>`n"
            foreach ($img in $unseenImages) {
                $imagesHtml += "  <div><img src='${prefix}images/$img' alt='$title Image' loading='lazy'></div>`n"
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

# -----------------------------------------------------------------------------
# MAIN GENERATION EXECUTION
# -----------------------------------------------------------------------------
Write-Output "Starting Site Generation..."

# 1. Generate English Home Page
Write-Output "Generating index.html..."
$indexHtml = Generate-HomePage "en"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "index.html"), $indexHtml, [System.Text.Encoding]::UTF8)

# 2. Generate Tamil Home Page
Write-Output "Generating ta/index-ta.html..."
$indexTaHtml = Generate-HomePage "ta"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\index-ta.html"), $indexTaHtml, [System.Text.Encoding]::UTF8)

# 3. Generate Gallery Pages
Write-Output "Generating gallery.html & ta/gallery.html..."
$galleryEn = Generate-GalleryPage "en"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "gallery.html"), $galleryEn, [System.Text.Encoding]::UTF8)

$galleryTa = Generate-GalleryPage "ta"
[System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\gallery.html"), $galleryTa, [System.Text.Encoding]::UTF8)

# 4. Generate All Inner Pages
$count = 0
foreach ($p in $pagesList) {
    if ($p.slug -eq "rosary") {
        Write-Output "Generating special Rosary pages (rosary.html & ta/rosary.html)..."
        $rosaryEn = Generate-RosaryPage "en"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "rosary.html"), $rosaryEn, [System.Text.Encoding]::UTF8)
        
        $rosaryTa = Generate-RosaryPage "ta"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\rosary.html"), $rosaryTa, [System.Text.Encoding]::UTF8)
        $count += 2
        continue
    }

    if ($p.slug -eq "contact") {
        Write-Output "Generating special Contact Us pages (contact.html & ta/contact.html)..."
        $contactEn = Generate-ContactPage "en"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "contact.html"), $contactEn, [System.Text.Encoding]::UTF8)
        
        $contactTa = Generate-ContactPage "ta"
        [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "ta\contact.html"), $contactTa, [System.Text.Encoding]::UTF8)
        $count += 2
        continue
    }

    Write-Output "Generating $($p.slug).html & ta/$($p.slug).html..."
    
    # English
    $pageEn = Generate-InnerPage $p "en"
    [System.IO.File]::WriteAllText((Join-Path $workspaceRoot "$($p.slug).html"), $pageEn, [System.Text.Encoding]::UTF8)

    # Tamil
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
