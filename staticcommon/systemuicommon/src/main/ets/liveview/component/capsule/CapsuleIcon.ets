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

import { LengthMetrics } from '@ohos.arkui.node';
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { CapsuleListState } from '../../info/capsule/CapsuleListState';
import { capsuleStateMgr } from '../../CapsuleManager';
import { SysTypeCode } from '../../common/LiveConstants';

interface ICapsuleIconProps {
  icon: image.PixelMap | string;
  opacity?: number;
}

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, 'CapsuleIcon');

@Component
export struct CapsuleIcon {
  /**
   * 实况胶囊样式
   */
  @State capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
  @ObjectLink data: LiveCapsuleData;
  @Prop iconOpacity?: number;
  @State isScreenRecord: boolean = false;

  @Builder
  image($$: ICapsuleIconProps) {
    Image($$.icon)
      .draggable(false)
      .objectFit(this.data.typeCode === SysTypeCode.BROADCASTING_CENTER ? ImageFit.Cover : ImageFit.Contain)
      .width('100%')
      .height('100%')
      .borderRadius(this.data.typeCode === SysTypeCode.BROADCASTING_CENTER ? '100%' : undefined)
      .clip(this.data.typeCode === SysTypeCode.BROADCASTING_CENTER)
      .interpolation(ImageInterpolation.Medium)
      .opacity($$.opacity)
      .syncLoad(true)
  }

  build() {
    Stack() {
      if (this.data?.prevIcon) {
        this.image({
          icon: this.data.prevIcon,
          opacity: typeof this.iconOpacity === 'number' ? 1 - this.iconOpacity : 0,
        })
      }
      if (this.data?.icon) {
        this.image({
          icon: this.data.icon,
          opacity: this.iconOpacity ?? undefined,
        })
      }
    }
    .width(this.capsuleListState.capsuleIconWidth)
    .height(this.capsuleListState.capsuleIconWidth)
    .margin({
      start: LengthMetrics.vp(this.isScreenRecord ? 0 : this.capsuleListState.capsuleIconLeftMargin),
      end: LengthMetrics.vp(this.isScreenRecord ? this.capsuleListState.capsuleIconLeftMargin : 0)
    })
  }
}