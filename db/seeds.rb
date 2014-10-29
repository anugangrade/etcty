# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# CoupenType.create([
# 	{name:"First Coupen"},
# 	{name:"Second Coupen"}
# ])

# EducationType.create([
# 	{name:"First Education"},
# 	{name:"Second Education"}
# ])


# SaleType.create([
# 	{name:"First Sale"},
# 	{name:"Second Sale"}
# ])

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
# 	{name:"Graphics & Design"},
# 	{name:"Online Marketing"},
# 	{name:"Writing & Translation"},
# 	{name:"Video & Animation", url:"video-animation"},
# 	{name:"Music & Audio", url:"music-audio"},
# 	{name:"Programming & Tech", url:"programming-tech"},
# 	{name:"Gifts", url: "gifts"}
# ])


# SubCategory.create ([
# 	{category_id: 1, name:"Cartoons & Caricatures"},
# 	{category_id: 1, name:"Logo Design"},
# 	{category_id: 1, name:"Illustration"},
# 	{category_id: 1, name:"Ebook Covers & Packages"},
# 	{category_id: 1, name:"Web Design & UI"},
# 	{category_id: 1, name:"Photography & Photoshopping"},
# 	{category_id: 1, name:"Presentation Design"},
# 	{category_id: 1, name:"Flyers & Brochures"},
# 	{category_id: 1, name:"Business Cards"},
# 	{category_id: 1, name:"Landing Pages"},
# 	{category_id: 1, name:"Banners & Headers"},
# 	{category_id: 1, name:"Architecture"},
# 	{category_id: 1, name:"Other"},

# 	{category_id: 2, name:"Web Analytics"},
# 	{category_id: 2, name:"Article & PR Submission"},
# 	{category_id: 2, name:"Blog Mentions"},
# 	{category_id: 2, name:"Domain Research"},
# 	{category_id: 2, name:"Fan Pages"},
# 	{category_id: 2, name:"Keywords Research"},
# 	{category_id: 2, name:"SEO"},
# 	{category_id: 2, name:"Bookmarking & Links"},
# 	{category_id: 2, name:"Social Marketing"},
# 	{category_id: 2, name:"Get Traffic"},
# 	{category_id: 2, name:"Video Marketing"},
# 	{category_id: 2, name:"Other"},

# 	{category_id: 3, name:"Copywriting"},
# 	{category_id: 3, name:"SEO Keyword Optimization"},
# 	{category_id: 3, name:"Creative Writing & Scripting"},
# 	{category_id: 3, name:"Translation"},
# 	{category_id: 3, name:"Transcripts"},
# 	{category_id: 3, name:"Website Content"},
# 	{category_id: 3, name:"Reviews"},
# 	{category_id: 3, name:"Resumes & Cover Letters"},
# 	{category_id: 3, name:"Speech Writing"},
# 	{category_id: 3, name:"Proofreading & Editing"},
# 	{category_id: 3, name:"Press Releases"},
# 	{category_id: 3, name:"Other"},

# 	{category_id: 4, name:"Commercials"},
# 	{category_id: 4, name:"Editing & Post Production"},
# 	{category_id: 4, name:"Animation & 3D"},
# 	{category_id: 4, name:"Testimonials & Reviews by Actors"},
# 	{category_id: 4, name:"Puppets"},
# 	{category_id: 4, name:"Stop Motion"},
# 	{category_id: 4, name:"Intros"},
# 	{category_id: 4, name:"Other"},

# 	{category_id: 5, name:"Audio Editing & Mastering"},
# 	{category_id: 5, name:"Jingles"},
# 	{category_id: 5, name:"Songwriting"},
# 	{category_id: 5, name:"Music Lessons"},
# 	{category_id: 5, name:"Rap Music"},
# 	{category_id: 5, name:"Hip-Hop Music"},
# 	{category_id: 5, name:"Narration & Voice-Over"},
# 	{category_id: 5, name:"Sound Effects & Loops"},
# 	{category_id: 5, name:"Custom Ringtones"},
# 	{category_id: 5, name:"Voicemail Greetings"},
# 	{category_id: 5, name:"Custom Songs"},
# 	{category_id: 5, name:"Other"},

# 	{category_id: 6, name:".Net"},
# 	{category_id: 6, name:"C++"},
# 	{category_id: 6, name:"CSS & HTML"},
# 	{category_id: 6, name:"Joomla & Drupal"},
# 	{category_id: 6, name:"Databases"},
# 	{category_id: 6, name:"Java"},
# 	{category_id: 6, name:"JavaScript"},
# 	{category_id: 6, name:"PSD to HTML"},
# 	{category_id: 6, name:"WordPress"},
# 	{category_id: 6, name:"Flash"},
# 	{category_id: 6, name:"iOS, Android & Mobile"},
# 	{category_id: 6, name:"PHP"},
# 	{category_id: 6, name:"QA & Software Testing"},
# 	{category_id: 6, name:"Technology"},
# 	{category_id: 6, name:"Other"},

# 	{category_id: 7, name:"Greeting Cards"},
# 	{category_id: 7, name:"Video Greetings"},
# 	{category_id: 7, name:"Unusual Gifts"},
# 	{category_id: 7, name:"Arts & Crafts"},
# 	{category_id: 7, name:"Handmade Jewelry"},
# 	{category_id: 7, name:"Gifts for Geeks"},
# 	{category_id: 7, name:"Postcards From..."},
# 	{category_id: 7, name:"Recycled Crafts"},
# 	{category_id: 7, name:"Other"}

# ])

User.create(email: "admin@bytelogistics.com", password: "bytelogistics", username: "bytelogistics", is_admin: true)
User.create(email: "admin@encodous.com", password: "encodous", username: "encodous" , is_admin: true)