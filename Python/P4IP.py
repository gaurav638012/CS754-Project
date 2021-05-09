from types import LambdaType
import bm3d
import numpy as np
import cv2
from ADMM import ADMM

class P4IP:

    def __init__(self,y, beta, Lambda, lambdaStep, shape, H = None,verbose=0):
        self.H = H
        self.y = y.ravel()
        self.shape = shape
        self.beta = beta
        self.Lambda = Lambda
        self.lambdaStep = lambdaStep
        self.verbose = verbose

    def zero_init(self, iter = 100):
        self.u_0 = np.zeros(self.shape)
        self.v_0 = self.y.reshape(self.shape)
        self.iter = iter
    
    def reconstruct(self):
        u = self.u_0
        v = self.v_0
        x = self.y.reshape(self.shape)
        Lambda = self.Lambda
        
        if self.verbose:
            print(v.shape,u.shape,self.y.shape)
        for k in range(self.iter):
            x = ADMM(self.y.copy(),Lambda,v.copy(),u.copy(),x.copy()+0.1*np.random.randn(*x.shape),self.H) 
            v = bm3d.bm3d(x + u, stage_arg=bm3d.BM3DStages.ALL_STAGES, sigma_psd = np.sqrt(self.beta / self.Lambda))
            u = u + x - v
            Lambda = Lambda*self.lambdaStep
            print(k)
        
        return x

            


