//
//  Post.swift
//  Game On
//
//  Created by Eduardo Irias on 1/19/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return "Post"
    }
    
    // MARK: - Attributes
    
    /// The post's user. This is the user that created the Post.
    @NSManaged var user : User!
    /// The post's content
    @NSManaged var content : String!
    /// The post's image file. **Default** is nil. Use getFile function to get the image.
    @NSManaged var image : PFFile?
    /// The post's likes Relation
    @NSManaged var likes : PFRelation<User>?
    /// The post's likes count
    @NSManaged var likesCount : NSNumber?
    /// The post's likes Relation
    @NSManaged var comments : PFRelation<PostComment>?
    /// The post's likes count
    @NSManaged var commentsCount : NSNumber?
    
    // MARK: - Private Attributes
    
    fileprivate var cachedLikes : [User]? = nil
    var cachedPostComment : [PostComment]? = nil
    
    // MARK: - Functions
    
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
        
        cachedLikes?.append(user)
        self.incrementKey(#keyPath(Post.likesCount))
        
        PFCloud.callFunction(inBackground: "likePost", withParameters: ["postId" : self.objectId!]) { (response, error) in
            if let likesCount = response as? Int {
                self.likesCount = likesCount as NSNumber?
            }
            block(error == nil, error)
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
        self.incrementKey(#keyPath(Post.likesCount), byAmount: -1)
        
        PFCloud.callFunction(inBackground: "likePost", withParameters: ["postId" : self.objectId!]) { (response, error) in
            if let likesCount = response as? Int {
                self.likesCount = likesCount as NSNumber?
            }
            block(error == nil, error)
        }
    }
    
    
    /**
     
     Add's a user that likes the post.
     
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    func add(comment : String, fromUser user: User, block : @escaping (Bool, Error?) -> Void ) {
        if cachedPostComment == nil {
            cachedPostComment = [PostComment]()
        }
        
        
        let postComment = PostComment()
        postComment.setValue(self.objectId, forKey: "postId") 
        postComment.comment = comment
        postComment.user = user
        
        cachedPostComment?.append(postComment)
        self.incrementKey(#keyPath(Post.commentsCount))
        
        postComment.saveInBackground(block: block)        
    }
    
   
    
    /**
     
     Add's a user that likes the post.
     
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    func removeCommentFrom(user: User, atIndex index: Int, block : @escaping (Bool, Error?) -> Void ) {
        if cachedPostComment == nil {
            cachedPostComment = [PostComment]()
        }
        
        let postComment = cachedPostComment?[index]
        
        cachedPostComment?.remove(at: index)
        
        self.relation(forKey: #keyPath(Post.comments)).remove(postComment!)
        self.incrementKey(#keyPath(Post.commentsCount), byAmount: -1)

        postComment?.deleteInBackground(block: block)
        
    }
    
    
    func getImage(block : @escaping (_ image : UIImage) -> Void) {
        self.getFile(forKey: #keyPath(Post.image)) { (data) in
            if let data = data {
                block(UIImage(data: data)!)
            }
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
    
    /**
     
     Get all the Likes from the Post.
     
     - Parameter block: A block returning the requested array of schedules or an error
     - Parameter schedules: The requested array of Schedule
     
     */
    func getComments(block : @escaping ([PostComment]?, Error?) -> Void ) {
        guard let cachedPostComment = cachedPostComment else {
            DataManager.getCommentsFrom(post: self, block: { (comments, error) in
                self.cachedPostComment = comments ?? []
                block(self.cachedPostComment, nil)
            })
            return
        }
        block(cachedPostComment, nil)
    }
}
