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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { GestureDockConstants } from '../../../common/GestureDockConstants';
import { ScreenInfoUtil } from '../../../common/util/ScreenInfoUtil';
import { GestureDockItemInfo } from '../../model/GestureDockItemInfo';

const TAG = 'GestureDockBarParam';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * Dock参数
 */
@Observed
export class DockBarParam {
  public isLeft: boolean = true;
  public blendRatio: number = GestureDockConstants.BLEND_MODE_DEFAULT_RATIO;
  public blurRadius: number = GestureDockConstants.GESTURE_DOCK_BLUR_RADIUS;
  public brightness: number = 1;
  public maxHeight: number = (GestureDockConstants.GESTURE_DOCK_MAX_RECENT + GestureDockConstants.CUSTOM_SHOW_COUNT +
  GestureDockConstants.EDIT_ICON_COUNT) * GestureDockConstants.GESTURE_DOCK_ICON_SIZE + (
    GestureDockConstants.GESTURE_DOCK_MAX_RECENT + GestureDockConstants.CUSTOM_SHOW_COUNT +
    GestureDockConstants.EDIT_ICON_COUNT + 2) * GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;
  public backGroundColor: Resource = $r('app.color.gesture_dock_bg_color');

  /**
   * 重置dock最大高度
   *
   * @param recentPaddingCount
   * @param screenProperty
   */
  public resetDockMaxHeight(recentPaddingCount: number, screenProperty?: SCBScreenProperty): void {
    if (screenProperty) {
      this.maxHeight = ScreenInfoUtil.isVertical(screenProperty) ?
        (GestureDockConstants.GESTURE_DOCK_MAX_RECENT + GestureDockConstants.CUSTOM_SHOW_COUNT +
        GestureDockConstants.EDIT_ICON_COUNT) * GestureDockConstants.GESTURE_DOCK_ICON_SIZE +
          (GestureDockConstants.GESTURE_DOCK_MAX_RECENT + GestureDockConstants.CUSTOM_SHOW_COUNT +
          GestureDockConstants.EDIT_ICON_COUNT + recentPaddingCount) * GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE :
        (GestureDockConstants.GESTURE_DOCK_MAX_RECENT + GestureDockConstants.EDIT_ICON_COUNT) *
        GestureDockConstants.GESTURE_DOCK_ICON_SIZE + (GestureDockConstants.GESTURE_DOCK_MAX_RECENT +
        GestureDockConstants.EDIT_ICON_COUNT + recentPaddingCount) * GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;

      if (DeviceHelper.isPad()) {
        this.maxHeight = GestureDockConstants.GESTURE_DOCK_MAX_PAD *
          (GestureDockConstants.GESTURE_DOCK_ICON_SIZE + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE) +
          recentPaddingCount * GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE
      }
      log.showInfo(`maxHeight is ${this.maxHeight}, screenProperty rotation is ${screenProperty.rotation}`);
    }
  }
}

/**
 * Dock呼出参数
 */
@Observed
export class DockBarOutParam {
  public translation: number = 0;
  public cutOutDistance: number = 0;
  public shadow: ShadowStyle | undefined = undefined;
}

/**
 * Dock滑动区域数据
 */
@Observed
export class DockBarScrollerParam {
  public isRecentAppShow: boolean = false;
  public dividerColor: string | Resource = GestureDockConstants.DIVIDER_COLOR;
  public recentApps: GestureDockItemInfo[] = [];
}


