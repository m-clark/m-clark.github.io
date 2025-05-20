cp_split  <- function(
    x, y, x0, train.fun, predict.fun, alpha = 0.1, rho = 0.5,
    w = NULL, mad.train.fun = NULL, mad.predict.fun = NULL, split = NULL,
    seed = NULL, verbose = FALSE) {
    x <- as.matrix(x)
    y <- as.numeric(y)
    n <- nrow(x)
    p <- ncol(x)
    x0 <- matrix(x0, ncol = p)
    n0 <- nrow(x0)
    check.args(
        x = x, y = y, x0 = x0, alpha = alpha, train.fun = train.fun,
        predict.fun = predict.fun, mad.train.fun = mad.train.fun,
        mad.predict.fun = mad.predict.fun
    )
    if (is.null(rho) || length(rho) != 1 || !is.numeric(rho) ||
        rho <= 0 || rho >= 1) {
        stop("rho must be a number in between 0 and 1")
    }
    if (is.null(w)) {
        w <- rep(1, n + n0)
    }
    if (verbose == TRUE) {
        txt <- ""
    }
    if (verbose != TRUE && verbose != FALSE) {
        txt <- verbose
        verbose <- TRUE
    }
    if (!is.null(split)) {
        i1 <- split
    } else {
        if (!is.null(seed)) {
            set.seed(seed)
        }
        i1 <- sample(1:n, floor(n * rho))
    }
    i2 <- (1:n)[-i1]
    n1 <- length(i1)
    n2 <- length(i2)
    if (verbose) {
        cat(sprintf(
            "%sSplitting data into parts of size %i and %i ...\n",
            txt, n1, n2
        ))
        cat(sprintf("%sTraining on first part ...\n", txt))
    }
    out <- train.fun(x[i1, , drop = F], y[i1])
    fit <- matrix(predict.fun(out, x), nrow = n)
    pred <- matrix(predict.fun(out, x0), nrow = n0)
    m <- ncol(pred)
    if (verbose) {
        cat(sprintf(
            "%sComputing residuals and quantiles on second part ...\n",
            txt
        ))
    }
    res <- abs(y[i2] - matrix(predict.fun(out, x[i2, , drop = F]),
        nrow = n2
    ))
    lo <- up <- matrix(0, n0, m)
    for (l in 1:m) {
        if (!is.null(mad.train.fun) && !is.null(mad.predict.fun)) {
            res.train <- abs(y[i1] - fit[i1, l])
            mad.out <- mad.train.fun(x[i1, , drop = F], res.train)
            mad.x2 <- mad.predict.fun(mad.out, x[i2, , drop = F])
            mad.x0 <- mad.predict.fun(mad.out, x0)
            res[, l] <- res[, l] / mad.x2
        } else {
            mad.x0 <- rep(1, n0)
        }
        o <- order(res[, l])
        r <- res[o, l]
        ww <- w[i2][o]
        for (i in 1:n0) {
            q <- weighted.quantile(
                c(r, Inf), 
                1 - alpha, 
                w = c(ww, w[n + i]), 
                sorted = TRUE
            )
            lo[i, l] <- pred[i, l] - q * mad.x0[i]
            up[i, l] <- pred[i, l] + q * mad.x0[i]
        }
    }
    return(list(pred = pred, lo = lo, up = up, fit = fit, split = i1))
}