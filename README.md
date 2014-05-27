S3BucketBrowser_OSX
===================

an example of using AFAmazonS3Client on OSX to access an Amazon S3 bucket

Step 1:  Set up your S3 bucket(s) and an AWS IAM user with the appropriate permissions to access the bucket and its contents through the AWS API.  (If you don't know how to do this, please search the web for help.  I don't plan on trying to improve on Amazons copious documentation here).
Step 2:  Run S3BucketBrowser_OSX and enter your information into the following screen:

![](https://github.com/cruinh/S3BucketBrowser_OSX/blob/master/screens/authenticationPanel.png?raw=true)

Step 3:  Once the app has had time to download the list of items in your bucket, you'll see them listed in the following screen:

![](https://github.com/cruinh/S3BucketBrowser_OSX/blob/master/screens/bucketWindow.png?raw=true)

Things to note:
* The right-hand panel isn't yet built out.  I intend to provide a way to display contents for some file types there.
* You can filter the bucket table using the text field in the upper-right.  This filters items based on the "key" value (i.e. the filename).
