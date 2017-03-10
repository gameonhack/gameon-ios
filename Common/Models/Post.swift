//
//  Post.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject, PFSubclassingSkipAutomaticRegistration {

    static func parseClassName() -> String {
        return "Post"
    }
    
    /// The post's user. This is the user that created the Post.
    @NSManaged var user : User!
    /// The post's content
    @NSManaged var content : String!
    /// The pot's image file. **Default** is nil. Use getFile function to get the image.
    @NSManaged var image : PFFile?
    /// The pot's likes Relation
    @NSManaged var likes : PFRelation<User>?
    /// The pot's likes count
    @NSManaged var likesCount : NSNumber?
    
    fileprivate var cachedLikes : [User]? = nil
    
    
    /**
     
     A function that verifies if a user likes a post. **Get all post likes first.**
     
     - Parameter user: The user to evaluate if he likes the post
     - Returns: A bool if the user likes saying
     
     */
    
    func isLikedBy(user: User) -> Bool {
        guard let cachedLikes = cachedLikes else {
            fatalError("Consider getting the post's likes first.")
        }
        
        let mappedUsers = cachedLikes.map({ (user) -> String in
            return user.objectId!
        })
        
        return mappedUsers.contains(user.objectId!)
    }
    
    /**
     
     Add's a user that likes the post.
     
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    func addLikeFrom(user: User, block : @escaping (Bool, Error?) -> Void ) {
        if cachedLikes == nil {
            cachedLikes = [User]()
        }
        if likes == nil {
            likes = PFRelation()
        }
        cachedLikes?.append(user)
        
        self.relation(forKey: #keyPath(Post.likes)).add(user)
        self.incrementKey(#keyPath(Post.likesCount))
        self.saveInBackground { (success, error) in
            block(success, error)
        }
    }
    
   
    /**
     
     Add's a user that likes the post.
     
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    func removeLikeFrom(user: User, block : @escaping (Bool, Error?) -> Void ) {
        if cachedLikes == nil {
            cachedLikes = [User]()
        }
        if likes == nil {
            likes = PFRelation()
        }
        
        var indexOfUser : Int? = nil
        for (index, cachedUser) in cachedLikes!.enumerated() {
            if user.objectId == cachedUser.objectId {
                indexOfUser = index
                break
            }
        }
        guard let index = indexOfUser else {
            return
        }
        cachedLikes?.remove(at: index)
        
        self.relation(forKey: #keyPath(Post.likes)).remove(user)
        self.incrementKey(#keyPath(Post.likesCount), byAmount: -1)
        self.saveInBackground { (success, error) in
            block(success, error)
        }
    }
    
    
    /**
     
     Get all the Likes from the Post.
     
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    func getLikes(block : @escaping ([User]?, Error?) -> Void ) {
        guard let cachedLikes = cachedLikes else {
            DataManager.getLikesFrom(post: self, block: { (users, error) in
                self.cachedLikes = users ?? []
                block(self.cachedLikes, nil)
            })
            return
        }
        block(cachedLikes, nil)
    }
}
