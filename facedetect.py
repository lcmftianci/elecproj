# coding=utf-8
import cv2
import numpy as np
#指定图片的人脸识别然后存储
img = cv2.imread("D:/file/Database/timg.jpg")
color = (0, 255, 0)
coloreye = (255, 0, 255)

grey = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

facefier = cv2.CascadeClassifier("E:/code/opencv/data/haarcascades/haarcascade_frontalface_alt2.xml")
eyefier  = cv2.CascadeClassifier("E:/code/opencv/data/haarcascades/haarcascade_eye_tree_eyeglasses.xml")

faceRects = facefier.detectMultiScale(grey, scaleFactor=1.2, minNeighbors=1, minSize=(10, 10))
if len(faceRects) > 0:          # 大于0则检测到人脸
    for faceRect in faceRects:  # 单独框出每一张人脸
        x, y, w, h = faceRect
        cv2.rectangle(img, (x - 10, y - 10), (x + w + 10, y + h + 10), color, 3) #5控制绿色框的粗细
        eyesRects = eyefier.detectMultiScale(grey, scaleFactor=1.2, minNeighbors=1, minSize=(3, 3))
    if len(eyesRects) > 0:
        for eyeRect in eyesRects:
            x, y, w, h = eyeRect
            cv2.rectangle(img, (x - 2, y - 2), (x + w + 2, y + h + 2), coloreye, 3)
cv2.imshow("人脸检测", img)

c = cv2.waitKeyEx(0)
# 写入图像
#cv2.imwrite('./aaa.jpg',img)
