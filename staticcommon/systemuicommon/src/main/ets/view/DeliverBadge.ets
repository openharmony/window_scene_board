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
import { LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { ImmersiveAodStyle } from '../immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { immersiveKgMgr } from '../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';

const TAG = 'DeliverBadge';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DEFAULT_IMAGE_SIZE = 32;
const RADIUS_RATIO = 0.3;
const WIDTH_RATIO = 0.5;
const HEIGHT_RATIO = 0.8;
const BORDER_RADIUS_RATIO = 2 / 3;
const BORDER_RADIUS = 1.5;
const IMAGE_WIDTH_RADIO = 0.43;
const IMAGE_HEIGHT_RADIO = 0.5;
const OPACITY = 0.3;
const AOD_OPACITY = 0.4;


/**
 * 通知克隆应用角标
 */
@Component
export struct DeliverBadge {
  @Prop @Watch('onReflashData') iconSize: number = DEFAULT_IMAGE_SIZE;
  @Prop isKgScene: boolean = false;
  geometryTransitionId: string = '';
  @State badgeRadius: number = 0;
  @State badgeOffsetTop: number = 0;
  @State badgeOffsetStart: number = 0;
  @State badgeWidth: number = 0;
  @State badgeHeight: number = 0;
  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(this.isKgScene);
  private badgeToIconBottom: number = 3; // 卓字图标和icon下边距离3vp
  private badgeToIconRight: number = 3; // 卓字图标和icon右边距离3vp
  private badgeToSmallIconBottom: number = 2; // 卓字图标和组通知展开icon下边距离2vp
  private badgeToSmallIconRight: number = 2; // 卓字图标和组通知展开icon右边距离2vp

  aboutToAppear(): void {
    this.onReflashData();
  }

  onReflashData():void {
    this.badgeRadius = this.iconSize * RADIUS_RATIO;
    this.badgeWidth = this.iconSize * WIDTH_RATIO;
    this.badgeHeight = this.badgeWidth * HEIGHT_RATIO;

    if (this.iconSize === DEFAULT_IMAGE_SIZE) { //
      this.badgeOffsetTop = this.iconSize / 2 - this.badgeHeight / 2 - this.badgeToIconBottom;
      this.badgeOffsetStart = this.iconSize / 2 - this.badgeWidth / 2 - this.badgeToIconRight;
    } else {
      this.badgeOffsetTop = this.iconSize / 2 - this.badgeHeight / 2 - this.badgeToSmallIconBottom;
      this.badgeOffsetStart = this.iconSize / 2 - this.badgeWidth / 2 - this.badgeToSmallIconRight;
    }

    log.showInfo(`iconSize: ${this.iconSize}, geometryTransitionId ${this.geometryTransitionId} \
      badgeOffsetTop: ${this.badgeOffsetTop}, badgeOffsetStart ${this.badgeOffsetStart} badgeHeight \
      ${this.badgeHeight}, badgeWidth: ${this.badgeWidth}`);
  }

  build() {
    Stack() {
      Column()
        .backgroundColor($r('sys.color.black'))
        .width(this.badgeWidth)
        .height(this.badgeHeight)
        .borderRadius({
          topLeft: RTLUtil.isRTL() ? BORDER_RADIUS : this.badgeRadius * BORDER_RADIUS_RATIO,
          topRight: RTLUtil.isRTL() ? this.badgeRadius * BORDER_RADIUS_RATIO : BORDER_RADIUS,
          bottomLeft: RTLUtil.isRTL() ? this.badgeRadius * BORDER_RADIUS_RATIO : BORDER_RADIUS,
          bottomRight: RTLUtil.isRTL() ? BORDER_RADIUS : this.badgeRadius * BORDER_RADIUS_RATIO,
        })
        .enabled(false)
        .opacity(this.getColumnOpacity())
      Image($r(`app.media.app_icon_deliver`))
        .width(this.badgeWidth * IMAGE_WIDTH_RADIO)
        .height(this.badgeHeight * IMAGE_HEIGHT_RADIO)
        .enabled(false)
        .objectFit(ImageFit.Contain)
        .fillColor(this.getBadgeFillColor())
    }
    .width(this.badgeWidth)
    .height(this.badgeHeight)
    .offset({ start: LengthMetrics.vp(this.badgeOffsetStart), top: LengthMetrics.vp(this.badgeOffsetTop) })
    .enabled(false)
    .geometryTransition(this.geometryTransitionId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
  }

  private getColumnOpacity(): number {
    return this.aodStyle?.isAod ? AOD_OPACITY : OPACITY;
  }

  private getBadgeFillColor(): ResourceColor {
    return this.aodStyle?.isAod ? $r('app.color.immersive_capsule_deliver_aod_color') :
    $r('app.color.immersive_capsule_deliver_default_color');
  }
}