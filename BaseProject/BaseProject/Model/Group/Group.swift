//
//  Group.swift
//  BaseProject
//
//  Created by MAC MINI on 10/01/2018.
//  Copyright © 2018 Wave. All rights reserved.
//

import UIKit
// Group
let KGRP_id                  = "id"
let KGRP_Name                  =  "name"
let KGRP_image                 =  "image"
let KGRP_title                 =   "title"
let KGRP_group_description                  = "group_description"
let KGRP_is_private                  = "is_private"
let KGRP_get_members_count                  = "get_members_count"
let KGRP_is_admin_count                 = "is_admin_count"
let KGRP_is_following_count                  = "is_following_count"
let KGRP_created_at                  = "created_at"
let KGRP_updated_at                  = "updated_at"
let KGRP_group_owner                  = "group_owner"
let KGRP_group_tags                  = "group_tags"
let KGRP_group_tags_ids                  = "group_tags_ids"
let KGRP_isCurrentUserAdmin                  = "isCurrentUserAdmin"
let KGRP_group_members                  = "group_members"
let KGRP_group_message_count                  = "group_message_count"
let KGRP_Member_id                  = "id"
let KGRP_Member_group_id                  = "group_id"
let KGRP_Member_isAdmin                  = "isAdmin"
let KGRP_Member_Name                  = "Name"
let KGRP_Member_image_path                  = "image_path"

class Group: NSObject {
    var Name  = kEmptyString
    var id  = kEmptyInt
    var user_id  = kEmptyInt
    var group_message_count = kEmptyInt
    var image  = kEmptyString
    var title  = kEmptyString
    var  group_description  = kEmptyString
    var is_private  = kEmptyInt
    var get_members_count   = kEmptyInt
    var is_admin_count   = kEmptyInt
    var is_following_count  = kEmptyInt
    var created_at   = kEmptyString
    var updated_at   = kEmptyString
    var group_owner   = kEmptyString
    var group_tags   = kEmptyString
    var group_tags_ids   = kEmptyString
    var isCurrentUserAdmin   = kEmptyBoolean
    var group_members :[GroupMembers] = [GroupMembers]()
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json!)
         self.Name =  json?[KGRP_Name] as? String ?? kEmptyString
         self.id =  json?[KGRP_id] as? Int ?? 0
          self.group_message_count =  json?[KGRP_group_message_count] as? Int ?? 0
         self.user_id =  json?[kuser_id] as? Int ?? 0
         self.image =  json?[KGRP_image] as? String ?? kEmptyString
         self.title =  json?[KGRP_title] as? String ?? kEmptyString
         self.group_description =  json?[KGRP_group_description] as? String ?? kEmptyString
         self.is_private =  json?[KGRP_is_private] as? Int ?? 0
          self.get_members_count =  json?[KGRP_get_members_count] as? Int ?? 0
          self.is_admin_count =  json?[KGRP_is_admin_count] as? Int ?? 0
          self.is_following_count =  json?[KGRP_is_following_count] as? Int ?? 0
          self.created_at =  json?[KGRP_created_at] as? String ?? kEmptyString
          self.updated_at =  json?[KGRP_updated_at] as? String ?? kEmptyString
          self.group_owner =  json?[KGRP_group_owner] as? String ?? kEmptyString
          self.group_tags =  json?[KGRP_group_tags] as? String ?? kEmptyString
        self.group_tags_ids =  json?[KGRP_group_tags_ids] as? String ?? kEmptyString
        self.isCurrentUserAdmin =  json?[KGRP_isCurrentUserAdmin] as? Bool ?? kEmptyBoolean
        self.group_members =  json?[KGRP_group_members] as? [GroupMembers] ?? [GroupMembers]()
    }
}

class GroupMembers : NSObject {
    var Name = kEmptyString
    var user_id = kEmptyInt
    var group_id = kEmptyInt
    var image_path = kEmptyString
    var isAdmin = kEmptyBoolean
    convenience init(json: [String: AnyObject]?) {
        self.init()
        print(json!)
        self.user_id =  json?[KGRP_Member_id] as? Int ?? 0
        self.group_id = json?[KGRP_Member_group_id] as? Int ?? 0
        self.isAdmin =  json?[KGRP_Member_isAdmin] as? Bool ?? false
        self.Name =  json?[KGRP_Member_Name] as? String ?? kEmptyString
        self.image_path =  json?[KGRP_Member_image_path] as? String ?? kEmptyString
    }
}
