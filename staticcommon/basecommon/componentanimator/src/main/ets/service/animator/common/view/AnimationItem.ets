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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimationViewData } from '../viewmodel/AnimationViewData';

const TAG: string = 'AnimationItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 用截图来执行动效的组件
 */
@Component
export struct AnimationItem {
  private tag: string = '';
  @State viewData?: AnimationViewData = undefined;

  build() {
    if (this.viewData && this.viewData.pixmap) {
      Image(this.viewData.pixmap)
        .id(`${TAG}_${this.tag}_${this.viewData?.key}`)
        .draggable(false)
        .hitTestBehavior(HitTestMode.Transparent)
        .clip(true)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .width(this.viewData.width)
        .objectFit(this.viewData.imageFit) // 保证图片比例、编辑模式缩放可能会存在误差
        .height(this.viewData.height)
        .borderRadius(this.viewData.radius)
        .visibility(this.viewData.isShow ? Visibility.Visible : Visibility.Hidden)
        .scale({ x: this.viewData.scaleX, y: this.viewData.scaleY })
        .zIndex(this.viewData.zIndex)
        .translate({ x: this.viewData.translateX - this.viewData.width / 2,
          y: this.viewData.translateY - this.viewData.height / 2 })
        .offset({ x: this.viewData.offsetX, y: this.viewData.offsetY })
        .rotate(this.viewData.rotate)
        .useEffect(this.viewData.useEffect)
        .opacity(this.viewData.opacity)
        .onAppear(() => {
          log.showInfo(`animation item appear tag:${this.tag} key:${this.viewData?.key}`);
        })
        .onDisAppear(() => {
          log.showInfo(`animation item disappear tag:${this.tag} key:${this.viewData?.key}`);
        })
    }
  }
}