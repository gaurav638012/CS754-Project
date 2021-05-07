import numpy as np
import cv2

def PSNR(img1,img2):
    mse = np.mean((img1-img2)**2)

    return 20*np.log10(255/np.sqrt(mse))