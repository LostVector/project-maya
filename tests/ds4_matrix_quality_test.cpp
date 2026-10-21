#include "../src/ds4/ds4_model.hpp"
#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

static std::vector<int> ids(const std::string& path) {
    std::ifstream f(path);
    std::string s((std::istreambuf_iterator<char>(f)), {});
    for (auto& c : s) if (c == '[' || c == ']' || c == ',') c = ' ';
    std::istringstream in(s); std::vector<int> out; int x;
    while (in >> x) out.push_back(x);
    return out;
}
int main(int argc, char** argv) {
    if (argc != 3) return 2;
    const std::string root = argv[2];
    for (const char* key : {"DS4_HIP_HOST_COPY_WAIT", "DS4_HIP_PEER_AR", "DS4_EXL3_PREDECODE",
                            "DS4_EXL3_PACKED_HOST", "DS4_EXL3_FMA16", "DS4_SKIP_UNPICKED",
                            "DS4_EXL3_MATRIX_DECODED"}) setenv(key, "1", 1);
    setenv("DS4_EXL3_MATRIX_RELAXED", "0", 1);
    setenv("DS4_EXL3_MATRIX_ROWS", "16", 1);
    setenv("DS4_SPLIT", "36,4", 1);
    setenv("DS4_CACHE_BONUS", "1e30", 1);
    setenv("DS4_ENGRAM_THREADS", "16", 1);
    setenv("DS4_PATH_PICK", "0", 1);
    strata::ds4::Options o;
    o.pack = argv[1]; o.gpus = {0,1,2}; o.max_context = 262144; o.reserve_mib = 2048;
    o.tp = 2; o.threads = true; o.mmap_experts = 0; o.dspark = false; o.vision = false;
    o.prefill_chunk = 2048; o.profile = root + "/frozen-profile.bin";
    strata::ds4::Model m; std::string err;
    if (!m.load(o, err)) { std::fprintf(stderr, "%s\n", err.c_str()); return 1; }
    std::ofstream allocation(root + "/allocation.txt"); allocation << m.describe(); allocation.close();
    std::ifstream list(root + "/case-list.txt"); std::string name; int count = 0;
    std::ofstream results(root + "/scores.jsonl"); results.precision(17);
    while (std::getline(list, name)) {
        const auto prompt = ids(root + "/" + name + "-ids.json");
        const auto answer = ids(root + "/" + name + "-answer-ids.json");
        if (prompt.empty() || answer.empty()) return 1;
        for (int pos = 0; pos < 2; ++pos) {
            const int mode = (count + pos) % 2;
            setenv("DS4_EXL3_MATRIX_RELAXED", mode ? "1" : "0", 1);
            if (!m.benchmark_host_mode(true, false)) return 1;
            m.reset();
            if (!m.feed(prompt.data(), int(prompt.size()), 1, err)) {
                std::fprintf(stderr, "%s\n", err.c_str()); return 1;
            }
            double nll = 0;
            for (int target : answer) {
                std::vector<float> logits;
                if (!m.logits(logits) || logits.size() != size_t(m.vocab()) || target < 0 || target >= m.vocab()) return 1;
                for (float x : logits) if (!std::isfinite(x)) return 1;
                const double maximum = *std::max_element(logits.begin(), logits.end());
                double sum = 0;
                for (float x : logits) sum += std::exp(double(x) - maximum);
                nll += maximum + std::log(sum) - logits[size_t(target)];
                if (!m.step(target, true, err)) return 1;
            }
            m.reset();
            if (!m.feed(prompt.data(), int(prompt.size()), 1, err)) return 1;
            std::ofstream generated(root + "/" + name + "-mode" + std::to_string(mode) + "-tokens.txt");
            bool ended = false;
            for (int i = 0; i < 64; ++i) {
                const int token = m.sample(0, 1, 0, 0, 0, i);
                if (token < 0 || token >= m.vocab()) return 1;
                if (token == 1) { ended = true; break; } // pack config EOS=1
                generated << token << '\n';
                if (!m.step(token, true, err)) return 1;
            }
            generated.close();
            if (!generated || !std::isfinite(nll)) return 1;
            results << "{\"id\":\"" << name << "\",\"mode\":" << mode
                    << ",\"prompt_tokens\":" << prompt.size() << ",\"answer_tokens\":" << answer.size()
                    << ",\"answer_nll_sum\":" << nll << ",\"ended\":" << (ended ? "true" : "false") << "}\n";
            results.flush();
            std::fprintf(stderr, "QUALITY id=%s mode=%d nll=%.6f ended=%d\n", name.c_str(), mode, nll, int(ended));
        }
        ++count;
    }
    std::fprintf(stderr, "QUALITY_COMPLETE cases=%d swaps=%lld ram_moves=%lld\n", count,
                 (long long)m.stats().swaps, (long long)m.stats().ram_moves);
    return count == 12 && results && !m.stats().swaps && !m.stats().ram_moves ? 0 : 1;
}
