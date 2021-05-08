from operator import matmul
import cv2
import numpy as np
import scipy

def NNLog(x):
    e = 1e-10
    a = - 0.5 / (e ** 2)
    b = 2 / e
    c = np.log(e) - 1.5      
    return np.log(x) if x >= e else  a*x*x + b*x + c 

def ADMM(y,Lambda,v,u,H=None):
    """
    Params - 
        y       -  Noisy image in vectorized form with shape (n,)
        Lambda  -  Hyperparameter
        v,u     -  Hyperparams with same shape as image
        H       -  Operator matrix on  vectorized x. Default - Identity  
    """
    shape = v.shape
    siz = np.prod(shape)
    v = np.ravel(v)
    u = np.ravel(u)

    nnlog = np.vectorize(NNLog)
    
    def func(x):
        Hx = H(x)   
        return -np.matmul(y.reshape(-1,1).T,nnlog(Hx).reshape(-1,1))[0][0] + np.sum(Hx) + Lambda*(np.linalg.norm(x - v + u)**2)/2
    
    def grad(x):
        return H(y / H(x)) + H(np.ones(siz)) + Lambda*(x - v + u)

    if H == None:
        res = Lambda*(v - u) - 1 + np.sqrt((Lambda*(v - u) - 1)**2 + 4*Lambda*y)
        res = res / (2 * Lambda)
        return res.reshape(shape)
    else:
        x_0 = np.random.rand(siz)
        res = scipy.optimize.minimize(func,x_0,method='L-BFGS-B',jac=grad)
        print(res.message)
        return res.x.reshape(shape)


