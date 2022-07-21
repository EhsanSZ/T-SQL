USE master
GO

USE MyEShop
GO

CREATE TABLE ProductGroups
(
	GroupID INT  NOT NULL,
	GroupTitle NVARCHAR(400) NOT NULL,
	ParentID INT NULL
)
GO

ALTER TABLE ProductGroups ADD CONSTRAINT PK_ProductGroups
PRIMARY KEY CLUSTERED (GroupID)
GO

ALTER TABLE ProductGroups ADD CONSTRAINT FK_ProductGroups
FOREIGN KEY(ParentID) REFERENCES ProductGroups(GroupID)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO

INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (1, N'الکترونیک', NULL)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (2, N'صوتی و تصویری', 1)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (3, N'تلویزیون', 1)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (5, N'لوازم شخصی', NULL)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (6, N'مسواک', 5)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (7, N'حوله', 5)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (8, N'گوشی', 5)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (9, N'صنایع دستی', NULL)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (10, N'کیف', 9)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (11, N'کفش', 9)
INSERT ProductGroups (GroupID, GroupTitle, ParentID) VALUES (12, N'لوازم ورزشی', NULL)