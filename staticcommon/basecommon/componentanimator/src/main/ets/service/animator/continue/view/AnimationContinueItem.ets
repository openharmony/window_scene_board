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

import { AnimationViewDataList } from '../../common/viewmodel/AnimationViewData';
import { animationContinueManager } from '../manager/AnimationContinueManager';
import { AnimationItemList } from '../../common/view/AnimationItemList';

const TAG: string = 'AnimationContinueItem';

/**
 * 动效衔接的组件，对于动效需要互相衔接的场景，可采用截图来进行过渡，避免衔接不上导致闪烁
 */
@Component
export struct AnimationContinueItem {
  @State continueData: AnimationViewDataList = animationContinueManager.getAllData();

  build() {
    AnimationItemList({ tag: TAG, viewDataList: this.continueData })
  }
}