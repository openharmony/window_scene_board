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
import { ItemUtils } from '@ohos/componenthelper';
import { RectInfo } from '@ohos/basicutils';
import { ItemAnimationParams } from '@ohos/launchercommon/Index';
import SmartDockConstants from '../common/constants/SmartDockConstants';

const TAG = 'PhoneDockUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PhoneDockUtils {

  public static getBackPlaneAnimation(): ItemAnimationParams {
    let residentRect: RectInfo = ItemUtils.getRectById(SmartDockConstants.DOCK_RESIDENT_BG_ID);
    let recentRect: RectInfo = ItemUtils.getRectById(SmartDockConstants.DOCK_RECENT_BG_ID);
    let backPlaneRect: RectInfo = new RectInfo();
    if (recentRect.left === 0) {
      backPlaneRect = residentRect;
    } else {
      backPlaneRect.left = residentRect.left;
      backPlaneRect.right = recentRect.right;
      backPlaneRect.top = residentRect.top;
      backPlaneRect.bottom = residentRect.bottom;
      backPlaneRect.height = residentRect.height as number;
      backPlaneRect.width = (residentRect.width as number) + (recentRect.width as number);
    }
    log.showInfo(`backPlaneRect, left is ${backPlaneRect.left}, right is ${backPlaneRect.right}`);
    let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
    const screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    itemAnimation.calculateStartAppProperty(screenWidth, screenHeight, backPlaneRect);
    return itemAnimation;
  }
}