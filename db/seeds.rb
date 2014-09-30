# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

EducationType.create([
	{name:"First Education"},
	{name:"Second Education"}
])


SaleType.create([
	{name:"First Sale"},
	{name:"Second Sale"}
])



# DealType.create([
# 	{name:"First Deal"},
# 	{name:"Second Deal"},
# 	{name:"Third Deal"},
# 	{name:"Fourth Deal"}
# ])


# Zone.create([
# 	{name:"First Zone"},
# 	{name:"Second Zone"},
# 	{name:"Third Zone"},
# 	{name:"Fourth Zone"},
# 	{name:"Fifth Zone"},
# 	{name:"Sixth Zone"},
# 	{name:"Seventh Zone"},
# 	{name:"Eighth Zone"},
# 	{name:"Ninth Zone"}
# ])

# Category.create([
# 	{name:"Graphics & Design", url:"graphics-design"},
# 	{name:"Online Marketing", url:"online-marketing"},
# 	{name:"Writing & Translation", url:"writing-translation"},
# 	{name:"Video & Animation", url:"video-animation"},
# 	{name:"Music & Audio", url:"music-audio"},
# 	{name:"Programming & Tech", url:"programming-tech"},
# 	{name:"Gifts", url: "gifts"}
# ])


# SubCategory.create ([
# 	{category_id: 1, name:"Cartoons & Caricatures", url: "cartoons-caricatures"},
# 	{category_id: 1, name:"Logo Design", url: "logo-design"},
# 	{category_id: 1, name:"Illustration", url: "illustration"},
# 	{category_id: 1, name:"Ebook Covers & Packages", url: "ebook-covers-packages"},
# 	{category_id: 1, name:"Web Design & UI", url: "web-design-ui"},
# 	{category_id: 1, name:"Photography & Photoshopping", url: "photography-photoshopping"},
# 	{category_id: 1, name:"Presentation Design", url: "presentation-design"},
# 	{category_id: 1, name:"Flyers & Brochures ", url: "flyers-brochures"},
# 	{category_id: 1, name:"Business Cards", url: "business-cards"},
# 	{category_id: 1, name:"Banners & Headers", url: "banners-headers"},
# 	{category_id: 1, name:"Architecture", url: "architecture"},
# 	{category_id: 1, name:"Landing Pages", url: "landing-pages"},
# 	{category_id: 1, name:"Other", url: "other"},

# 	{category_id: 2, name:"Web Analytics", url: "web-analytics"},
# 	{category_id: 2, name:"Article & PR Submission", url: "article-pr-submitssion"},
# 	{category_id: 2, name:"Blog Mentions", url: "blog-mentions"},
# 	{category_id: 2, name:"Domain Research", url: "domain-research"},
# 	{category_id: 2, name:"Fan Pages", url: "fan-pages"},
# 	{category_id: 2, name:"Keywords Research", url: "keyword-research"},
# 	{category_id: 2, name:"SEO", url: "seo"},
# 	{category_id: 2, name:"Bookmarking & Links", url: "bookmarking-links"},
# 	{category_id: 2, name:"Social Marketing", url: "social-marketing"},
# 	{category_id: 2, name:"Get Traffic", url: "get-traffic"},
# 	{category_id: 2, name:"Video Marketing", url: "video-marketing"},
# 	{category_id: 2, name:"Other", url: "other"},

# 	{category_id: 3, name:"Copywriting", url: "copywriting"},
# 	{category_id: 3, name:"SEO Keyword Optimization", url: "seo-keyword-optimization"},
# 	{category_id: 3, name:"Creative Writing & Scripting", url: "creattive-writing-scripting"},
# 	{category_id: 3, name:"Translation", url: "translation"},
# 	{category_id: 3, name:"Transcripts", url: "transcripts"},
# 	{category_id: 3, name:"Website Content", url: "website-content"},
# 	{category_id: 3, name:"Reviews", url: "reviews"},
# 	{category_id: 3, name:"Resumes & Cover Letters", url: "resumes-cover-letters"},
# 	{category_id: 3, name:"Speech Writing", url: "speech-writing"},
# 	{category_id: 3, name:"Proofreading & Editing", url: "proofreading-editing"},
# 	{category_id: 3, name:"Press Releases", url: "press-releases"},
# 	{category_id: 3, name:"Other", url: "other"},

