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

import {
  dropAnimationManager,
} from '@ohos/componentanimator/Index';
import {
  DropAnimationScene,
  AnimationViewData,
  AnimationViewDataList
} from '@ohos/componentanimator';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { MultiSelectStyleConfig } from '../data/MultiSelectStyleConfig';
import { EditModeUtils } from '../../TsIndex';

const TAG: string = 'DropAnimationItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct MultiSelectAnimationView {
  @State dropItemViewData: AnimationViewDataList = new AnimationViewDataList();
  private scene: DropAnimationScene = DropAnimationScene.SCENE_MULTI_SELECT;

  aboutToAppear() {
    dropAnimationManager.addDropItemArray(this.scene, this.dropItemViewData);
  }

  aboutToDisappear() {
    dropAnimationManager.removeDropItemArray(this.scene);
  }

  build() {
    if (this.dropItemViewData.length > 0) {
      Stack({ alignContent: Alignment.TopStart }) {
        ForEach(this.dropItemViewData, (item: AnimationViewData) => {
          AnimationItem({ viewData: item})
        })
      }
      .position({ x: 0, y: 0 })
    }
  }
}

@Component
export struct AnimationItem {
  @State viewData?: AnimationViewData = undefined;

  build() {
    if (this.viewData && this.viewData.pixmap) {
      RelativeContainer() {
        Image(this.viewData.pixmap)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .clip(true)
          .width(this.viewData.width)
          .height(this.viewData.height)
          .borderRadius(this.viewData.radius)
      }
      .id(`${TAG}_${this.viewData?.key}`)
      .width(this.viewData.width)
      .height(this.viewData.height)
      .draggable(false)
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility(this.viewData.isShow ? Visibility.Visible : Visibility.Hidden)
      .scale({ x: this.viewData.scaleX, y: this.viewData.scaleY })
      .zIndex(this.viewData.zIndex)
      .translate({
        x: this.viewData.translateX - this.viewData.width / 2,
        y: this.viewData.translateY - this.viewData.height / 2
      })
      .offset({ x: this.viewData.offsetX, y: this.viewData.offsetY })
      .rotate(this.viewData.rotate)
      .useEffect(this.viewData.useEffect)
      .opacity(this.viewData.opacity)
      .onAppear(() => {
        log.showInfo(`animation item appear tag:${TAG}`);
      })
      .onDisAppear(() => {
        log.showInfo(`animation item disappear tag:${TAG}`);
      })
    }
  }
}