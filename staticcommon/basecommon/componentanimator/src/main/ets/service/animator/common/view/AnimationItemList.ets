/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { AnimationViewData, AnimationViewDataList } from '../viewmodel/AnimationViewData';
import { AnimationItem } from './AnimationItem';

/**
 * 用截图来执行动效的组件列表，适用于有多个截图执行动效的场景
 */
@Component
export struct AnimationItemList {
  private tag: string = '';
  @Link viewDataList: AnimationViewDataList;

  build() {
    if (this.viewDataList.length > 0) {
      Stack({ alignContent: Alignment.TopStart }) {
        ForEach(this.viewDataList, (item: AnimationViewData) => {
          AnimationItem({ tag: this.tag, viewData: item })
        })
      }
      .id(`AnimationItemList_${this.tag}`)
      .position({ x: 0, y: 0 })
      .hitTestBehavior(HitTestMode.Transparent)
    }
  }
}