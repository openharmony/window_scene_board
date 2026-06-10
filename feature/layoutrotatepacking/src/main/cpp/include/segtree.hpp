/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef SEGTREE_HPP
#define SEGTREE_HPP
#include <algorithm>
#include <optional>
#include <vector>

namespace Gui {

struct SegTree {
    SegTree() = default;
    explicit SegTree(int n, int k = 0)
    {
        Resize(n, k);
    }
    ~SegTree() = default;

    void Resize(int n, int k = 0)
    {
        this->arrSize = n;
        this->tree_.resize(n * 4);
        Build(1, 0, arrSize - 1, k);
    }

    int Size()
    {
        return this->arrSize;
    }

    int GetSum(int l, int r)
    {
        return GetSum(1, 0, arrSize - 1, std::max(l, 0), std::min(r, arrSize - 1));
    }

    void Add(int l, int r, int k)
    {
        return Add(1, 0, arrSize - 1, std::max(l, 0), std::min(r, arrSize - 1), k);
    }

    void Assign(int l, int r, int k)
    {
        return Assign(1, 0, arrSize - 1, std::max(l, 0), std::min(r, arrSize - 1), k);
    }

    int GetFirstNonzero()
    {
        return GetFirstNonzero(1, 0, arrSize - 1);
    }

private:
    int GetFirstNonzero(int h, int l, int r)
    {
        if (tree_[h].sum == 0) {
            return -1;
        }
        if (l == r) {
            return l;
        }
        int w = (l + r) / 2;
        Push(h, l, r);
        if (tree_[h * 2].sum > 0) {
            return GetFirstNonzero(h * 2, l, w);
        } else {
            return GetFirstNonzero(h * 2 + 1, w + 1, r);
        }
    }

    void Add(int h, int l, int r, int x, int y, int k)
    {
        if (x > y) {
            return;
        }
        if (l == x && y == r) {
            tree_[h].sum += k * (r - l + 1);
            tree_[h].pushAdd += k;
            return;
        }
        int w = (l + r) / 2;
        Push(h, l, r);
        Add(h * 2, l, w, x, std::min(y, w), k);
        Add(h * 2 + 1, w + 1, r, std::max(x, w + 1), y, k);
        tree_[h].MakeFrom(tree_[h * 2], tree_[h * 2 + 1]);
    }

    void Assign(int h, int l, int r, int x, int y, int k)
    {
        if (x > y) {
            return;
        }
        if (l == x && y == r) {
            tree_[h].sum = k * (r - l + 1);
            tree_[h].pushAssign = k;
            return;
        }
        int w = (l + r) / 2;
        Push(h, l, r);
        Assign(h * 2, l, w, x, std::min(y, w), k);
        Assign(h * 2 + 1, w + 1, r, std::max(x, w + 1), y, k);
        tree_[h].MakeFrom(tree_[h * 2], tree_[h * 2 + 1]);
    }

    int GetSum(int h, int l, int r, int x, int y)
    {
        if (x > y) {
            return 0;
        }
        if (l == x && y == r) {
            return tree_[h].sum;
        }
        int w = (l + r) / 2;
        Push(h, l, r);
        return GetSum(h * 2, l, w, x, std::min(y, w)) + GetSum(h * 2 + 1, w + 1, r, std::max(x, w + 1), y);
    }

    void Build(int h, int l, int r, int k = 0)
    {
        if (l == r) {
            tree_[h].sum = k;
            return;
        }
        int w = (l + r) / 2;
        Build(h * 2, l, w, k);
        Build(h * 2 + 1, w + 1, r, k);
        tree_[h].MakeFrom(tree_[h * 2], tree_[h * 2 + 1]);
    }

    void Push(int h, int l, int r)
    {
        if (tree_[h].pushAdd) {
            int w = (l + r) / 2;
            tree_[h * 2].sum += (w - l + 1) * tree_[h].pushAdd;
            tree_[h * 2].pushAdd += tree_[h].pushAdd;
            tree_[h * 2 + 1].sum += (r - w) * tree_[h].pushAdd;
            tree_[h * 2 + 1].pushAdd += tree_[h].pushAdd;
            tree_[h].pushAdd = 0;
        }
        if (tree_[h].pushAssign.has_value()) {
            int w = (l + r) / 2;
            tree_[h * 2].sum = (w - l + 1) * tree_[h].pushAssign.value();
            tree_[h * 2].pushAssign = tree_[h].pushAssign.value();
            tree_[h * 2 + 1].sum = (r - w) * tree_[h].pushAssign.value();
            tree_[h * 2 + 1].pushAssign = tree_[h].pushAssign.value();
            tree_[h].pushAssign = std::nullopt;
        }
    }

    struct Node {
        int sum{0};
        int pushAdd{0};
        std::optional<int> pushAssign{std::nullopt};

        void MakeFrom(Node const &a, Node const &b)
        {
            sum = a.sum + b.sum;
            pushAdd = 0;
            pushAssign = std::nullopt;
        }
    };

    int arrSize{0};
    std::vector<Node> tree_{};
};

}  // namespace Gui
#endif // SEGTREE_HPP
