# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "marimo>=0.23.3",
#     "numpy",
#     "pandas",
# ]
# ///

import marimo

__generated_with = "0.25.2"
app = marimo.App(width="medium")


@app.cell(hide_code=True)
def _():
    import marimo as mo
    import numpy as np
    import pandas as pd

    return mo, np, pd


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    # Fellegi-Sunter by hand

    A toy version of what splink does to get $m$ and $u$.

    - 100 records, 3 fields: `fname`, `lname`, `dob`
    - 95 distinct people, plus 5 duplicate records of 5 of them
        - 2 are exact copies
        - 3 differ on one field (fname typo, lname change, dob off by a year)
    - Comparisons are plain exact agreement (1/0) per field. Splink would usually
      have several levels per field (exact, fuzzy, else), but binary keeps the
      algebra visible.

    For a field $k$ and comparison vector $\gamma$:

    - $m_k = P(\gamma_k = 1 \mid \text{match})$
    - $u_k = P(\gamma_k = 1 \mid \text{non-match})$
    - $\pi = P(\text{match})$ for a random pair
    """)

    return


@app.cell
def _(np, pd):
    rng = np.random.default_rng(1234)
    fields = ["fname", "lname", "dob"]

    first_names = (
        "James Mary John Patricia Robert Jennifer Michael Linda William Elizabeth "
        "David Barbara Richard Susan Joseph Jessica Thomas Sarah Charles Karen "
        "Daniel Nancy Matthew Lisa Anthony Betty Mark Margaret Donald Sandra"
    ).split()
    last_names = (
        "Smith Johnson Williams Brown Jones Garcia Miller Davis Rodriguez Martinez "
        "Hernandez Lopez Gonzalez Wilson Anderson Thomas Taylor Moore Jackson Martin "
        "Lee Perez Thompson White Harris Sanchez Clark Ramirez Lewis Robinson"
    ).split()

    def zipf_p(k, s=1.0):
        # some names are much more common than others, like real life
        w = 1 / np.arange(1, k + 1) ** s

        return w / w.sum()

    n_people = 95
    people = pd.DataFrame(
        {
            "entity_id": np.arange(n_people),
            "fname": rng.choice(first_names, n_people, p=zipf_p(len(first_names))),
            "lname": rng.choice(last_names, n_people, p=zipf_p(len(last_names))),
            "dob": (
                pd.Timestamp("1960-01-01")
                + pd.to_timedelta(rng.integers(0, 365 * 40, n_people), unit="D")
            ).strftime("%Y-%m-%d"),
        }
    )

    # 5 duplicate records of 5 different people
    dupes = people.iloc[rng.choice(n_people, 5, replace=False)].copy()
    dupes["dupe_type"] = ["full", "full", "fname typo", "lname change", "dob year"]

    # fname typo: drop a character
    _f = dupes.columns.get_loc("fname")
    dupes.iat[2, _f] = dupes.iat[2, _f][:2] + dupes.iat[2, _f][3:]

    # lname change: a different surname
    _l = dupes.columns.get_loc("lname")
    dupes.iat[3, _l] = rng.choice([n for n in last_names if n != dupes.iat[3, _l]])

    # dob entry error: wrong year
    _d = dupes.columns.get_loc("dob")
    _old = dupes.iat[4, _d]
    dupes.iat[4, _d] = str(int(_old[:4]) + 1) + _old[4:]

    df = (
        pd.concat([people.assign(dupe_type=""), dupes])
        .sample(frac=1, random_state=1)
        .reset_index(drop=True)
        .rename_axis("record_id")
        .reset_index()
    )

    return df, fields


@app.cell
def _(df, mo):
    _ids = df.loc[df.dupe_type != "", "entity_id"]
    mo.vstack(
        [
            mo.md(f"**{len(df)} records.** The duplicated entities:"),
            df[df.entity_id.isin(_ids)].sort_values(["entity_id", "dupe_type"]),
        ]
    )

    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Comparison vectors

    Every pair of records ($\binom{100}{2} = 4950$) gets a vector $\gamma$ of
    0/1 agreements. With 3 binary fields there are only $2^3 = 8$ possible
    patterns, so the whole dataset collapses to 8 counts. That table is all EM
    ever sees. The `true_matches` column is the answer key, which the model does
    *not* get.
    """)

    return


