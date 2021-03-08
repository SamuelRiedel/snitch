import re
import seaborn as sns
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# Configure
plot_all = True

# Read the data
p_run = re.compile("[a-zA-z0-9\s]*\(([0-9]*)\).*:([\s\-a-zA-Z]*)")
p_num = re.compile("([0-9\.]+)\s([kMG]?)")
df = pd.DataFrame(columns=['cores', 'flags', 'perf'])
with open('results.log', 'r') as f:
    cores = 0
    latency = False
    trace = False
    perf = 0
    for line in f:
        # print("Text: {}".format(line))
        run = p_run.match(line)
        if run is not None:
            cores = int(run[1])
            latency = "latency" in run[2]
            trace = "trace" in run[2]
            continue
        num = p_num.match(line)
        if num is not None:
            perf = float(num[1])
            if 'k' in num[2]: perf = perf * 10 ** 3
            if 'M' in num[2]: perf = perf * 10 ** 6
            if 'G' in num[2]: perf = perf * 10 ** 9
            if plot_all or trace:
                if not plot_all: perf = perf / 10 ** 3
                df = df.append({'cores': cores, 'flags': (trace, latency), 'perf': perf}, ignore_index=True)
        # print("Cores {}, Latency {}, Trace {}: {} inst/s".format(cores, latency, trace, perf))

sns.set_style("whitegrid", {'grid.linestyle': '--'})
pal = sns.color_palette("mako", 4)
# sns.set_palette(pal[2:])
# penguins = sns.load_dataset("penguins")

print(df.groupby(['cores','flags']).mean())

# Draw a nested barplot by species and sex
fig, ax = plt.subplots()
g = sns.catplot(
    data=df, kind="bar",
    x="cores", y="perf", hue="flags",
    ci="sd", alpha=1, height=6, aspect=2,
    errcolor='silver', errwidth=2, capsize=0.07
)
g.despine(left=True)

if plot_all:
    g.set_axis_labels("Cores", "Performance [Inst/s]")
    g.ax.yaxis.set_minor_locator(ticker.LogLocator(base=10, subs='all'))
    g.ax.yaxis.set_minor_formatter(ticker.NullFormatter())
    g.ax.set_yscale('log')
else:
    g.set_axis_labels("Cores", "Performance [kInst/s]")

g.ax.grid(True, which="both", ls="--", c='gray')
# g.fig.get_axes()[0].legend(loc='lower left')
g.legend.set_title("Flags")
new_labels = ['None', 'Latency', 'Tracing', 'Tracing & Latency']
# new_labels = new_labels[2:]
for t, l in zip(g._legend.texts, new_labels): t.set_text(l)

g.savefig("output.pdf")
