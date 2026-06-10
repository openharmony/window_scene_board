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
import { desktopItemDraggableManager } from '../../manager/DesktopItemDraggableManager';
import { AppItemInfo, editModeManager, GridLayoutItemInfo, MultiSelectManager } from '../../TsIndex';
import { AppIconData } from './AppIconData';
import { AppIconGestureJudgeIface } from '../interface/AppIconGestureJudgeIface';

const TAG = 'AppIconGestureJudgeEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

/**
 * AppIconGestureJudgeEvent 初始化参数封装
 */
export interface AppIconGestureJudgeEventParam {
  itemInfo: AppItemInfo;
  iconData: AppIconData;
  enableMultiSelect: boolean;
}

/**
 * Icon GestureJudge事件处理
 */
export class AppIconGestureJudgeEvent implements AppIconGestureJudgeIface {
  private itemInfo?: AppItemInfo;
  private iconData?: AppIconData;
  private enableMultiSelect: boolean = false;

  /**
   * AppIconGestureJudgeEvent 参数初始化
   * @param param AppIconGestureJudgeEventParam
   * @returns AppIconGestureJudgeCb
   */
  public initGestureJudgeParam(param: AppIconGestureJudgeEventParam): AppIconGestureJudgeIface {
    if (!param?.itemInfo) {
      log.showError('initGestureJudgeParam failed, param is invalid!');
      return this;
    }

    this.itemInfo = param.itemInfo;
    this.iconData = param.iconData;
    this.enableMultiSelect = param.enableMultiSelect;
    return this;
  }

  /**
   * 判断是否接受对应的手势
   * @param gestureInfo GestureInfo 手势信息
   * @param event BaseGestureEvent 手势事件
   * @returns GestureJudgeResult
   */
  public onGestureJudgeBegin(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    // 长按震动后无需响应点击手势
    if (gestureInfo?.type === GestureControl.GestureType.CLICK && this.iconData?.isLongPressVibrated) {
      log.showWarn('reject click gesture after long press');
      return GestureJudgeResult.REJECT;
    }

    if (gestureInfo?.type !== GestureControl.GestureType.DRAG) {
      return GestureJudgeResult.CONTINUE;
    }

    if (!desktopItemDraggableManager.getEnableDrag()) {
      return GestureJudgeResult.REJECT;
    }

    if (!editModeManager.isInEditMode() || !this.itemInfo) {
      return GestureJudgeResult.CONTINUE;
    }

    const manager = MultiSelectManager.getInstance();
    if (this.enableMultiSelect && !manager.enabledDefaultDrag(manager.getUniqueId(this.itemInfo))) {
      return GestureJudgeResult.REJECT;
    }

    if (!editModeManager.isDraggable(this.itemInfo as Object as GridLayoutItemInfo)) {
      return GestureJudgeResult.REJECT;
    }

    return GestureJudgeResult.CONTINUE;
  }
}
