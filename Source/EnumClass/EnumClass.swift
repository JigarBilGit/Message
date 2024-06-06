//
//  EnumClass.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 16/08/21.
//

import Foundation

enum NotifyView : String {
    case none           = ""
    case assessment     = "Assessment"
}

enum NotifyPurpose : String {
    case none              = ""
}

enum PreDefineMobilePrimaryKey : String {
    case none               = ""
    case diagnosisSequence  = "I_DIAGNOSIS_SEQUENCE"
}

enum DBAction : Int{
    case none       = 0
    case insert     = 1
    case update     = 2
    case delete     = 3
}

enum DirectoryFolder: String {
    case none                  = ""
    case ProfilePicture        = "ProfilePicture"
    case Attachments           = "Attachments"
    case ChatAttachment        = "ChatAttachment"
    case TextFile              = "TextFile"
    case EMarAttachments       = "EMarAttachments"
    case TrackableAttachment   = "TrackableAttachment"
    case FaceToFacePDF         = "FaceToFacePDF"
    case IncidentsPDF          = "IncidentsPDF"
    case ConversationList       = "ConversationList"
    case EmployeeProfilePicture = "EmployeeProfilePicture"
    case Communication          = "Communication"
}

enum SyncImageType: Int{
    case none                           = -1
    case clinicalAssessmentClientSign   = 1
    case clinicalAssessmentEmployeeSign = 2
    case woundCare                      = 3
    case documentSignature              = 4
    case woundAttachment                = 5
    case clinicalAssessmentPDF          = 6
    case clinicalAssessmentAttachment   = 7
    case contactAttachment              = 8
    case employeeProfilePic             = 9
    case taskAttachment                 = 10
    case payrollAttachment              = 11
    case textFile                       = 12
    case assessmentSignature            = 13
    case eMarAttachment                 = 14
    case TrackableAttachment            = 15
    case carePlanSignature              = 16
}

enum MessagePageSize: Int {
    case Default = 100
    case Other = 10
}

enum UserTypeTag: Int {
    case None = 00
    case AddParticipants = 11
    case Own = 22
    case Other = 33
    case ViewAll = 44
    case LeaveGroup = 55
}

enum MessageType: Int {
    case Text = 1
    case Image = 2
    case Voice_Audio = 3
    case Video = 4
    case SystemGenerated = 5
    case Document = 6
    case Location = 7
}

enum UploadingStatus: Int {
    case Uploading = 1
    case Uploaded = 2
    case Failed = 3
}

enum MessageAction: Int {
    case Reply = 1
    case Forward = 2
    case Copy = 3
    case Edit = 4
    case Delete = 5
}