@app.cell
def _(df, fields, np, pd):
    _i, _j = np.triu_indices(len(df), k=1)

    pairs = pd.DataFrame(
        {
            "id_l": df.record_id.values[_i],
            "id_r": df.record_id.values[_j],
            **{f: (df[f].values[_i] == df[f].values[_j]).astype(int) for f in fields},
            "is_match": df.entity_id.values[_i] == df.entity_id.values[_j],
        }
    )
    G = pairs[fields].to_numpy()

    patterns = (
        pairs.groupby(fields)
        .agg(n_pairs=("is_match", "size"), true_matches=("is_match", "sum"))
        .reset_index()
        .sort_values(fields, ascending=False)
    )
    patterns

    return G, pairs


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## The answer key

    Since we know the truth here, we can just compute $m$ and $u$ directly. With
    only 5 true matching pairs, "truth" for $m$ is coarse (multiples of 0.2).
    """)

    return


@app.cell
def _(G, fields, pairs, pd):
    _match = pairs.is_match.to_numpy()
    truth = pd.DataFrame(
        {
            "m_true": G[_match].mean(0),
            "u_true": G[~_match].mean(0),
        },
        index=fields,
    )

    pi_true = _match.mean()
    truth

    return pi_true, truth


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Step 1: $u$ from random pairs

    Splink's `estimate_u_using_random_sampling()`: take a big random sample of
    pairs and *pretend they are all non-matches*. Since $\pi$ is tiny, that's
    nearly true, and the agreement rate is the $u$ estimate. Here we can afford
    to use every pair. The 5 matches contaminate it slightly, which you can see
    by comparing to `u_true`.

    $u$ is then **held fixed** for everything that follows, which is splink's
    default behavior in EM training.
    """)

    return


@app.cell
def _(G, fields, pd, truth):
    u_hat = G.mean(0)
    pd.DataFrame({"u_hat": u_hat, "u_true": truth.u_true}, index=fields)

    return (u_hat,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Step 2: $\pi$ from a deterministic rule

    Splink's `estimate_probability_two_random_records_match()`: count pairs that
    satisfy a strict rule we're confident means "match", then inflate by a
    guessed recall, since a strict rule misses matches with any error.

    Rule: all three fields agree. Here we "guess" recall = 0.4, which happens to
    be right (2 of 5 duplicates are exact), but in practice this is a judgment
    call.
    """)

    return


@app.cell
def _(G, pi_true):
    recall_guess = 0.4
    _n_rule = (G.sum(1) == G.shape[1]).sum()
    pi_hat = _n_rule / recall_guess / len(G)
    print(f"pairs meeting rule: {_n_rule}")
    print(f"pi_hat:  {pi_hat:.6f}")
    print(f"pi_true: {pi_true:.6f}")

    return (pi_hat,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Step 3: EM for $m$

    Each pair is a draw from a two-component mixture of independent Bernoullis
    (independence across fields given match status is the core Fellegi-Sunter
    assumption):

    $$
    P(\gamma) = \pi \prod_k m_k^{\gamma_k}(1-m_k)^{1-\gamma_k}
    + (1-\pi) \prod_k u_k^{\gamma_k}(1-u_k)^{1-\gamma_k}
    $$

    - **E step**: $p_i = P(\text{match} \mid \gamma_i)$, the posterior
      probability that pair $i$ is a match, from Bayes' rule using current $m, u, \pi$.
    - **M step**: weighted agreement rates.
      $m_k = \sum_i p_i \gamma_{ik} / \sum_i p_i$, $\pi = \bar{p}$,
      and (if not fixed) $u_k = \sum_i (1-p_i) \gamma_{ik} / \sum_i (1-p_i)$.
    """)

    return


