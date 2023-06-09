% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gibbs_vnp.R
\name{gibbs_vnp}
\alias{gibbs_vnp}
\title{Gibbs sampler for multivaiate Bayesian nonparametric inference with Whittle likelihood}
\usage{
gibbs_vnp(
  data,
  Ntotal,
  burnin,
  thin = 1,
  print_interval = 100,
  numerical_thresh = 1e-07,
  adaption.N = burnin,
  adaption.batchSize = 50,
  adaption.tar = 0.44,
  eta = ncol(data),
  omega = ncol(data),
  Sigma = 10000 * diag(ncol(data)),
  k.theta = 0.01,
  kmax = 100 * coars + 500 * (!coars),
  trunc_l = 0.1,
  trunc_r = 0.9,
  coars = F,
  L = max(20, length(data)^(1/3))
)
}
\arguments{
\item{data}{numeric matrix; NA values are interpreted as missing values and treated as random}

\item{Ntotal}{total number of iterations to run the Markov chain}

\item{burnin}{number of initial iterations to be discarded}

\item{thin}{thinning number (postprocessing)}

\item{print_interval}{Number of iterations, after which a status is printed to console}

\item{numerical_thresh}{Lower (numerical pointwise) bound for the eigenvalues of the spectral density}

\item{adaption.N}{total number of iterations, in which the proposal variances (of r and U) are adapted}

\item{adaption.batchSize}{batch size of proposal adaption}

\item{adaption.tar}{target acceptance rate for adapted parameters}

\item{eta}{AGamma process parameter, real number > ncol(data)-1}

\item{omega}{AGamma process parameter, positive constant}

\item{Sigma}{AGamma process parameter, Hpd matrix}

\item{k.theta}{prior parameter for polynomial degree k (propto exp(-k.theta*k*log(k)))}

\item{kmax}{upper bound for polynomial degree of Bernstein-Dirichlet mixture (can be set to Inf, algorithm is faster with kmax<Inf due to pre-computation of basis functions, but values 500<kmax<Inf are very memory intensive)}

\item{trunc_l, trunc_r}{left and right truncation of Bernstein polynomial basis functions, 0<=trunc_l<trunc_r<=1}

\item{coars}{flag indicating whether coarsened or default bernstein polynomials are used (see Appendix E.1 in Ghosal and van der Vaart 2017)}

\item{L}{truncation parameter of Gamma process}
}
\value{
list containing the following fields:

   \item{r,x,U}{traces of the AGamma process parameters}
   \item{k}{posterior trace of polynomial degree}
   \item{psd.median,psd.mean}{psd estimates: (pointwise, componentwise) posterior median and mean}
   \item{psd.p05,psd.p95}{pointwise credibility interval}
   \item{psd.u05,psd.u95}{uniform credibility interval, see (6.5) in Meier (2018)}
   \item{lpost}{trace of log posterior}
}
\description{
Obtain samples of the posterior of the multivariate Whittle likelihood in conjunction with an Hpd AGamma process prior on the spectral density matrix.
}
\details{
A detailed description of the method can be found in Section 5 in Meier (2018).
}
\examples{
\dontrun{

##
## Example: Fit multivariate NP model to SOI/Recruitment series:
##

data <- cbind(as.numeric(astsa::soi-mean(astsa::soi)), 
              as.numeric(astsa::rec-mean(astsa::rec)) / 50)
data <- apply(data, 2, function(x) x-mean(x))

# If you run the example be aware that this may take several minutes
print("example may take some time to run")
mcmc <- gibbs_vnp(data=data, Ntotal=10000, burnin=4000, thin=2)

# Visualize results
plot(mcmc, log=T)


##
## Example 2: Fit multivariate NP model to VMA(1) data
##

n <- 256
ma <- rbind(c(-0.75, 0.5), c(0.5, 0.75))
Sigma <- rbind(c(1, 0.5), c(0.5, 1))
data <- sim_varma(model=list(ma=ma), n=n, d=2)
data <- apply(data, 2, function(x) x-mean(x))

# If you run the example be aware that this may take several minutes
print("example may take some time to run")
mcmc <- gibbs_vnp(data=data, Ntotal=10000, burnin=4000, thin=2)

# Plot spectral estimate, credible regions and periodogram on log-scale
plot(mcmc, log=T)
}
}
\references{
A. Meier (2018)
\emph{A Matrix Gamma Process and Applications to Bayesian Analysis of Multivariate Time Series}
PhD thesis, OvGU Magdeburg
<https://opendata.uni-halle.de//handle/1981185920/13470>
}
