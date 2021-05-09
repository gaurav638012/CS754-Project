import cv2
import numpy as np
from P4IP import P4IP
from utils import PSNR1,blurFunc


img  = cv2.imread("images/pepper.png",0).astype('float64')/255
peak = 2

H = blurFunc(img.shape, "gaussian", {"sigma" : 1.6, "kern_size" : 25})

noisy_img = H(img).reshape(img.shape)

noisy_img = np.random.poisson(noisy_img*peak)
print("Max value in noisy image", np.max(noisy_img))
noisy_img = noisy_img / np.max(noisy_img) 

cv2.imshow("orig", img)
cv2.imshow("noisy", noisy_img)
cv2.waitKey(10000)

print("Noisy image : ", PSNR1(img, noisy_img), "dB")

arr = np.zeros((4,4))
for i,beta in enumerate([peak**5]):
    for j,Lambda in enumerate([peak**-1.5]):
        l_step = 1.065
        obj = P4IP(noisy_img,beta,Lambda,l_step,noisy_img.shape,H,verbose=0)
        obj.zero_init(40)
        recon_img = obj.reconstruct()

        cv2.imshow("reconstruction", recon_img)
        cv2.imshow("recon_add",recon_img/np.max(recon_img))
        cv2.waitKey(1000)
        
        print("Reconstructed image : ", PSNR1(recon_img,img), "dB")
        print("Reconstructed image normalised : ", PSNR1(recon_img/np.max(recon_img),img), "dB")
        arr[i][j] = PSNR1(recon_img/np.max(recon_img),img)
np.save("tune.npy",arr)
cv2.waitKey(1000)
cv2.destroyAllWindows()