import cv2
import numpy as np
from P4IP import P4IP
from utils import PSNR


img  = cv2.imread("images/flag.ppm",0).astype('float64')

peak = 2

noisy_img = np.random.poisson(img / 255.0 * peak) / peak * 255  

#noisy_img = cv2.imread("images/flag-noisy.ppm",0)

cv2.imshow("orig", img/255)
cv2.imshow("noisy", noisy_img/255)
cv2.waitKey(100)

print("Noisy image : ", PSNR(img,noisy_img), "dB")

beta = peak**-0.75 + 20
Lambda = peak **-1.5
l_step = 1.065

obj = P4IP(noisy_img.reshape(-1,1),beta,Lambda,l_step,noisy_img.shape,verbose=0)
obj.zero_init(70)
recon_img = obj.reconstruct()

cv2.imshow("orig", img/255)
cv2.imshow("noisy", noisy_img/255)
cv2.imshow("reconstruction", recon_img/255)
cv2.imshow("recon_add",recon_img/np.max(recon_img))

print("Reconstructed image : ", PSNR(recon_img,img), "dB")
print("Reconstructed image normalised : ", PSNR(recon_img/np.max(recon_img)*255,img), "dB")
cv2.waitKey()
cv2.destroyAllWindows()