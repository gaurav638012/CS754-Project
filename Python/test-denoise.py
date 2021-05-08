import cv2
import numpy as np
from P4IP import P4IP
from utils import PSNR1


img  = cv2.imread("images/flag.ppm",0).astype('float64')/255

peak = 1

noisy_img = np.random.poisson(img*peak)

print(np.max(noisy_img))
noisy_img = noisy_img / np.max(noisy_img) 

cv2.imshow("orig", img)
cv2.imshow("noisy", noisy_img)
cv2.waitKey(100)

print("Noisy image : ", PSNR1(img, noisy_img), "dB")

beta = peak**-0.5
Lambda = peak **-1.5+7
l_step = 1.065

obj = P4IP(noisy_img,beta,Lambda,l_step,noisy_img.shape,verbose=0)
obj.zero_init(70)
recon_img = obj.reconstruct()

cv2.imshow("reconstruction", recon_img)
cv2.imshow("recon_add",recon_img/np.max(recon_img))

print("Reconstructed image : ", PSNR1(recon_img,img), "dB")
print("Reconstructed image normalised : ", PSNR1(recon_img/np.max(recon_img),img), "dB")
cv2.waitKey()
cv2.destroyAllWindows()