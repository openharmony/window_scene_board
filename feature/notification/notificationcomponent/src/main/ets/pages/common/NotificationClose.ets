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

import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { ComponentConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { NtfHeadsUpVM } from '../../vm/NtfHeadsUpVM';
import { NotificationEntry } from '../../model/NotificationEntry';

const TAG = 'NotificationClose';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_CLOSE = TAG + '_Close_Image';
const CLOSE_BUTTON_SHADOW_RADIUS = 20;
const CLOSE_BUTTON_SHADOW_OFFSETY = 4;

/**
 * 通知条目close按钮
 */
@Component
export struct NotificationClose {
  /**
   * VM数据处理
   */
  @Consume private closeVM: NtfCloseVM;

  private headsUpVM?: NtfHeadsUpVM;
  /**
   * 通知栏的x号的距离和横幅的有不同，这里增加状态位
   */
  private isFromNtf: boolean = false;

  private shadowStyle: ShadowOptions = {
    radius: CLOSE_BUTTON_SHADOW_RADIUS,
    color: $r('app.color.ntf_item_bg_shadow_color'),
    offsetY : CLOSE_BUTTON_SHADOW_OFFSETY
  };

  aboutToAppear(): void {
    log.showInfo('About to appear.')
  }

  private getPosition(): Position {
    let yOffset: number = -4;
    let xNormalOffset: number = -5;
    let xRTLNtfOffset: number = 16;
    // PC增加了hover缩放，位置需要重新调整
    if (DeviceHelper.isPC()) {
      yOffset = -5;
      xNormalOffset = -2;
      xRTLNtfOffset = 19;
    }
    return {
      x: RTLUtil.isRTL() ?
        (this.isFromNtf ? this.closeVM.buttonPositionX + xRTLNtfOffset : this.closeVM.buttonPositionX) :
        (this.closeVM.buttonPositionX + xNormalOffset),
      y: this.closeVM.buttonPositionY + yOffset
    }
  }

  private getMyTransitionEffect(): TransitionEffect | undefined {
    if (DeviceHelper.isPC() && this.isFromNtf) {
      return TransitionEffect
        .translate({x: -3, y: 1})
        .animation({duration: 300, curve: Curve.Sharp});
    }
    return undefined;
  }

  build() {
    if (this.closeVM.isShow()) {
      Stack() {
        Row() {
          Image($r('app.media.ic_pc_item_hover_close'))
            .draggable(false)
            .id(COMPONENT_ID_CLOSE)
            .objectFit(ImageFit.Contain)
            .fillColor($r('app.color.ntf_app_name_font_color'))
            .width($r('app.float.ntf_pc_close_icon_size'))
            .height($r('app.float.ntf_pc_close_icon_size'))
        }
        .border({
          radius: $r('app.float.ntf_close_inner_border_radius'),
          color: $r('app.color.ntf_close_inner_border_color'),
          width: $r('app.float.ntf_close_inner_border_width')
        })
        .outline({
          radius: $r('app.float.ntf_close_outer_border_radius'),
          color: $r('app.color.ntf_close_outer_border_color'),
          width: $r('app.float.ntf_close_outer_border_width')
        })
        .justifyContent(FlexAlign.Center)
        .width($r('app.float.ntf_pc_close_container_size'))
        .height($r('app.float.ntf_pc_close_container_size'))
        .backgroundColor($r('app.color.ntf_item_bg_color'))
        .backgroundBrightness({
          rate: ResourceManager.getInstance().getNumberByResource($r('app.float.ntf_close_background_brightness_rate')),
          lightUpDegree: ResourceManager.getInstance().getNumberByResource($r('app.float.ntf_close_background_brightness_degree'))
        })
        .shadow(this.shadowStyle)
        .backdropBlur(ComponentConstants.DEFAULT_BLUR_RADIUS)
        .saturate(1)
      }
      .focusable(false)
      .position(this.getPosition())
      .transition(TransitionEffect.asymmetric((DeviceHelper.isPC() && this.isFromNtf) ?
        TransitionEffect
          .translate({x: -3, y: 1})
          .animation({duration: 300, curve: Curve.Sharp}) : undefined, undefined))
      .width($r('app.float.ntf_close_hot_region_size'))
      .height($r('app.float.ntf_close_hot_region_size'))
      .onHover((isHover) => {
        log.showInfo(`onHover ${isHover}`);
        if (isHover) {
          this.closeVM.clearCancelTimer();
        } else {
          this.closeVM.cancelItemHover();
        };
        if (!this.closeVM.ntfEntry) {
          return;
        }
        this.headsUpVM?.setItemHoverState(this.closeVM.ntfEntry, isHover);
      })
      .onClick(() => {
        this.closeVM.ntfEntry?.notifyOutChanged();
        setTimeout(() => {
          this.closeVM.deleteNotification();
          if (!this.closeVM.ntfEntry) {
            return;
          }
          this.headsUpVM?.setItemHoverState(this.closeVM.ntfEntry, false);
          this.closeVM.cancelItemHover();
        }, this.isFromNtf ? 0 : 100);
      })
    }
  }
}