import cv2
import numpy as np
import bm3d

image = cv2.imread("../images/lenna.jpg",0)

print(*image.shape)

noisy_img = image + 20*np.random.randn(*image.shape)

cv2.imshow("frame1",noisy_img/255)

print(noisy_img)

cv2.waitKey()

denoised_image = bm3d.bm3d(noisy_img, sigma_psd = 20, stage_arg=bm3d.BM3DStages.ALL_STAGES)

cv2.imshow("frame",denoised_image/255)

cv2.waitKey()

cv2.destroyAllWindows()