@app.cell
def _(np):
    def em(G, m, u, pi, fix_u=True, max_iter=200, tol=1e-8):
        m, u = np.asarray(m, float).copy(), np.asarray(u, float).copy()
        history = []

        for _ in range(max_iter):
            # E step
            p_m = pi * np.prod(m**G * (1 - m) ** (1 - G), axis=1)
            p_u = (1 - pi) * np.prod(u**G * (1 - u) ** (1 - G), axis=1)
            p_match = p_m / (p_m + p_u)

            # M step
            m_new = (p_match[:, None] * G).sum(0) / p_match.sum()
            pi_new = p_match.mean()

            if not fix_u:
                u = ((1 - p_match)[:, None] * G).sum(0) / (1 - p_match).sum()

            m_new = m_new.clip(1e-6, 1 - 1e-6)  # keep log weights finite

            # convergence
            delta = np.abs(m_new - m).max()
            m, pi = m_new, pi_new
            history.append([*m, pi])

            if delta < tol:
                break

        return dict(m=m, u=u, pi=pi, p_match=p_match, history=np.array(history))

    return (em,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ### 3a. Splink style: EM within blocks

    Splink doesn't run EM over all pairs. It runs separate training sessions,
    each on pairs that pass a **blocking rule**. Within a block, the blocked
    field agrees by construction, so its $m$ can't be learned there and it is
    dropped from that session. Hence multiple sessions with different rules,
    and $m$ is averaged for fields estimated in more than one.

    The in-block $\pi$ is much larger than the global one (that's the point
    of blocking: enrich for matches), and is re-estimated per session and then
    thrown away. The global $\pi$ from step 2 is what's used for prediction.

    Starting $m$ = 0.9 for every field, in-block $\pi$ start = 0.1.
    """)

    return


@app.cell
def _(G, em, fields, np, pairs, pd, u_hat):
    sessions = {}

    for _block_on in ["fname", "lname"]:
        _keep = pairs[_block_on].to_numpy() == 1
        _est = [f for f in fields if f != _block_on]
        _idx = [fields.index(f) for f in _est]
        _fit = em(G[_keep][:, _idx], m=[0.9] * len(_idx), u=u_hat[_idx], pi=0.1)
        sessions[_block_on] = dict(
            n_pairs=int(_keep.sum()),
            n_true=int(pairs.is_match[_keep].sum()),
            iters=len(_fit["history"]),
            pi_block=_fit["pi"],
            m=dict(zip(_est, _fit["m"])),
        )

    session_table = pd.DataFrame(
        {
            f"block on {k}": {
                "pairs in block": v["n_pairs"],
                "true matches in block": v["n_true"],
                "EM iterations": v["iters"],
                "in-block pi": round(v["pi_block"], 4),
                **{f"m_{f}": round(v["m"].get(f, np.nan), 3) for f in fields},
            }
            for k, v in sessions.items()
        }
    )

    # average m over sessions that estimated it
    m_splink = np.array(
        [np.mean([s["m"][f] for s in sessions.values() if f in s["m"]]) for f in fields]
    )
    session_table

    return (m_splink,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ### 3b. Classic Fellegi-Sunter: one EM over all pairs

    For comparison, the textbook version: every pair, estimate $m$, $u$ and
    $\pi$ together. With 5 matches in 4950 pairs this is a hard mixture to
    find, and the result is sensitive to starting values.
    """)

    return


@app.cell
def _(G, em, fields, pd, pi_hat, u_hat):
    fit_full = em(G, m=[0.9] * 3, u=u_hat, pi=pi_hat, fix_u=False)
    pd.DataFrame(
        fit_full["history"], columns=[*[f"m_{f}" for f in fields], "pi"]
    ).rename_axis("iter")

    return (fit_full,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Compare the estimates
    """)

    return


@app.cell
def _(fields, fit_full, m_splink, pd, pi_hat, pi_true, truth, u_hat):
    comparison = pd.DataFrame(
        {
            "m_true": truth.m_true,
            "m_splink_style": m_splink,
            "m_full_em": fit_full["m"],
            "u_true": truth.u_true,
            "u_random_pairs": u_hat,
            "u_full_em": fit_full["u"],
        },
        index=fields,
    ).round(4)

    _pi = pd.Series(
        {"true": pi_true, "deterministic rule": pi_hat, "full EM": fit_full["pi"]},
        name="pi",
    )
    comparison, _pi.round(6)

    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Match weights and scoring

    Each field level contributes $\log_2$ of a Bayes factor:

    - agree: $\log_2(m_k / u_k)$
    - disagree: $\log_2\big((1-m_k)/(1-u_k)\big)$

    Add the prior weight $\log_2(\pi / (1-\pi))$ and sum to get the total
    match weight $W$; the match probability is $2^W / (1 + 2^W)$. This is what
    splink's waterfall charts show.
    """)

    return