# 	{category_id: 4, name:"Commercials", url: "commercials"},
# 	{category_id: 4, name:"Editing & Post Production", url: "editing-post-production"},
# 	{category_id: 4, name:"Animation & 3D", url: "animation-3d"},
# 	{category_id: 4, name:"Testimonials & Reviews by Actors", url: "testimonials-reviews-by-actors"},
# 	{category_id: 4, name:"Puppets", url: "puppets"},
# 	{category_id: 4, name:"Stop Motion", url: "stop-motion"},
# 	{category_id: 4, name:"Intros", url: "intros"},
# 	{category_id: 4, name:"Other", url: "other"},

# 	{category_id: 5, name:"Audio Editing & Mastering", url: "audio-editing-mastering"},
# 	{category_id: 5, name:"Jingles", url: "jingles"},
# 	{category_id: 5, name:"Songwriting", url: "songwriting"},
# 	{category_id: 5, name:"Music Lessons", url: "music-lessons"},
# 	{category_id: 5, name:"Rap Music", url: "rap-music"},
# 	{category_id: 5, name:"Hip-Hop Music", url: "hip-hop-music"},
# 	{category_id: 5, name:"Narration & Voice-Over", url: "narration-voice-over"},
# 	{category_id: 5, name:"Sound Effects & Loops", url: "sound-effects-loops"},
# 	{category_id: 5, name:"Custom Ringtones", url: "custom-ringtones"},
# 	{category_id: 5, name:"Voicemail Greetings", url: "voicemail-greetings"},
# 	{category_id: 5, name:"Custom Songs", url: "custom-songs"},
# 	{category_id: 5, name:"Other", url: "other"},

# 	{category_id: 6, name:".Net", url: "dot-net"},
# 	{category_id: 6, name:"C++", url: "c++"},
# 	{category_id: 6, name:"CSS & HTML", url: "css-html"},
# 	{category_id: 6, name:"Joomla & Drupal", url: "joomle-drupal"},
# 	{category_id: 6, name:"Databases", url: "databases"},
# 	{category_id: 6, name:"Java", url: "java"},
# 	{category_id: 6, name:"JavaScript", url: "javascript"},
# 	{category_id: 6, name:"PSD to HTML", url: "psd-to-html"},
# 	{category_id: 6, name:"WordPress", url: "wordpress"},
# 	{category_id: 6, name:"Flash", url: "flash"},
# 	{category_id: 6, name:"iOS, Android & Mobile", url: "ios-android-mobile"},
# 	{category_id: 6, name:"PHP", url: "php"},
# 	{category_id: 6, name:"QA & Software Testing", url: "qa-software-testing"},
# 	{category_id: 6, name:"Technology", url: "technology"},
# 	{category_id: 6, name:"Other", url: "other"},

# 	{category_id: 7, name:"Greeting Cards", url: "greeting-cards"},
# 	{category_id: 7, name:"Video Greetings", url: "voice-greetings"},
# 	{category_id: 7, name:"Unusual Gifts", url: "unusual-gifts"},
# 	{category_id: 7, name:"Arts & Crafts", url: "arts-crafts"},
# 	{category_id: 7, name:"Handmade Jewelry", url: "handsome-jewelry"},
# 	{category_id: 7, name:"Gifts for Geeks", url: "gifts-for-geeks"},
# 	{category_id: 7, name:"Postcards From...", url: "postcadrs-from"},
# 	{category_id: 7, name:"Recycled Crafts", url: "recycled-crafts"},
# 	{category_id: 7, name:"Other", url: "other"}

# ])