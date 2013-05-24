//
//  RZLoginStringConstants.h
//  RZLogin
//
//  Created by Joshua Leibsly on 5/24/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

// ------ Facebook Permissions ------
//List of all permissions: http://developers.facebook.com/docs/reference/login/#permissions
//Last updated 5/24/2013.

//Email is a special protected property, have to request it on it's own.
NSString* const kRZFBPermissionEmail = @"email";

//Extended permissions; these are all revokable in the login flow.
NSString* const kRZFBPermissionReadMailbox              = @"read_mailbox";
NSString* const kRZFBPermissionReadFriendRequests       = @"read_requests";
NSString* const kRZFBPermissionReadFriendLists          = @"read_friendlists";
NSString* const kRZFBPermissionReadInsights             = @"read_insights";
NSString* const kRZFBPermissionReadNewsFeed             = @"read_stream";

NSString* const kRZFBPermissionCreateEvent              = @"create_event";
NSString* const kRZFBPermissionManageNotifications      = @"manage_notifications";
NSString* const kRZFBPermissionManageFriendLists        = @"manage_friendlists";

NSString* const kRZFBPermissionPublishToFeed            = @"publish_actions";

NSString* const kRZFBPermissionLoginToChat              = @"xmpp_login";
NSString* const kRZFBPermissionAdsManagement            = @"ads_management";
NSString* const kRZFBPermissionManagePages              = @"manage_pages";

NSString* const kRZFBPermissionUserOnlinePresence       = @"user_online_presence";
NSString* const kRZFBPermissionFriendsOnlinePresence    = @"friends_online_presence";

NSString* const kRZFBPermissionRSVPEvent                = @"rsvp_event";

//Extended profile permissions. These cannot be revoked during the login flow.
NSString* const kRZFBPermissionUserAboutMe              = @"user_about_me";
NSString* const kRZFBPermissionUserActivities           = @"user_activities";
NSString* const kRZFBPermissionUserBirthday             = @"user_birthday";
NSString* const kRZFBPermissionUserCheckins             = @"user_checkins";
NSString* const kRZFBPermissionUserEducation            = @"user_education_history";
NSString* const kRZFBPermissionUserEvents               = @"user_events";
NSString* const kRZFBPermissionUserGroups               = @"user_groups";
NSString* const kRZFBPermissionUserHometown             = @"user_hometown";
NSString* const kRZFBPermissionUserInterests            = @"user_interests";
NSString* const kRZFBPermissionUserLikes                = @"user_likes";
NSString* const kRZFBPermissionUserLocation             = @"user_location";
NSString* const kRZFBPermissionUserNotes                = @"user_notes";
NSString* const kRZFBPermissionUserPhotos               = @"user_photos";
NSString* const kRZFBPermissionUserQuestions            = @"user_questions";
NSString* const kRZFBPermissionUserRelationships        = @"user_relationships";
NSString* const kRZFBPermissionUserRelationshipDetails  = @"user_relationship_details";
NSString* const kRZFBPermissionUserReligionAndPolitics  = @"user_religion_politics";
NSString* const kRZFBPermissionUserStatus               = @"user_status";
NSString* const kRZFBPermissionUserSubscriptions        = @"user_subscriptions";
NSString* const kRZFBPermissionUserVideos               = @"user_videos";
NSString* const kRZFBPermissionUserWebsite              = @"user_website";
NSString* const kRZFBPermissionUserWorkHistory          = @"user_work_history";

//Retrieves actions published by all apps regarding to music listened to, news read, and video watched. These cannot be revoked during the login flow.
NSString* const kRZFBPermissionUserActionsMusic     = @"user_actions.music";
NSString* const kRZFBPermissionUserActionsNews      = @"user_actions.news";
NSString* const kRZFBPermissionUserActionsVideo     = @"user_actions.video";

NSString* const kRZFBPermissionFriendsActionsMusic  = @"friends_actions.music";
NSString* const kRZFBPermissionFriendsActionsNews   = @"friends_actions.news";
NSString* const kRZFBPermissionFriendsActionsVideo  = @"friends_actions.video";

//Extended friends profile permissions. These cannot be revoked during the login flow.
NSString* const kRZFBPermissionFriendsAboutMe               = @"friends_about_me";
NSString* const kRZFBPermissionFriendsActivities            = @"friends_activities";
NSString* const kRZFBPermissionFriendsBirthday              = @"friends_birthday";
NSString* const kRZFBPermissionFriendsCheckins              = @"friends_checkins";
NSString* const kRZFBPermissionFriendsEducation             = @"friends_education_history";
NSString* const kRZFBPermissionFriendsEvents                = @"friends_events";
NSString* const kRZFBPermissionFriendsGroups                = @"friends_groups";
NSString* const kRZFBPermissionFriendsHometown              = @"friends_hometown";
NSString* const kRZFBPermissionFriendsInterests             = @"friends_interests";
NSString* const kRZFBPermissionFriendsLikes                 = @"friends_likes";
NSString* const kRZFBPermissionFriendsLocation              = @"friends_location";
NSString* const kRZFBPermissionFriendsNotes                 = @"friends_notes";
NSString* const kRZFBPermissionFriendsPhotos                = @"friends_photos";
NSString* const kRZFBPermissionFriendsQuestions             = @"friends_questions";
NSString* const kRZFBPermissionFriendsRelationships         = @"friends_relationships";
NSString* const kRZFBPermissionFriendsRelationshipDetails   = @"friends_relationship_details";
NSString* const kRZFBPermissionFriendsReligionAndPolitics   = @"friends_religion_politics";
NSString* const kRZFBPermissionFriendsStatus                = @"friends_status";
NSString* const kRZFBPermissionFriendsSubscriptions         = @"friends_subscriptions";
NSString* const kRZFBPermissionFriendsVideos                = @"friends_videos";
NSString* const kRZFBPermissionFriendsWebsite               = @"friends_website";
NSString* const kRZFBPermissionFriendsWorkHistory           = @"friends_work_history";