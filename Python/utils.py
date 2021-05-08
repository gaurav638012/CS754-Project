import numpy as np
import cv2
from scipy import signal

def PSNR(img1,img2):
    mse = np.mean((img1-img2)**2)

    return 20*np.log10(255/np.sqrt(mse))

def PSNR1(img1,img2):
    mse = np.mean((img1-img2)**2)

    return 20*np.log10(1/np.sqrt(mse))

def blurFunc(shape,type,options):
    """
    type  : type of kernel  from ("gaussian","uniform","custom")
    options : a dict with keys -"kernel","sigma", "kern_size" etc
    shape  : shape tuple of image
    """
    def func(x):
        x = x.reshape(shape)
        
        if type == "gaussian":
            kern1d = signal.gaussian(options["kern_size"],std=options["sigma"]).reshape(options["kern_size"],1)
            kernel = np.outer(kern1d,kern1d)
            kernel = kernel/np.sum(kernel)
        elif type == "uniform":
            kernel = np.ones((options["kern_size"],options["kern_size"]))
        elif type == "custom":
            kernel = options["kernel"]
        x = signal.fftconvolve(x,kernel,mode="same")

        return x.ravel()

    return func