@app.cell
def _(fields, m_splink, np, pd, pi_hat, u_hat):
    weights = pd.DataFrame(
        {
            "m": m_splink,
            "u": u_hat,
            "w_agree": np.log2(m_splink / u_hat),
            "w_disagree": np.log2((1 - m_splink) / (1 - u_hat)),
        },
        index=fields,
    ).round(3)

    prior_weight = np.log2(pi_hat / (1 - pi_hat))
    print(f"prior weight: {prior_weight:.2f}")
    weights

    return prior_weight, weights


@app.cell
def _(G, df, fields, np, pairs, prior_weight, weights):
    _W = prior_weight + np.where(
        G == 1, weights.w_agree.to_numpy(), weights.w_disagree.to_numpy()
    ).sum(1)

    scored = pairs.assign(
        match_weight=_W.round(2),
        match_prob=(2**_W / (1 + 2**_W)).round(4),
    ).sort_values("match_weight", ascending=False)

    # true matches first (uses the answer key), then the top-scoring non-matches
    top = scored.sort_values(["is_match", "match_weight"], ascending=False).head(15)

    # attach names and dobs for display
    _lookup = df.set_index("record_id")

    for _side in ["l", "r"]:
        _rec = _lookup.loc[top[f"id_{_side}"], fields]
        top[f"name_{_side}"] = (_rec.fname + " " + _rec.lname).to_numpy()
        top[f"dob_{_side}"] = _rec.dob.to_numpy()

    _cols = ["name_l", "dob_l", "name_r", "dob_r", *fields]
    top[[*_cols, "match_weight", "match_prob", "is_match"]]

    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ### What the table shows

    All 5 true duplicate pairs, followed by the 10 highest-scoring non-matches
    out of the 4950 pairs. The ordering uses the answer key so the true pairs
    sit together; the scores themselves come only from the splink-style $m$,
    the random-pairs $u$, and the rule-based $\pi$.

    - `name_l`, `dob_l`, `name_r`, `dob_r`: the two records in the pair.
    - `fname`, `lname`, `dob`: the agreement pattern (1 = exact agreement).
    - `match_weight`: the prior weight plus each field's agree or disagree
      weight from the weights table above. For example, John Davis vs John
      Miller agrees on fname and dob but not lname:
      $-9.95 + 2.93 - 1.84 + 10.27 = 1.41$.
    - `match_prob`: that weight converted to a probability, $2^W / (1 + 2^W)$.
      This is the same as $p_i$ from the E step, evaluated at the final estimates.
    - `is_match`: the answer key, not used by the model.

    Because there are only 8 patterns, there are only 8 distinct scores. Four
    of the true pairs score well. The fifth, David Brown with the birth year
    off by one, has pattern (1, 1, 0) and scores $-24.23$, essentially 0.
    Every non-match shown below it has that same pattern and score, as do 37
    more not shown: 47 same-name strangers that the model has no way to tell
    apart from the real duplicate.
    """)

    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    Things to notice:

    - The pattern table has only 8 rows, so all pairs with the same pattern get
      the same score. That's why splink uses multi-level comparisons (exact /
      Jaro-Winkler > 0.9 / else) and term-frequency adjustments: "Smith = Smith"
      should count less than "Ramirez = Ramirez", and with one $u$ per field it
      can't.
    - Name agreement alone is common by chance (high $u$), so its weight is
      small. DOB agreement by chance is rare (low $u$), so it carries most of
      the evidence.
    - The fname-typo and lname-change duplicates still get found (prob ~0.7):
      the big dob agreement weight overcomes one name disagreement and the very
      negative prior.
    - The dob-year duplicate is **missed** (prob ~0). No non-match ever agrees
      on dob, so EM concludes "every dob disagreement is a non-match" and pushes
      $m_{dob} \to 1$, which makes the disagreement weight hugely negative. Its
      pattern (1, 1, 0) is shared with ~47 same-name strangers, so with binary
      comparisons it is unrecoverable in principle. A "dob within a year" or
      "2 of 3 date parts" level is the fix.
    - True $u_{dob}$ is exactly 0 here; the random-pairs estimate is nonzero
      *only* because of the 4 true matches it includes. Harmless at scale, but
      it shows what "assume they're all non-matches" is doing.
    - $m$ estimates are coarse because there are only 5 matches. Truth is 0.8
      for every field, since each field is broken in exactly 1 of 5 duplicates.
    """)

    return


if __name__ == "__main__":
    app.run()
